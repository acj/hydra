#!/usr/bin/perl
package visitcstatebodyNodePak;
use UniversalClass;
use ASTStateVisitorForPromela;

#inner sub
#used by RunCProctype()
sub ADDPID
{
	my ( $class, $thiscstatenode, @outputCStateID ) = @_;
	my $cstatename = $thiscstatenode->{ID};
	my $temp       = $cstatename . "_pid";
	push( @outputCStateID, $temp );
	return @outputCStateID;
}

#inner sub
#used by RunCProctype()
sub addEmptyPID
{
	my ( $class, @outputCStateID ) = @_;
	push( @outputCStateID, "_pid" );
	return @outputCStateID;
}

#inner sub
#used by RunCProctype()
sub EmptyCStateOutput
{
	my ( $class, @outputCState ) = @_;
	push( @outputCState, "/* Link to composite state  */" );
	push( @outputCState, "to_:      _pid = run (m);" );
	push( @outputCState, "        wait??eval(_pid),m;" );

	#   push(@outputCState,"        if");
	#   push(@outputCState,"        fi;");
	return @outputCState;
}

#inner sub
#called by RunCProctype()
sub CStateHeadOutput
{
	my ( $class, $ent, @outputCState ) = @_;
	my $cstatename = $ent->{ID};
	push( @outputCState, "/* Link to composite state $cstatename */" );    #add to class attribute @outputCState
	my $temp1 = $cstatename . "_pid";
	my $temp2 = "to_" . $cstatename;
	my $temp3 = $cstatename . "_C!1";
	my $temp4 = $cstatename . "_C?1";
	#push( @outputCState, "atomic{skip;" );                                     #add to class attribute @outputCState
	#SK 050712: Changed to fix the process die bug. Needs some additional changes to the rules
	#push( @outputCState, "$temp2: $temp1 = run $cstatename(m); $temp3;}" );    #add to class attribute @outputCState
    push( @outputCState, "$temp2: atomic{skip; ".$cstatename."_start!1;}" );    #add to class attribute @outputCState
	push( @outputCState, "        atomic{$temp4;wait??$temp1,m;}" );      #add to class attribute @outputCState
	push( @outputCState, "        if" );                                       #add to class attribute @outputCState
	return @outputCState;
}

#inner sub
#called by RunCProctype()
#analyze CStateNode and put the output to @outputCState if necessary
sub AnalyzeCStateNode
{
	my ( $class, $ent, $mtypelist, $outputCState ) = @_;

	#pass parameters to ASTStateVisitorForPromela
	ASTStateVisitorForPromela->PassNodeToProcess($ent);
	ASTStateVisitorForPromela->PassoutputCState(@$outputCState);    #pass class attribute @outputCState
	ASTStateVisitorForPromela->Passmtypelist(@$mtypelist);          #pass class attribute @mtypelist

	#new a visitor to Analyze CStateNode, visit its decendants,
	#if the dest of transitions of the (States,CStates) is out of this CStateNode(including CStateNode)
	#then I need to output the corresponding thing to @outputCState
	#otherwise I do not need to output anything
	my $ASTStateVisitorForPromela = new ASTStateVisitorForPromela;

	#visit its children
	my $cstatechild = $ent->{child};
	my $newent;
	foreach $newent (@$cstatechild)    #actually it only has one child, maybe later I will modify it
	{
		my $cstatebody      = $newent;
		my $cstatebodychild = $cstatebody->{child};
		my $temp;
		foreach $temp (@$cstatebodychild)
		{
			if (    ( $temp->{object} eq 'StateNode' )
				 or ( $temp->{object} eq 'CStateNode' )
				 or ( $temp->{object} eq 'CCStateNode' )
				 or ( $temp->{object} eq 'TransNode' ) )
			{
				$temp->Accept($ASTStateVisitorForPromela);

				#in the process the output to @outputCState & @mtypelist will be generated
			}
		}
	}

	#get parameters from ASTStateVisitorForPromela
	@$outputCState = ASTStateVisitorForPromela->GetoutputCState;
	@$mtypelist    = ASTStateVisitorForPromela->Getmtypelist;
	return ( $mtypelist, @$outputCState );
}

#inner sub
#called by RunCProctype()
sub CStateEndOutput
{
	my ( $class, @outputCState ) = @_;
	push( @outputCState, "        fi;" );
	return @outputCState;
}

#inner sub
#called by CProctype()
sub outputClassHead
{
	my ( $class, $thiscstatebodynode, @GlobaloutputCState ) = @_;
	my $classname = $thiscstatebodynode->{parent}->{ID};
	#SK removed this to eliminate process die bug
	#my $temp      = $classname . "_C?1";
	push( @GlobaloutputCState, "" );
	push( @GlobaloutputCState, "" );
	push( @GlobaloutputCState, "active proctype $classname(mtype state)" );
#	push( @GlobaloutputCState, "{atomic{ $temp;" );
	push( @GlobaloutputCState, "{atomic{" );
	push( @GlobaloutputCState, "mtype m;" );


	#KS 041303 Took out dummy
	#push(@GlobaloutputCState,"bit dummy;");
	return @GlobaloutputCState;
}

