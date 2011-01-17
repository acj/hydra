#!/usr/bin/perl

#This class is to check some syntax and semantics errors. 
#I will call it before I call any target language generating visitor.

#Functionality:
#In classbodyNode, statebodyNode, cstatebodyNode, ccstatebodynode, bad child type
#Destination of InitNode, TransNode, HistoryNode is undefined
#InstVarNode used but undefined
#SignalNode used but undefined
#More details, pls refer to this program

package ASTErrorCheckerVisitor;

use TraverseVisitor;
our @ISA=("TraverseVisitor");

use UniversalClass;
use ASTStateVisitorForPromela;

my $counterror=0;


sub PassErrorNum
{
    return $counterror;
}

sub visitmodelNode
{
    my ($thisvisitor,$themodelNode)=@_;
    
    my $stmt=$themodelNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        $ent->Accept($thisvisitor);
    }
}

sub visitmodelbodyNode
{
    my ($thisvisitor,$themodelbodyNode)=@_;
    
    my $stmt=$themodelbodyNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        if ($ent->{object} eq 'ClassNode')
        {
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'DriverfileNode')
        {}
        elsif ($ent->{object} eq 'NullNode') 
        {}
        else
        {die "In this model, bad type $ent->{object}."}     
    }
}

sub visitClassNode
{
    my ($thisvisitor,$theclassNode)=@_;
    
    
    my $stmt=$theclassNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        $ent->Accept($thisvisitor);
    }
}

#Now there is no HistoryNode inside any Class!
#Bad child type
#No Initial state
#More than one Initial state
sub visitclassbodyNode
{
    my ($thisvisitor,$theclassbodyNode)=@_;

    my $countInit=0;
    
    my $stmt=$theclassbodyNode->{child};
    my $ent;
    
    foreach $ent (@$stmt)
    {
        if ($ent->{object} eq 'InitNode')
        {
            $countInit=$countInit+1;
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'InstVarNode')
        {}
        elsif ($ent->{object} eq 'SignalNode')
        {}
        elsif ($ent->{object} eq 'StateNode')
        {
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'CStateNode')
        {
            $ent->Accept($thisvisitor);
        }
        #040903 added to support time invariants
        elsif ($ent->{object} eq 'timeinvariantNode')
        {
            $ent->Accept($thisvisitor);
        }
        #end add 040903
        elsif ($ent->{object} eq 'CCStateNode')
        {
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'JoinNode')
        {}
        else
        {die "In Class [$theclassbodyNode->{parent}->{ID}], bad type [$ent->{object}]!"}
    }

#for InitNode   
    if ($countInit eq 0)
    {
        UniversalClass->printMsg("Warning",$theclassbodyNode->{parent},"","no initial state");
    }
    elsif ($countInit gt 1)
    {
        UniversalClass->printMsg("Warning",$theclassbodyNode->{parent},"","more than one initial state");
    }
}

sub visitStateNode
{
    my ($thisvisitor,$thisstateNode)=@_;
    
    if (exists($thisstateNode->{child}))
    {
        my $stmt=$thisstateNode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            $ent->Accept($thisvisitor);
        }
    }
}

#Bad child type
#No transitions
sub visitstatebodyNode
{
    my ($thisvisitor,$thestatebodyNode)=@_;

    my $countTrans=0;
    
    my $stmt=$thestatebodyNode->{child};
    my $ent;
    
    foreach $ent (@$stmt)
    {
        if ($ent->{object} eq 'ActionNode')
        {
            $ent->Accept($thisvisitor); 
        }
        elsif ($ent->{object} eq 'TransNode')
        {
            $countTrans=$countTrans+1;
            $ent->Accept($thisvisitor);
        }
        #added 040903 to support time invariant
        elsif ($ent->{object} eq 'timeinvariantNode')
        {
            $ent->Accept($thisvisitor);
        }
        #end add
        else
        {   
            my $classref=UniversalClass->SearchUpForDest($thestatebodyNode,"ClassNode");
            my $stateref=$thestatebodyNode->{parent};
            die "In Class [$classref->{ID}], State [$stateref->{ID}], bad type [$ent->{object}]!"
        }
    }
    
    if ($countTrans eq 0)
    {
        my $classref=UniversalClass->SearchUpForDest($thestatebodyNode,"ClassNode");
        UniversalClass->printMsg("Warning",$classref,$thestatebodyNode->{parent},
                     "this state can never be exited (no outbound transitions)");
    }   
}

