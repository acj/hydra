#!/usr/bin/perl
package ASTWalker;
use CState;
use CCState;
use State;	
use Class;	
use Context;
use History;
use Join;
use Init;
use Log;

sub Model
{
    my ($class, $tree) = @_;

    my $stmt = $$tree{modelbody}{modelstmtlist};
    my $ent;
    foreach $ent (@$stmt) {   # Each one of these is a hash
	Put Log "In Model, type=$$ent{type}";
	if ($$ent{type} eq 'Enum') {
	    my @list;
	    $$ent{list} =~ s/^\((.+)\)$/$1/;
	    @list = split(/,/, $$ent{list});
	    Context->Enum($$ent{ID}, @list); 
	}
	elsif ($$ent{type} eq 'Driverfile') {
	    Context->DriverFile($$ent{ID});
	}
	elsif ($$ent{type} eq 'Class') {
	    ASTWalker->Class($ent);
	}
	elsif ($$ent{type} eq 'Null') {next}
	else {die "bad type $$ent{type}"}
    }
    Put Log "Model done with tree";
}

sub Class
{
    my ($class, $tree) = @_;

    $$tree{type} eq 'Class' || die "this is not an Class node";

    my $objref = new Class($$tree{ID});
    my $init;
    my $inittran;

    my $body = $$tree{classbody}{classstmtlist};
    my $ent;
    my %nametoref;
    my @joinlist;
    foreach $ent (@$body) {
	Put Log "In Class, type=$$ent{type}";
	if ($$ent{type} eq 'Signal') {
	    $objref->Signal($$ent{name},$$ent{sigtype});
	}
	elsif ($$ent{type} eq 'CState') {
	    $nametoref{$$ent{ID}} = ASTWalker->CState($ent, $objref);
	}
	elsif ($$ent{type} eq 'CCState') {
	     my $ref = ASTWalker->CCState($ent, $objref);
# This used to save a ref to the CCState, but it needs to save refs to
# the CStates in the CCState, hence the following code. Fetch members,
# then get their names. We still need a ref to the CCState container.
	     $nametoref{$$ent{ID}} = $ref;
	     my @members;
	     @members = $ref->GetMembers;
	     my $thing;
	     foreach $thing (@members) {
		 my $name = $thing->GetName;
		 $nametoref{$name} = $thing;
	     }
	}
	elsif ($$ent{type} eq 'State') {
	    $nametoref{$$ent{ID}} = ASTWalker->State($ent, $objref);
	}
	elsif ($$ent{type} eq 'Init') {
	    if ($init) {
		Put Msg(level=>'warn', class=>$$tree{id},
			msg=> 'has more than one init state');
	    }
	    $init = $$ent{ID};
# If there is a transition string on the Initial state, grab it and save it.
	    if (exists($$ent{tran})) {    
		($inittran) = $$ent{tran} =~ /^\"(.+)\"/;
	    }
	}
	elsif ($$ent{type} eq 'Join') {
	    push(@joinlist, [$$ent{ID},$$ent{from},$$ent{to}]);
	}
	elsif ($$ent{type} eq 'InstVar') {
	    $objref->InstVar($$ent{vtype}, $$ent{var}, $$ent{initval});
	}
	else {die "bad type $$ent{type}"}
    }

    foreach $ent (@joinlist) {
	new Join($objref, $$ent[0], 
		 $nametoref{$$ent[1]}, $nametoref{$$ent[2]});
    }

    my $tname = $objref->GetName;
    Put Log "Class $tname init is $init";
    if ($init) {new Init($objref, $nametoref{$init}, $inittran)}
}

