#!/usr/bin/perl
package CState;
use Class;

# Resolve dests, dispatch tables and run tables:
# Each simple state has to know where it's destination state is for each 
# transition. There are four possibilities:
# 1. Local transition. goto state; is the contruct
# 2. Local transition to composite state. goto to_cstate; is contruct
# 3. Transition down into composite state. m=state; goto to_cstate;
# 4. Transition up to parent composite state. wait??eval(pid),m is construct

# In addition, we need essentially a routing from a src to a dest. So each
# CState or Class must keep a route (lcl, lclcs, up, down) for each dest
# that might pass thru.

# This is done by passing control to each simple state at 'Resolve'
# where it calls it's parent 'Find'. Find looks locally for simple states and
# composite states (returns 'lcl' and 'lclcs'), then looks down into it's
# composite states via 'GoDown'. A hit here returns 'down' and the name 
# of the CState down. Finally, it looks up via GoUp. A hit here returns 
# 'up'. Now the simple states know all the proper constructs to get to the
# dest.

# CStates and Class must also keep track of what it returned for the dest.

# For an 'up', the 'run cstate' construct higher up is going to get a return
# state for the next dest, so a table (runtab) is required to dispatch the
# next dest properly. For 'down', the receiving CState must have an initial
# dispatch tab so control can be passed as required. The choices are as 
# before, locally, locally-to-cstate, up (some more), or down (some more). 
# For up and down, any given cstate may only be a passthru for a dest several
# levels deep. 

# The 'run cstate' construct is contructed by LclOutput, so it has to know
# about what to expect back. The CState itself must know about incoming
# states in Output, because that is where the body is contructed.

# So State must tell it's parent LclOutput about possible returns, and 
# it' child Output about dispatch table entries. State calls BldTab of parent
# with 'up', or calls child 'down'. Each CState propogates the call according
# it's route tab entry until 'lcl' or 'lclcs' is found.

sub BEGIN
{
    %CS = (CState=>1, CCState=>1);
}

sub new { my ($class, $parent, $name) = @_;

    my $obj = {};
    bless $obj;
    $$obj{name} = $name;
    $$obj{parent} = $parent;
    $$obj{objref} = $parent->GetObjRef; # See GetObjRef below
    $$obj{objref}->AllStates($obj);     # add to list of states
    $$obj{states} = [];   # reference to states we own
    $$obj{owndest} = {};  # text names of states we own
    $$obj{inittab} = {};  # list of state info we'll get called with
    $$obj{runtab} = {};   # list of states that may come back
    $parent->AddState($obj); # add myself to parent's list
    return $obj;
}

sub GetName
{
    my ($obj) = @_;

    return $$obj{name};
}

sub HistoryPresent
{
    my ($obj) = @_;
    return exists($$obj{historypresent});
}


sub GetObjRef
{
# return a ref to the class. I don't know where it is but my parent does.
# Eventually, the 'parent' IS the class.
    my $obj = shift;
    return $$obj{objref}
}

sub AddState
{
# called by simple state process to include state in my list of states
    my ($obj, $state) = @_;

    push(@{$$obj{states}}, $state);
    my $name;
    $name = $state->GetName;
# lcl means simple local state, lclcs means composite state of some kind
    $$obj{owndest}{$name} = ref($state) eq 'State' ? 'lcl' : 'lclcs';
    if (ref($state) eq 'History') {$$obj{historypresent} = $state}
}

sub GetMembers
{
# This method produces a list of refs of the states we own.
    my ($obj) = @_;

    return @{$$obj{states}};
}

sub Tran
{
# Accept a transition from the boundary of this CState. We'll just add it
# to all our children states.
    my ($obj, $tran, $dest) = @_;

    push(@{$$obj{trans}}, [$tran, $dest]);
}

