#!/usr/bin/perl

package ASTStateVisitorForPromela;

use TraverseVisitor;
our @ISA=("TraverseVisitor");   #SUPER
use UniversalClass;

my @temparray;  #added 31/7/2002 11:47AM
undef(@temparray);

#parameters passed from class visitclassbodyNodePak.pm/visitcstatebodyNodePak.pm
my $CSNode='';
my @outputCState;
my @mtypelist;

#these subs are used to receive parameters from visitclassbodyNodePak.pm/visitcstatebodyNodePak.pm
sub PassNodeToProcess 
{
    my $thisvisitor;
    #assign value to global var: $CSNode
    ($thisvisitor,$CSNode)=@_;
}

sub PassoutputCState 
{
    my $thisvisitor;
    #assign value to global var: @outputCState
    ($thisvisitor,@outputCState)=@_;
}

sub Passmtypelist 
{
    my $thisvisitor;
    #assign value to global var: @mtypelist
    ($thisvisitor,@mtypelist)=@_;
}

sub GetoutputCState 
{
    @outputCState=UniversalClass->jointwoarrays(\@temparray,\@outputCState);  #added 31/7/2002 11:50AM
    return @outputCState;
}

sub Getmtypelist 
{
    return @mtypelist;
}

#{dest} of TransNode is the thing I am looking for
sub visitTransNode 
{
    my ($thisvisitor, $thetransnode)=@_;
    
    my $found=0;
    my $dest=$thetransnode->{dest}; 
    
    my $SorCSorCCS=ASTStateVisitorForPromela->SearchIncluding($CSNode,$dest); 
        #an inner subroutine, search if $dest is in the subtree of $CSNode (including) or not
    if ($SorCSorCCS ne '')  #$dest is in the subtree of $CSNode (excluding $CSNode), I don't need to output here
    {
        if ($SorCSorCCS eq $CSNode)  #use the comparison of two refs
        {#output here
            my $temp10="st_".$dest;
            my $temp11="to_".$dest;
        #modified 31/7/2002 11:48AM
            #push(@outputCState,"        :: m == $temp10 -> goto $temp11;");  #removed 31/7/2002 11:48AM
            my $outputstring="        :: atomic{m==$temp10 -> goto $temp11; skip;};";
            $found=UniversalClass->ifinarray($outputstring,@temparray);
            if ($found eq 0)
            {
                push(@temparray,$outputstring);
            }
        #modified end
            $found=UniversalClass->ifinarray($temp10,@mtypelist);
            if ($found eq 0)
            {
                push(@mtypelist,$temp10);
            }
            return;
        }
        return; #don't output anything
    }
    else
    {#continue to search if $dest is in the subtree of $ClassNode or not
        #get $classNode
        my $ClassNode=UniversalClass->SearchUpForDest($thetransnode,"ClassNode");
        #search it
        $SorCSorCCS=ASTStateVisitorForPromela->SearchIncluding($ClassNode,$dest); #inner function, search if $dest is in the subtree of $modelbodyNode (including) or not
        if ($SorCSorCCS ne '') #$dest is in the subtree of $ClassNode (including $ClassNode)
        {
            if ($SorCSorCCS->{object} eq 'StateNode')
            {#output to @outputCState
                my $temp10="st_".$dest;
            #modified 31/7/2002 11:54AM
                #push(@outputCState,"        :: m == $temp10 -> goto $dest;");  #removed 31/7/2002 11:54AM
                my $outputstring="        :: atomic{m==$temp10 -> goto $dest; skip;};";
                $found=UniversalClass->ifinarray($outputstring,@temparray);
                if ($found eq 0)
                {
                    push(@temparray,$outputstring);
                }
            #modified end   
                $found=UniversalClass->ifinarray($temp10,@mtypelist);
                if ($found eq 0)
                {
                    push(@mtypelist,$temp10);
                }               
                return;
            }
            elsif (($SorCSorCCS->{object} eq 'CStateNode') or ($SorCSorCCS->{object} eq 'CCStateNode'))
            {#output to #outputCState
                my $temp10="st_".$dest;
                my $temp11="to_".$dest;
            #modified 31/7/2002 11:55AM
                #push(@outputCState,"        :: m == $temp10 -> goto $temp11;");  #removed 31/7/2002 11:56AM
                my $outputstring="        :: atomic{m==$temp10 -> goto $temp11; skip;};";
                $found=UniversalClass->ifinarray($outputstring,@temparray);
                if ($found eq 0)
                {
                    push(@temparray,$outputstring);
                }
            #modified end   
                $found=UniversalClass->ifinarray($temp10,@mtypelist);
                if ($found eq 0)
                {
                    push(@mtypelist,$temp10);
                }           
                return;
            }
        }
        #else
        #{warn "Cannot find $dest in the whole range of model!"}
    }   
}