sub CState
{
    my ($class, $tree, $parent) = @_;

    $$tree{type} eq 'CState' || die "node is not a CState";

    my $cstateref = new CState($parent, $$tree{ID});
    my $myname = $$tree{ID};

    my $body = $$tree{body}{cstatestmtlist}; # List of stmts
    my %nametoref;
    my ($ent, $init, $history, $inittran, $histtran);
    foreach $ent (@$body) {
	if ($$ent{type} eq 'State') {
	    my $r = ASTWalker->State($ent, $cstateref);
	    $nametoref{$$ent{ID}} = $r;     # save ref by name
	}
	elsif ($$ent{type} eq 'Trans') {
	    my $tran;
	    ($tran) = $$ent{tran} =~ /^"(.+)"$/;
	    $cstateref->Tran($tran, $$ent{dest});
	}	elsif ($$ent{type} eq 'Action') {
	    my $action;
	    ($action) = $$ent{action} =~ /^"(.+)"$/;
	    $cstateref->Action($action);
	}

	elsif($$ent{type} eq 'CState') {
	    my $r = ASTWalker->CState($ent, $cstateref);
	    $nametoref{$$ent{ID}} = $r;     # save ref by name
	}
	elsif ($$ent{type} eq 'Init') {
	    if ($init) {
		Put Msg(level=>'warn', class=>$$tree{id},
			msg=> 'has more than one init state');
	    }
	    $init = $$ent{ID};
# If there is a transition string on the Initial state, grab it and save it.
	    if (exists($$ent{tran})) {    
		($inittran) = $$ent{tran} =~ /^\"(.+)\"/;
	    }
	}
	elsif ($$ent{type} eq 'History') {
	    if ($history) {
		Put Msg(level=>'warn', class=>$$tree{id},
			msg=> 'has more than one History state');
	    }
	    $history = $$ent{ID};
# If there is a transition string on the Initial state, grab it and save it.
	    if (exists($$ent{tran})) {    
		($histtran) = $$ent{tran} =~ /^\"(.+)\"/;
	    }
	}
	elsif ($$ent{type} eq 'CCState') {
	    my %names;
	    %names = ASTWalker->CCState($ent, $objref);
	    my $key;
	    foreach $key (keys %names) {$nametoref{$key} = $name{$key}}
	}
	else {die "bad type $$ent{type}"}
    }
# Now to Init states
    if ($history) {
# This differs from VHDL, where we pass state name instead of state ref
	new History($cstateref, $nametoref{$history}, $histtran);
    }
    if ($init) {
	if (!exists($nametoref{$init})) {
	    Put Msg(level=>error, 
		    class=>cstate=>$cstateref->GetObjRef->GetName,
		    cstate=>$cstateref->GetName,
		    msg=> "state $init not found");
	    exit(1);
	}
	new Init($cstateref, $nametoref{$init}, $inittran);
    }
    else {"**** Warning: There is no Initial state for $$tree{ID}\n"}
    return $cstateref;  # return the ref to this CState
}

sub CCState
{
# The only legal statements for this container is CState. Transitions (such
# as inits) may want to transition to one of our components, which starts the
# threads running. Therefore, we pass back a hash of CState refs indexed by
# CState name.
    my ($class, $tree, $parent) = @_;

    my $ccstate = new CCState($parent, $$tree{ID});

    my $body = $$tree{body}{ccstatestmtlist}; # List of stmts
    my $ent;
    foreach $ent (@$body) {
	if ($$ent{type} eq 'State') {
	    ASTWalker->State($ent, $ccstate);
	}
	elsif($$ent{type} eq 'CState') {
	    ASTWalker->CState($ent, $ccstate);
	}
	elsif($$ent{type} eq 'Action') {
	    my $classname = $ccstate->GetObjRef->GetName;
	    Put Msg(level=>error, class=>$classname, 
		    ccstate=>$$tree{ID},
		    msg=> "Wrappers can't have Actions. "
		    . "Put the action in the contained CompositeStates.");
	}
	else {die "bad type $$ent{type}"}
    }
    return $ccstate;
}

sub State
{
    my ($class, $tree, $parent) = @_;

    $$tree{type} eq 'State' || die 'Node is not a State node';
    my $stateobj = new State($parent, $$tree{ID});

# The next statement checks to see if a InState var is forced
    if (exists($TS{$$tree{ID}})) {$stateobj->MakeInTarget}

    my $body = $$tree{statebody}{statestmtlist};
    my $ent;
    foreach $ent (@$body) {
	Put Log "In State: type=$$ent{type}";
	if ($$ent{type} eq 'Trans') {
	    my $tran;
	    ($tran) = $$ent{tran} =~ /^"(.+)"$/;
	    $stateobj->Tran($tran, $$ent{dest}, $$ent{linenum});
	}
	elsif ($$ent{type} eq 'Action') {
	    my $action;
	    ($action) = $$ent{action} =~ /^"(.+)"$/;
	    $stateobj->Action($action, $$ent{linenum});
	}
	else {die "State got node type $$ent{type}"}
    }
    return $stateobj;   # return the ref to this state
}

sub InStateTarget
{
# This method called to pass a NAMES, (not ref) that should
# have IN predicate variables forced for it.
    my ($class, $state) = @_;

    $TS{$state} = 1;
    Put Msg(level=>info, state=>$state, 
	    msg=> "Creating IN-State variable");
}
1;
