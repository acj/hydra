#!/usr/bin/perl
package History;

sub new
{
# Both parent and start are refs.
# $tran is the initial action/messages on the history transition.
    my ($class, $parent, $start, $tran) = @_;

    my $obj = {};
    bless $obj;
    $$obj{parent} = $parent;
    $$obj{start} = $start;
    $parent->AddState($obj);
    $$obj{objref} = $parent->GetObjRef;
    $$obj{objref}->AllStates($obj);  # We want a call to ResolveDest later
    return $obj;
}

sub GetName {return 'History'}

sub PreProcess
{
    my ($obj) = @_;

    my $ent;
    foreach $ent ($$obj{parent}->GetMembers) {
	if ($ent == $obj) {next}  # skip self
	Context->AddEnum($$obj{objref}->GetName, "st_" . $ent->GetName);
    }
# declare the global var to hold history.
    my $pn = $$obj{parent}->GetName;
    $$obj{objref}->AddMtype("H_$pn", "st_" . $$obj{start}->GetName);
}
      

sub Output {return}

sub ResolveDest
{
# This is called while states are resolving dests. We use the call to
# tell the object to declare the history mtype globally
    my ($obj) = @_;

    my $name = $$obj{parent}->GetName;
    my $dest = $$obj{start}->GetName;
    if (ref($$obj{start}) eq 'CState' ||ref($$obj{start}) eq 'CCState') {
	$$obj{objref}->AddMtype("H_$name", "to_$dest");
    }
    else {$$obj{objref}->AddMtype("H_$name", "st_" . $dest)}
}

sub LclOutput
{
    my ($obj) = @_;

# If the intial state is CState, we need a 'to_state' type label.
    my $name = $$obj{start}->GetName;
    my @states = $$obj{parent}->GetMembers;
    my $csname = $$obj{parent}->GetName;
    my $name;
    Put Context 0,"/* History pseduostate construct  */";

# Check if there is an initial action/message. We're going to ignore
# any event/guard that might have somehow gotten thru the parser.
    if (exists($$obj{tran})) {
	Put Context 0, "/* History initial actions/messages */";
# tell the parser what class we are working on (for access to vars, etc)
	TranYaccPak->SetClassRef($$obj{objref}, $obj);
	Put Log "History transition before parse <$$obj{tran}>";
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

    Put Context 1,"if";
    foreach $ent (@states) {
	if ($ent == $obj) {next}  # But not me....
	$name = $ent->GetName;
	if (ref($ent) eq 'CState') {
	    Put Context 1,":: H_$csname == st_$name -> goto to_$name;";
	}
	else {Put Context 1,":: H_$csname == st_$name -> goto $name;"}
    }
    Put Context 1,"fi;";
}
1;







