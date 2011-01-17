#!/usr/bin/perl
# This class implments language-specific constructs for the
# transition parser.
package LTLYaccPak;

sub SetClassRef
{
# Set the reference to the class object so we can get at variables,
# and other goodies of this class. Also establish the class State.pm
# builds names from.
    my ($class, $obj) = @_;
    $CLASSREF = $obj;
    $VOBJ = $CLASSREF->GetName;
}

sub InstVar  # return name of an instance variable for this class at hand
{
    my ($class, $var) = @_;

    return "${VOBJ}InstVar2_V.$var";
}


sub INPredicate
{
# In predicate implememtation. In addition to making the code, we have
# register the state target with the class.
    my ($class, $target) = @_;

    if (!Yacc->LkupSym($target)) {
    print "**** Error: state $target undefined in IN predicate in"
        . " class $VOBJ\n";
    }
    $CLASSREF->INTarget($target);
    return "${VOBJ}INPredicate_V.st_$target";
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
        print "**** Error: right hand side of $left is not an enum type\n";
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
# SPECIAL NOTE ON ENUMS:
# There is no good contruct or place to delcare and enumerated type on
# a UML class diagram, so we accept the instance var declaration of
# 'enum', then look for each of it's uses in a 'is' phrase, like
# mode is heat. This will come to us as CLASS_V.mode, CLASS_V.heat, so
# we parse out the val ('heat') and call AddEnum to add this value to the
# enum list. This way we pick up every val of an enum (also see assign)
    my ($class, $arg1, $op, $arg2) = @_;

    if ($op eq 'is') {
    if ($CLASSREF->VarExists($arg1) ne 'enum') {
        print "**** Error: variable $arg1 either not defined",
        " or not type enum\n";
    }
    my $val;
    ($val) = $arg2 =~ /^$VOBJ\_V\.(.+)/;
    Context->AddEnum($VOBJ, $val);
    return "$arg1==$val";
    }
    if (!Yacc->LkupSym(TranYaccPak->RawVar($arg1))) {
    print "**** Error: variable $arg1 not defined\n";
    }
    if (!Yacc->LkupSym(TranYaccPak->RawVar($arg2))) {
    print "**** Error: variable $arg2 not defined\n";
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
    $$CLASSREF{outboundsig}{"$objname.$signame"} = 1;
# Changed to have only one atomic wraped around
#SK 04-04-03
#    if ($val) {return "atomic{${signame}_p1!$val; ${objname}_q!$signame};"}
    if ($val) {return "${signame}_p1!$val; ${objname}_q!$signame;"}
    else {return "${objname}_q!$signame;"}
}

sub StateSend
{
# Semantics for signal send within a class
    my ($class, $id) = @_;

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