sub visitCStateNode
{
    my ($thisvisitor,$thiscstateNode)=@_;
    
    if (exists($thiscstateNode->{child}))
    {
        my $stmt=$thiscstateNode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            $ent->Accept($thisvisitor);  #cstatebodyNode
        }
    }
}

#Bad child type
#No Initial state
#More than one Initial state
#More than one History state
sub visitcstatebodyNode
{
    my ($thisvisitor,$thecstatebodyNode)=@_;

    my $countInit=0;
    my $countHistory=0;
    
    my $stmt=$thecstatebodyNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        if ($ent->{object} eq 'InitNode')
        {
            $countInit=$countInit+1;
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'ActionNode')
        {
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'HistoryNode')
        {
            $countHistory=$countHistory+1;
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
        elsif ($ent->{object} eq 'CStateNode')
        {
            $ent->Accept($thisvisitor);
        }
        elsif ($ent->{object} eq 'CCStateNode')
        {
            $ent->Accept($thisvisitor);
        }
        else
        {   
            my $classref=UniversalClass->SearchUpForDest($thecstatebodyNode,"ClassNode");
            my $cstateref=$thecstatebodyNode->{parent};
            die "In Class [$classref->{ID}], CState [$cstateref->{ID}], bad type [$ent->{object}]!"
        }
    }

#for InitNode   
    if ($countInit eq 0)
    {
        my $classref=UniversalClass->SearchUpForDest($thecstatebodyNode,"ClassNode");
        my $cstateref=$thecstatebodyNode->{parent};

        UniversalClass->printMsg("Warning",$classref,$cstateref,"no initial state");
    }
    elsif ($countInit gt 1)
    {
        $counterror=$counterror+1;
        UniversalClass->printMsg("Error",$classref,$cstateref,"more than one initial state");
    }

#for HistoryNode    
    if ($countInit gt 1)
    {
        $counterror=$counterror+1;
        UniversalClass->printMsg("Error",$classref,$cstateref,"more than one history state");
    }

}

sub visitCCStateNode
{
    my ($thisvisitor,$thisccstateNode)=@_;
    
    if (exists($thisccstateNode->{child}))
    {
        my $stmt=$thisccstateNode->{child};
        my $ent;
        foreach $ent (@$stmt)
        {
            $ent->Accept($thisvisitor);  #ccstatebodyNode
        }
    }
}

#Bad child type
sub visitccstatebodyNode
{
    my ($thisvisitor,$theccstatebodyNode)=@_;
    
    my $stmt=$theccstatebodyNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        if ($ent->{object} eq 'CStateNode')
        {   
            $ent->Accept($thisvisitor);
        }
        else
        {
            my $classref=UniversalClass->SearchUpForDest($theccstatebodyNode,"ClassNode");
            my $ccstateref=$theccstatebodyNode->{parent};
            die "In Class [$classref->{ID}], CCState [$ccstateref->{ID}], bad type [$ent->{object}]!"
        }
    }
}

#The destination of InitNode doesn't exist
sub visitInitNode
{
    my ($thisvisitor,$theinitNode)=@_;
    
    my $initID=$theinitNode->{ID};
    my $parentbodyref=$theinitNode->{parent};

#ID 
    my $found=UniversalClass->IfinParent($parentbodyref,"StateNode",$initID);
    if ($found eq 0)
    {
        $found=UniversalClass->IfinParent($parentbodyref,"CStateNode",$initID);
        if ($found eq 0)
        {
            $found=UniversalClass->IfinParent($parentbodyref,"CCStateNode",$initID);
            if ($found eq 0)
            {
                $counterror=$counterror+1;
                my $parentID=$parentbodyref->{parent}->{ID};
                
                if ($parentbodyref eq 'classbodyNode')
                {
                    UniversalClass->printMsg("Error",$parentbodyref->{parent},
                                 "State [$initID] not found");
                }
                else #($parentbodyref eq 'cstatebodyNode')
                {
                    my $classref=UniversalClass->SearchUpForDest($theinitNode,"ClassNode");
                    UniversalClass->printMsg("Error",$classref,$parentbodyref->{parent},
                                 "State [$initID] not found");
                }
            }
        }       
    }

#tran   
    if (exists($theinitNode->{tran}) and ($theinitNode->{tran} ne ''))
    {
        $theinitNode->{tran}->Accept($thisvisitor);
    }   
}

