#!/usr/bin/perl

#This visitor is to get all the INPredicate of one classbodyNode
#return @INPredicateTarget to ASTVisitorForPromela.pm;
#used by ASTVisitorForPromela.pm;

package ASTINPredVisitorForPromela;

use TraverseVisitor; #SUPER
our @ISA=("TraverseVisitor");

use UniversalClass;
use ExprYaccForPromela;
use ExprYaccForPromelaPak;

#to hold all the INPredicate targets of every class
#every entry is a hash which including a ref to a classbodyNode and a list of INPredicate Targets
my @INPredicateTarget;          

#pass @INPredicateTarget to ASTVisitorForPromela.pm/sub visitmodelodyNode()
sub GetResult
{
    return @INPredicateTarget;
}

#called by ExprYaccForPromelaPak.pm
sub INTarget
{
    my ($class,$thisclassbodyref,$target)=@_; 
    #$target is a state/cstate/ccstate Name not a Ref
    #$thisclassbodyref is to indicate who owns that IN-Predicate    

#add $target to the list of $thisclassbodyref if not overlapping to @INPredicateTarget
    AddNewINPredicate($thisclassbodyref,$target);
}

#used by INTarget
sub AddNewINPredicate
{
    my ($thisclassbodyref,$target)=@_;
    
    my $ent;
    my $found=0;
    foreach $ent (@INPredicateTarget)
    {
        $found=0;
        if ($ent->{classbodyref} eq $thisclassbodyref)  #compare two refs
        {
            $found=1;
            my $INPredicatelist=$ent->{INPredicatelist};
        #check if $target is already in $INPredicatelist or not
            my $inarray=UniversalClass->ifinarray($target,@$INPredicatelist);
            if ($inarray eq 0)
            {
                push(@$INPredicatelist,$target);
            }
            return;
        }
    }

#add a new entry to @INPredicateTarget
    my $entry={classbodyref=>undef,INPredicatelist=>undef};
    my $INPredicatelist;
    push(@$INPredicatelist,$target);        #assign a value
    $entry->{classbodyref}=$thisclassbodyref;   #assign a value
    $entry->{INPredicatelist}=$INPredicatelist;
    push(@INPredicateTarget,$entry);
    
    return;
}

sub visitmodelbodyNode
{
    my ($thisvisitor,$themodelbodynode) = @_;

    my $stmt = $themodelbodynode->{child};
        my $ent;
    foreach $ent (@$stmt) 
    {
        if ($ent->{object} eq 'ClassNode') #This ClassNode is not empty
        {
            $ent->Accept($thisvisitor);
        }
    }
}

sub visitclassbodyNode 
{
    my ($thisvisitor, $theclassbodynode)=@_;
    
    my $stmt = $theclassbodynode->{child};
    foreach $ent (@$stmt) 
    {
            if ($ent->{object} eq 'StateNode')
            {
                $ent->Accept($thisvisitor);
            }
        elsif ($ent->{object} eq 'CStateNode')
        {
            $ent->Accept($thisvisitor);
            }
            elsif ($ent->{object} eq 'CCStateNode')
        {
            $ent->Accept($thisvisitor);
            }
        }
}

sub visitstatebodyNode
{
    my ($thisvisitor,$thisstatebodynode)=@_;

        my $stmt = $thisstatebodynode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            if ($ent->{object} eq 'TransNode')
            {
                $ent->Accept($thisvisitor);
            }
    }   
}

sub visitcstatebodyNode
{
    my ($thisvisitor,$thiscstatebodynode)=@_;
        
        my $stmt = $thiscstatebodynode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            if ($ent->{object} eq 'CStateNode')
            {
                $ent->Accept($thisvisitor);
            }
            elsif ($ent->{object} eq 'CCStateNode')
            {
                $ent->Accept($thisvisitor);
            }
            elsif ($ent->{object} eq 'TransNode')
            {
                $ent->Accept($thisvisitor);
            }
            elsif ($ent->{object} eq 'StateNode')
            {
                $ent->Accept($thisvisitor);
            }
        }
}

sub visitccstatebodyNode
{
    my ($thisvisitor,$thisccstatebodynode)=@_;
    
    my $stmt = $thisccstatebodynode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            if ($ent->{object} eq 'CStateNode')
            {
                $ent->Accept($thisvisitor);
            }
        elsif ($ent->{object} eq 'StateNode')
            {
                $ent->Accept($thisvisitor);
            }       
        }
}

sub visitTransNode
{
    my ($thisvisitor,$thistransnode)=@_;
    
    if ($thistransnode->{tran} ne '')
    {
        $thistransnode->{tran}->Accept($thisvisitor);
    }
}

sub visittransitionbodyNode 
{
    my ($thisvisitor,$thetransitionbodynode)=@_;
    
    #event
    if ($thetransitionbodynode->{event} ne '')
    {
        $thetransitionbodynode->{event}->Accept($thisvisitor);
    }
    
    #guard
    if ($thetransitionbodynode->{guard} ne '')
    {
        my $guard=$thetransitionbodynode->{guard};
        ExprYaccForPromelaPak->PassRef($thetransitionbodynode);
        my $result=ExprYaccForPromela->Parse("$thetransitionbodynode->{guard}");
        if ($result eq '')
        {
            my $classref=UniversalClass->SearchUpForDest($thetransitionbodynode,"ClassNode");
            die "In Class [$classref->{ID}], bad expression [$thetransitionbodynode->{guard}]!";
        }
    }
}

sub visiteventNode
{
    my ($thisvisitor,$theeventnode)=@_;
    
    if ($theeventnode->{eventtype} eq 'when')
    {
        ExprYaccForPromelaPak->PassRef($theeventnode);
        my $result=ExprYaccForPromela->Parse("when($theeventnode->{whenvar})");
        if ($result eq '')
        {
            my $classref=UniversalClass->SearchUpForDest($theeventnode,"ClassNode");
            die "In Class [$classref->{ID}], bad expression [when($theeventnode->{whenvar})]!";
        }
    }
}

1;