sub Action
{
# (This method is a clone of the Action method in State)
# We parse the in-state action. This produces a delimited string of event,guard
# action,msg. The only legal 'events' are ENTRY, EXIT, and DO. Guards
# are not permitted nor are parms. Otherwise, this looks just like a 
# transition.

    my ($obj, $act, $lineno) = @_;

    my $classname = $$obj{objref}->GetName;
    my $ret;
    if ($act) {
	TranYaccPak->SetClassRef($$obj{objref}, $obj); # tell parser about class
	Put Log "action before parse <$act>";
	$ret = TranYacc->Parse($act);
	if (!$ret) {
	    my $msg = "Bad action expression \"$act\" near <" .
		TranYacc->LastToken . '>';
	    Put Msg(level=>error, class=>$classname, cstate=>$$obj{name},
		    msg=>$msg);
	    exit;
	}
    }
    else {$ret = ''}
    Put Log "actret=$ret";
    my @list = split(/\#/, $ret);
    my %tab;
    my ($type,$thing);
# This builds a hash of the components of the parsed action string. Keys
# are E (action name), V (variable on action... illegal), G (guard... illegal)
# A (action), M (messages).
    while (@list) {
	$type = shift(@list);
	$thing = shift(@list);
	$tab{$type} = $thing; 
    }
    if (exists($tab{G})) {
	Put Msg(level=>error, class=>$classname, cstate=>$$obj{name},
		msg=> "Internal actions can't have guards.");
    }
    if (exists($tab{V})) {
	Put Msg(level=>error, class=>$classname, cstate=>$$obj{name},
		msg=> "Action $tab{E} can't have variables");
    }
    if ($tab{E} ne 'entry' && $tab{E} ne 'exit') {
	Put Msg(level=>error, class=>$classname, cstate=>$$obj{name},
		msg=> "Action $tab{E} is not legal");
	return;
    }

# Push an action onto the action list (entry, exit)
    push(@{$$obj{action}{$tab{E}}}, [$tab{A}, $tab{M}]);
}

sub Find
{
# This is called my the simple state we own to resolve a dest
    my ($obj, $dest) = @_;

    Put Log "Find for cstate $$obj{name} called. Looking for $dest";
# Look locally first.
    if (exists($$obj{owndest}{$dest})) {return $$obj{owndest}{$dest}}

# Next, look down thru CState nodes
    foreach $ent (@{$$obj{states}}) {
	if (!$CS{ref($ent)}) {next}  # Skip all non-CStates
	if ($ent->GoDown($dest)) {  # parent -> child call
	    $$obj{runtab}{$dest} = ['down', $ent->GetName];
	    Put Log "Find in $$obj{name} $dest is down";
	    return ('down', $ent->GetName);
	}
    }

# Finally look up a level; child -> parent
    if ($$obj{parent}->GoUp($dest, $obj)) {
	$$obj{runtab}{$dest} = ['up'];
	Put Log "Find in $$obj{name} $dest is up";
	return ('up');
    }
    die "can't find $dest";
}

# GoUp returns the context in which it finds the dest, but for LclOutput
# in States and CStates, this is how the label will look becuase that is
# where the LclOuput code will be... in the parent. Only GoUp calls GoUp, 
# GoUp also records the dest context the call to the parent returns.

# GoDown just returns true if it finds the label down, but the 'called' 
# GoDown should expect this dest coming into the code built by Output...
# the body of the CState. So GoDown records inittab entries

# The process starts with a call to GoUp from a simple State coming from
# ResolveDest.

# We have a ResolveDest just to make the set of methods complete. Someday,
# we should handle a transition from a boundary, and thus resolve a dest,
# but not right now.

sub ResolveDest { return }

sub GoDown
{
# Parents call this routine looking for a dest state.
    my ($obj, $dest) = @_;

    Put Log "GoDown of $$obj{name} called, looking for $dest";

# First, look locally
    if (exists($$obj{owndest}{$dest})) {
	$$obj{inittab}{$dest} = [$$obj{owndest}{$dest}];
	return 1;
    }
# Look down
    foreach $ent (@{$$obj{states}}) {
	if (!$CS{ref($ent)}) {next}
	if ($ent->GoDown($dest)) {
	    my $csname = $ent->GetName;
	    $$obj{inittab}{$dest} = ['down', $csname];
	    return 1;
	}
    }
# Looking up makes no sense because parent called me in the first place...
    return 0;
}

sub GoUp
{ 
# My children call me here looking for dest state. I will not call
# the child that called me, hence the $child parm.
    my ($obj, $dest, $child) = @_;

    Put Log "GoUp of cstate $$obj{name} called, looking for $dest";

# Look locally. Can't be me; no way to write this.
    if (exists($$obj{owndest}{$dest})) {
	Put Log "in $$obj{name} $dest is $$obj{owndest}{$dest}";
	return [$$obj{owndest}{$dest}];
    }
# Look down, cycle thru children
    my $ent;
    foreach $ent (@{$$obj{states}}) {
	if ($ent == $child) {next}  # don't loop back down to same classq
	if (!$CS{ref($ent)}) {next}
	if ($ent->GoDown($dest)) {
	    my $csname = $ent->GetName;
	    $$obj{runtab}{$dest} = ['down', $csname];
	    Put Log "in $$obj{name} dest is down";
	    return ['down', $csname];
	}
    }

# Look up a level to my parent. Return value gives context parent see
# dest (if any), so we save this because this is where our LclOutput code
# will be constructed.

    if ($ref = $$obj{parent}->GoUp($dest, $obj)) {
	Put Log "$$obj{name} got back $$ref[0], $$ref[1]";
	$$obj{runtab}{$dest} = $ref;
	Put Log "got back $$ref[0], $$ref[1] from ",$$obj{parent}->GetName;
	return ['up'];
    }
# not found anywhere....
    return ();
}

sub PreProcess
{
    my ($obj) = @_;
# Our parent calls us here when all the input is parsed. We need to do
# any final setups, like resolving dests, making CCState members appear
# local, etc. This is called before any output routine.

# Pass down boundary transitions to children simple and CStates. This works
# because we'll call children CState 'preprocess' below, so we're completing
# transitions in a depth-first order.
#
# We need to make children of CCStates we own look local to us.
# CCState->GetName returns a list of CStates it owns.
    my $init;
    
    my $classname = $$obj{objref}->GetName;  # get name of class
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'State' || ref($ent) eq 'CState') {
	    my $tranref;
	    Put Log "Object type: ",ref($ent);
	    foreach $tranref (@{$$obj{trans}}) {
#  [0] = transition string;  [1] = dest name
		Put Log "--Adding transition \"$$tranref[0] to $$tranref[1]\"";
		$ent->Tran($$tranref[0], $$tranref[1]);
	    }
	}
	if (ref($ent) eq 'Init') {$init = 1}
	if (ref($ent) eq 'CCState') {
	    foreach $ccs ($ent->GetMembers) {
		$$obj{owndest}{$ent->GetName} = 'lclcs';
	    }
	}
	$ent->PreProcess;
    }
    if (!$init) {
	Put Msg(level=>'warn', class=>$classname, cstate=>$$obj{name},
		msg=> "No initial state");
    }
    my $key;
    Put Log "Here is $$obj{name} owndest:";
    foreach $key (keys %{$$obj{owndest}}) {
	Put Log "state=$key, value=$$obj{owndest}{$key}";
    }
}