#inner sub
#called by CProctype()
sub outputClassEnd
{
	my ( $class, @GlobaloutputCState ) = @_;
	push( @GlobaloutputCState, "}" );

	#   push(@GlobaloutputCState,"");
	#   push(@GlobaloutputCState,"");
	#   push(@GlobaloutputCState,"");
	return @GlobaloutputCState;
}

#inner sub
#used by OutputCCState()
#$ent is a CCStateNode
#in this process @outputCCState, @outputCCStateID will be output
sub AnalyzeCCStateNode
{
	my ( $class, $ent, $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, @outputCCState ) = @_;
	my @tempoutputCCState1;
	my @tempoutputCCState2;
	my $ccstatename = $ent->{ID};
	my $temp1       = "to_" . "$ccstatename:";
	push( @outputCCState, $temp1 );
	my $ccstatechild = $ent->{child};
	my $newent;

	foreach $newent (@$ccstatechild)    #actually it only has one child
	{
		my $ccstatebody      = $newent;
		my $ccstatebodychild = $ccstatebody->{child};
		my $temp;
		foreach $temp (@$ccstatebodychild)
		{
			if ( $temp->{object} eq 'CStateNode' )
			{
				if ( exists( $temp->{child} ) )
				{
					my $cstatename = $temp->{ID};
					my $temp10     = "to_" . $cstatename;
					my $temp11     = UniversalClass->jointwostrings( $temp10, ":" );
					push( @outputCCState, $temp11 );
					my $temp20 = $cstatename . "_pid";
					my $temp30 = $cstatename . "AnalyzeCCStateNode_V";
					push( @tempoutputCCState1, "        $temp20 = run $cstatename(none);" );
					push( @outputCCStateIDint, $temp20 );
					my $temp30 = $cstatename . "_code";
					#push( @tempoutputCCState2,   "        wait??eval($temp20),$temp30;}" );
					push( @tempoutputCCState2,   "        wait??$temp20,$temp30;}" );
					push( @outputCCStateIDmtype, $temp30 );
				} else
				{
					my $temp10 = "to_" . ":";
					push( @outputCCState,        $temp10 );
					push( @tempoutputCCState1,   "        _pid = run (none);" );
					push( @outputCCStateIDint,   "_pid" );
					push( @tempoutputCCState2,   "        wait??eval(_pid),_code;}" );
					push( @outputCCStateIDmtype, "_code" );
				}

				#add {none} to @mtypelist
				if ( scalar(@mtypelist) eq 0 )
				{
					push( @mtypelist, "none" );
				} else
				{
					my $foundnone = UniversalClass->ifinarray( "none", @mtypelist );
					if ( $foundnone eq 0 )
					{
						push( @mtypelist, "none" );
					}
				}
			}
		}
	}

	#copy @tempoutputCCState1 to @outputCCState
	#push(@outputCCState,"        atomic {");
	foreach $newent (@tempoutputCCState1)
	{
		push( @outputCCState, $newent );
	}
	push( @outputCCState, "        }" );

	#copy @tempoutputCCState2 to @outputCCState
	foreach $newent (@tempoutputCCState2)
	{
		push( @outputCCState, $newent );
	}
	return ( $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, @outputCCState );
}

