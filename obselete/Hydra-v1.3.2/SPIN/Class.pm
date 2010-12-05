#!/usr/bin/perl
package Class;

sub BEGIN
{
    %CS = (CState=>1, CCState=>1);
}

sub new
{
    my ($class, $name) = @_;

    my $obj = {};
    $$obj{allstates} = [];   # all states in class at any level
    $$obj{states} = [];      # My immediate local states
    $$obj{enums} = {};       # global enums we're asked to declare
    $$obj{name} = $name;
    Context->AddObj($obj);  # add me to the context (model)
    bless $obj;
    return $obj;
}

sub GetName
{
    my ($obj) = @_;
    return $$obj{name};
}

sub GetObjRef
{
# I am the top (the class) so this is the reference everyone wants
    my $obj = shift;
    return $obj;
}

sub Signal
{
# Save declared signals we expect from other classs. Signal may have int parm.
# Signals are named objname_signame, but this is done in the output
# routines.
    my ($obj, $name, $type) = @_;
# mark this event as a signal and save parm var if there is one.
    $$obj{signal}{$name} = $type;
    Put Log "registering signal $name type $type";
    Context->AddEnum($$obj{name}, $name);  # add the signal name
}

sub IsASignal
{
# Determine if an event is a class->class signal
    my ($obj, $event) = @_;

    return exists($$obj{signal}{$event});
}

sub ThrownInterSig
{ 
# Unlike other signal methods, this one returns an indication of
# whether the signal is really sent inter-class from this class or
# not. To get a 'true' return, there has to be a ^Class.sig or
# send(Class.sig) somewhere in this class.

    my ($obj, $sig) = @_;

    return exists($$obj{outboundsig}{$sig});
}

sub ThrownIntraSig
{
# Check to see if the signal is thrown within the class
    my ($obj, $sig) = @_;

    return exists($$obj{internalsig}{$sig});
}

sub GetSignalVar
{
# detetmine is obj->obj signal has a parm
    my ($obj, $event) = @_;

    return $$obj{signal}{$event};
}

sub InstVar
{
# We just save instance variables here along with their type and initial
# values. Type 'enum' (enumeration) is noted separate because it takes
# a special declaration and the predicate testing it is different.
# The names saved are as declared without class qualification.
# VALID TYPES: int, boolean, enum
# For Promela, int--> int, boolean--> bool, 
    my ($obj, $type, $var, $initval) = @_;

    if ($type eq 'int' || $type eq 'enum') {}
    elsif ($type eq 'boolean') {$type = 'bool'}
    else {
	    Put Msg(level=>error, class=>$$obj{name}, 
		    msg=> "Unknown type $type");
    }

    $$obj{instvar}{$var} = [$type, $initval];
    if ($type eq 'enum') {
	$initval =~ s/ //g;   # clear blanks, if any
	foreach $val (split(/,/, $initval)) {
	    Context->AddEnum($$obj{name},$val);
	}
    }
}

sub VarExists
{
# Check to see if the raw variable name exists (has been declared). This implies that
# we need to see instvar declares before their usage, which is probably not good.
    my ($obj, $var) = @_;
    if (!exists($$obj{instvar}{$var})) {return 0}
    return $$obj{instvar}{$var};
}

sub HistoryPresent
{
    my ($obj) = @_;
    return exists($$obj{historypresent});
}

sub AllStates
{
# Every state everywhere is recorded here. We cycle thru them later to
# resolve dests on trans. Composite states don't have dests
    my ($obj, $state) = @_;

    Put Log "AllStates called by ",$state->GetName;
    push(@{$$obj{allstates}}, $state);
    return $obj;
}

sub AddState
{
# called by state process to include state in MY list of states
# This differs from AllStates by only having the states in the top
# level, where the former has ALL STATES in the entire class.
#  $state is a reference.
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

sub Find
{
    my ($obj, $dest) = @_;

    Put Log "Find for class $$obj{name} called. Looking for $dest";
# Look locally first.
    if (exists($$obj{owndest}{$dest})) {return ($$obj{owndest}{$dest}, '')}
    Put Log "$dest not local";
# Next, look down thru CState nodes
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) ne 'CState') {next}  # Skip all non-CStates
	if ($ent->GoDown($dest)) {  # parent -> child call
	    return ('down', $ent->GetName);
	}
    }
# If not found by now, then it doesn't exist
    die "class $$obj{name} can't find dest $dest";
}

# No GoDown method because I don't have any parents that can call me.
# See CState for description of GoUp and GoDown.