sub LclOutput
{
    my ($obj) = @_;
    my $name = $$obj{name};

    Put Context 0, "/* Link to composite state $name */";
    Put Context 0, "to_$name:${name}_pid = run $name(m);";
    Put Context 1,"wait??eval(${name}_pid),m;";
# Now do runtab but only if it has entries
    Put Log "building runtab for ",$$obj{name};
    if (keys(%{$$obj{runtab}}) > 0) {
	Put Context 1,"if";
	foreach $ent (keys %{$$obj{runtab}}) {
	    Put Log "dest=$ent $$obj{runtab}{$ent}[0], $$obj{runtab}{$ent}[1]";
	    PutNR Context 1,":: m == st_$ent -> ";
	    if ($$obj{runtab}{$ent}[0] eq 'lcl') {
		Put Context 0,"goto $ent;";
	    }
	    elsif ($$obj{runtab}{$ent}[0] eq 'lclcs') {
		Put Context 0,"goto to_$ent;";
	    }
	    elsif ($$obj{runtab}{$ent}[0] eq 'up') {
		Put Context 0,"wait!_pid,st_$ent; goto exit;";
	    }
	    elsif ($$obj{runtab}{$ent}[0] eq 'down') {
		Put Context 0,"m = st_$ent; goto to_$$ent[2];";
	    }
	}
	Put Context 1,"fi;";
    }
}
sub Output
{
    my $obj = shift;

# ----- Initial  stuff ------
# Categorize states we own.
    my @csnames;
    my @ccnames;
    my $init;
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'CState') {push(@csnames, $ent->GetName)}
	elsif (ref($ent) eq 'CCState') {push(@ccnames, $ent->GetName)}
	elsif (ref($ent) eq 'History' || ref($ent) eq 'Init') {$init = $ent}
    }

    Put Context 0,"proctype $$obj{name}(mtype state)";
    Put Context 0, "{";