#inner sub
#used by OutputCCState()
#Functionality: in the range $myparent search its direct children to see if there is some JoinNode related to
#this $ent (a CCStateNode), if so output to @outputCCState
sub AnalyzeJoinNode
{
	my ( $class, $ent, $myparent, @outputCCState ) = @_;
	my @tempjoin;     #hold the content for each JoinNode without format, reset each time
	my @tempjoin1;    #hold the content for the WHOLE JoinNodes with format

	#search to get the ref of type $myparent
	my $myparentref = UniversalClass->SearchUpForDest( $ent, $myparent );
	my $entname = $ent->{ID};
	my $newent;
	my $child = $myparentref->{child};
	foreach $newent (@$child)
	{
		if ( $newent->{object} eq 'JoinNode' )
		{
			undef(@tempjoin);
			my $joinfrom = $newent->{from};
			if ( $joinfrom eq $entname )
			{

				#Yes, I find a JoinNode match this CCStateNode, so I need to output to @outputCCState here
				my $joinID       = $newent->{ID};
				my $jointo       = $newent->{to};
				my $temp20       = "st_" . $joinID;
				my $ccstatechild = $ent->{child};
				my $temp;
				foreach $temp (@$ccstatechild)
				{
					my $ccstatebody      = $temp;
					my $ccstatebodychild = $ccstatebody->{child};
					my $temp10;
					foreach $temp10 (@$ccstatebodychild)
					{
						if ( $temp10->{object} eq 'CStateNode' )
						{
							my $temp100;
							if ( exists( $temp10->{child} ) )
							{
								my $cstatename = $temp10->{ID};
								$temp100 = $cstatename . "_code";
							} else
							{
								$temp100 = "_code";
							}

							#update @tempjoin
							push( @tempjoin, "$temp100 == $temp20" );
						}
					}
				}

				#add format to @tempjoin and output to @tempjoin1
				#actually only one string begins with "::" ends with ";"
				my $temp200 = "        " . "::";
				@tempjoin = UniversalClass->FormatoutputArraySeparateType( $temp200, " && ", @tempjoin );
				my $temptemp = shift(@tempjoin);    #because @tempjoin only has one string
				push( @tempjoin1, $temptemp );
			}
		}
	}

	#output @tempjoin1 to @outputCCState
	my @another;
	if ( scalar(@tempjoin1) ne 0 )
	{
		push( @outputCCState, "        do" );
		foreach $another (@tempjoin1)
		{
			push( @outputCCState, $another );
		}
		push( @outputCCState, "        od;" );
		return ( 1, @outputCCState );
	} else
	{    #there is no join for this CCStateNode
		push( @outputCCState, "        assert(0);" );
		return ( 0, @outputCCState );
	}
}

#inner sub
#used by CProctype()
sub FormatoutputCStateID
{
	my ( $class, @outputCStateID ) = @_;
	@outputCStateID = UniversalClass->FormatoutputArrayType( "int", @outputCStateID );
	return @outputCStateID;
}

#inner sub
#used by CProctype()
sub FormatoutputCCStateIDint
{
	my ( $class, @outputCCStateIDint ) = @_;
	@outputCCStateIDint = UniversalClass->FormatoutputArrayType( "int", @outputCCStateIDint );
	return @outputCCStateIDint;
}

#inner sub
#used by CProctype()
sub FormatoutputCCStateIDmtype
{
	my ( $class, @outputCCStateIDmtype ) = @_;
	@outputCCStateIDmtype = UniversalClass->FormatoutputArrayType( "mtype", @outputCCStateIDmtype );
	return @outputCCStateIDmtype;
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
sub getOutgoingTransitions
{
	my ( $class, $thiscstatebodynode ) = @_;
	my ( $countTransNode, @OutgoingTransitionlist );
	$countTransNode = 0;
	my $stmt = $thiscstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'TransNode' )
		{
			$countTransNode = $countTransNode + 1;
			push( @OutgoingTransitionlist, $ent );
		}
	}
	return ( $countTransNode, @OutgoingTransitionlist );

	#Obviously if $countTransNode gt 0, then @OutgoingTransitionlist is not empty.
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
#Functionality:
#If $countTransNode ne 0, recursively push @OutgoingTransitionlist to StateNode,
#\CStateNode & CCStateNode inside this cstatebodyNode.
#Obviously if $countTransNode gt 0, then @OutgoingTransitionlist is not empty.
#This sub will use three inner subs: pushToStateNode(), pushToCStateNode() & pushToCCStateNode().
sub pushOutgoingTransitionlist
{
	my ( $class, $thiscstatebodynode, $countTransNode, @OutgoingTransitionlist ) = @_;
	if ( $countTransNode eq 0 )
	{    #I don't need to push anything to the children of this cstatebodyNode.
		return;
	} else
	{    #I need to recursively push the transitions inside
		    #\@OutgoingTransitionlist to the children of this cstatebodyNode.
		my $stmt = $thiscstatebodynode->{child};
		my $ent;
		foreach $ent (@$stmt)
		{
			if ( $ent->{object} eq 'StateNode' )
			{
				visitcstatebodyNodePak->pushDownToStateNode( $ent, $thiscstatebodynode, @OutgoingTransitionlist );
			} elsif ( $ent->{object} eq 'CStateNode' )
			{
				visitcstatebodyNodePak->pushDownToCStateNode( $ent, $thiscstatebodynode, @OutgoingTransitionlist );
			} elsif ( $ent->{object} eq 'CCStateNode' )
			{
				visitcstatebodyNodePak->pushDownToCCStateNode( $ent, $thiscstatebodynode, @OutgoingTransitionlist );
			} else
			{
				next;
			}
		}
		return;
	}
}

