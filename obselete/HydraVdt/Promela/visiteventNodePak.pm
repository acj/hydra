#!/usr/bin/perl

package visiteventNodePak;

use UniversalClass;

sub OnePartEventOutput 
{
    my ($class,$thiseventnode,@outputState)=@_;
    
    my $classref=UniversalClass->SearchUpForDest($thiseventnode,"ClassNode");
    my $classname=$classref->{ID};
    my $eventname=$thiseventnode->{eventname};
    
     #KS 062203 added time invariant to normal transitions
    my $statetimeinvariant=ASTVisitorForPromela->GetstatetimeinvariantAndUndef();
    my $temp=$classname."_q";
    
    if($statetimeinvariant eq '')
    {
        push(@outputState,"        :: atomic{$temp?$eventname -> ");
    }
    else
    {
        push(@outputState,"        :: atomic{Timer_V.$statetimeinvariant && $temp?$eventname -> ");
    }
     #KS 062203 and add
    
    return @outputState;
}

sub TwoPartEventOutput 
{
    my ($class,$thiseventnode,@outputState)=@_;

    my $classref=UniversalClass->SearchUpForDest($thiseventnode,"ClassNode");
    my $classname=$classref->{ID};
    my $eventname=$thiseventnode->{eventname};
    my $eventvar=$thiseventnode->{eventvar};
    
    #KS 062203 added time invariant to normal transitions
    my $statetimeinvariant=ASTVisitorForPromela->GetstatetimeinvariantAndUndef();
    
    my $temp1=$classname."_q";
    my $temp2=$classname."_";
    my $temp3=$eventname."_p1";
    my $temp4=$classname."_V.";
    if($statetimeinvariant eq '')
    {
        push(@outputState,"        :: atomic{$temp1?$eventname ->");
    }
    else
    {
        push(@outputState,"        :: atomic{Timer_V.$statetimeinvariant && $temp1?$eventname ->");
    }
    push(@outputState,"                   $temp2$temp3?$temp4$eventvar");
    push(@outputState,"                   -> ");
    #KS 062203 end add
    
    return @outputState;
}

sub addTomtypelist 
{
    my ($class,$signalname,@mtypelist)=@_;
    my $found=0;
    if (scalar(@mtypelist) eq 0)
    {
        push(@mtypelist,$signalname);
        return @mtypelist;
    }
    else
    {
        $found=UniversalClass->ifinarray($signalname,@mtypelist);
    }
    
    if ($found eq 0)
    {
        push(@mtypelist,$signalname);
    }
    
    return @mtypelist;
}   

1; 