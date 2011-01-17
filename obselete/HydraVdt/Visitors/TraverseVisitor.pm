#!/usr/bin/perl

package TraverseVisitor;

use AbstractVisitor;
our @ISA=("AbstractVisitor");

sub visitNODE {
	my ($thisvisitor,$thisnode) = @_;
	
	#print out the value of the key
	if (exists($thisnode->{linenum}))
	{
		if ($thisnode->{linenum} ne '')
		{
			#print("linenum  ");print($thisnode->{linenum});print("\n");
		}
	}
	if (exists($thisnode->{object}))
	{
		if ($thisnode->{object} ne '')
		{
			#print("object  ");print($thisnode->{object});print("\n");
		}
	}
	if (exists($thisnode->{ID}))
	{
		if ($thisnode->{ID} ne '')
		{
			#print("ID  ");print($thisnode->{ID});print("\n");
		}
	}
	if (exists($thisnode->{parent}))
	{
		if ($thisnode->{parent} ne '')
		{
			#print("parent  ");print($thisnode->{parent});print("\n");
		}
	}
	if (exists($thisnode->{child}))
	{
		if ($thisnode->{child} ne '')
		{
			my $thischild=$thisnode->{child};
			my $ent;
			foreach $ent (@$thischild)
			{
				$ent->Accept($thisvisitor);
			}
		}
	}
}


#Node(model,ID,$2,modelbody,$4)
#Node(model,ID,'Model',modelbody,$4)
sub visitmodelNode {
    	my ($thisvisitor,$themodelnode) = @_;
	visitNODE($thisvisitor,$themodelnode);
}

#Node(modelbody,modelstmtlist,[$1])
sub visitmodelbodyNode {
	my ($thisvisitor, $themodelbodynode) = @_;
	visitNODE($thisvisitor,$themodelbodynode);
}

##Node(Class,ID,$2,classbody,$4)
sub visitClassNode {
	my ($thisvisitor, $theclassnode) = @_;
	visitNODE($thisvisitor, $theclassnode);
}

#Node(classbody,classstmtlist,[$1])
sub visitclassbodyNode {
	my ($thisvisitor, $theclassbodynode)=@_;
	visitNODE($thisvisitor, $theclassbodynode);
}

#Node(Driverfile,ID,$2)
sub visitDriverfileNode {
    	my ($thisvisitor, $thedriverfilenode)=@_;
    	visitNODE($thisvisitor, $thedriverfilenode);
}

#Node(Signal,name,$2)
#Node(Signal,name,$2,sigtype,$4)
sub visitSignalNode {
    	my ($thisvisitor, $thesignalnode)=@_;
    	#print("name  ");print($thesignalnode->{name});print("\n");	    	
    	if (exists($thesignalnode->{sigtype})) 
    	{
    		if ($thesignalnode->{sigtype} ne '')
    		{
			#print("sigtype  ");print($thesignalnode->{sigtype});print("\n");    	
		}
	}	    	
    	visitNODE($thisvisitor, $thesignalnode);
}

#Node(CCState,ID,$2,body,$4)
sub visitCCStateNode {
	my ($thisvisitor, $theccstatenode)=@_;
	visitNODE($thisvisitor, $theccstatenode);
}

#Node(ccstatebody,ccstatestmtlist,[$1])
sub visitccstatebodyNode {
    	my ($thisvisitor, $theccstatebodynode)=@_;
    	visitNODE($thisvisitor, $theccstatebodynode);
}

#Node(CState,ID,$2,body,$4)
sub visitCStateNode {
	my ($thisvisitor, $thecstatenode)=@_;
	visitNODE($thisvisitor, $thecstatenode);
}

#Node(cstatebody,cstatestmtlist,[$1])
sub visitcstatebodyNode {
    	my ($thisvisitor, $thecstatebodynode)=@_;
    	visitNODE($thisvisitor, $thecstatebodynode);
}

#Node(State,ID,$2,statebody,$4)
#Node(State,ID,$2,statebody,'')
sub visitStateNode {
	my ($thisvisitor, $thestatenode)=@_;
	visitNODE($thisvisitor, $thestatenode);
}

