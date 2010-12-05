#!/usr/bin/perl
package Init;

sub new
{
# Both parent and start are refs. $tran is any initial transition string.
# $tran is null if no transition.
    my ($class, $parent, $start, $tran) = @_;

    Put Log "parent isa ",ref($parent), " start isa ",ref($start);
    my $obj = {};
    bless $obj;
    $$obj{parent} = $parent;
    $$obj{objref} = $parent->GetObjRef;  # get a ref to object we're in.
                                         # (Need this for transition parsing)
    if (ref($start) ne 'State' && ref($start) ne 'CState' &&
	ref($start) ne 'CCState') {
	my $cn = $$obj{objref}->GetName;
	print "**** Error: Class $cn, ",
	"Init for ", $parent->GetName, " is undefined\n";
	exit(1);
    }
    $$obj{start} = $start;
    if ($tran) {$$obj{tran} = $tran}
    $parent->AddState($obj);
    return $obj;
}

sub GetName {return 'Init'}

sub PreProcess {return}

sub Output {return}

sub ResolveDest {return}  # we assume initial states are local, which is
                          # probably a bad assumption. Should resolve target
                          # like State, Fork, and everyone else does.

sub LclOutput
{
    my ($obj) = @_;
    
    Put Log "Doing Init for ", $$obj{parent}->GetName;
# If the intial state is CState, we need a 'to_state' type label.
    my $name = $$obj{start}->GetName;
    Put Context 0, "/*  Init state      */";

# Check if there is an initial action/message. We're going to ignore
# any event/guard that might have somehow gotten thru the parser.
    if (exists($$obj{tran})) {
	Put Context 0, "/* Initial actions / messages */";
# tell the parser what class we are working on (for access to vars, etc)
	TranYaccPak->SetClassRef($$obj{objref}, $obj);
	Put Log "Initial transition before parse <$$obj{tran}>";
	$ret = TranYacc->Parse($$obj{tran});
	if (!$ret) {  # bad string... exit
	    exit;
	}
    }
    else {$ret = ''}
    Put Log "tranret=$ret";
    my @list = split(/\#/, $ret);
    my %tab;
    my ($type,$thing);
    while (@list) {
	$type = shift(@list);
	$thing = shift(@list);
	$tab{$type} = $thing; 
    }
    if (exists($tab{A})) {Put Context 1, $tab{A}}
    if (exists($tab{M})) {Put Context 1, $tab{M}}
# OK, we're done with all the action / message stuff.

    if (ref($$obj{start}) eq 'CState' || ref($$obj{start}) eq 'CCState') {
	Put Context 1,"goto to_$name;";
    }
    else {Put Context 1,"goto $name;"}
}
1;






