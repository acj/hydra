#!/usr/bin/perl
package Join;

use CCState;

sub new
{
# All of these are refs except $name, which is my join name (equiv to
# state name)
    my ($class, $parent, $name, $ccstate, $dest) = @_;

    my $obj = {};
    bless $obj;
    $$obj{name} = $name;
    $$obj{dest} = $dest;
    $$obj{parent} = $parent;
    $$obj{objref} = $parent->GetObjRef;
    $$obj{objref}->AllStates($obj);   # tell our object we're here.
    $parent->AddState($obj);
    $$obj{ccstate} = $ccstate;
    $ccstate->AddJoin($obj);         # tell CCState about our join.
    return $obj;
}

sub GetName
{
    my ($obj) = @_;

    return $$obj{name};
}

sub ResolveDest
{
# Need to resolve the dest here just like we do for states, except there is
# only one.
    my ($obj) = @_;

    Put Log "Resolve called for join $$obj{name}";
    my ($dir, $cstate) = $$obj{parent}->Find($$obj{dest}->GetName);
    Put Log "$$obj{name} got back $dir, $cstate";
    if (!$dir) {die "Join can't find dest $$obj{dest}"}
    $$obj{desttype} = $dir;
    $$obj{cstate} = $cstate;  # except for 'down', this is null
}

sub PreProcess {return}

sub Output {return}

sub LclOutput
{
    my ($obj) = @_;
    ($class, $f, $line) = caller;
    Put Log "I was called by $class($line)";
# Get a list of all the CStates in the CCState
    my @csnames;
    my $ent;
    foreach $ent ($$obj{ccstate}->GetMembers) {push(@csnames, $ent->GetName)}

# Here is what I am building:
# 	 :: cp1_code == st_join && cp2_code == st_join -> goto state
    PutNR Context 1,":: ";
    my $dest = $$obj{dest}->GetName;
    Put Log "dest=$dest, type=",ref($$obj{dest});
    my $first = 1;
    foreach $ent (@csnames) {
	if ($first) {
	    PutNR Context 0, "${ent}_code == st_$$obj{name}";
	    $first = 0;
	}
	else {PutNR Context 0," && ${ent}_code == st_$$obj{name}"}
    }
    PutNR Context 0, " -> ";
    
# Now determine what kind of dispatch we need.
    write_tran($$obj{desttype}, $dest, '');
}

sub write_tran
{
    my ($desttype, $dest, $cstate) = @_;
# This is a local routine to write out the right kind of transition.
    
    Put Log " WriteTran desttype=$desttype, dest=$dest, cstate=$cstate";
# local state transition, use goto
    if ($desttype eq 'lcl') {
	Put Context 0,"goto $dest;";
    }
    elsif ($desttype eq 'lclcs') {
	Put Context 0,"goto to_$dest;";
    }
# transition to state up somewhere (higher level)
    elsif ($desttype eq 'up') {
	Put Context 0,"wait!_pid,st_$dest; goto quit;";
    }
# transition to lower CState
    elsif ($desttype eq 'down') {
	Put Context 0,"m = st_$dest; ",
	"goto to_$cstate;";
    }
# whoops! we have a problem here....
    else {die "destination <$desttype> not typed"}
}
1;



