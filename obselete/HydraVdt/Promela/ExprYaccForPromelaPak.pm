#!/usr/bin/perl

package ExprYaccForPromelaPak;

use UniversalClass;
use ASTVisitorForPromela;

my $classref;

sub PassRef 
{
    my $class=shift();
    $classref=shift();  #class var of ExprYaccForPromelaPak.pm
    
    return;
}

sub Assignment 
{
# Assignment statement implementation. The grammar rule passes us the left
# side as a raw variable name. Must check to see if it's an enum. If so,
# need to unqualify right side and add to enum list.
    my ($class, $left, $right) = @_;

    my $newleft = ExprYaccForPromelaPak->InstVar($left);
    
#    if ($CLASSREF->VarExists($left) eq 'enum') {
#        if ($right =~ tr/+\-\*\+//) {
#            Put Msg(level=>error, class=>$VOBJ, state=>$STATEREF->GetName,
#                    msg=> "Value '$right' assigned to '$left' is not an enum");
#        }
#        ($right) = $right =~ /^$VOBJ\_V\.(.+)/;
#        Context->AddEnum($VOBJ, $right);
#    }
    return "$newleft=$right;";
}

#SK 041403 Added call back to ASTVisitorForPromela to receieve TimerList
sub InstVar
{
    my ($class,$instvar)=@_;
    
    my @GlobalTimerList;
    
    @GlobalTimerList=ASTVisitorForPromela->GetGlobalTimerList;
#check if in classbodyNode this $instvar is defined or not
#if not, then a warning, otherwise return "<classname>_V.$instvar"
    
    my $thisclassref=UniversalClass->SearchUpForDest($classref,"ClassNode");
    my $classname=$thisclassref->{ID};
    my $returnvalue=UniversalClass->FindLocalDestNode($classref,"InstVarNode",$instvar,"var");
    
    my $temp=$classname."_V.";
        
    foreach $ent (@GlobalTimerList)
    {
        if ($ent eq $instvar)
        {
            $temp="Timer_V.";
        }
    }
    
    if ($returnvalue ne '')
    {
        return "$temp$instvar";
    }
    else
    {
        #SK 091903 Changed to make declaration in _SYSTEMCLASS_ global
        #Just assume it is global rather than undeclared (I know, just a hack, can make it better later)
        #SPIN will complain anyways about undeclared variables
        #die("In Class [$thisclassref->{ID}], instance variable [$instvar] undefined.");
        return $instvar;
        #SK 091903 end change
    }
}
#SK 041403 end of changes

sub Logic
{
    my ($class,$operator,$var1,$var2)=@_;
    
    my $ret = $operator eq 'not' ? '!' . ExprYaccForPromelaPak->InstVar($var1) :
              $operator eq 'or' ? "$var1 || $var2" :
              $operator eq 'and' ? "$var1 && $var2" :
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

    my ($class, $arg1, $operator, $arg2) = @_;

#    if ($operator eq 'is') {
#        if ($CLASSREF->VarExists($arg1) ne 'enum') {
#            Put Msg(level=>error, class=>$VOBJ, state=>$STATEREF->GetName,
#                    msg=> "Variable '$arg1' in compare either not defined "
#                    . "or not type enum");
#        }
#        my $val;
#        ($val) = $arg2 =~ /^$VOBJ\_V\.(.+)/;
#        Context->AddEnum($VOBJ, $val);
#        return "$arg1==$val";
#    }
    if ($operator eq '=') 
    {
            return "$arg1==$arg2"
        }
        else 
        {
            return "$arg1$operator$arg2"
        }
}

sub INPredicate
{
# In predicate implememtation. In addition to making the code, we have
# register the state target with the class. Register with the class
# because the state may not exists yet (may be further down in the
# text) 

        my ($class, $target) = @_;

    my $thisclassref=UniversalClass->SearchUpForDest($classref,"ClassNode");
    my $classname=$thisclassref->{ID};

    my $myparent=$classref->{parent}->{parent}->{parent};  #$myparent->{object} eq 'StateNode' or 'CStateNode'
    my $parentname=$myparent->{ID};

        if (!Yacc->LkupSym($target)) 
        {
            die "In class $classname, $myparent->{object} $parentname, state $target undefined in IN predicate."
    }
    
        my $thisclassbodyref=UniversalClass->SearchUpForDest($classref,"classbodyNode");
        ASTINPredVisitorForPromela->INTarget($thisclassbodyref,$target);  #the classbodyNode to record this state is a IN-Predicate target
        
        my $temp1=$classname."INPredicate_V.";
        my $temp2="st_".$target;
        return "$temp1$temp2";
}

1;
