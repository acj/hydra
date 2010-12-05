#!/usr/bin/perl
package CCState;

# This class cooperates with Join closely. There has to be at least
# one Join to match each CCState. There can be more than one Join.

sub new
{
    my ($class, $parent, $name) = @_;

    my $obj = {};
    bless $obj;
    $$obj{parent} = $parent;
    $$obj{name} = $name;
    $$obj{objref} = $parent->GetObjRef;
    $parent->AddState($obj);
    $$obj{states} = [];
    return $obj;
}

sub GetObjRef
{
# return a ref to the class. I don't know where it is but my parent does.
# Eventually, the 'parent' IS the class.
    my $obj = shift;
    return $$obj{objref}
}

sub ResolveDest { return }

sub GoDown
{
# Parents call this routine looking for a dest state. We don't own any
# states except member CStates, we delegate down right away.

    my ($obj, $dest) = @_;

# Look down. Everything here has to be a CState
    foreach $ent (@{$$obj{states}}) {
	if ($ent->GoDown($dest)) {return 1}  # one of my children has it
    }
# Looking up makes no sense because parent called me in the first place...
    return 0;
}

sub GoUp
{ 
# My children call me here looking for dest state. We have no local simple
# states. We look down, then up as before.


    my ($obj, $dest, $caller) = @_;
# Look at our local CStates. No runtab required because Join will pick
# this up. The choices of designated next states from the children
# are limited (to Joins, to be precise)
    if ($$obj{owndest}{$dest}) {
	return ['lclcs'];   # Someone lower than my child will get this
    }

# Look down, cycle thru children
    foreach $ent (@{$$obj{states}}) {
	if ($caller == $ent) {next}
	if ($ent->GoDown($dest)) {return 1}
    }

# Look at parent. 
    if ($$obj{parent}->GoUp($dest, $obj)) {
	return ['up'];   # return up... still no runtab needed
    }

# not found anywhere....
    return ();
}

sub AddState
{
    my ($obj, $state) = @_;
    
    Put Log "Addstate called from ",$state->GetName;
    push(@{$$obj{states}}, $state);
    my $name = $state->GetName;
    $$obj{owndest}{$dest} = 'lclcs';
}

sub AddJoin
{
    my ($obj, $join) = @_;

    Put Log $join->GetName;
    push(@{$$obj{joins}}, $join);
}

sub GetMembers
{
    my ($obj) = @_;

    return @{$$obj{states}};
}

sub GetName
{
    my ($obj) = @_;

    return $$obj{name};   # Return the name of the container.
                          # elsewhere we equate this container with child
                          # CStates
}

# Old GetName. 
#sub GetName
#{
#    my ($obj) = @_;
#
#    my $ent;
#    my @list;
#    foreach $ent (@{$$obj{states}}) {push(@list, $ent->GetName)}
#    return @list;
#}

sub PreProcess
{
    my ($obj) = @_;

    my $ent;
    Context->AddEnum($$obj{objref}->GetName, 'none');
    Put Log "CCState ", $$obj{name}, " states";
    foreach $ent (@{$$obj{states}}) {
	Put Log "---", $ent->GetName;
	$ent->PreProcess;
    }
}

sub LclOutput
{
    my ($obj) = @_;

    my $ent;
    my @names;
    Put Log "LclOutput called";
# Put out my name (the name of the CCState container), which will start
# my children CStates
    Put Context 0,"to_$$obj{name}:";
    foreach $ent (@{$$obj{states}}) {
	my $name = $ent->GetName;
	push(@names, $name);
	Put Context 0,"to_$name:";
    }
    Put Context 1,"atomic {";
    foreach $ent (@names) {Put Context 1,"${ent}_pid = run $ent(none);"}
    Put Context 1,"}";
#  wait??eval(cp1_pid),cp1_code;  
    foreach $ent (@names) {
	Put Context 1,"wait??eval(${ent}_pid),${ent}_code;";
    }
# Time to do Join stuff.
    if (@{$$obj{joins}}) {
	Put Context 1,"do";
	foreach $ent (@{$$obj{joins}}) {
	    $ent->LclOutput;   # write out the correct if - dispatch
	}
	Put Context 1,"od;";
    }
    else {
	Put Msg(level=>'warn', class=>$$obj{objref}->GetName,
		ccstate=>$$obj{name},
		msg=> "Join missing (these threads can never be joined)");
	Put Context 1,"assert(0);";
    }
# That's it. We're done.
}

sub Output
{
    my ($obj) = @_;

    my $ent;
# I have nothing to write out, but my CStates must be written.
    foreach $ent (@{$$obj{states}}) {
	Put Log  "calling output for ", $ent->GetName; 
	$ent->Output;
    }
}
1;