sub GoUp
{ 
# My children call me here looking for dest state.

    my ($obj, $dest, $caller) = @_;

    Put Log "GoUp of class $$obj{name} called, looking for $dest";

# Look locally
    if (exists($$obj{owndest}{$dest})) { # we own this simple state
	return [$$obj{owndest}{$dest}];  # return our context for $dest
    }
    
# Look down, cycle thru children
    foreach $ent (@{$$obj{states}}) {
	if ($caller == $ent) {next} # Don't loop back to caller class
	if (!$CS{ref($ent)}) {next}
	if ($ent->GoDown($$obj{$dest})) {
	    return ['down', $ent->GetName];
	}
    }
# If not found by now, then it doesn't exist in this class
    Put Msg(level=>error, class=>$$obj{name},
	    msg=> "Can't find transition destination $dest");
    exit(1);
}

sub Assoc
{
# All events flow thru evq and evt channels for now. Since they'll appear
# as events, we can ignore them here. This will work until we need to
# pass values on assoc. Then we'll need legitimate channels.
    return;
}

sub Dcl
{
    my ($obj, $var, $type) = @_;
# Save declared instance var.
    $$obj{ivars}{$var} = $type;
}


sub AddMtype
{
# This routine allows global delcaration of mtype variables; not definition.
# See AddEnum above for defintion of mtype value.
    my ($obj, $var, $initial) = @_;
    $$obj{mtypes}{$var} = $initial;
}

sub AddWhen
{
    my ($obj, $name, $clause) = @_;

    $$obj{when}{$name} = $clause;
}

sub INTarget
{
    my ($obj, $name) = @_;
# We are being told of a state name that is the target of an IN predicate
# somewhere in the class. We need to make en enum, an enum variable, and
# save state name so it can be queried later. The argument is a name, not 
# a reference.

    Put Log "$name added as IN target";
    $$obj{INtarget}{$name} = 1;
}

sub IsAINTarget
{
# $name is a symbolic name, not a reference.
    my ($obj, $name) = @_;
# return true if $name is a target of an IN predicate
    return exists($$obj{INtarget}{$name});
}

sub PreProcess
{
    my ($obj) = @_;
# Context calls us here when all the input is parsed. We need to do
# any final setups, like resolving dests, making CCState members appear
# local, etc. This is called before any output routine.

# First, we need to make children of CCStates we own look local to us.
# CCState->GetName returns a list of CStates it owns. We also call other
# PreProcess methods.
    my $ent;
    my $init;
    my $name;
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'Init') {$init = 1}
	$ent->PreProcess;
	if (ref($ent) eq 'CCState') {
	    my $member;
	    my $name;
	    foreach $member ($ent->GetMembers) {
		$$obj{owndest}{$member->GetName} = 'lclcs'}
	}
    }
    my $key;
    Put Log "Here is $$obj{name} owndest:";
    foreach $key (keys %{$$obj{owndest}}) {
	Put Log "state=$key, value=$$obj{owndest}{$key}";
    }

# See if there is an Init state
    if (!$init) {
	Put Msg(level=>'warn', class=>$$obj{name}, msg=> "No Initial state");
    }

# This is a good time to resolve all destinations
    my $i = @{$$obj{allstates}};
    Put Log "PreProcess called for $$obj{name}. $i states";
    foreach $ent (@{$$obj{allstates}}) {$ent->ResolveDest}
    Put Log "$$obj{name} dests all resolved";

# Check to see if signals we send are declared in other class. This data
# comes from TranTaccGram. key (signals) are in form class.signal
    my $key;
    foreach $key (keys %{$$obj{outboundsig}}) {
	Put Log "key=$key";
	my ($class, $sig) = split(/\./, $key);
	my $ref = Context->GetClassRefByName($class);
	if (!$ref) {
	    Put Msg(level=>error, class=>$$obj{name}, 
		    state=>$$obj{outboundsig}{$key}{name},
		    msg=> "State sends signal to nonexistent class $class");
	    next;
	}
	if (!$ref->IsASignal($sig)) {
	    Put Msg(level=>error, class=>$$obj{name}, 
		    state=>$$obj{outboundsig}{$key}{name},
		    msg=> "Signal '$sig', sent to class $class, "
		    . "is not declared");
	}
    }

# See if every used variable is declared.
    foreach $key (keys(%{$$obj{usedvar}})) {
	if (!exists($$obj{instvar}{$key})) {
	    my $states = join(' and ', @{$$obj{usedvar}{$key}});
	    Put Msg(level=>'warn', class=>$$obj{name},
		    msg=> "Instance variable $key is undeclared but used "
		    . "in state(s) $states");
	}
    }

# See if all declared variables are actually used somewhere
    foreach $key (keys(%{$$obj{instvar}})) {
	if (!exists($$obj{usedvar}{$key})) {
	    Put Msg(level=>'warn', class=>$$obj{name},
		    msg=> "Instance variable '$key' is declared but unused");
	}
    }
}

