#!/usr/bin/perl
package visitclassbodyNodePak;
use UniversalClass;
use ASTStateVisitorForPromela;

#SK 041003 Changed to support timing
#SK 091903 Changed to make declarations in _SYSTEMCLASS_ global
#inner sub
#Called by visitclassbodyNodePak.pm/sub FormGlobaloutputInstVar()
sub GlobaloutputInstVarHead
{
	my ( $class, $theclassbodynode, @GlobaloutputInstVar ) = @_;
	my $temp1;

	#print $theclassbodynode->{parent}->{ID};
	if ( $theclassbodynode eq 'Timer' )
	{
		$temp1 = "Timer_T";
	} else
	{
		if ( $theclassbodynode->{parent}->{ID} eq '_SYSTEMCLASS_' )
		{
			$temp1 = '';
		} else
		{
			my $classname = $theclassbodynode->{parent}->{ID};
			$temp1 = $classname . "_T";
		}
	}
	if ( $temp1 ne '' )
	{
		push( @GlobaloutputInstVar, "typedef $temp1 {" );
		push( @GlobaloutputInstVar, "        bool timerwait;" );
	}
	return @GlobaloutputInstVar;
}

#end change SK091903
#end change SK041003
#inner sub
#Called by visitclassbodyNodePak.pm/sub FormGlobaloutputInstVar()
#SK 041303 changed to support timing
sub GlobaloutputInstVarEnd
{
	my ( $class, $theclassbodynode, @GlobaloutputInstVar ) = @_;

	#SK 041003 changed to support time invariants
	my $classname;
	if ( $theclassbodynode ne 'Timer' )
	{
		$classname = $theclassbodynode->{parent}->{ID};
	} else
	{
		$classname = "Timer";
	}

	#end change 041003
	#SK change 091903 to make declarations in _SYSTEMCLASS_ global
	if ( $classname ne '_SYSTEMCLASS_' )
	{
		my $temp1 = $classname . "_T";
		my $temp2 = $classname . "_V";
		push( @GlobaloutputInstVar, "        }" );
		push( @GlobaloutputInstVar, "$temp1 $temp2;" );
		push( @GlobaloutputInstVar, "" );
	}

	#end change SK091903
	return @GlobaloutputInstVar;
}