#Node(statebody,statestmtlist,[$1]
sub visitstatebodyNode {
    	my ($thisvisitor, $thestatebodynode)=@_;
    	visitNODE($thisvisitor, $thestatebodynode);
}

#Node(Init,ID,$2)
#Node(Init,ID,$3,tran,$2)
sub visitInitNode {
	my ($thisvisitor, $theinitnode)=@_;
	visitNODE($thisvisitor, $theinitnode);
	if (exists($theinitnode->{tran}))
	{
		if ($theinitnode->{tran} ne '')
		{
			my $tran=$theinitnode->{tran};
			$tran->Accept($thisvisitor);
		}
	}
}

#Node(History,ID,$2)
#Node(History,ID,$3,tran,$2)
sub visitHistoryNode {
	my ($thisvisitor, $thehistorynode)=@_;
	visitNODE($thisvisitor, $thehistorynode);
	if (exists($thehistorynode->{tran}))
	{
		if ($thehistorynode->{tran} ne '')
		{
			my $tran=$thehistorynode->{tran};
			$tran->Accept($thisvisitor);
		}
	}
}

#Node(Join,ID,$2,from,$4,to,$6)
sub visitJoinNode {
	my ($thisvisitor, $thejoinnode)=@_;
    	#print("from  ");print($thejoinnode->{from});print("\n");	
    	#print("to  ");print($thejoinnode->{to});print("\n");	
	visitNODE($thisvisitor, $thejoinnode);
}

#Node(Trans,tran,$2,dest,$4)
#Node(Trans,tran,'',dest,$3)
sub visitTransNode {
	my ($thisvisitor, $thetransitionnode)=@_;
    	#print("dest  ");print($thetransitionnode->{dest});print("\n");
	visitNODE($thisvisitor, $thetransitionnode);
	if (exists($thetransitionnode->{tran}))
	{
		if ($thetransitionnode->{tran} ne '')
		{
			my $tran=$thetransitionnode->{tran};
			$tran->Accept($thisvisitor);
		}
	}
}

#Node(Action,action,$2)
sub visitActionNode {
	my ($thisvisitor, $theactionnode)=@_;
    	#print("action  ");print($theactionnode->{action});print("\n");
	#visitNODE($thisvisitor, $theactionnode);
	if (exists($theactionnode->{tran}))
	{	
		if ($theactionnode->{tran} ne '')
		{
			my $tran=$theactionnode->{tran};
			$tran->Accept($thisvisitor);
		}
	}	
}

#Node(InstVar,vtype,$2,var,$3)
#Node(InstVar,vtype,$2,var,$3,initval,$6)
#Node(InstVar,vtype,$2,var,$3,Initlist,$6)
sub visitInstVarNode {
	my ($thisvisitor, $theinstvarnode)=@_;
    	#print("vtype  ");print($theinstvarnode->{vtype});print("\n");
    	#print("var  ");print($theinstvarnode->{var});print("\n");
    	if ( exists($theinstvarnode->{initval} )) {
    		if ($theinstvarnode->{initval} ne '')
    		{
    	#		print("initval is ==> ");
    	#		print($theinstvarnode->{initval});
    	#		print("\n");
    		}
    	}
#    	elsif 
#    	($theinstvarnode->{Initlist} ne '') {
#    		print("Initlist is \n");
#	}	
	visitNODE($thisvisitor, $theinstvarnode);    	
}

##Node(Null)
sub visitNullNode {
	my ($thisvisitor, $thenullnode) = @_;
	visitNODE($thisvisitor, $thenullnode);
}

