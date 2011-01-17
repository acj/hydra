#!/usr/bin/perl
package visitstatebodyNodePak;
use UniversalClass;
use ExprYaccForPromela;

#inner sub
#Called by NoTransitionOutput()
#There is no transitions in this statebodyNode, only some ActionNode
sub EmptyTransOutput
{
	my ( $class, @outputState ) = @_;

	#push(@outputState,"        atomic {if :: !t?[free] -> t!free :: else skip fi;}");
	push( @outputState, "        if" );
	push( @outputState, "        :: skip -> false" );
	push( @outputState, "        fi;" );
	return @outputState;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub Formeventlist
{
	my ( $class, $thisstatebodynode ) = @_;

	
	my @transeventlist;
	my $stmt = $thisstatebodynode->{child};
	my $ent;
	my $newent;
	my $event;
	my $guardbool = 0;
	foreach $ent (@$stmt)
	{

		if ( $ent->{object} eq 'TransNode' )
		{

			#There are two situations of this TransNode
			#1, empty transtionbody: $ent->{tran}, and a dest: $ent->{dest}
			#2, non-empty transitionbody: $ent->{tran}, and a dest: $ent->{dest}
			#I will categorize the transtions that have empty transitionbody as "event=>EMPTYTRANS", it is special.
			if ( $ent->{tran} eq '' )
			{    #This TransNode has empty transitionbody
				    #search if an entry with this event type already in @transeventlist or not
				@transeventlist = SearchForEventType( $ent, 'EMPTYTRANS', @transeventlist );    #an inner sub
				       #print("\n *****in 'EMPTYTRANS', ent->{dest} is: $ent->{dest} \n");
			} else
			{          #This TransNode has non-empty transitionbody
				       #get its event (empty or non-empty)
				$event = $ent->{tran}->{event};
				if ( $event eq '' )
				{      #$event is empty, another category
					    #First find it already has it or not
					@transeventlist = SearchForEventType( $ent, 'NOEVENT', @transeventlist );
				} else
				{       #$event is not-empty
					@transeventlist = CompareEvent( $ent, $event, @transeventlist );
				}

				#test if this transitionbody has guard or not, if it has set $guardbool
				if ( $ent->{tran}->{guard} ne '' )
				{
					$guardbool = 1;
				}
			}
		}
	}
	return ( $guardbool, @transeventlist );
}

#inner sub
#This is used for sub Formeventlist()
#Functionlity:
#search in @transeventlist if one type of event exists or not
#if existing, then add this TransNode to the transitionlist of this entry of @transeventlist
#if not, then add a new entry to @transeventlist
sub SearchForEventType
{
	my ( $ent, $eventtype, @transeventlist ) = @_;    #$ent is a ref to a TransNode
	my $eventhash = { event => undef, transitionlist => undef };    #an entry in @transeventlist
	my $transitionlist;
	my $found = 0;
	my $newent;
	my $desttype;

	#First resolve the type of {dest} of $ent, add {desttype} to $ent which is a TransNode
	$ent = Find_desttype($ent);

	#Search if $eventtype is in @transeventlist or not
	#if it is not, add an entry: $eventhash to @transeventlist
	foreach $newent (@transeventlist)
	{
		if ( $newent->{event} eq $eventtype )
		{

			#I find it
			$found = 1;

			#add this transition $ent to the transitionlist of $newent
			$transitionlist = $newent->{transitionlist};
			push( @$transitionlist, $ent );
			goto OUT;
		}
	}

	#I didn't find this event type in the current @transeventlist.
	#so add a new entry to @transeventlist.
	#push $ent to @$transitionlist
	push( @$transitionlist, $ent );

	#$eventhash->{event}
	$eventhash->{event}          = $eventtype;
	$eventhash->{transitionlist} = $transitionlist;
	push( @transeventlist, $eventhash );
  OUT:
	return @transeventlist;
}

#inner sub
#This is used for sub Formeventlist() above
#Functionality:
#This is used to compare an event with the event entries of @transeventlist
#$ent is a TransNode
#$event is $ent->{event}
sub CompareEvent
{
	my ( $ent, $event, @transeventlist ) = @_;
	my $eventhash = { event => undef, transitionlist => undef };    #an entry in @transeventlist
	my $transitionlist;
	my $eventtype = $event->{eventtype};
	my $eventname = '';
	my $eventvar  = '';
	my $whenvar   = '';
	my $leng      = 0;

	#First resolve the type of {dest} of $ent, add {desttype} to $ent which is a TransNode
	$ent = Find_desttype($ent);

	#form things to be compared for an event
	if ( $eventtype eq 'normal' )
	{
		$eventname = $event->{eventname};
		$eventvar  = $event->{eventvar};
	} elsif ( $eventtype eq 'when' )
	{
		$whenvar = $event->{whenvar};
	}

	#begin to compare $event with the entries in this @transeventlist
	my $found = 0;
	my $evententry;    #actually it is a ref
	my $evententrytype    = '';    #a property of $evententry
	my $evententryname    = '';    #a property of $evententry
	my $evententryvar     = '';    #a property of $evententry
	my $evententrywhenvar = '';    #a property of $evententry
	my $newent;

	foreach $newent (@transeventlist)
	{

		#form the variables of this entry: $newent
		$evententry     = $newent->{event};
		$evententrytype = $evententry->{eventtype};
		if ( $evententrytype eq 'normal' )
		{
			$evententryname = $evententry->{eventname};
			$evententryvar  = $evententry->{eventvar};
		} elsif ( $evententrytype eq 'when' )
		{
			$evententrywhenvar = $evententry->{whenvar};
		}

		#compare the properties of $event and $newent
		if (     ( $eventtype eq $evententrytype )
			 and ( $eventname eq $evententryname )
			 and ( $eventvar  eq $evententryvar )
			 and ( $whenvar   eq $evententrywhenvar ) )
		{

			#I find it
			$found = 1;

			#add this transition $ent to the transitionlist of $newent
			$transitionlist = $newent->{transitionlist};
			push( @$transitionlist, $ent );
			goto OUT;
		}
	}

	#I didn't find this event type in the current @transeventlist
	#so add a new entry to @transeventlist
	push( @$transitionlist, $ent );

	#$eventhash->{event}
	$eventhash->{event}          = $event;
	$eventhash->{transitionlist} = $transitionlist;
	push( @transeventlist, $eventhash );
  OUT:
	return @transeventlist;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub GuardlabelOutput
{
	my ( $class, $thisstatebodynode, $guardbool, @outputState ) = @_;
	my $stateID = $thisstatebodynode->{parent}->{ID};

	#guard
	#KS 041503 changed this to always get the guard symbol for the time invariant
	#if ($guardbool eq 1)
	#{#there is at least one guard in this statebodyNode, generate the guard symbol
	my $temp = $stateID . "_G";
	push( @outputState, "        $temp:" );

	#}
	#KS 041503 end change
	return @outputState;
}

#inner sub
#used by outputTransitions()
sub TransitionHeadOutput
{
	my ( $class, @outputState ) = @_;

	#token
	# push(@outputState,"        atomic {if :: !t?[free] -> t!free :: else skip fi;}");
	#if-stmt
	#KS added atomicity for transitions + check for token
	# Line removed again for evrsion 7
	#    push(@outputState,"        atomic{dijkstra_V.free == 1 ->");
	push( @outputState, "        if" );
	return @outputState;
}

#KS 041503 Added time invariant output
#inner sub
#used by outputTransitions()
sub TransitionEndOutput
{
	my @timearray;
	my ( $class, $dest, @outputState ) = @_;
	my $gotodest = $dest->{parent}->{ID};
	my $stmt     = $class->{child};
	my $statetimeinvariant;
	my $nooutput = 0;
	$statetimeinvariant = ASTVisitorForPromela->Getstatetimeinvariant();

	#KS change 041803 parse the statetime invariant
	if ( $statetimeinvariant ne '' )
	{
		@timearray = split( /<=/, $statetimeinvariant );
		@timearray[1] = @timearray[1] - 1;
		my $filler  = "<=";
		my $filler2 = ">";
		if ( @timearray[1] < 0 )
		{
			$nooutput = 1;
		}
		if ( @timearray[1] eq '' )
		{
			@timearray = split( /</, $statetimeinvariant );

			#print("ta: ",@timearray[1],"\n");
			@timearray[1] = @timearray[1] - 1;
			my $filler  = "<";
			my $filler2 = ">=";
			if ( @timearray[1] <= 0 )
			{
				$nooutput = 1;
			}
		}
		$classname = $dest;

		#KS 041803 end change
		if ( $nooutput ne 1 )
		{
			while ( $classname->{object} ne 'ClassNode' )
			{
				$classname = $classname->{parent};
			}
			$classname = $classname->{ID};
			push( @outputState,
				      "           :: atomic{Timer_V."
					. @timearray[0]
					. $filler
					. @timearray[1] . " -> "
					. $classname
					. "_V.timerwait = 1;" );
			push( @outputState, "              " . $classname . "_V.timerwait==0 -> goto " . $gotodest . "_G;}" );

			#Need to add one to make time invariant violation condition right
			my $temptimearray = @timearray[1];
			$temptimearray = $temptimearray + 1;
			push( @outputState, "           :: atomic{Timer_V." . @timearray[0] . $filler2 . $temptimearray . " ->" );
			push( @outputState, "              Timer_V." . @timearray[0] . "=-2; assert(0); false;}" );
		}
	}
	push( @outputState, "        fi;" );

	#KS added atomicity for transitions + check for token (added }
	#here)
	#Removed again in version 7
	return @outputState;
}

#KS 041503 end add
#inner sub
#Used by sub outputActionsMsgs()
sub MergeFormatOutput
{
	my ( $class, $array1, $array2, $countguard ) = @_;
	my $ent;
	foreach $ent (@$array1)
	{
		if ( $countguard eq 0 )
		{
			push( @$array2, "   $ent" );
		} else
		{
			push( @$array2, "      $ent" );
		}
	}
	return @$array2;
}

#inner sub
#used by sub SearchForEventType() & sub CompareEvent()
sub Find_desttype
{
	my ($ent) = @_;    #$ent is a TransNode
	if ( !exists( $ent->{desttype} ) )
	{
		my $statebodynode = $ent->{parent};
		my $dest          = $ent->{dest};
		my $SorCSorCCS    = visitstatebodyNodePak->ResolveTransDest( $statebodynode, $dest );
		if ( $SorCSorCCS ne '' )
		{
			if ( $SorCSorCCS->{object} eq 'StateNode' )
			{
				$$ent{desttype} = 'SS';
			} elsif ( ( $SorCSorCCS->{object} eq 'CStateNode' ) or ( $SorCSorCCS->{object} eq 'CCStateNode' ) )
			{
				$$ent{desttype} = 'CS';
			}

			#modify to add a new situation here
			else    #($SorCSorCCS eq 'Outgoing')
			{
				$$ent{desttype} = 'Outgoing';
			}
		}

		#else {die "Error: The destination $ent->{dest} of Transition is undefined!"}
	}
	return $ent;
}

#inner sub
#Used by sub Find_desttype()
#to resolve the {dest} of one TransNode to see it is a StateNode or CStateNode or CCStateNode
#return the type of {dest} as $SorCSorCCS
sub ResolveTransDest
{
	my ( $class, $thisstatebodynode, $dest ) = @_;
	my $SorCSorCCS = '';

	#modify to add more restrictions
	#step1: search the parent of this statebodynode: $thisstatebodynode, if I cannot find, then step2, otherwise return
	#step2: search in the whole ClassNode: $classparent
	my $statenodeparentref = $thisstatebodynode->{parent}->{parent}->{parent};
	$SorCSorCCS = ASTStateVisitorForPromela->SearchIncluding( $statenodeparentref, $dest );

#print("    statenodeparentref is ==>> ($statenodeparentref->{ID}, $statenodeparentref->{object}) ;; SorCSorCCS is ==>> $SorCSorCCS \n");
	if ( $SorCSorCCS eq '' )
	{    #I didn't find this $dest in my parent, continue to search for it.
		    #In this case my parent can only be 'CStateNode because I have passed
		    #the semantics checking stage done by ASTErrorCheckerVisitor.pm.
		if ( $statenodeparentref->{object} eq 'CStateNode' )
		{
			my $classparent = UniversalClass->SearchUpForDest( $thisstatebodynode, "ClassNode" );
			$SorCSorCCS = ASTStateVisitorForPromela->SearchIncluding( $classparent, $dest );
			if ( $SorCSorCCS ne '' )
			{
				return 'Outgoing';
			}
		}
	} else    #I found $dest in my parent, return it as it is (I don't need to change to 'Outgoing')
	{

		#modified 31/7/2002 7:47PM
		if ( $SorCSorCCS eq $statenodeparentref )
		{
			return 'Outgoing';
		}

		#modified end
		else
		{
			return $SorCSorCCS;
		}
	}
}

#inner sub
#used by sub outputTransitions()
sub EMPTYTRANSoutputState
{
	my ( $class, $thisstatebodynode, $transitionlist, @outputState ) = @_;
	my $ent;

	#KS 062203 added time invariant to normal transitions
	my $statetimeinvariant = ASTVisitorForPromela->GetstatetimeinvariantAndUndef();
	if ( $statetimeinvariant eq '' )
	{
		foreach $ent (@$transitionlist)
		{
			push( @outputState, "        :: atomic{1 -> " );
			my $dest = $ent->{dest};
			@outputState =
			  visitstatebodyNodePak->output_dest( $thisstatebodynode, $dest, $ent->{desttype}, 0, '', @outputState );
		}
	} else
	{
		foreach $ent (@$transitionlist)
		{
			push( @outputState, "        :: atomic{Timer_V.$statetimeinvariant -> " );
			my $dest = $ent->{dest};
			@outputState =
			  visitstatebodyNodePak->output_dest( $thisstatebodynode, $dest, $ent->{desttype}, 0, '', @outputState );
		}
	}

	#KS 062203 end add
	return @outputState;
}

#inner sub
#used by sub EMPTYTRANSoutputState()
#used by sub outputTransitions()
sub output_dest
{
	my ( $class, $thisstatebodynode, $dest, $desttype, $countguard, $mtypelist, @outputState ) = @_;
	if ( $desttype eq 'SS' )
	{
		if ( $countguard eq 0 )
		{
			push( @outputState, "           goto $dest; skip;}" );
		} else
		{
			push( @outputState, "              goto $dest; skip;}" );
		}
	} elsif ( $desttype eq 'CS' )
	{
		my $temp = "to_" . $dest;
		if ( $countguard eq 0 )
		{
			push( @outputState, "           goto $temp; skip;}" );
		} else
		{
			push( @outputState, "              goto $temp; skip;}" );
		}
	} else    #($desttype eq 'Outgoing')
	{
		my $temp       = "st_" . $dest;
		my $tempfound  = UniversalClass->ifinarray( $temp, @$mtypelist );
		my $cstatename = $dest->{ID};
		my $temp3      = $thisstatebodynode;
		while (    ( $temp3->{object} eq 'statebodyNode' )
				or ( $temp3->{object} eq 'StateNode' )
				or ( $temp3->{object} eq 'cstatebodyNode' ) )
		{
			$temp3 = $temp3->{parent};
		}
		$temp3 = $temp3->{ID};
		my $temp2 = $temp3 . "_C!1";
		if ( $tempfound eq 0 )
		{
			push( @$mtypelist, $temp );
		}
		if ( $countguard eq 0 )
		{
			push( @outputState, "           wait!_pid,$temp; $temp2; goto exit; skip;}" );
		} else
		{
			push( @outputState, "              wait!_pid,$temp; $temp2; goto exit; skip;}" );
		}
	}
	return @outputState;
}

#inner sub
#used by outputTransitions()
#The guard end of normal event is different from when event.
sub output_guardEnd
{
	my ( $class, $countguard, $event, $thisstatebodynode, @outputState ) = @_;
	if ( $countguard ne 0 )
	{

		#output else part of this guard
		my $stateID = $thisstatebodynode->{parent}->{ID};
		my $temp    = $stateID . "_G";

		#KS 041403 Added next if to keep else out of eventfree transitions
		if ( $event->{eventtype} ne '' )
		{
			if ( $event->{eventtype} eq 'when' )
			{
				my $whenvar = $event->{whenvar};

				#Here I call ExprYaccForPromela.pm to get result of when clause.
				ExprYaccForPromelaPak->PassRef($event);
				my $returnvalue = ExprYaccForPromela->Parse("when($whenvar)");
				push( @outputState, "           :: else -> !($returnvalue) -> goto $temp; skip;" );
			} else    #($event->{eventtype} eq 'normal')
			{
				push( @outputState, "           :: else -> goto $temp; skip;" );    #11 blanks
			}

			#output the end of this event
		}

		#KS 041403 end change
		#KS 041803 changed to make time invariant verification more efficiently
		if ( $event ne 'NOEVENT' )
		{
			push( @outputState, "           fi}" );
		}

		#KS 041803 end change
	}
	return @outputState;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub outputPredicateStmt
{
	my ( $class, $iftarget, $thisstatebodynode, @outputState ) = @_;
	if ( $iftarget eq 1 )
	{
		my $stateID  = $thisstatebodynode->{parent}->{ID};
		my $classref = UniversalClass->SearchUpForDest( $thisstatebodynode, "ClassNode" );
		my $temp1    = ( $classref->{ID} ) . "outputPredicateStatement_V.";
		my $temp2    = "st_" . $stateID;
		push( @outputState, "        $temp1$temp2 = 1;" );
	}
	return @outputState;
}

#Called by ASTVisitorForPromela.pm/ sub visitstatebodyNode()
sub IntraObjectOutput
{
	my ( $class, $thisstatebodynode, $transeventlist, $outputState ) = @_;
	my $event;
	my $ent;
	foreach $ent (@$transeventlist)
	{
		$event = $ent->{event};

		#test if $event is a signal defined in classbodyNode, if no, output "        evq!$event->{eventname},_pid;"
		if ( $event->{eventtype} eq 'normal' )
		{
			my $returnvalue =
			  UniversalClass->FindLocalDestNode( $thisstatebodynode, "SignalNode", $event->{eventname}, "name" );
			if ( $returnvalue eq '' )    #I couldn't find out
			{
				push( @$outputState, "        evq!$event->{eventname},_pid;" );
			}
		}
	}
	return @$outputState;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub CountTransNode
{
	my ( $class, $thisstatebodynode ) = @_;
	my $countTransNode = 0;
	my $stmt           = $thisstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'TransNode' )
		{
			$countTransNode = $countTransNode + 1;
		}
	}
	return $countTransNode;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub ifINPredicateTarget
{
	my ( $class, $thisstatebodynode, $INPredicateTarget ) = @_;
	my $ID           = $thisstatebodynode->{parent}->{ID};
	my $classbodyref = UniversalClass->SearchUpForDest( $thisstatebodynode, "classbodyNode" );
	my $iftarget     = 0;
	my $ent;
	foreach $ent (@$INPredicateTarget)
	{
		if ( $ent->{classbodyref} eq $classbodyref )
		{    #find this class
			my $INPredicatelist = $ent->{INPredicatelist};
			my $newent;
			foreach $newent (@$INPredicatelist)
			{
				if ( $newent eq $ID )
				{
					return 1;    #1
				}
			}
		}
	}
	return $iftarget;            #0
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
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

		#KS 041503 Added visit to timeinvariant node
		if ( $ent->{object} eq 'timeinvariantNode' )
		{
			$ent->Accept($thisvisitor);
		}

		#KS 041503 end add
	}

	#get @outputActionEntry
	if ( scalar(@temparrayentry) ne 0 )
	{
		push( @$outputActionEntry, "/* entry actions */" );

		#push(@$outputActionEntry,"        atomic {");
		@$outputActionEntry = UniversalClass->jointwoarrays( \@temparrayentry, $outputActionEntry );
		push( @$outputActionEntry, "        }" );
	} else
	{
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

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub NoTransitionOutput
{
	my ( $class, $thisstatebodynode, @outputState ) = @_;

	#output the following to @outputState
	#         atomic {if :: !t?[free] -> t!free :: else skip fi;}
	#         if
	#         :: skip -> false
	#         fi;
	@outputState = visitstatebodyNodePak->EmptyTransOutput(@outputState);
	return @outputState;
}

#Called by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub outputTransitions
{
	my ( $class, $thisvisitor, $outputState, $transeventlist, $mtypelist, $iftarget, $thisstatebodynode ) = @_;

	#head of transitions in this statebodyNode
	#           atomic {if :: !t?[free] -> t!free :: else skip fi;}
	#           if
	@$outputState = visitstatebodyNodePak->TransitionHeadOutput(@$outputState);

	#2, visit @transeventlist and generate the body of transitions in this statebodyNode
	my $event;
	my $transitionlist = '';    #a pointer to an array
	my $newent;
	my $guard;
	my $actions;
	my $messages;
	my $countguard = 0;         #used to count how many guards one event category has
	my @outputTrans;

	#added 04-04-03 To fix non-determinism
	my $iffirst = 0;

	#added 04-04-03
	foreach $ent (@$transeventlist)    #$ent is $eventhash
	{
		$event          = $ent->{event};
		$transitionlist = $ent->{transitionlist};

		#according to different categories output to @outputState
		if ( $event eq 'EMPTYTRANS' )
		{                              #in this category the TransNode has an empty transitionbody
			                           #print("\n Yes I find out a EMPTYTRANS TransNode \n ");
			                           #my $leng=scalar(@$transitionlist);
			                           #print("\n length of transitionlist is: $leng \n");
			@$outputState =
			  visitstatebodyNodePak->EMPTYTRANSoutputState( $thisstatebodynode, $transitionlist, @$outputState );
		} else    #($event eq 'NOEVENT') or ($event is a ref)
		{         #One category here is the TransNode has a non-empty transitionbody but has an empty event.
			    #The event part is like ":: 1 -> t?free;"
			    #Another category is the TransNode has a non-empty transitionbody and has a non-empty event.
			    #The event part can have two kinds of situations:
			    #1st, only eventname, e.g.
			    #ready         ===>  :: _SYSTEMCLASS__q?ready -> t?free;
			    #2nd, eventname & eventvar, e.g.
			    #carspeed(setspd) ===>  :: atomic{Control_q?carspeed ->Control_carspeed_p1?Control_V.setspd} -> t?free;
			    #print("\n Yes I find out a NOEVENT TransNode \n ");
			    #For every Transition, first analysis of {event}
			    #Then for every entry in @$transitionlist
			    #First analysis of {transition}->{guard}
			    #Second analysis of {transition}->{messages}
			    #Third analysis of {transition}->{actions}
			    #Finally analysis of {transition}->{dest}
			    #SK 041803 moved down to make time invariant more efficient

			if ( $event eq 'NOEVENT' )
			{    #empty event
				    #push(@$outputState,"        :: atomic{1 -> ");
			}

			#SK 041803 end change
			else
			{       #a ref to an eventNode
				                                 #output @outputTrans to @outputState
				$event->Accept($thisvisitor);    #@outputTrans holds the result of this eventNode
				@outputTrans = ASTVisitorForPromela->PassoutputTrans;
				if ( $event->{eventtype} eq 'normal' )
				{

	 #Here I check if this $event->{eventname} is defined in classbodyNode or not, if not, then it's intra-object output
					my $localret =
					  UniversalClass->FindLocalDestNode( $thisstatebodynode, "SignalNode", $event->{eventname},
														 "name" );
					if ( $localret eq '' )
					{
						push( @$outputState, "        :: atomic{evt??$event->{eventname},eval(_pid) -> " );
					} else
					{
						@$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
					}
				} else
				{
					@$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
				}
			}

			#the output of INPredicate symbol if this state is target of one INPredicate
			@$outputState =
			  visitstatebodyNodePak->outputINPredicateZero( $iftarget, $thisstatebodynode, @$outputState );
			$countguard = 0;

			#added 04-04-03 Fix non-determinism
			$iffirst = 1;

			#added end 04-04-03
			foreach $newent (@$transitionlist)    #$newent is a TransNode
			{

				#first is the analysis of {guard}
				( $countguard, @$outputState ) =
				  visitstatebodyNodePak->outputGuard( $newent->{tran}, $newent->{tran}->{guard},
													  $countguard, $event, @$outputState );

				#added 04-04-03 FIx non-determinism
				#print("[event]: $event, [countguard]: $countguard, [iffirst]: $iffirst\n");
				#SK 041803 changed to make timeinvariants more efficient
				if ( ( $countguard eq 0 ) )
				{                                 #there is no guard at all, so nondeterminism
					if ( $event eq 'NOEVENT' )
					{

						#empty event
						#SK 062203 Changed time invariant semantics
						my $statetimeinvariant = ASTVisitorForPromela->GetstatetimeinvariantAndUndef();
						if ( $statetimeinvariant eq '' )
						{
							push( @$outputState, "        :: atomic{1 -> " );
						} else
						{
							push( @$outputState, "        :: atomic{Timer_V.$statetimeinvariant -> " );
						}

						#SK 062203 end change
					} else
					{
						if ( $iffirst ne 1 )
						{
							$event->Accept($thisvisitor);    #@outputTrans holds the result of this eventNode
							@outputTrans = ASTVisitorForPromela->PassoutputTrans;
							@$outputState = UniversalClass->jointwoarrays( \@outputTrans, $outputState );
						}
					}
				}
				$iffirst = $iffirst + 1;

				#SK end change 041803
				#added end 04-04-03
				#second is the analysis of {actions}
				@$outputState =
				  visitstatebodyNodePak->outputActionsMsgs( $thisvisitor, 'Actions', $newent->{tran}->{actions},
															$countguard, @$outputState );

				#third is the analysis of {messages}
				@$outputState =
				  visitstatebodyNodePak->outputActionsMsgs( $thisvisitor, 'Msgs', $newent->{tran}->{messages},
															$countguard, @$outputState );

				#Finally is the analysis of {dest} of one Transition in (@$transitionlist).
				#Here I need to test if this {dest} of one Transition in (@$transitionlist) is
				#\a StateNode or CStateNode or CCStateNode.
				@$outputState = visitstatebodyNodePak->output_dest(        $thisstatebodynode, $newent->{dest}, $newent->{desttype},
															   $countguard,        $mtypelist,      @$outputState );
			}

			#output the end of guard to @outputState if any
			#           :: else -> goto <stateID>_G /*11 blanks*/
			#              fi               /*11 blanks*/
			#OR
			#           :: else -> !(<when-event-construct>) -> goto <stateID>_G    /*11 blanks*/
			#              fi                               /*11 blanks*/
			@$outputState =
			  visitstatebodyNodePak->output_guardEnd( $countguard, $event, $thisstatebodynode, @$outputState );
		}
	}

	#3, generate the end of transitions in this statebodyNode
	#        fi;            /*8 blanks*/
	my $tempdest = $thisstatebodynode->{parent}->{ID};
	@$outputState = visitstatebodyNodePak->TransitionEndOutput( $thisstatebodynode, @$outputState );

	#Well, now @outputState hold all the things (ActionNode & TransNode) in this statebodyNode
	return @$outputState;
}

#inner sub
#Used by sub outputTransitions()
sub outputINPredicateZero
{
	my ( $class, $iftarget, $thisstatebodynode, @outputState ) = @_;
	if ( $iftarget eq 1 )
	{
		my $stateID  = $thisstatebodynode->{parent}->{ID};
		my $classref = UniversalClass->SearchUpForDest( $thisstatebodynode, "ClassNode" );
		my $temp1    = ( $classref->{ID} ) . "outputINPreidcateZero_V.";
		my $temp2    = "st_" . $stateID;
		push( @outputState, "           $temp1$temp2 = 0;" );
	}
	return @outputState;
}

#inner sub
#Used by sub outputTransitions()
sub outputGuard
{
	my ( $class, $transref, $guardstring, $countguard, $event, @outputState ) = @_;
	if ( $guardstring ne '' )
	{

		#TransNode has a guard
		#if it is the first guard in this statebodyNode, then generate "if"
		#analyze this guard and output to @outputState
		$countguard = $countguard + 1;

		#KS 041803 changed to make time invariant verification more efficiently
		if ( $event ne 'NOEVENT' )
		{
			if ( $countguard eq 1 )
			{
				push( @outputState, "           if" );
			}
		}

		#KS 041803 end change
		#pass $newent->{tran} to ExprYaccForPromela.pm to let it get some ref
		ExprYaccForPromelaPak->PassRef($transref);

		#a parser to parse this guard and get the return string: $guardexpr
		my $guardexpr = ExprYaccForPromela->Parse("$guardstring");
		
		#KS 10/23/05 Remove spaces out of guards in order to help the slicer
		#KL commented out 11/8/05
		#$guardexpr =~s/\s+//g;

		#output $guardexpr to @outputState
		#KS 062203 added time invariant to normal transitions
		#KS 091903 Why in hell was it broke here? removed undef
		my $statetimeinvariant = ASTVisitorForPromela->Getstatetimeinvariant();
		if ( $statetimeinvariant eq '' )
		{
			if ( $guardexpr ne '' )
			{
				push( @outputState, "           :: atomic{$guardexpr ->" );
			} else
			{
				my $classref = UniversalClass->SearchUpForDest( $transref, "ClassNode" );
				die "In Class [$classref->{ID}], bad expression [$guardstring].";
			}
		} else
		{
			if ( $guardexpr ne '' )
			{
				push( @outputState, "           :: atomic{Timer_V.$statetimeinvariant && $guardexpr ->" );
			} else
			{
				my $classref = UniversalClass->SearchUpForDest( $transref, "ClassNode" );
				die "In Class [$classref->{ID}], bad expression [$guardstring].";
			}
		}

		#KS 062203 end change
	}
	return ( $countguard, @outputState );
}

#inner sub
#Used by sub outputTransitions()
sub outputActionsMsgs
{
	my ( $class, $thisvisitor, $ActionsORMsgs, $noderef, $countguard, @outputState ) = @_;
	my @outputtranactions;
	my @outputmessages;
	if ( $noderef ne '' )
	{    #The transitionbody of this TransNode has {actions}.
		    #analyze actions and get result in @outputtranactions
		    #output @outputtranactions to @outputState
		$noderef->Accept($thisvisitor);
		if ( $ActionsORMsgs eq 'Actions' )
		{    #if $countguard eq 0, then I will have 11 blanks.
			    #if $countguard ne 0, then I will have 14 blanks.
			@outputtranactions = ASTVisitorForPromela->Getoutputtranactions;
			@outputState = visitstatebodyNodePak->MergeFormatOutput( \@outputtranactions, \@outputState, $countguard );
		} else    #($ActionsORMsgs eq 'Msgs')
		{         #if $countguard eq 0, then I will have 11 blanks.
			      #if $countguard ne 0, then I will have 14 blanks.
			@outputmessages = ASTVisitorForPromela->Getoutputmessages;
			@outputState = visitstatebodyNodePak->MergeFormatOutput( \@outputmessages, \@outputState, $countguard );
		}
	}
	return @outputState;
}
1;