sub visitStateNode 
{
    my ($thisvisitor, $thestatenode)=@_;
    
    if (exists($thestatenode->{child}))
    {
        my $statechild=$thestatenode->{child};
        my $newent;
        foreach $newent (@$statechild)  #actually it only has one child, maybe later I will modify it
        {
            my $statebody=$newent;
            my $thischild=$statebody->{child};
            my $ent;
            foreach $ent (@$thischild)
            {
                if (($ent->{object} eq 'TransNode') and ($ent->{desttype} ne 'Outgoing'))
                {                   
                    $ent->Accept($thisvisitor);
                }
            }
        }
    }
}

sub visitCStateNode {
    my ($thisvisitor, $thecstatenode)=@_;

    if (exists($thecstatenode->{child}))
    {
        my $cstatechild=$thecstatenode->{child};
        my $newent;
        foreach $newent (@$cstatechild)   #actually it only has one child, maybe later I will modify it
        {
            my $cstatebody=$newent;
            my $thischild=$cstatebody->{child};
            my $ent;
            foreach $ent (@$thischild)
            {
                if (($ent->{object} eq 'TransNode') or ($ent->{object} eq 'StateNode') 
                    or 
                    ($ent->{object} eq 'CStateNode') or ($ent->{object} eq 'CCStateNode'))
                {
                    undef(@temparray);  #added 31/7/2002 12:09PM
                    $ent->Accept($thisvisitor);
                }
            }
        }   
    }
}

sub visitCCStateNode 
{
    my ($thisvisitor, $theccstatenode)=@_;
    
    if (exists($theccstatenode->{child}))
    {
        my $ccstatechild=$$theccstatenode->{child};
        my $newent;
        foreach $newent (@$ccstatechild)
        {
            my $ccstatebody=$newent;
            my $thischild=$ccstatebody->{child};
            my $ent;
            foreach $ent (@$thischild)
            {
                if ($ent->{object} eq 'CStateNode')
                {
                    undef(@temparray);  #added 31/7/2002 12:10PM
                    $ent->Accept($thisvisitor);
                }
            }
        }
    }
}

#Functionality: to search if $dest is in the subtree of $CSNode (excluding $CSNode) or not
#If it is in, then return the ref of that node (the node type can only be StateNode, CStateNode & CCStateNode)
#This sub will call sub SearchIncluding
#Originally I used this sub, but now I directly sub SearchIncluding() not this one.
sub SearchExcluding 
{
    my ($Node,$dest)=@_;

    my $returnvalue;
    
    $returnvalue=ASTStateVisitorForPromela->SearchIncluding($Node,$dest);
    
    if (($returnvalue eq '') or ($returnvalue eq $Node))  #use the comparison between two refs
    {
        return '';
    }
    else
    {
        return $returnvalue;
    }   
}

#Functionality: to search if $dest is in the subtree of $Node (including $Node) or not
#If it is in, then return the ref of that node (the node type can only be StateNode, CStateNode & CCStateNode)
#This is a recursive process
sub SearchIncluding 
{
    my ($class,$Node,$dest)=@_;

    my $returnvalue; #a ref to a Node
    my $nodechild;
    my $body;
    my $child;
    my $ent;
    
    my $nodename=$Node->{ID};
    if (($nodename eq $dest) and 
         (($Node->{object} eq 'StateNode') or ($Node->{object} eq 'CStateNode') or ($Node->{object} eq 'CCStateNode')))
    {
        return $Node;
    }
    else
    {
        if (exists($Node->{child}))
        {
            $nodechild=$Node->{child};
            my $newent;
            foreach $newent (@$nodechild)  #actually it only has one child, so only one loop
            {
                $body=$newent;
            
                $child=$body->{child};              
        
                foreach $ent (@$child)
                {
                    $returnvalue=ASTStateVisitorForPromela->SearchIncluding($ent,$dest);
                    if ($returnvalue ne '')
                    {
                        return $returnvalue;
                    }
                }
            }
        }
    }
    
    return '';
}

1;
