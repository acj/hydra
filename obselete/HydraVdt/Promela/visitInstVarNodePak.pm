#!/usr/bin/perl

package visitInstVarNodePak;

use UniversalClass;

#SK 041003 Change to support time invariants
sub GlobaloutputInstVarBody 
{
    my ($class,$thisinstvarnode,$GlobalTimerInstVarOutput,$GlobalTimerList,@GlobaloutputInstVarBody)=@_;
    my $vtype=$thisinstvarnode->{vtype};
    my $var=$thisinstvarnode->{var};
    
    if($vtype ne 'timer')
    {
        push(@GlobaloutputInstVarBody,"        $vtype $var;");   
    }
    else
    {   
        push(@$GlobalTimerInstVarOutput,"       short $var=-1;");
        push(@$GlobalTimerList,$var);   
    }
    return @GlobaloutputInstVarBody; 
    #SK 041003 end change
}

sub outputInstVar 
{
    my ($class, $thisinstvarnode, @outputInstVar)=@_;
    
    my $var=$thisinstvarnode->{var};
    my $initval=$thisinstvarnode->{initval};
    
    #search for classname
    my $instvarref=UniversalClass->FindLocalDestNode($thisinstvarnode,"InstVarNode",$var,"var");
    my $classname=$instvarref->{parent}->{parent}->{ID};
    
    $temp1=$classname."_V.";
    push(@outputInstVar,"        $temp1$var = $initval;");
    
    return @outputInstVar;
}

1; 