#SK 041303 end change
#inner sub
#Called by visitclassbodyNodePak.pm/sub Proctype()
sub outputClassHead
{
	my ( $class, $theclassbodynode, @outputClass ) = @_;
	my $classname = $theclassbodynode->{parent}->{ID};
	if ( $classname eq '_SYSTEMCLASS_' )
	{
		push( @outputClass, "" );
		push( @outputClass, "" );
		push( @outputClass, "active proctype $classname()" );
	} else
	{
		push( @outputClass, "" );
		push( @outputClass, "" );
		push( @outputClass, "active proctype $classname()" );
	}
	push( @outputClass, "{atomic{" );
	push( @outputClass, "mtype m;" );

	#KS 041303 Took out dummy
	#push(@outputClass,"bit dummy;");
	return @outputClass;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub Proctype()
sub outputClassEnd
{
	my ( $class, @outputClass ) = @_;
	push( @outputClass, "exit:  skip" );
	push( @outputClass, "}" );

	#   push(@outputClass,"");
	#   push(@outputClass,"");
	return @outputClass;
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
sub GlobalSignalHeadOutput
{
	my ( $class, $theclassbodynode, @GlobaloutputSignal ) = @_;
	my $classID = $theclassbodynode->{parent}->{ID};
	my $temp2   = $classID . "_C";
	my $temp    = $classID . "_q";
	push( @GlobaloutputSignal, "chan $temp=[5] of {mtype};" );
	push( @GlobaloutputSignal, "chan $temp2=[0] of {bit};" );
	return @GlobaloutputSignal;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
#this is to add the <cstatename>_pid to the declarations of this class
sub ADDPID
{
	my ( $class, $thiscstatenode, @outputCStateID ) = @_;
	my $cstatename = $thiscstatenode->{ID};
	my $temp       = $cstatename . "_pid";
	push( @outputCStateID, $temp );    #add to class attribute
	return @outputCStateID;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
sub addEmptyPID
{
	my ( $class, @outputCStateID ) = @_;
	push( @outputCStateID, "_pid" );
	return @outputCStateID;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
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
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
sub CStateHeadOutput
{
	my ( $class, $ent, @outputCState ) = @_;
	my $cstatename = $ent->{ID};
	push( @outputCState, "/* Link to composite state $cstatename */" );    #add to class attribute @outputCState
	my $temp1 = $cstatename . "_pid";
	my $temp2 = "to_" . $cstatename;
	my $temp3 = $cstatename . "_C!1";
	my $temp4 = $cstatename . "_C?1";
	#push( @outputCState, "        atomic{skip;" );
	#SK: Fix for process die bug
#	push( @outputCState, "$temp2: $temp1 = run $cstatename(m); $temp3;}" )
	push( @outputCState, "$temp2: atomic{skip; ".$cstatename."_start!1;}" )
	  ;    #add to class attribute @outputCState;}"); #add to class attribute @outputCState
	push( @outputCState, "        atomic{$temp4; wait??$temp1,m;}" );    #add to class attribute @outputCState
	push( @outputCState, "        if" );                                      #add to class attribute @outputCState
	return @outputCState;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
#Functionality: analyze CStateNode and put the output to @outputCState if necessary
sub AnalyzeCStateNode
{
	my ( $class, $ent, $outputCState, $mtypelist ) = @_;

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
	foreach $newent ( @$cstatechild )    #actually it only has one child, maybe later I will modify it
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
#Called by visitclassbodyNodePak.pm/sub RunCProctype()
sub CStateEndOutput
{
	my ( $class, @outputCState ) = @_;
	push( @outputCState, "        fi;" );
	return @outputCState;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub Proctype()
#format is: int <>_pid,<>_pid,...;
sub FormatoutputCStateID
{
	my ( $class, @outputCStateID ) = @_;
	@outputCStateID = UniversalClass->FormatoutputArrayType( "int", @outputCStateID );
	return @outputCStateID;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub Proctype()
sub FormatoutputCCStateIDint
{
	my ( $class, @outputCCStateIDint ) = @_;
	@outputCCStateIDint = UniversalClass->FormatoutputArrayType( "int", @outputCCStateIDint );
	return @outputCCStateIDint;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub Proctype()
sub FormatoutputCCStateIDmtype
{
	my ( $class, @outputCCStateIDmtype ) = @_;
	@outputCCStateIDmtype = UniversalClass->FormatoutputArrayType( "mtype", @outputCCStateIDmtype );
	return @outputCCStateIDmtype;
}

#inner sub
#Called by visitclassbodyNodePak.pm/sub OutputCCState()
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
					my $temp11     = $temp10 . ":";
					push( @outputCCState, $temp11 );
					my $temp20 = $cstatename . "_pid";
					my $temp30 = $cstatename . "_C!1";
					my $temp40 = $cstatename . "_C?1";
					push( @tempoutputCCState1,  "        $temp20 = run $cstatename(none); $temp30;" );
					push( @$outputCCStateIDint, $temp20 );
					my $temp30 = $cstatename . "_code";
					push( @tempoutputCCState2,    "        atomic{$temp40; wait??$temp20,$temp30;}" );
					push( @$outputCCStateIDmtype, $temp30 );
				} else
				{
					my $temp10 = "to_" . ":";
					push( @outputCCState,         $temp10 );
					push( @tempoutputCCState1,    "        _pid = run (none);" );
					push( @$outputCCStateIDint,   "_pid" );
					push( @tempoutputCCState2,    "        wait??eval(_pid),_code;}" );
					push( @$outputCCStateIDmtype, "_code" );
				}

				#add (none) to @mtypelist
				if ( scalar(@$mtypelist) eq 0 )
				{
					push( @$mtypelist, "none" );
				} else
				{
					my $foundnone = UniversalClass->ifinarray( "none", @$mtypelist );
					if ( $foundnone eq 0 )
					{
						push( @$mtypelist, "none" );
					}
				}
			}
		}
	}

	#copy @tempoutputCCState1 to @outputCCState
	push( @outputCCState, "        atomic {" );
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
#Called by visitclassbodyNodePak.pm/sub OutputCCState()
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

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
#It's the same as visitcstatebodyNodePak.pm/sub StateBlock()
#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
#Functionality: to output @$outputState to @$outputWholeState
sub StateBlock
{
	my ( $class, $ent, $outputWholeState, $outputState ) = @_;
	my $StateID = $ent->{ID};

	#output StateHead to @outputWholeState
	my $parentref = UniversalClass->SearchUpForDest( $ent, "ClassNode" );
	my $parentID = $parentref->{ID};
	push( @$outputWholeState, "/* State $StateID */" );
	my $temp1 = $parentID . ".";
	my $temp2 = $temp1 . $StateID;
	my $temp3 = "\"in state " . $temp2;
	my $temp4 = $temp3 . "\\n\"";
	#push( @$outputWholeState, "atomic{skip;" );
	push( @$outputWholeState, "$StateID:   atomic{skip; printf($temp4);" );

	#write @$outputState to @$outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( $outputState, $outputWholeState );
	return @$outputWholeState;
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
#This is a special part, here I only provide the necessary infomation for class-level.
#I put the result in @outputCState of the output of this CStateNode.
#I put the pid of this CStateNode in @outputCStateID.
#In the process I also update @mtypelist when there is some TransNode jump out of the boundary of this CStateNode.
#\Then I will put the {dest} of such TransNode into @mtypelist, e.g., st_<{dest}_of_TransNode>.
sub RunCProctype
{
	my ( $class, $ent, $mtypelist, $outputCStateID, $outputWholeState ) = @_;

	#$ent is a CStateNode
	my @outputCState;
	if ( exists( $ent->{child} ) )    #this CStateNode has children
	{

		#add pid to @outputCStateID, this will be output to the definitions of this class
		@$outputCStateID = visitclassbodyNodePak->ADDPID( $ent, @$outputCStateID );

		#add the head of this CState to @outputCState, i.e,
		#/*Link to composite state <cstate_name>*/
		#to_<cstate_name>: <cstate_name>_pid = run <cstate_name>(m);
		#                  wait??eval(<cstate_name>_pid),m;
		#                  if
		@outputCState = visitclassbodyNodePak->CStateHeadOutput( $ent, @outputCState );

		#visit its direct and indirect children,
		#if the dest of transitions of the states is out of the CStateNode
		#then I need to output the corresponding thing to @outputCState.
		#otherwise I do not need to output anything.
		#e.g.       #          :: m == st_<{dest}_of_TransNode> -> goto <{dest}_of_TransNode>;
		( $mtypelist, @outputCState ) = visitclassbodyNodePak->AnalyzeCStateNode( $ent, \@outputCState, $mtypelist );

		#add the end of this CState to @outputCState, i.e.,
		#                   fi;
		#So far, I have got all the result of @outputCState.
		my $temp100 = pop(@outputCState);
		if ( $temp100 ne '        if' )
		{
			push( @outputCState, $temp100 );
			@outputCState = visitclassbodyNodePak->CStateEndOutput(@outputCState);
		}
	} else    #This CStateNode does not have any child
	{

		#add empty pid to @outputCStateID, i.e.,
		#_pid
		@$outputCStateID = visitclassbodyNodePak->addEmptyPID(@$outputCStateID);

		#add the corresponding part to @outputCState
		@outputCState = visitclassbodyNodePak->EmptyCStateOutput(@outputCState);
	}

	#write @outputCState to @outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( \@outputCState, $outputWholeState );
	return ( $mtypelist, $outputCStateID, $outputWholeState );
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
#This is a special part, here I only provide the necessary infomation for class-level.
#I will access and get the result of CCStateNode later in this sub.
#I put the result of this CCStateNode in @outputCCState that will output to @outputWholeState in this sub.
#I will add (none) to @mtypelist.
#@outputCCStateIDint is to hold the pids of CStateNodes inside this CCStateNode.
#<cstate_name>_pid
#I need to add format when outputing it to @outputClass.
#@outputCCStateIDmtype is to hold the codes of CStateNodes inside this CCStateNode.
#<cstate_name>_code
#I need to add format when outputing it to @outputClass.
sub OutputCCState
{
	my ( $class, $ent, $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, $outputWholeState ) = @_;
	my @outputCCState;
	if ( exists( $ent->{child} ) )    #This CCStateNode has children.
	{

		#Process this CCStateNode, get results to @outputCCState, @$outputCCStateIDint & @$outputCCStateIDmtype.
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
		  visitclassbodyNodePak->AnalyzeCCStateNode( $ent, $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype,
													 @outputCCState );

		#process JoinNode from this CCStateNode if there is any.
		#If there is no JoinNode for this CCStateNode, then I will output: assert(0);
		#Otherwise I will output constructs of JoinNodes for this CCStateNode inside this Class.
		#The output is in @outputCCState.
		my $myparent = "classbodyNode";
		my $found;
		( $found, @outputCCState ) = visitclassbodyNodePak->AnalyzeJoinNode( $ent, $myparent, @outputCCState );
		if ( $found eq 0 )
		{
			my $classref = UniversalClass->SearchUpForDest( $ent, "ClassNode" );
			UniversalClass->printMsg( "Warning", $classref, $ent, "join missing (these threads can never be joined" );
		}
	}

	#write @$outputCCState to @$outputWholeState
	@$outputWholeState = UniversalClass->jointwoarrays( \@outputCCState, $outputWholeState );
	return ( $mtypelist, $outputCCStateIDint, $outputCCStateIDmtype, $outputWholeState );
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
#Besides @GlobaloutputInstVarBody, I also need to consider INPredicate in @INPredicateTarget
sub FormGlobaloutputInstVar
{
	my ( $class, $theclassbodynode, $GlobaloutputInstVarBody, $INPredicateTarget, $GlobaloutputInstVar ) = @_;

	#get INPredicatelist of this classbodynode: $theclassbodynode
	my @tempINPredicatelist;
	@tempINPredicatelist = visitclassbodyNodePak->GetClassINPredicatelist( $theclassbodynode, $INPredicateTarget );

	#SK 041403 change: took this if out baecause I need the typedef for the timerwait even if the class has no instavrs
	#if ((scalar(@$GlobaloutputInstVarBody) ne 0) or (scalar(@tempINPredicatelist) ne 0 ))
	#this class has InstVarNodes
	#{
	#output the head to @GlobaloutputInstVar
	@$GlobaloutputInstVar = visitclassbodyNodePak->GlobaloutputInstVarHead( $theclassbodynode, @$GlobaloutputInstVar );

	#output the body: @GlobaloutputInstVarBody to @GlobaloutputInstVar
	@$GlobaloutputInstVar = UniversalClass->jointwoarrays( $GlobaloutputInstVarBody, $GlobaloutputInstVar );

	#output @INPredicateTarget to @GlobaloutputInstVar, not directly but adding format
	@tempINPredicatelist  = visitclassbodyNodePak->AddFormatToINPredicate(@tempINPredicatelist);
	@$GlobaloutputInstVar = UniversalClass->jointwoarrays( \@tempINPredicatelist, $GlobaloutputInstVar );

	#output the end to @GlobaloutputInstVar
	@$GlobaloutputInstVar = visitclassbodyNodePak->GlobaloutputInstVarEnd( $theclassbodynode, @$GlobaloutputInstVar );

	#}
	#SK 041403 end change
	return @$GlobaloutputInstVar;
}

#SK added 041003 to support time invariants
sub FormTimingInstVar
{
	my ( $class, $theclassbodynode, $GlobaloutputInstVarBody, $INPredicateTarget, $GlobaloutputInstVar,
		 $GlobalTimerInstVarOutput )
	  = @_;

	#Clear array because otherwise the last processed regular class shows up two times
	@$GlobaloutputInstVar = ();

	#Added begin typedef...
	@$GlobaloutputInstVar = visitclassbodyNodePak->GlobaloutputInstVarHead( "Timer", @$GlobaloutputInstVar );

	#Add body taken from list $GlobalTimerInstVarOutput built by the InstVar visitor
	@$GlobaloutputInstVar = UniversalClass->jointwoarrays( $GlobalTimerInstVarOutput, $GlobaloutputInstVar );

	#Output the end ..._T ..._V
	@$GlobaloutputInstVar = visitclassbodyNodePak->GlobaloutputInstVarEnd( "Timer", @$GlobaloutputInstVar );
	return @$GlobaloutputInstVar;
}

#end add 041003
#inner sub
#Used by sub visitclassbodyNodePak.pm/sub FormGlobaloutputInstVar()
sub GetClassINPredicatelist
{
	my ( $class, $theclassbodynode, $INPredicateTarget ) = @_;
	my @tempINPredicatelist;
	my $ent;
	foreach $ent (@$INPredicateTarget)
	{
		if ( $ent->{classbodyref} eq $theclassbodynode )
		{
			my $INPredicatelist = $ent->{INPredicatelist};
			my $newent;
			foreach $newent (@$INPredicatelist)
			{
				push( @tempINPredicatelist, $newent );
			}
		}
	}
	return @tempINPredicatelist;
}

#inner sub
#Used by visitclassbodyNodePak.pm/sub FormGlobaloutputInstVar()
sub AddFormatToINPredicate
{
	my ( $class, @tempINPredicatelist ) = @_;
	my @returnlist;
	my $ent;
	foreach $ent (@tempINPredicatelist)
	{
		my $temp = "st_" . $ent;
		push( @returnlist, "        bool $temp;" );
	}
	return @returnlist;
}

#Called by ASTVisitorForPromela.pm/sub visitclassbodyNode()
sub Proctype
{
	my (
		 $class,          $theclassbodynode,   $outputClass,
		 $outputCStateID, $outputCCStateIDint, $outputCCStateIDmtype,
		 $outputInstVar,  $outputInit,         $outputWholeState
	  )
	  = @_;

	#First output the head of each class
	#proctype <class name> ()  /*OR active proctype <class name>*/
	#{
	#mtype m;
	#int dummy;
	@$outputClass = visitclassbodyNodePak->outputClassHead( $theclassbodynode, @$outputClass );

	#Inserted: output the composite state ids @outputCStateID if there is any
	#e.g. <cstate name>_pid
	if ( scalar(@$outputCStateID) ne 0 )
	{    #add format and output @outputCStateID to @outputClass
		    #int <cstate name>_pid,<cstate name>_pid;
		@$outputCStateID = visitclassbodyNodePak->FormatoutputCStateID(@$outputCStateID);
		@$outputClass = UniversalClass->jointwoarrays( $outputCStateID, $outputClass );
	}

	#Inserted: output the composite state ids of the concurrent state
	#\from @outputCCStateIDint, @outputCCStateIDmtype if there is any.
	#@outputCCStateIDint & @outputCCStateIDmtype holds the same number of entries.
	if ( scalar(@$outputCCStateIDint) ne 0 )
	{       #add format and output @outputCCStateIDint to @outputClass
		    #int <cstate name>_pid,<cstate name>_pid;
		@$outputCCStateIDint = visitclassbodyNodePak->FormatoutputCCStateIDint(@$outputCCStateIDint);
		@$outputClass        = UniversalClass->jointwoarrays( $outputCCStateIDint, $outputClass );

		#add format and output @outputCCStateIDmtype to @outputClass
		#mtype <cstate name>_code,<cstate name>_code;
		@$outputCCStateIDmtype = visitclassbodyNodePak->FormatoutputCCStateIDmtype(@$outputCCStateIDmtype);
		@$outputClass = UniversalClass->jointwoarrays( $outputCCStateIDmtype, $outputClass );
	}

	#Second if @outputInstVar is not empty, output it to @outputClass
	#          <class name>.<InstVar name> = <{initval} of InstVar>;
	@$outputClass = UniversalClass->jointwoarrays( $outputInstVar, $outputClass );

	#Third @outputInit to @outputClass
	#/* Init state */
	#           goto <state name>; OR goto <cstate name>; OR goto <ccstate name>;
	@$outputClass = UniversalClass->jointwoarrays( $outputInit, $outputClass );

	#Fourth @outputWholeState to @outputClass
	@$outputClass = UniversalClass->jointwoarrays( $outputWholeState, $outputClass );

	#Fifth output the end of each class
	#exit:      skip
	#}
	@$outputClass = visitclassbodyNodePak->outputClassEnd(@$outputClass);
	return @$outputClass;
}
1;