sub visittransitionbodyNode {
	my ($thisvisitor, $thetransitionbodynode)=@_;
	#event
	if ($thetransitionbodynode->{event} ne '')
	{
		my $event=$thetransitionbodynode->{event};
		$event->Accept($thisvisitor);
	}
	#guard
	if ($thetransitionbodynode->{guard} ne '')
	{
		my $guard=$thetransitionbodynode->{guard};
	#	print("\n***guard is $guard \n");
	}
	#actions
	if ($thetransitionbodynode->{actions} ne '')
	{
		my $actions=$thetransitionbodynode->{actions};
		$actions->Accept($thisvisitor);
	}
	#messages
	if ($thetransitionbodynode->{messages} ne '')
	{
		my $messages=$thetransitionbodynode->{messages};
		$messages->Accept($thisvisitor);
	}		
}

sub visiteventNode {
	my ($thisvisitor, $theeventnode)=@_;
	if ($theeventnode->{eventtype} eq 'normal')
	{
	#	print("\n***eventtype is $theeventnode->{eventtype} \n");
	#	print("\n***eventname is $theeventnode->{eventname} \n");
		if ($theeventnode->{eventtype} ne '')
		{
	#		print("\n***eventvar is $theeventnode->{eventvar} \n");
		}
	}
	elsif ($theeventnode->{eventtype} eq 'when')
	{
	#	print("\n***eventtype is $theeventnode->{eventtype} \n");
	#	print("\n***whenvar is $theeventnode->{whenvar} \n");
	}
}

sub visittranactionsNode {
	my ($thisvisitor, $thetranactionsnode)=@_;
	visitNODE($thisvisitor, $thetranactionsnode);
}

sub visittranactionNode {
	my ($thisvisitor, $thetranactionnode)=@_;
	if ($thetranactionnode->{actiontype} eq 'newaction')
	{
	#	print("\n***actiontype is  ==> $thetranactionnode->{actiontype}\n");
	#	print("\n***content is  ==> $thetranactionnode->{content}\n");
	}
	elsif ($thetranactionnode->{actiontype} eq 'sendmsg')
	{
	#	print("\n***actiontype is  ==> $thetranactionnode->{actiontype}\n");
	#	print("\n***content is  ==> $thetranactionnode->{content}\n");
		my $msg=$thetranactionnode->{content};
		$msg->Accept($thisvisitor);
	}
	elsif ($thetranactionnode->{actiontype} eq 'assignstmt')
	{
	#	print("\n***actiontype is  ==> $thetranactionnode->{actiontype}\n");
	#	print("\n***leftvar is  ==> $thetranactionnode->{left}\n");		
	#	print("\n***rightstr is  ==> $thetranactionnode->{rightstr}\n");
	}
	elsif ($thetranactionnode->{actiontype} eq 'printstmt')
	{
	#	print("\n***actiontype is  ==> $thetranactionnode->{actiontype}\n");
	#	print("\n***printcontent is  ==> $thetranactionnode->{printcontent}\n");
		if ($thetranactionnode->{printparmlist} ne '')
		{
			my $printparmlist=$thetranactionnode->{printparmlist};
			$printparmlist->Accept($thisvisitor);
		}				
	}
	elsif ($thetranactionnode->{actiontype} eq 'function')
	{
	#	print("\n***actiontype is  ==> $thetranactionnode->{actiontype}\n");
	#	print("\n***funcID is  ==> $thetranactionnode->{funcID}\n");
		my $funcparmlist=$thetranactionnode->{funcparmlist};
		$funcparmlist->Accept($thisvisitor);
	}
	else 
	{warn "This actiontype $thetranactionnode->{actiontype} is not defined! "}
}

sub visitmessagesNode {
	my ($thisvisitor, $themessagesnode)=@_;
	visitNODE($thisvisitor, $themessagesnode);	
}

sub visitmessageNode {
	my ($thisvisitor, $themessagenode)=@_;
	if ($themessagenode->{msgclassname} ne '')
	{
	#	print("\n***msgclassname is  ==> $themessagenode->{msgclassname}\n");
	}
	if ($themessagenode->{msgsignalname} ne '')
	{
	#	print("\n***msgsignalname is  ==> $themessagenode->{msgsignalname}\n");	
	}
	if ($themessagenode->{msgintvarname} ne '')
	{
	#	print("\n***msgintvarname is  ==> $themessagenode->{msgintvarname}\n");	
	}
}

return 1;