#inner sub
#Called by pushOutgoingTransitionlist()
sub pushDownToStateNode
{
	my ( $class, $StateNodeRef, $thiscstatebodynode, @OutgoingTransitionlist ) = @_;
	if ( exists( $StateNodeRef->{child} ) )

	  #This StateNode has children
	{
		my $thischild = $StateNodeRef->{child};
		my $ent;
		foreach $ent (@$thischild)    #Actually only one child here, i.e., statebodyNode
		{
			my $statebodychild = $ent->{child};
			my $newent;
			foreach $newent (@OutgoingTransitionlist)
			{
				$$newent{desttype}     = "Outgoing";
				$$newent{formerparent} = $thiscstatebodynode;
				push( @$statebodychild, $newent );
			}
		}
	} else

	  #This StateNode does not have children, add child to it
	{

		#new a statebodyNode
		my $newstatebodyNode;
		$$newstatebodyNode{parent} = $StateNodeRef;      #add {parent} to statebodyNode
		$$newstatebodyNode{object} = "statebodyNode";    #add {object} to statebodyNode
		bless( $newstatebodyNode, "statebodyNode" );     #now $newstatebodyNode is a statebodyNode

		#add $newstatebodynode to this StateNode: $StateNodeRef
		$$StateNodeRef{child} = [];                      #[empty];
		$statechild = $StateNodeRef->{child};
		push( @$statechild, $newstatebodyNode );         #add {child} to StateNode
		$statechild = $StateNodeRef->{child};

		#add @OutgoingTransitionlist to $newstatebodynode->{child}
		$$newstatebodyNode{child} = [];
		my $statebodychild = $newstatebodyNode->{child};
		my $newent;
		foreach $newent (@OutgoingTransitionlist)
		{
			$$newent{desttype}     = "Outgoing";
			$$newent{formerparent} = $thiscstatebodynode;
			$$newent{parent}       = $newstatebodyNode;
			push( @$statebodychild, $newent );
		}
	}
}

#inner sub
#Called by pushOutgoingTransitionlist()
#recursive
sub pushDownToCStateNode
{
	my ( $class, $CStateNodeRef, $thiscstatebodynode, @OutgoingTransitionlist ) = @_;
	if ( exists( $CStateNodeRef->{child} ) )

	  #This CStateNode has children
	{
		my $thischild = $CStateNodeRef->{child};
		my $ent;
		foreach $ent (@$thischild)    #Actually only one child here, i.e., cstatebodyNode
		{
			my $cstatebodychild = $ent->{child};
			my $newent;
			foreach $newent (@$cstatebodychild)
			{
				if ( $newent->{object} eq 'StateNode' )
				{
					visitcstatebodyNodePak->pushDownToStateNode( $newent, $thiscstatebodynode,
																 @OutgoingTransitionlist );
				} elsif ( $newent->{object} eq 'CStateNode' )
				{
					visitcstatebodyNodePak->pushDownToCStateNode( $newent, $thiscstatebodynode,
																  @OutgoingTransitionlist );
				} elsif ( $newent->{object} eq 'CCStateNode' )
				{
					visitcstatebodyNodePak->pushDownToCCStateNode( $newent, $thiscstatebodynode,
																   @OutgoingTransitionlist );
				} else
				{
					next;
				}
			}
		}
	} else

	  #This CStateNode does not have children
	  #So far I don't know the semantics here, stop
	{
	}
}

#inner sub
#Called by pushOutgoingTransitionlist()
sub pushDownToCCStateNode
{
	my ( $class, $CCStateNodeRef, $thiscstatebodynode, @OutgoingTransitionlist ) = @_;
	my $ent;
	if ( exists( $CCStateNodeRef->{child} ) )

	  #This CCStateNode has children
	{
		my $thischild = $CCStateNodeRef->{child};
		foreach $ent (@$thischild)
		{
			my $ccstatebodychild = $ent->{child};
			my $newent;
			foreach $newent (@$ccstatebodychild)
			{
				if ( $newent->{object} eq 'CStateNode' )
				{
					visitcstatebodyNodePak->pushDownToCStateNode( $newent, $thiscstatebodynode,
																  @OutgoingTransitionlist );
				}

				#elsif ($newent->{object} eq 'StateNode')
				#{
				#   visitcstatebodyNodePak->pushDownToStateNode($newent,$thiscstatebodynode,@OutgoingTransitionlist);
				#}
				else { next }
			}
		}
	} else

	  #This CCStateNode does not have children
	  #So far I don't know the semantics here, stop
	{
	}
}

