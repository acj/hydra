#!/usr/bin/perl
# This class implments language-specific constructs for the
# transition parser. trangram.y calls this for items as listed below.
package TranYaccPak;

sub SetClassRef
{
# Set the reference to the class object so we can get at variables,
# and other goodies of this class. Also establish the class State.pm
# builds names from.
    my ($class, $obj, $state) = @_;
    $CLASSREF = $obj;
    $STATEREF = $state;
    $VOBJ = $CLASSREF->GetName;
}

sub InstVar  # return name of an instance variable for this class at hand
{
    my ($class, $var) = @_;

    if (!$CLASSREF->VarExists($var)) {
	my $classname = $CLASSREF->GetName;
	my $statename = $STATEREF->GetName;
	Put Msg(level=>error, class=>$classname, state=>$statename,
		msg=>"Variable $var is undeclared");
    }
    return "${VOBJ}_V.$var";
}


sub INPredicate
{
# In predicate implememtation. In addition to making the code, we have
# register the state target with the class. Register with the class
# because the state may not exists yet (may be further down in the
# text) 

    my ($class, $target) = @_;

    if (!Yacc->LkupSym($target)) {
	Put Msg(level=>error, class=>$VOBJ, state=>$STATEREF->GetName,
		msg=> "state $target undefined in IN predicate");
    }
    $CLASSREF->INTarget($target);
    return "${VOBJ}_V.st_$target";
}

sub Assign
{
# Assignment statement implementation. The grammar rule passes us the left
# side as a raw variable name. Must check to see if it's an enum. If so,
# need to unqualify right side and add to enum list.
    my ($class, $left, $right) = @_;
    
    $left = TranYaccPak->InstVar($left);
    if ($CLASSREF->VarExists($left) eq 'enum') {
	if ($right =~ tr/+\-\*\+//) {
	    Put Msg(level=>error, class=>$VOBJ, state=>$STATEREF->GetName,
		    msg=> "Value '$right' assigned to '$left' is not an enum");
	}
	($right) = $right =~ /^$VOBJ\_V\.(.+)/;
	Context->AddEnum($VOBJ, $right);
    }
    return "$left=$right;";
}

sub Logic
{
# Logic operations on vars
    my ($class, $op, $var1, $var2) = @_;

    my $ret = $op eq 'not' ? '!' . TranYaccPak->InstVar($var1) :
    $op eq 'or' ? "$var1 || $var2" :
    $op eq 'and' ? "$var1 && $var2" :
	'';
    $ret || die "Logic was passed a bad operator: <$op>";
    return $ret;
}

sub Compare
{
# We get called when there is a predicate with a compare op. Must check
# to see if one side or the other is an enum. If so, don't make the enum
# side into a variable name
# We are passed two expressions. They may be simple vars or complex
# expressions. In the enum case, see below.

# SPECIAL NOTE ON ENUMS:
# There is no good contruct or place to declare and enumerated type on
# a UML class diagram, so we accept the instance var declaration of
# 'enum', then look for each of it's uses in a 'is' phrase, like
# mode is heat. This will come to us as CLASS_V.mode, CLASS_V.heat, so
# we parse out the val ('heat') and call AddEnum to add this value to the
# enum list. This way we pick up every val of an enum (also see assign)


    my ($class, $arg1, $op, $arg2) = @_;

    if ($op eq 'is') {
	if ($CLASSREF->VarExists($arg1) ne 'enum') {
	    Put Msg(level=>error, class=>$VOBJ, state=>$STATEREF->GetName,
		    msg=> "Variable '$arg1' in compare either not defined "
		    . "or not type enum");
	}
	my $val;
	($val) = $arg2 =~ /^$VOBJ\_V\.(.+)/;
	Context->AddEnum($VOBJ, $val);
	return "$arg1==$val";
    }
    if ($op eq '=') {
	return "$arg1==$arg2"}
    else {return "$arg1$op$arg2"}
}

sub ClassSend
{
# Given send of the form Class.event(val) (optional val), builds a class 
# message send of the form:
# Without parm: Class_q!Eventname
# With parm   : atomic{Eventname_p1!val; Class_q!Eventname;}

    my ($class, $objname, $signame, $val) = @_;

# Save call to other class so we can check it later.
    $$CLASSREF{outboundsig}{"$objname.$signame"} = $STATEREF;
    if ($val) {
	return "atomic{${objname}_${signame}_p1!$val; ${objname}_q!$signame};"
	}
    else {return "${objname}_q!$signame;"}
}

sub StateSend
{
# Semantics for signal send within a class.
# Message has form event(val) (optional val), builds a intraclass send.
    my ($class, $id) = @_;

# Save intra-state signal. Reference to state is saved.
    $$CLASSREF{internalsig}{$id} = $STATEREF;
    return "run event($id);";
}

sub New
{
# This routine generates the code to instantiate and start an object
    my ($class, $newclass) = @_;

    return "run $newclass();";
}

sub RawVar
{
# This method takes a variable name either qualified with the class name
# or not qualified and returns the unqualified, parsed (simple) variable
# name that Yacc knows about.
    my ($class, $var) = @_;

    my $simple = '';
    ($simple) = $var =~ /^$VOBJ\_V\.(.+)/;
    return $simple ? $simple : $var;
}
1;




