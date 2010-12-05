#!/usr/bin/perl
package State;
use Msg;

sub BEGIN
{
    $EVENTCNT = 1;   # This counts no-event transitions without guards.
}

sub new
{
    my ($class, $parent, $name) = @_;

    my $obj = {};
    bless $obj;
    $$obj{parent} = $parent;
    $$obj{name} = $name;
    $$obj{objref} = $parent->GetObjRef;  # get a ref to object we're in.
    Put Log "my parent class is ",$$obj{objref}->GetName,"\n";
    $$obj{dest} = [];
    $parent->AddState($obj);
    $$obj{objref}->AllStates($obj);   # tell our object we're here.
    return $obj;
}

sub GetName
{
    my ($obj) = @_;

    return $$obj{name};
}

sub MakeInTarget
{
# Called to force making of an IN target variable
    my $obj = shift;
# Make me a target.
    $$obj{objref}->INTarget($$obj{name});
}

sub Tran
{
# We parse the transition. This produces a delimited string of event,guard
# action,msg. Save each in a hash by it's delimiter type. If event=null
# grab a number for a placeholder on the event hash.
    my ($obj, $tran, $dest, $lineno) = @_;

    my $classname = $$obj{objref}->GetName;
    Put Log "Transition on line $lineno\n";
    my $ret;
    $tran =~ s/ +$//;
    if ($tran) {
# tell the parser what class and state we are working on 
# (for access to vars, errors, etc).
	TranYaccPak->SetClassRef($$obj{objref}, $obj);
	Put Log "transition before parse <$tran>";
	$ret = TranYacc->Parse($tran);
	if (!$ret) {
	    Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		    msg=> "Transition parse error for expression "
		    . "'$tran' near <" . TranYacc->LastToken . '>');
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
# Check to see if there IS an event. 
    if (!exists($tab{E}) || $tab{E} eq 'NULL') {
	$tab{E} = 'NOEVENT'}   # No event, placeholder.
    push(@{$$obj{event}{$tab{E}}}, [$tab{G}, $tab{A}, $tab{M}, $dest]);
    if (!Yacc->LkupSym($dest)) {
	Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		msg=> "State $dest is an undefined transition destination");
    }
    $$obj{sigvar}{$tab{E}} = $tab{V};
    Put Log "event=$tab{E}";
    Put Log "var=$tab{V}";
    Put Log "guard=$tab{G}";
    Put Log "action=$tab{A}";
    Put Log "msg=$tab{M}";
    Put Log "dest=$dest";
}

sub Action
{

# (This code is cloned to CState, that is, there is a copy of Action
# there too.. Changes here should go there too) We parse the in-state
# action. This produces a delimited string of event,guard
# action,msg. The only legal 'events' are ENTRY, EXIT, and DO. Guards
# are not permitted nor are parms. Otherwise, this looks just like a
# transition.

    my ($obj, $act, $lineno) = @_;

    my $classname = $$obj{objref}->GetName;
    my $ret;
    if ($act) {
	TranYaccPak->SetClassRef($$obj{objref}, $obj); # tell parser about class
	Put Log "class is $classname, action before parse <$act>";
	$ret = TranYacc->Parse($act);
	if (!$ret) {
	    Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		    msg=> "Bad action expression '$act' near <"
		    . TranYacc->LastToken . '>');
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
	Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		msg=> "Internal actions can't have guards");
    }
    if (exists($tab{V})) {
	Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		msg=> "Action $tab{E} can't have variables");
    }
    if ($tab{E} ne 'entry' && $tab{E} ne 'exit') {
	Put Msg(level=>error, class=>$classname, state=>$$obj{name},
		msg=> "Action $tab{E} is not legal");
	return;
    }

# Push an action onto the action list (entry, exit)
    push(@{$$obj{action}{$tab{E}}}, [$tab{A}, $tab{M}]);
}

sub GetParent
{
# return my parent composite thingy (CState or Class)
    return $$obj{objref};
}


# Ok, here's what we do below: The object knows about every state. At output
# time, the object cycles thru the states, and each state resolves where
# each dest is relative to the owner of this state. Results can be 'up',
# 'down', or 'lcl'. If down, we need the cstate to go down to.

sub ResolveDest
{
    my $obj = shift;

    Put Log "Resolve called for state $$obj{name}";
    my $parent = $$obj{parent};
    my ($ent,$dir,$csname, $ref);
    foreach $e (keys %{$$obj{event}}) {     # this gets each event
	foreach $g (@{$$obj{event}{$e}}) {  # this gets each guard/action
	    $dest = $$g[3];                 # get the dest
# This handles transition to 'exit' state
	    if ($dest eq 'exit') {
		$$obj{desttype}{$dest} = 'lcl';
		next;
	    }
	    $ref = $$obj{parent}->GoUp($dest, $obj);  # resolve direction
	    Put Log "Got back:$$ref[0], $$ref[1]";
	    if (!$$ref[0]) {die "can't find dest $dest"}
	    $$obj{desttype}{$dest} = $$ref[0];   # save direction
	    $$obj{cstate}{$dest} = $$ref[1];     # save ref to CState, if req'd
# Setup enum for state name 
	    if ($$ref[0] eq 'up' || $$ref[0] eq 'down') {
		Context->AddEnum($$obj{objref}->GetName, "st_$dest");
	    }
	}
    }
}