#The destination of TransNode doesn't exist
sub visitTransNode
{
    my ($thisvisitor,$thetransNode)=@_;

#dest
    my $transdest=$thetransNode->{dest};
    my $classref=UniversalClass->SearchUpForDest($thetransNode,"ClassNode");
    my $parentref=$thetransNode->{parent}->{parent};
    
    my $found=ASTStateVisitorForPromela->SearchIncluding($classref,$transdest);
    if ($found eq '')
    {
        $counterror=$counterror+1;
        UniversalClass->printMsg("Error",$classref,$parentref,
                     "State [$transdest] is an undefined transition destination");
    }
    
#tran
    if ($thetransNode->{tran} ne '')
    {
        $thetransNode->{tran}->Accept($thisvisitor);
    }
}

#shallow history state
#The destination of history doesn't exist
sub visitHistoryNode
{
    my ($thisvisitor,$thehistoryNode)=@_;

    my $historyID=$thehistoryNode->{ID};
    my $parentbodyref=$thehistoryNode->{parent};  #a cstatebodyNode
    
#ID 
    my $found=UniversalClass->IfinParent($parentbodyref,"StateNode",$historyID);
        
    if ($found eq 0)
    {
        $found=UniversalClass->IfinParent($parentbodyref,"CStateNode",$historyID);
        if ($found eq 0)
        {
            $found=UniversalClass->IfinParent($parentbodyref,"CCStateNode",$historyID);
            if ($found eq 0)
            {
                $counterror=$counterror+1;
                my $classref=UniversalClass->SearchUpForDest($thehistoryNode,"ClassNode");
                UniversalClass->printMsg("Error",$classref,$parentbodyref->{parent},
                             "State [$historyID] not found");               
            }
        }       
    }

#tran   
    if (exists($thehistoryNode->{tran}) and ($thehistoryNode->{tran} ne ''))
    {
        $thehistoryNode->{tran}->Accept($thisvisitor);
    }
}

sub visitActionNode
{
    my ($thisvisitor,$theactionNode)=@_;
    
    if ($theactionNode->{tran} ne '')
    {
        $theactionNode->{tran}->Accept($thisvisitor);
    }
}

#Actions cannot have guards
sub visittransitionbodyNode
{
    my ($thisvisitor,$thetransitionbodyNode)=@_;

#event  
    if ($thetransitionbodyNode->{event} ne '')
    {
        if ( ($thetransitionbodyNode->{parent}->{object} eq 'InitNode') or 
             ($thetransitionbodyNode->{parent}->{object} eq 'HistoryNode') )
        {
            my $nodetype;
            if ($thetransitionbodyNode->{parent}->{object} eq 'InitNode')
            {
                $nodetype='initial';
            }
            else 
            {
                $nodetype='history';    
            }
        
            $counterror=$counterror+1;
            my $classref=UniversalClass->SearchUpForDest($thetransitionbodyNode,"ClassNode");
            my $parentstateref=$thetransitionbodyNode->{parent}->{parent}->{parent};
            UniversalClass->printMsg("Error",$classref,$parentstateref,
                         "$nodetype state cannot have event");
        
        }
        else
        {
            $thetransitionbodyNode->{event}->Accept($thisvisitor);
        }
    }

#guard
    if ($thetransitionbodyNode->{guard} ne '')
    {
        if ( ($thetransitionbodyNode->{parent}->{object} eq 'ActionNode') or 
             ($thetransitionbodyNode->{parent}->{object} eq 'InitNode') or
             ($thetransitionbodyNode->{parent}->{object} eq 'HistoryNode') )
        {
            my $nodetype;
            if ($thetransitionbodyNode->{parent}->{object} eq 'InitNode')
            {
                $nodetype='initial';
            }
            elsif ($thetransitionbodyNode->{parent}->{object} eq 'HistoryNode')
            {
                $nodetype='history';    
            }
            else
            {
                $nodetype='internal action';        
            }
            
            $counterror=$counterror+1;
            my $classref=UniversalClass->SearchUpForDest($thetransitionbodyNode,"ClassNode");
            my $parentstateref=$thetransitionbodyNode->{parent}->{parent}->{parent};
            UniversalClass->printMsg("Error",$classref,$parentstateref,
                         "$nodetype cannot have guard");            
        }       
    }

#actions
    if ($thetransitionbodyNode->{actions} ne '')
    {
        $thetransitionbodyNode->{actions}->Accept($thisvisitor);
    }

#messages
    if ($thetransitionbodyNode->{messages} ne '')
    {
        $thetransitionbodyNode->{messages}->Accept($thisvisitor);
    }   
}