sub GlobalOutput
{
    my ($obj) = @_;
# This is the first output routine called. All global declares need to
# written at this time. Exception: Mtype dcls are at the context level
# because class can share signals (no... move it back here. prefix
# signal with class name.

    my $ent;

# Write out global mtype variable dcls. Some have initializers (history)
    foreach $ent (keys %{$$obj{mtypes}}) {
	if ($$obj{mtypes}{$ent}) {
	    Put Context 0, "mtype $ent=$$obj{mtypes}{$ent};";
	}
	else {Put Context 0,"mtype $ent;"}
    }

# write out my instance vars
    Put Log "starting to write instvars in $$obj{name}";
    if (keys %{$$obj{instvar}} || keys %{$$obj{INtarget}}) {
	Put Context 0, "typedef $$obj{name}_T {";
	foreach $ent (keys %{$$obj{instvar}}) {
	    if ($$obj{instvar}{$ent}[0] eq 'enum') {
		Put Context 1, "mtype $ent;";
	    }
	    else {Put Context 1, "$$obj{instvar}{$ent}[0] $ent;"}
	}
# Write out state vars for IN predicate
	foreach $ent (keys %{$$obj{INtarget}}) {
	    Put Context 1, "bool st_$ent;";
	}

	Put Context 1, "}";
	Put Context 0, "$$obj{name}_T $$obj{name}_V;";
    }

# Handle signals
    if (keys %{$$obj{signal}}) {
	Put Context 0,"chan $$obj{name}_q=[5] of {mtype};";
    }
# shared variables for signals...
# WARNING: shared variables may get overwritten.
#    foreach $ent (%{$$obj{signal}}) {
#	if ($$obj{signal}{$ent}) {
#	    Put Context 0,"$$obj{signal}{$ent} ${ent}v;"
#	    }
#    }

# Parameter channel for signals. Replacement for shared variable.
    foreach $ent (%{$$obj{signal}}) {
	if ($$obj{signal}{$ent}) {
	    Put Context 0,
	    "chan $$obj{name}_${ent}_p1=[5] of {$$obj{signal}{$ent}};";
	}
    }

    Put Log "global output done in $$obj{name}";
}
		
sub Output
{
    my $obj = shift;

# ----- Initial  stuff ------
# If this is the _SYSTEMCLASS_ we must note it and build proctype
# appropriately
    my $systemclass = $$obj{name} eq '_SYSTEMCLASS_';

# Categorize states we own.
    my @csnames;
    my @ccnames;
    my ($int, $mtype);
    my $init;
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'CState') {push(@csnames, $ent->GetName)}
	elsif (ref($ent) eq 'CCState') {
	    my $member;
	    foreach $member ($ent->GetMembers) {
		push(@ccnames, $member->GetName);
	    }
	    Put Log "CCState members", join(',', @ccnames);
	}
	elsif (ref($ent) eq 'History' || ref($ent) eq 'Init') {$init = $ent}
    }
    
    if ($systemclass) {
	Put Context 0,"active proctype $$obj{name}()";
    }
    else {Put Context 0,"proctype $$obj{name}()"}
    Put Context 0, "{";
# declare pid vars for runs and waits. First, add "_pid" to each
    my $dcl;
    my @dlist;    # temp variables to accumulate cdl list
    my @mlist;
    if (@csnames > 0) {
	foreach $ent (@csnames) {push(@dlist, "${ent}_pid")}
    }
    
# declare pid vars for CCState runs
    if (@ccnames > 0) {
	foreach $ent (@ccnames) {
	    push(@dlist, "${ent}_pid");
	    push(@mlist, "${ent}_code");
	}
	Put Context 0,"mtype " . join(',', @mlist) . ';';
    }
# from csname code above    
    if (@dlist) {Put Context 0, "int " . join(',', @dlist) . ';'}
    Put Context 0,"mtype m;";
    Put Context 0,"int dummy;";

# Debugging output to list to see enums
    foreach $ent (keys %{$$obj{enums}}) {
	Put Context 1,"printf(\"$ent=%d\\n\", $ent);";
    }

# Instance var initializers
    foreach $ent (keys %{$$obj{instvar}}) {
	if ($$obj{instvar}{$ent}[1]) {
	    Put Context 1, "$$obj{name}_V.$ent = $$obj{instvar}{$ent}[1];";
	}
    }

# Start when procs
    foreach $ent (keys %{$$obj{when}}) {
	Put Context 1,"run proc$ent();";
    }

# Do init state or history setup
    if ($init) {$init->LclOutput}

# now put out code for states and cstates. 
    foreach $ent (@{$$obj{states}}) {
	if (ref($ent) eq 'Join') {next} # Skip Joins. CCState will handle
	if (ref($ent) eq 'History' || ref($ent) eq 'Init') {next}
	$ent -> LclOutput;
    }

# Wind up this Class
    Put Context 0,"exit:skip";
    Put Context 0,"}";
    Put Context 0;

# Output body of composite states we own
    foreach $ent (@{$$obj{states}}) {
	Put Log "class name $$obj{name} outputing type ", ref($ent);
	$ent->Output;
    }
    Put Log "composite states done";

    Put Context 0;
}

1;		    