# declare pid vars for runs and waits.
    foreach $ent (@csnames) {Put Context 0, "int ${ent}_pid;"}
    foreach $ent (@ccnames) {
	Put Context 0, "int ${ent}_pid;";
	Put Context 0, "mtype ${ent}_code;";
    }

    Put Context 0,"mtype m;";
    Put Context 0,"int dummy;";
# Perform 'entry' action, if any
    if (exists($$obj{action}{entry})) {
	Put Context 0, "/* entry actions */";
	Put Context 1, "atomic{";
	my $i;
	foreach $ent (@{$$obj{action}{entry}}) {
	    Put Log "action=$$ent[0], msg=$$ent[1]";
	    foreach $i (0,1) {
		if (!$$ent[$i]) {next}
		$$ent[$i] =~ s/ +$//;      # trim off blanks
		Put Context 2, $$ent[$i];
	    }
	}
	Put Context 1, "}";
    }
# Perform 'do' action, if any. These semantics imply 'do' actions must
# complete BEFORE transitions can be taken
    if (exists($$obj{action}{'do'})) {
	Put Context 0, "/* State do actions */";
	Put Context 1, "$$obj{action}{'do'}";
    }

# build initial dispatch table
    if (keys %{$$obj{inittab}}) {
	Put Context 1,"if";
	foreach $ent (keys %{$$obj{inittab}}) {
	    if ($$obj{inittab}{$ent}[0] eq 'lcl') {
		Put Context 1,":: state == st_$ent -> goto $ent";
	    }
	    elsif ($$obj{inittab}{$ent}[0] eq 'lclcs') {
		Put Context 1,":: state == st_$ent -> goto to_$ent";
	    }
	    elsif ($$obj{inittab}{$ent}[0] eq 'down') {
		Put Context 1,
		":: state == st_$ent -> goto to_$$obj{inittab}{$ent}[1]";
	    }
	    else {die "bad initab entry"}
	}
# Picks up default initial state, or dies (to catch translation errors)
	if ($init) {Put Context 1,":: else -> skip  /* drop to init state */"}
	else {Put Context 1, ":: else -> assert(0) /* no init state - " .
	      "die if bad state */"}
	Put Context 1,"fi;";
    }
# Do init state or history setup
    if ($init) {$init->LclOutput}

# now put out code for states and cstates. 
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'Join') {next} # Skip Joins. CCState will handle
# We already did init and history
	if (ref($ent) eq 'Init' || ref($ent) eq 'History') {next}
	$ent -> LclOutput;
    }
# Wind up this CState

    Put Context 0,"exit: skip";
    if (exists($$obj{action}{'exit'})) {
	my $i;
	Put Context 0, "/*  exit actions  */";
	foreach $ent (@{$$obj{action}{'exit'}}) {
	    foreach $i (0,1) {
		if (!$$ent[$i]) {next}
		$$ent[$i] =~ s/ +$//;      # trim off blanks
		PutNR Context 0, $ent[$i];
		if ($$ent[$i] !~ /;$/) {Put Context 0, ";"}
	    }
	}
    }
    Put Context 0,"}";
    Put Context 0;
    Put Context 0;

# Output body of composite states we own
    foreach $ent (@{$$obj{states}}) {$ent->Output}
}
1;