#Action event cannot have variables
#Actions can only have "entry" & "exit" type event
#InstVar undeclared but used
#Signal undeclared but used
sub visiteventNode
{
    my ($thisvisitor,$thiseventNode)=@_;
    
    my $transitionbodyref=$thiseventNode->{parent};
    my $parentstateref=$transitionbodyref->{parent}->{parent}->{parent};
    
    if ($transitionbodyref->{parent}->{object} eq 'ActionNode')
    {
        my $classref=UniversalClass->SearchUpForDest($thiseventNode,"ClassNode");
        if (($thiseventNode->{eventname} ne 'entry') and ($thiseventNode->{eventname} ne 'exit'))
        {
            $counterror=$counterror+1;
            UniversalClass->printMsg("Error",$classref,$parentstateref,"illegal action event");
        }
    }
        
    if (exists($thiseventNode->{eventvar}) and ($thiseventNode->{eventvar} ne ''))
    {
        if ($transitionbodyref->{parent}->{object} eq 'ActionNode')
        {
            $counterror=$counterror+1;
            UniversalClass->printMsg("Error",$classref,$parentstateref,
                         "action event cannot have variables");
        }
        else
        {
            my $classbodyref=UniversalClass->SearchUpForDest($thiseventNode,"classbodyNode");
            my $eventvar=$thiseventNode->{eventvar};
            my $found=UniversalClass->IfinParent($classbodyref,"InstVarNode",$eventvar);
            if ($found eq '')
            {
                $counterror=$counterror+1;
                UniversalClass->printMsg("Error",$classbodyref->{parent},$parentstateref,
                             "instance variable is undeclared but used");
            }       
        }
    }
    
    if (exists($thiseventNode->{eventname}))
    {   
        if ($transitionbodyref->{parent}->{object} ne 'ActionNode')
        {
            my $found=UniversalClass->FindLocalDestNode($thiseventNode,"SignalNode",
                                                        $thiseventNode->{eventname},"name");
            my $classbodyref=UniversalClass->SearchUpForDest($thiseventNode,"classbodyNode");
            if ($found eq '')
            {
                UniversalClass->printMsg("Warning",$classbodyref->{parent},$parentstateref,
                             "signal [$thiseventNode->{eventname}] is undeclared");
            }
        }
    }
}

sub visittranactionsNode
{
    my ($thisvisitor,$thetranactionsNode)=@_;
    
    my $stmt=$thetranactionsNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        $ent->Accept($thisvisitor);
    }
}

#added 040903 to support timing invariants
sub visittimeinvariantNode
{
    my ($thisvisitor,$thetranactionsNode)=@_;
    
    my $stmt=$thetranactionsNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        $ent->Accept($thisvisitor);
    }
}
#end add 040903