sub PreProcess
{
    my $obj = shift;

# Get a list of all classes by ref. Will use this below to check for unused
# signals.    
    my @classrefs = Context->GetClassRefList;
    my $classname = $$obj{objref}->GetName;

# We scan all events and register enums for those that are NOT
# signals. 'Class' already registered signals.

# In the loop below, we also make sure each event we listen for is thrown
# by somebody. The class knows this because TranYaccGram sets a hash
# for every signal thrown.

# NOTE: we continue to save signals by their name without the OBJ_ prefix.

    my $e;
    my $objref = $$obj{objref};
    foreach $e (keys %{$$obj{event}}) {
	if ($e ne 'NOEVENT' 
	    && $e !~ /^\*\*when/
	    && !$objref->IsASignal($e)) {
	    Context->AddEnum($objref->GetName, $e);

# Now check if signal is thrown (this is NOT a NOEVENT)
	    my $ok = 0;
	    foreach $class (@classrefs) {
		if ($class->ThrownInterSig("$classname.$e")) {
		    $ok = 1;
		    last;
		}
	    }
	    if ($objref->ThrownIntraSig($e)) {$ok = 1}
	    if (!$ok) {
		Put Msg(level=>'warn', class=>$classname, state=>$$obj{name},
			msg=> "Event $e on transition is not thrown "
			. "anywhere (event can't happen)");
	    }
	}
	if (grep($$_[0], @{$$obj{event}{$e}}) > 0) {$$obj{needlabel} = 1}
    }
}

sub Output {return}

sub LclOutput
{
    my $obj = shift;

    
    Put Log "LclOutput for state $$obj{name}";

    my $objref = $$obj{objref};  # get objrect ref to save writing.
    my $objname = $objref->GetName;  # get name of class

    Put Context 0, "/* State $$obj{name}   */";
    Put Context 0,"$$obj{name}:printf(\"in state $objname.$$obj{name}\\n\");";
# Do we need to save state for history
    if ($$obj{parent}->HistoryPresent) {
	Put Context 1,"H_", $$obj{parent}->GetName, " = st_$$obj{name};",
	"  /* Save state for history */";
    }

# 'entry' actions, if any. This is a list of [action, messages]
    my $ent;
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

# Do we need guarded transition label?
# See below.
    if ($$obj{needlabel}) {Put Context 0,"$$obj{name}\_G:"}

# Set up events we look for. Incoming signals are prefixed with objname
    foreach $e (keys %{$$obj{event}}) {
	Put Log "setting up event $e in state $objname";
# Either no transition event or when clause. Either way, don't queue event.
	if ($e eq 'NOEVENT'
	    || $e =~ /\*\*when/) {next}
# queued semantics
	if (!$objref->IsASignal($e)) {Put Context 1,"evq!$e,_pid;"}
    }

# If we are target of IN predicate, need assignment stmt
    if ($objref->IsAINTarget($$obj{name})) {
	Put Context 1,"${objname}_V.st_$$obj{name} = 1;"
    }

# The next SPIN stmt assures RTC semantics. This state has to be a
# target of something, and the previous state took 'free' out of
# channel 't' to stop all other transitions while this transition is
# in progress. Now, if 'free' is not in channel 't', we place it there
# (because the transition has ended. We are 'here'). Once we get an
# event, we'll wait until 'free' is present (meaning no transitions
# are in progress), then proceed with the transition. This assures
# only one transition at a time carries out actions and goes to a new
# dest.

    Put Context 1, "atomic {if :: !t?[free] -> t!free :: else skip fi;}";
# Wait for events, and build transitions, actions, send msgs.
# If event is signal, and there is a parm, save it.
# Keys are events, saved as [guard, action, msg, dest, var]
# First check if there are guards (the grep)
    my $dest;
    Put Context 1,"if";
    my $wc;
    foreach $e (keys %{$$obj{event}}) {
	$wc = '';       # blank out when condition
	Put Log "working on event $e in state $$obj{name}";
	if ($e eq 'NOEVENT') {PutNR Context 1, ":: 1 -> "}  # no event
	elsif ($objref->IsASignal($e)) {
	    Put Log "$e is a signal var=$$obj{sigvar}{$e}";
	    if ($$obj{sigvar}{$e}) {
# queued semantics
		PutNR Context 1, ":: atomic{${objname}_q?$e -> ",
		"${objname}_${e}_p1?$$obj{sigvar}{$e}} -> ";
# The next statement uses a temp variable: WARNING there is nothing
# to guarrantee that this variable won't get overwritten.
#		"$$obj{sigvar}{$e} = ${e}v} -> ";
# non queued semantics
#		PutNR Context 1, ":: atomic{evt??$e,eval(_pid) -> ",
#		"$$obj{sigvar}{$e} = ${e}v} -> ";
	    }
	    else {
# queued semantics
		PutNR Context 1, ":: ${objname}_q?$e -> ";
# non-queued
#		PutNR Context 1, ":: evt??$e,eval(_pid) -> ";
	    }
	}
# Pick up when clause and make the predicate a Promela guard like an event
	elsif ($e =~ /^\*\*when/) {
	    ($wc) = $e =~ /^\*\*when(.+)/;   # The when conmdition is saved
	    PutNR Context 1, ":: $wc -> ";   # for below
	}
	else {PutNR Context 1, ":: evt??$e,eval(_pid) -> "}

	PutNR Context 0,"t?free; ";
# If IN predicate, we need to clear variable
	if ($objref->IsAINTarget($$obj{name})) {
	    PutNR Context 0,"${objname}_V.st_$$obj{name} = 0;";
	}
	
# Now for the code that follows the event.
# $$obj{event}{<event-name>} is a list. Each entry is another list with:
# 0=guard, 1=action 2=msg 3=dest 4=var
# First we check to see if there are any guards. If so, we need an 'if'
# construct. No condition is '1'
	if (grep($$_[0], @{$$obj{event}{$e}})) { # any guards?
	    Put Log "guards present";
	    Put Context 0,"if";                 # 'if' for guard
	    foreach $g (@{$$obj{event}{$e}}) {  # enumerate conditions
		Put Log "gd=$$g[0], action=$$g[1], msg=$$g[2] ",
		"dest=$$g[3], var=$$g[4]";

# check for guard. No guard gets a '1'
		if ($$g[0]) {PutNR Context 2,":: $$g[0] -> "}
		else {PutNR Context 2,":: 1 -> "}
		codeseq($g, $obj);   # write out code seq
	    }
# Need this to flush event if guard is false. If guard is on 'when'
# need to wait until when-predicate ($wc) becomes false before 
# back to _G label.
	    if ($wc) {
		Put Context 2, ":: else -> !($wc) -> goto $$obj{name}\_G";
	    }
	    else {
		Put Context 2,":: else -> goto $$obj{name}\_G";
	    }
	    Put Context 2,"fi";
	}
# If we are here there are no guards, and hence one set of code for this event.
# (The only way to have a list is to have multiple guards for the same event)
	else {
	    codeseq($$obj{event}{$e}[0], $obj); # there is only 1 item on list
	}
    }
# If there are no transitions, we arrive here without executing the previous
# code. Here we build a 'stop and hang' construct.
    if (keys(%{$$obj{event}}) == 0) {
	Put Context 1,":: skip -> false";
	Put Msg(level=>'warn', class=>$objname, state=>$$obj{name},
		msg=> "State can never be exited (no outbound transitions)");
    }
    Put Context 1,"fi;";  # if that closes off event dispatch
}