#Called by ASTVisitorForPromela/sub visitcstatebodyNode()
sub AddTleafPID
{
	my ( $class, $StateNodeRef, @outputCStateID ) = @_;
	my $ifinoutputCStateID = 0;
	if ( exists( $StateNodeRef->{child} ) )
	{
		my $statechild = $StateNodeRef->{child};
		my $ent;
		foreach $ent (@$statechild)    #$ent is statebodyNode
		{
			my $stmt = $ent->{child};
			my $newent;
			foreach $newent (@$stmt)    #children of statebodyNode: InitNode or ActionNode or TransNode
			{
				if (     ( $newent->{object} eq "TransNode" )
					 and ( $newent->{desttype} eq "Outgoing" ) )
				{
					my $CStateRef = $newent->{formerparent}->{parent};
					my $CStateID  = $CStateRef->{ID};
					my $temp      = $CStateID . "_pid";
					$ifinoutputCStateID = UniversalClass->ifinarray( $temp, @outputCStateID );
					if ( $ifinoutputCStateID eq 0 )
					{                   #add $CStateID to @outputCStateID
						push( @outputCStateID, $temp );
					}
				}
			}
		}
	}
	return @outputCStateID;
}

#It's different from visitclassbodyNodePak.pm/sub StateBlock() because historyNode
#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
#Functionality: to output @$outputState to @$outputWholeState
sub StateBlock
{
	my ( $class, $ent, $ifHistory, $outputWholeState, $outputState ) = @_;
	my $StateID = $ent->{ID};

	#output StateHead to @outputWholeState
	my $parentref = UniversalClass->SearchUpForDest( $ent, "ClassNode" );
	my $parentID = $parentref->{ID};
	push( @$outputWholeState, "/* State $StateID */" );
	my $temp1 = $parentID . ".";
	my $temp2 = $temp1 . $StateID;
	my $temp3 = "\"in state " . $temp2;
	my $temp4 = $temp3 . "\\n\"";
	push( @$outputWholeState, "$StateID:    atomic{skip; printf($temp4);" );

	#output History saving statement:
	if ( $ifHistory eq 1 )
	{
		my $cstateref = UniversalClass->SearchUpForDest( $ent, "CStateNode" );
		my $cstateID  = $cstateref->{ID};
		my $temp10    = "H_" . $cstateID;
		my $temp11    = "st_" . $StateID;
		push( @$outputWholeState, "        $temp10 = $temp11;  /* Save state for history */" );
	}

	#write @$outputState to @$outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( $outputState, $outputWholeState );
	return @$outputWholeState;
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNodePak()
#used by visitcstatebodyNode()
sub RunCProctype
{
	my ( $class, $ent, $mtypelist, $outputCStateID, $outputWholeState, $WholeOutgoingTransitionlist ) = @_;
	my @outputCState;
	if ( exists( $ent->{child} ) )
	{

		#add pid to @outputCStateID, this will be output to the definitions of this proctype
		@$outputCStateID = visitcstatebodyNodePak->ADDPID( $ent, @$outputCStateID );

		#add the head of this CState to @outputCState
		@outputCState = visitcstatebodyNodePak->CStateHeadOutput( $ent, @outputCState );

		#visit its direct and indirect children, if the dest of transitions of the states is out of the CStateNode
		#then I need to output the corresponding thing to @outputCState
		#otherwise I do not need to output anything
		( $mtypelist, @outputCState ) = visitcstatebodyNodePak->AnalyzeCStateNode( $ent, $mtypelist, \@outputCState );

		#add the end of this CState to @outputCState
		my $temp100 = pop(@outputCState);
		if ( $temp100 ne '        if' )
		{
			push( @outputCState, $temp100 );
			@outputCState = visitcstatebodyNodePak->CStateEndOutput(@outputCState);
		}

		#output Tbridge, i.e., @WholeOutgoingTransitionlist to @outputCState
		@outputCState    = visitcstatebodyNodePak->outputTbridge( $WholeOutgoingTransitionlist,    \@outputCState );
		@$outputCStateID = visitcstatebodyNodePak->outputTbridgePID( $WholeOutgoingTransitionlist, $outputCStateID );
	} else
	{    #This CStateNode does not have children, it's an empty CStateNode
		    #add empty pid to @outputCStateID
		@$outputCStateID = visitcstatebodyNodePak->addEmptyPID(@$outputCStateID);

		#add the corresponding part to @outputCState
		@outputCState = visitcstatebodyNodePak->EmptyCStateOutput(@outputCState);
	}

	#write @outputCState to @outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( \@outputCState, $outputWholeState );
	return ( $mtypelist, $outputCStateID, $outputWholeState );
}

#inner sub
#used by sub RunCProctype()
sub outputTbridge
{
	my ( $class, $WholeOutgoingTransitionlist, $outputCState ) = @_;

	#@WholeOutgoingTransitionlist holds all the Tbridges, I will output here
	if ( scalar(@$WholeOutgoingTransitionlist) ne 0 )
	{

		#pop the last element, i.e., "fi;" from @$outputCState
		pop(@$outputCState);

		#add format and output @$WholeOutgoingTransitionlist to @$outputCState
		my $ent;
		foreach $ent (@$WholeOutgoingTransitionlist)
		{
			my $temp = "st_" . ( $ent->{dest} );

			#SK: 05-06-30 Fixed problem with composite states
			my $cstatename = $ent->{parent}->{parent}->{ID};
			#SK 10/23/05 I think this $temp2 statement is wrong
			#my $temp2      = $cstatename . "_C!1";
			push( @$outputCState, "        :: atomic{m == $temp -> wait!_pid,$temp; $temp2; goto exit; skip;};" );
		}

		#and then "fi;" back to @$outputCState
		#SK: 05-06-30 Fixed missing curly brace
		push( @$outputCState, "        fi;" );
	}
	return @$outputCState;
}

#used by visitcstatebodyNodePak.pm/sub RunCProctype()
sub outputTbridgePID
{
	my ( $class, $WholeOutgoingTransitionlist, $outputCStateID ) = @_;

	#@$WholeOutgoingTransitionlist holds all the Tbridges, I will output here
	#At the same time I need to check if one PID is in @$outputCStateID or not
	if ( scalar(@$WholeOutgoingTransitionlist) ne 0 )
	{
		my $ent;
		foreach $ent (@$WholeOutgoingTransitionlist)
		{
			my $formerparent = $ent->{formerparent};
			my $temp         = ( $formerparent->{parent}->{ID} ) . "_pid";
			my $returnvalue  = UniversalClass->ifinarray( $temp, @$outputCStateID );
			if ( $returnvalue eq 0 )
			{    #add $temp to @$outputCStateID
				push( @$outputCStateID, $temp );
			}
		}
	}
	return @$outputCStateID;
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
#This is a special part, here I only provide the necessary infomation for cstatebody-level.
#I will access and get the result of CCStateNode later in this sub.
#I put the result of this CCStateNode in @outputCCState that will output to @outputWholeState in this sub.
#I will add (none) to @mtypelist.
#@outputCCStateIDint is to hold the pids of CStateNodes inside this CCStateNode.
#<cstate_name>_pid
#I need to add format when outputing it to @outputClass.
#@outputCCStateIDmtype is to hold the codes of CStateNodes inside this CCStateNode.
#<cstate_name>_code
#I need to add format when outputing @outputCCStateIDint & @outputCCStateIDmtype to @outputClass.
sub OutputCCState
{
	my ( $class, $ent, $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, $outputWholeState ) = @_;
	my @outputCCState;
	if ( exists( $ent->{child} ) )    #This CCStateNode has children.
	{

		#analyze this CCStateNode, get the result to @outputCCState, @outputCCStateIDint,
		#\@outputCCStateIDmtype.
		#Also add (none) to @mtypelist.
		#to_<ccstate name>:
		#to_<cstate1 name>:
		#...
		#to_<cstateN name>:
		#          atomic {
		#          <cstate1 name>_pid = run <cstate1 name>(none);
		#          ...
		#          <cstateN name>_pid = run <cstateN name>(none);
		#          }
		#          wait??eval(<cstate1 name>_pid),<cstate1 name>_code;
		#          ...
		#          wait??eval(<cstateN name>_pid),<cstateN name>_code;
		#          assert(0);      /*assume there is no JoinNode*/
		( $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, @outputCCState ) =
		  visitcstatebodyNodePak->AnalyzeCCStateNode( $ent, $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype,
													  @outputCCState );

		#process JoinNode from this CCStateNode if there is any.
		#If there is no JoinNode for this CCStateNode, then I will output: assert(0);
		#Otherwise I will output constructs of JoinNodes for this CCStateNode inside this Class.
		#The output is in @outputCCState.
		my $myparent = "cstatebodyNode";
		my $found;
		( $found, @outputCCState ) = visitcstatebodyNodePak->AnalyzeJoinNode( $ent, $myparent, @outputCCState );
		if ( $found eq 0 )
		{
			my $classref = UniversalClass->SearchUpForDest( $ent, "ClassNode" );
			UniversalClass->printMsg( "Warning", $classref, $ent, "join missing (these threads can never be joined" );
		}
	}

	#write @outputCCState to @outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( \@outputCCState, $outputWholeState );
	return ( $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, $outputWholeState );
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
#Functionality: get @outputActionEntry and @outputActionExit inside this statebodyNode
sub GetAllActions
{
	my ( $class, $thisvisitor, $thisstatebodynode, $outputActionEntry, $outputActionExit ) = @_;
	my @outputAction;
	my @temparrayentry;
	my @temparrayexit;
	my $stmt = $thisstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{

		if ( $ent->{object} eq 'ActionNode' )
		{
			$ent->Accept($thisvisitor);    #get result to @outputAction
			@outputAction = ASTVisitorForPromela->PassoutputAction;
			if ( $ent->{tran} ne '' )
			{
				if ( $ent->{tran}->{event} ne '' )
				{
					if ( $ent->{tran}->{event}->{eventname} eq 'entry' )
					{                      #output @outputAction to @temparrayentry
						@temparrayentry = UniversalClass->jointwoarrays( \@outputAction, \@temparrayentry );
					} elsif ( $ent->{tran}->{event}->{eventname} eq 'exit' )
					{                      #output @outputAction to @temparrayexit
						@temparrayexit = UniversalClass->jointwoarrays( \@outputAction, \@temparrayexit );
					}
				}
			}
		}
	}

	#get @outputActionEntry
	if ( scalar(@temparrayentry) ne 0 )
	{
		push( @$outputActionEntry, "/* entry actions */" );

		#push(@$outputActionEntry,"        atomic {");
		@$outputActionEntry = UniversalClass->jointwoarrays( \@temparrayentry, $outputActionEntry );
		push( @$outputActionEntry, "        }" );
	}

	#get @outputActionExit
	if ( scalar(@temparrayexit) ne 0 )
	{
		push( @$outputActionExit, "/* exit actions */" );
		push( @$outputActionExit, "        atomic {" );
		@$outputActionExit = UniversalClass->jointwoarrays( \@temparrayexit, $outputActionExit );
		push( @$outputActionExit, "        }" );
	}
	return ( $outputActionEntry, $outputActionExit );
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
sub CProctype
{
	my (
		 $class,              $thiscstatebodynode,   $GlobaloutputCState,      $outputCStateID,
		 $outputCCStateIDint, $outputCCStateIDmtype, $CStateoutputActionEntry, $CStateoutputActionExit,
		 $outputInit,         $outputHistory,        $HistorySelect,           $outputWholeState
	  )
	  = @_;

	#First the head of this CStateNode to @GlobaloutputCState
	#proctype <cstate name> (mtype state)
	#{
	#mtype m;
	#int dummy;
	@$GlobaloutputCState = visitcstatebodyNodePak->outputClassHead( $thiscstatebodynode, @$GlobaloutputCState );

	#Inserted: output the composite state ids @outputCStateID if there is any
	#e.g. <cstate name>_pid
	if ( scalar(@$outputCStateID) ne 0 )
	{    #add format and output @outputCStateID to @GlobaloutputCState
		@$outputCStateID = visitcstatebodyNodePak->FormatoutputCStateID(@$outputCStateID);
		@$GlobaloutputCState = UniversalClass->jointwoarrays( $outputCStateID, $GlobaloutputCState );
	}
	
	#Inserted: output the composite state ids of the concurrent state
	#from @outputCCStateIDint, @outputCCStateIDmtype if there is any
	if ( scalar(@$outputCCStateIDint) ne 0 )
	{    #add format and output @outputCCStateIDint to @outputClass
		@$outputCCStateIDint = visitcstatebodyNodePak->FormatoutputCCStateIDint(@$outputCCStateIDint);
		@$GlobaloutputCState = UniversalClass->jointwoarrays( $outputCCStateIDint, $GlobaloutputCState );

		#add format and output @outputCCStateIDmtype to @outputClass
		@$outputCCStateIDmtype = visitcstatebodyNodePak->FormatoutputCCStateIDmtype(@$outputCCStateIDmtype);
		@$GlobaloutputCState = UniversalClass->jointwoarrays( $outputCCStateIDmtype, $GlobaloutputCState );
	}

	push( @$GlobaloutputCState, "goto exit;}" );

	#output Actions
	#output @CStateoutputActionEntry to @GlobaloutputCState
	@$GlobaloutputCState = UniversalClass->jointwoarrays( $CStateoutputActionEntry, $GlobaloutputCState );

	#Second @outputInit OR (@outputHistory and @HistorySelect) to @GlobaloutputCState
	#if has InitNode then only output @outputInit
	#if it doesn't have InitNode but has HistoryNode, then output (@outputHistory and @HistorySelect);
	my @tempHistory;
	@tempHistory = UniversalClass->jointwoarrays( $outputHistory, \@tempHistory );
	@tempHistory = UniversalClass->jointwoarrays( $HistorySelect, \@tempHistory );
	if ( scalar(@$outputInit) ne 0 )
	{
		@$GlobaloutputCState = UniversalClass->jointwoarrays( $outputInit, $GlobaloutputCState );
	} elsif ( scalar(@tempHistory) ne 0 )
	{
		push( @$GlobaloutputCState, "/* History pseduostate construct */" );
		@$GlobaloutputCState = UniversalClass->jointwoarrays( \@tempHistory, $GlobaloutputCState );
	}

	#Third @outputWholeState to @GlobaloutputCState
	@$GlobaloutputCState = UniversalClass->jointwoarrays( $outputWholeState, $GlobaloutputCState );

	#push a special construct to @GlobaloutputCState
	#special treatment for exits of composite states
	my $temp=$thiscstatebodynode->{parent};
	push( @$GlobaloutputCState, "exit:        ".$thiscstatebodynode->{parent}->{ID}."_start?1->goto startCState;" );

	#output @CStateoutputActionExit to @GlobaloutputCState
	@$GlobaloutputCState = UniversalClass->jointwoarrays( $CStateoutputActionExit, $GlobaloutputCState );

	#output blanks
	@$GlobaloutputCState = visitcstatebodyNodePak->outputClassEnd(@$GlobaloutputCState);
	return @$GlobaloutputCState;
}

#Called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
sub ifHistoryExist
{
	my ( $class, $thiscstatebodynode, $HistorySelect, @mtypelist ) = @_;
	my $ifHistory = 0;
	my $stmt      = $thiscstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'HistoryNode' )
		{
			$ifHistory = 1;
		}
	}
	if ( $ifHistory eq 0 )
	{
		return ( 0, '', @mtypelist );
	} else
	{    #add the children: InitNode, StateNode, CStateNode, CCStateNode to @mtypelist
		@mtypelist      = visitcstatebodyNodePak->AddtoMtypelist( $thiscstatebodynode,      @mtypelist );
		@$HistorySelect = visitcstatebodyNodePak->outputHistorySelect( $thiscstatebodynode, @$HistorySelect );
		return ( 1, $HistorySelect, @mtypelist );
	}
}

#inner sub
#used by sub ifHistoryExist()
sub AddtoMtypelist
{
	my ( $class, $thiscstatebodynode, @mtypelist ) = @_;
	my $stmt = $thiscstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if (    ( $ent->{object} eq 'InitNode' )
			 or ( $ent->{object} eq 'StateNode' )
			 or ( $ent->{object} eq 'CStateNode' )
			 or ( $ent->{object} eq 'CCStateNode' ) )
		{
			my $temp;
			if ( $ent->{object} eq 'InitNode' )
			{
				$temp = "st_Init";
			} else
			{
				$temp = "st_" . $ent->{ID};
			}
			my $found = UniversalClass->ifinarray( $temp, @mtypelist );
			if ( $found eq 0 )
			{
				push( @mtypelist, $temp );
			}
		}
	}
	return @mtypelist;
}

#inner sub
#used by sub ifHistoryExist()
sub outputHistorySelect
{
	my ( $class, $thiscstatebodynode, @HistorySelect ) = @_;
	my $cstateID   = $thiscstatebodynode->{parent}->{ID};
	my $H_cstateID = "H_" . $cstateID;
	my $stmt       = $thiscstatebodynode->{child};
	my $ent;
	my @tempHistory;
	foreach $ent (@$stmt)
	{

		if ( $ent->{object} eq 'StateNode' )
		{
			my $temp = "st_" . $ent->{ID};
			push( @tempHistory, "        :: $H_cstateID == $temp  ->  goto $ent->{ID};" );
		} elsif (    ( $ent->{object} eq 'CStateNode' )
				  or ( $ent->{object} eq 'CCStateNode' ) )
		{
			my $temp1 = "st_" . $ent->{ID};
			my $temp2 = "to_" . $ent->{ID};
			push( @tempHistory, "        :: $H_cstateID == $temp1  ->  goto $temp2; skip;" );
		}
	}
	if ( scalar(@tempHistory) ne 0 )
	{
		push( @HistorySelect, "        ifyu" );
		@HistorySelect = UniversalClass->jointwoarrays( \@tempHistory, \@HistorySelect );
		push( @HistorySelect, "        fi;" );
	}
	return @HistorySelect;
}

#added 31/7/2002 3:13PM
#called by ASTVisitorForPromela.pm/sub visitcstatebodyNode()
#remove redundancy in @$OutgoingTransitionlist and output it to @WholeOutgoingTransitionlist
sub PreserveOutgoingTransitionlist
{
	my ( $class, $OutgoingTransitionlist, @WholeOutgoingTransitionlist ) = @_;
	my $found;
	my $ent;
	foreach $ent (@$OutgoingTransitionlist)
	{
		$found = 0;
		my $tempent;
		foreach $tempent (@WholeOutgoingTransitionlist)
		{
			if ( $ent->{dest} eq $tempent->{dest} )
			{
				$found = 1;
				goto TEST;
			}
		}
	  TEST: if ( $found eq 0 )
		{
			push( @WholeOutgoingTransitionlist, $ent );
		}
	}
	return @WholeOutgoingTransitionlist;
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
sub GlobalSignalHeadOutput
{
	my ( $class, $theclassbodynode, @GlobaloutputSignal ) = @_;
	my $classID = $theclassbodynode->{parent}->{ID};
	my $temp2   = $classID . "_C";
	my $temp3   = $classID . "_start";
	push( @GlobaloutputSignal, "chan $temp2=[0] of {bit};" );
	push( @GlobaloutputSignal, "chan $temp3=[0] of {bit};" );
	return @GlobaloutputSignal;
}
1;