#In newaction, the class name does not exist inside the whole modelbody
sub visittranactionNode
{
    my ($thisvisitor,$thetranactionNode)=@_;
    
    my $classref=UniversalClass->SearchUpForDest($thetranactionNode,"ClassNode");
    my $transitionbodyparentref=UniversalClass->SearchUpForDest($thetranactionNode,"transitionbodyNode");
    my $parentstateref=$transitionbodyparentref->{parent}->{parent}->{parent};
    
    if ($thetranactionNode->{actiontype} eq 'newaction')
    {
        my $classname=$thetranactionNode->{content};
        my $modelbodyref=UniversalClass->SearchUpForDest($thetranactionNode,"modelbodyNode");
        my $found=UniversalClass->IfinParent($modelbodyref,"ClassNode",$classname);
        if ($found eq '')
        {
            UniversalClass->printMsg("Error",$classref,$parentstateref,
                         "Class [$classname] does not exist");
        }           
    }
    elsif ($thetranactionNode->{actiontype} eq 'sendmsg')
    {
        $thetranactionNode->{message}->Accept($thisvisitor);
    }
    elsif ($thetranactionNode->{actiontype} eq 'assignstmt')
    {#bad expression
    }
    elsif ($thetranactionNode->{actiontype} eq 'printstmt')
    {#bad expression
    }
    elsif ($thetranactionNode->{actiontype} eq 'function')
    {#bad expression
    }
    else
    {
        if ($parentstateref->{object} eq 'StateNode')
        {
            die "In Class [$classref->{ID}], State [$parentstateref->{ID}], bad actiontype.";
        }
        elsif ($parentstateref->{object} eq 'CStateNode')
        {
            die "In Class [$classref->{ID}], CState [$parentstateref->{ID}], bad actiontype.";          
        }
    }
}

sub visitmessagesNode
{
    my ($thisvisitor,$thismessagesNode)=@_;
    
    my $stmt=$thismessagesNode->{child};
    my $ent;
    foreach $ent (@$stmt)
    {
        $ent->Accept($thisvisitor);
    }
}

#class.signal: class does not exist inside the whole modelbodyNode, so does this signal
#class.signal(instvar): a) class does not exist inside the whole modelbodyNode, so does this signal
#           b) instvar is undeclared inside this class      
#signal: signal is undeclared inside this class
sub visitmessageNode
{
    my ($thisvisitor,$thismessageNode)=@_;
    
    if (($thismessageNode->{msgclassname} ne '') and ($thismessageNode->{msgsignalname} ne ''))
    {
        my $classname=$thismessageNode->{msgclassname};
        my $modelbodyref=UniversalClass->SearchUpForDest($thismessageNode,"modelbodyNode");
        my $found=UniversalClass->IfinParent($modelbodyref,"ClassNode",$classname);
        if ($found eq '')
        {
            $counterror=$counterror+1;                       
            warn "Error: In this model, Class [$classname] does not exist."         
        }
        else #Have this class
        {
            my $transitionbodyparentref
               =UniversalClass->SearchUpForDest($thismessageNode,"transitionbodyNode");
            my $parentstateref=$transitionbodyparentref->{parent}->{parent}->{parent};          
            my $classref=$found;
            my $stmt=$classref->{child};
            my $ent;
            foreach $ent (@$stmt)  #classbodyNode
            {
                my $signalname=$thismessageNode->{msgsignalname};
                $found=UniversalClass->IfinParent($ent,"SignalNode",$signalname);
                if ($found eq '')
                {
                    UniversalClass->printMsg("Warning",$classref,$parentstateref,
                                     "signal [$signalname] does not exist");
                }       
            }
        }
        
        if ($thismessageNode->{msgintvarname} ne '')
        {
            my $classbodyref=UniversalClass->SearchUpForDest($thismessageNode,"classbodyNode");
            $found=UniversalClass->IfinParent($classbodyref,"InstVarNode",
                              $thismessageNode->{msgintvarname});
            if ($found eq '')
            {
                $counterror=$counterror+1;
                UniversalClass->printMsg("Error",$classbodyref->{parent},$parentstateref,
                             "instance variable undeclared");
            }
        }       
    }
    elsif ($thismessageNode->{msgsignalname} ne '')
    {
        my $classbodyref=UniversalClass->SearchUpForDest($thismessageNode,"classbodyNode");
        $found=UniversalClass->IfinParent($classbodyref,"SignalNode",$thismessageNode->{msgintvarname});
        if ($found eq '')
        {
            my $event=$thismessageNode->{msgsignalname};
            UniversalClass->printMsg("Warning",$classbodyref->{parent},$parentstateref,
                         "event $event undeclared");
        }
    }   
}

1; 