sub codeseq
{

# This routine completes the transition code. It writes an action, if
# any and the msg sequence, if any, then exit action, if any, then
# calls write_tran to pick the right transition mechanism (goto,
# run(), etc...)  parm1($g) is ref to transition list, parm2 ($obj) is
# ref to state obj.

    my ($g, $obj) = @_;

# $g is ref to list: 0=guard, 1=action 2=msg 3=dest 4=var
# check for action
    if ($$g[1]) {PutNR Context 0, " $$g[1]"}
		
# check for msg
    if ($$g[2]) {PutNR Context 0, " $$g[2]"}

# check for exit actions. List of [action, msg]
    my $ent;
    if (exists($$obj{action}{'exit'})) {
	my $i;
	foreach $ent (@{$$obj{action}{'exit'}}) {
	    foreach $i (0,1) {
		if (!$$ent[$i]) {next}
		$$ent[$i] =~ s/ +$//;      # trim off blanks
		PutNR Context 0, $ent[$i];
		if ($$ent[$i] !~ /;$/) {Put Context 0, ";"}
	    }
	}
    }

# Finally, write dest expression
    write_tran($$obj{desttype}{$$g[3]}, $$g[3], $$obj{cstate}{$$g[3]});
    Put Context 0;
}

sub write_tran
{
    my ($desttype, $dest, $cstate) = @_;
# This is a local routine to write out the right kind of transition.
    
    Put Log " WriteTran desttype=$desttype, dest=$dest, cstate=$cstate";
# local state transition, use goto
    if ($desttype eq 'lcl') {
	PutNR Context 0," goto $dest";
    }
    elsif ($desttype eq 'lclcs') {
	PutNR Context 0," goto to_$dest";
    }
# transition to state up somewhere (higher level)
    elsif ($desttype eq 'up') {
	PutNR Context 0," wait!_pid,st_$dest; goto exit";
    }
# transition to lower CState
    elsif ($desttype eq 'down') {
	PutNR Context 0," m = st_$dest; ",
	"goto to_$cstate";
    }
# whoops! we have a problem here....
    else {die "destination <$desttype> not typed"}
}
1;

