#!/usr/bin/perl
#This program generates programs written in a target language called Promela.
#It inherits from TraverseVisitor, which is a subclass of AbstractVisitor.
package ASTVisitorForPromela;
use TraverseVisitor;    #SUPER
our @ISA = ("TraverseVisitor");
use ASTINPredVisitorForPromela;    #another visitor to get the INPredicate of one WHOLE model
use UniversalClass;
use LTLYacc;
use ExprYaccForPromela;
use ExprYaccForPromelaPak;
use visitmodelbodyNodePak;
use visitclassbodyNodePak;
use visitcstatebodyNodePak;
use visitInitNodePak;
use visitHistoryNodePak;
use visitmessageNodePak;
use visittranactionNodePak;
use visitInstVarNodePak;
use visitSignalNodePak;
use visitStateNodePak;
use visitstatebodyNodePak;
use visiteventNodePak;
my $modelnum1outputfile;
my @mtypelist;
my @outputInit;
my @outputHistory;
my @GlobalHistoryMtype;
my @outputAction;
my @outputActionEntry;
my @outputActionExit;
my @outputClass;
my @outputWholeClass;
my @outputState;
my @outputWholeState;
my @outputTrans;
my @outputCState;
my @outputCCState;
my @outputCStateID;
my @outputCCStateIDint;
my @outputCCStateIDmtype;
my @GlobaloutputInstVar;
my @GlobaloutputInstVarBody;

#SK added 041103 to support time invariants
#This list will contain the timer body that go into
#the timer typedef
my @GlobalTimerInstVarOutput;

#This list contains all the timer names for lookup purposes later
my @GlobalTimerList;

#end add 041103
#SK added 041303
#process list created to contain list of processes
#to use it in the timer proces output
my @GlobalProcessList;

#SK end add 041303
my @outputInstVar;
my @GlobaloutputSignal;
my @GlobalInstVarSignal;
my @GlobaloutputCCState;
my @GlobaloutputCState;
my @outputtransitionbody;
my @outputmessages;
my @outputmessage;
my @outputtranactions;
my @outputtranaction;
my @transeventlist;
my @OutgoingTransitionlist;

#KS 041503 Used to store the timeinvariant
my $statetimeinvariant;

#KS end
my @WholeOutgoingTransitionlist;

#to hold all the outgoing transitions of a CStateNode & all its CStateNodes children
my @INPredicateTarget;

#to hold all the INPredicate targets of every class
#every entry is a hash which including a ref to a classbodyNode and a list of INPredicate Targets
my @CStateoutputActionEntry;
my @CStateoutputActionExit;

#reused from SPIN/Context.pm
my @NEVER;
my @DEFINES;
my $driverfileID;

#to pass the output file name from file hydra
#$modelnum1outputfile is a ref to the output file
sub PassOutputFileName
{
	my $class = shift();
	$modelnum1outputfile = shift();
}

#reused from SPIN/Context.pm
sub SetNever
{
	my ( $class, $filename ) = @_;

	# This routine takes a name containing a 1 one LTL claim in hydra format
	# (see ltlgram.y). It grabs the claim, parses it, which gives a spin-able
	# claim and a symbol table to match to the spinable claim. Next, it
	# calls spin -F to get the never claim into Promela, then fetches the
	# symbol tables from LTLYacc and builds a set of #defines to make the
	# claim work. Along the way, if it find "Class_V.st_state" variable in a define
	# it signals ASTWalker to force a In-State variable for that state.
	# Get claim and parse
	open( IN, $filename ) || die "Can't open never claim file";
	$l = <IN>;    # get never claim
	chop $l;
	close(IN);
	print("Building never claim for LTL: $l \n");
	my $claim = LTLYacc->Parse("$l;");
	if ( !$claim )
	{
		print("***Error: Never claim has bad syntax \n");
		exit(1);
	}

	# Spinize the claim
	open( TEMP, ">hydratemp.$$" ) || die "Can't open claim temp file";
	print TEMP $claim;
	close(TEMP);
	if ( !open( SPIN, "spin -F hydratemp.$$|" ) )
	{
		print("***Error: Can't run spin!! \n");
		exit(1);
	}
	while ( $l = <SPIN> )
	{
		chop $l;
		push( @NEVER, $l );
	}
	close(SPIN);
	unlink("hydratemp.$$");

	# Get the symbol table from LTL parse. Force state vars.
	my %symtab = LTLYacc->GetDefn;
	foreach $sym ( keys %symtab )
	{
		push( @DEFINES, "#define $symtab{$sym} ($sym)" );
		if ( $sym =~ /^[A-z_]+\.st_([A-z0-9]+)/ )
		{
			my $state = $1;
			ASTVisitorForPromela->InStateTarget($state);
		}
	}
	print("***Info: LTL defines\n");
	print("***Info: join(\"\n\", @DEFINES) \n");
	print("***Info: Never proc: \n");
	print("***Info: join(\"\n\", @NEVER) \n");
}

#reused from SPIN/ASTWalker.pm
sub InStateTarget
{

	# This method called to pass a NAMES, (not ref) that should
	# have IN predicate variables forced for it.
	my ( $class, $state ) = @_;
	$TS{$state} = 1;
	print("***Info: Creating IN-State variable in $state \n");
}

sub visitmodelbodyNode
{
	my ( $thisvisitor, $themodelbodynode ) = @_;

	#******************
	#get all the IN-Predicate target states in this modelbodyNode
	#******************
	ASTINPredVisitorForPromela->visitmodelbodyNode($themodelbodynode);
	@INPredicateTarget = ASTINPredVisitorForPromela->GetResult;

	#******************
	#visit children of this modelbodyNode and get corresponding result
	#******************
	my $stmt = $themodelbodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'ClassNode' )    #This ClassNode has a classbody
		{
			push( @GlobalProcessList, $ent->{ID} );
			$ent->Accept($thisvisitor);

			#output @GlobalHistoryMtype to @GlobalInstVarSignal
			@GlobalInstVarSignal = UniversalClass->jointwoarrays( \@GlobalHistoryMtype, \@GlobalInstVarSignal );

			#output @GlobaloutputInstVar to @GlobalInstVarSignal
			@GlobalInstVarSignal = UniversalClass->jointwoarrays( \@GlobaloutputInstVar, \@GlobalInstVarSignal );

			#output @GlobaloutputSignal to @GlobalInstVarSignal
			@GlobalInstVarSignal = UniversalClass->jointwoarrays( \@GlobaloutputSignal, \@GlobalInstVarSignal );

			#output @outputClass to @outputWholeClass
			@outputWholeClass = UniversalClass->jointwoarrays( \@outputClass, \@outputWholeClass );
		} elsif ( $ent->{object} eq 'DriverfileNode' )
		{
			$ent->Accept($thisvisitor);
		} elsif ( $ent->{object} eq 'NullNode' )    #This ClassNode does not have a classbody
		{                                           #haven't done yet
		}

		#else
		#{warn "Warning: Bad type $ent->{object}!"};
	}    #end of foreach

	#SK added 041003 to support timing
	undef(@GlobaloutputInstVar);
	undef(@GlobaloutputInstVarBody);
	@GlobalTimeVarSignal =
	  visitclassbodyNodePak->FormTimingInstVar( $ent, \@GlobaloutputInstVarBody, \@INPredicateTarget,
												\@GlobaloutputInstVar, \@GlobalTimerInstVarOutput );
	@GlobalInstVarSignal = UniversalClass->jointwoarrays( \@GlobalInstVarSignal, \@GlobalTimeVarSignal );

	#@outputWholeClass=UniversalClass->jointwoarrays(\@outputClass,\@outputWholeClass);
	#SK end add 041003
	#get the output of the whole modelbodyNode
	$modelnum1outputfile = visitmodelbodyNodePak->OutputmodelbodyNode(
														   $modelnum1outputfile,  \@DEFINES,         \@mtypelist,
														   \@GlobalInstVarSignal, $driverfileID,     \@outputWholeClass,
														   \@NEVER,               \@GlobalTimerList, \@GlobalProcessList
	);
}

#used by visitclassbodyNode()
sub visitclassbodyReset
{
	undef(@GlobaloutputInstVar);        #every class has one
	undef(@outputInit);
	undef(@outputClass);                #every class has one
	undef(@outputCState);               #added 31/7/2002 3:30PM
	undef(@GlobaloutputSignal);         #every class has one
	undef(@outputInstVar);              #every class has one
	undef(@GlobaloutputInstVarBody);    #every class has one
	undef(@outputWholeState);           #every class has one
	undef(@GlobaloutputCState);         #every class has one
	undef(@GlobaloutputCCState);        #every class has one
	undef(@outputCStateID);             #every class has one
	undef(@outputCCStateIDint);         #every class has one
	undef(@outputCCStateIDmtype);       #every class has one
	undef(@OutgoingTransitionlist);
	undef(@GlobalHistoryMtype);
}

sub visitclassbodyNode
{
	my ( $thisvisitor, $theclassbodynode ) = @_;

	#*********************
	#reset classbodyNode-level attributes
	#*********************
	ASTVisitorForPromela->visitclassbodyReset;

	#**********************
	#visit its children and get corresponding result
	#**********************
	my $stmt              = $theclassbodynode->{child};
	my $countSignalNumber = 0;
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'InitNode' )
		{
			$ent->Accept($thisvisitor);

			#@outputInit holds the result of this Initial stmt,
			#I will output it to @outputClass later in this sub.
			#Because the output in @outputClass should obey some sequence
			#\but I can put Initial stmt anywhere in a class.
		} elsif ( $ent->{object} eq 'InstVarNode' )
		{
			$ent->Accept($thisvisitor);

			#@outputInstVar (LOCAL): to hold the local output of one class
			#\if there is any InstVar with non-zero initial value.
			#I will output @outputInstVar to @outputClass later in this sub.
		} elsif ( $ent->{object} eq 'SignalNode' )
		{
			$countSignalNumber = $countSignalNumber + 1;
			if ( $countSignalNumber eq 1 )
			{

				#output a signal head to @GlobaloutputSignal, i.e., chan $temp=[5] of {mtype};
				#If this class at least has one SignalNode,
				#\then I need output this head, this is for the class.
				#Later if there is any SignalNode WITH parameters, I will output to @GlobaloutputSignal.
				#Can refer to sub visitSignalNode() in this class.
				@GlobaloutputSignal =
				  visitclassbodyNodePak->GlobalSignalHeadOutput( $theclassbodynode, @GlobaloutputSignal );
			}
			$ent->Accept($thisvisitor);

			#@GlobaloutputSignal: I will output it to @GlobalInstVarSignal in sub visitmodelbodyNode() in this class.
			#I will not do anything more in this sub.
		}

		#elsif ($ent->{object} eq 'HistoryNode')
		#{
		#   $ent->Accept($thisvisitor);
		#}
		elsif ( $ent->{object} eq 'StateNode' )
		{

			#visit StateNode and get result to @outputState that holds all the other output of this StateNode.
			$ent->Accept($thisvisitor);
			@outputWholeState = visitclassbodyNodePak->StateBlock( $ent, \@outputWholeState, \@outputState );

			#I will output @outputWholeState to @outputClass later in this sub.
		} elsif ( $ent->{object} eq 'CStateNode' )
		{
			visitclassbodyNodePak->RunCProctype( $ent, \@mtypelist, \@outputCStateID, \@outputWholeState );
		} elsif ( $ent->{object} eq 'CCStateNode' )
		{
			visitclassbodyNodePak->OutputCCState( $ent, \@mtypelist, \@outputCCStateIDint, \@outputCCStateIDmtype,
												  \@outputWholeState );
		} elsif ( $ent->{object} eq 'JoinNode' )
		{

			#I merge this part into CCStateNode part, because these two parts are tightly related to each other
		}

		#else {warn "Warning: Bad type $ent->{object}!";}
	}    #end of foreach

	#**************
	#To form the global output of this class
	#**************
	#First to form @GlobaloutputInstVar
	@GlobaloutputInstVar = visitclassbodyNodePak->FormGlobaloutputInstVar(  $theclassbodynode,   \@GlobaloutputInstVarBody,
																		 \@INPredicateTarget, \@GlobaloutputInstVar );

#@GlobaloutputSignal will be output in visitmodelbodyNode because it holds all the content of SignalNodes in this Class.
#To form the proctype output of this class to @outputClass
	@outputClass =
	  visitclassbodyNodePak->Proctype( $theclassbodynode, \@outputClass, \@outputCStateID, \@outputCCStateIDint,
									   \@outputCCStateIDmtype, \@outputInstVar, \@outputInit, \@outputWholeState );

	#*************************
	#I will analyze CStateNode of this classbodyNode and get the result here
	#I will analyze CCStateNode of this classbodyNode and get the result here
	#*************************
	#For every CStateNode, there will be one proctype right after the proctype of this classbodyNode,
	#\@GlobaloutputCState holds the new proctype.
	#For every CCStateNode, there will be one class corresponding to every CStateNode in this CCStateNode.
	#\@GlobaloutputCCState holds all the new proctypes.
	#*************************
	#visit its children, i.e., CStateNode or CCStateNode
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'CStateNode' )
		{
			undef(@WholeOutgoingTransitionlist);
			$ent->Accept($thisvisitor);

			#@GlobaloutputCState holds the proctype output of this CStateNode.
			#Inside sub visitcstatebodyNode() in this class, I will directly
			#\output @GlobaloutputCState to @outputClass.
		} elsif ( $ent->{object} eq 'CCStateNode' )
		{
			$ent->Accept($thisvisitor);

			#@GlobaloutputCCState holds the proctype output of this CCStateNode.
			#I do not need to output @GlobaloutputCCState to @outputClass in sub visitccstatebodyNode(),
			#\because actually in sub visitccstatebodyNode() I will call sub visitcstatebodyNode(),
			#\and the result will be output from @GlobaloutputCState to @outputClass at that time.
		}
	}
}

sub visitDriverfileNode
{
	my ( $thisvisitor, $driverfileRef ) = @_;
	$driverfileID = $driverfileRef->{ID};    #it's a class attribute
}

sub visitSignalNode
{
	my ( $thisvisitor, $thissignalnode ) = @_;

	#register this SignalNode to @mtypelist
	my $signalname = $thissignalnode->{name};
	my $ifinarray = UniversalClass->ifinarray( $signalname, @mtypelist );
	if ( $ifinarray eq 0 )
	{
		push( @mtypelist, $signalname );
	}
	if ( exists( $thissignalnode->{sigtype} ) )
	{

		#output this sigtype to @GlobaloutputSignal
		@GlobaloutputSignal = visitSignalNodePak->GlobaloutputSignal( $thissignalnode, @GlobaloutputSignal );
	}
}

sub visitStateNode
{
	my ( $thisvisitor, $thisstatenode ) = @_;
	if ( exists( $thisstatenode->{child} ) )    #This StateNode has children
	{
		my $thischild = $thisstatenode->{child};
		my $ent;
		foreach $ent (@$thischild)              #Actually only one child here, i.e., statebodyNode
		{
			$ent->Accept($thisvisitor);
		}
	} else
	{                                           #it does not have children
		undef(@outputState);
		@outputState = visitStateNodePak->EmptyStateOutput(@outputState);
	}
}

#Called by visitstatebodyNode.pm/sub outputTransitions()
sub PassoutputTrans
{
	return @outputTrans;
}

#Called by visitstatebodyNode.pm/sub outputTransitions()
sub Getoutputtranactions
{
	return @outputtranactions;
}

#KS 041503 Added to get the state time invariant to the state visitor
#Called by visitstatebodyNode.pm/sub outputTransitions()
sub Getstatetimeinvariant
{
	my $temp = $statetimeinvariant;

	#undef($statetimeinvariant);
	return $temp;
}

#KS 041503 end add
#KS 062203 Added this to have somthing undefine the state invariant to make the
# semantincs for the time invariant right
#Called by visitstatebodyNode.pm/sub outputTransitions()
sub GetstatetimeinvariantAndUndef
{
	my $temp = $statetimeinvariant;
	undef($statetimeinvariant);
	return $temp;
}

#KS 062203 end add
#Called by visitstatebodyNode.pm/sub outputActionsMsgs()
sub Getoutputmessages
{
	return @outputmessages;
}

#Called by visitstatebodyNode.pm/sub GetAllActions()
sub PassoutputAction
{
	return @outputAction;
}

#Used by ASTVisitorForPromela.pm/sub visitstatebodyNode()
sub visitstatebodyNodeReset
{
	undef(@outputState);
	undef(@outputActionEntry);
	undef(@outputActionExit);
	undef(@transeventlist);
}

#Its children can be ActionNode(0..n) or TransNode(0..n).
sub visitstatebodyNode
{
	my ( $thisvisitor, $thisstatebodynode ) = @_;
	ASTVisitorForPromela->visitstatebodyNodeReset;

	#count if there is any Transition in this statebodyNode or not.
	#Because I need to categorize all the TransNodes in this statebodyNode,
	#\so I will process them later in this sub.
	my $countTransNode = visitstatebodyNodePak->CountTransNode($thisstatebodynode);

	#test if this visitstatebodyNode is the target of a INPredicate or not
	my $iftarget = visitstatebodyNodePak->ifINPredicateTarget( $thisstatebodynode, \@INPredicateTarget );

	#get result to @outputActionEntry and @outputActionExit
	#Because I need to collect all entry/exit ActionNodes in one statebodyNode respectively together
	visitstatebodyNodePak->GetAllActions( $thisvisitor, $thisstatebodynode, \@outputActionEntry, \@outputActionExit );

	#output @outputActionEntry to @outputState
	@outputState = UniversalClass->jointwoarrays( \@outputActionEntry, \@outputState );

	#output @outputActionExit to @outputState
	@outputState = UniversalClass->jointwoarrays( \@outputActionExit, \@outputState );
	if ( $countTransNode eq 0 )
	{

		#This statebody does not have any Transitions, it only has Actions.
		#So output special thing to @outputState. Also a warning.
		@outputState = visitstatebodyNodePak->NoTransitionOutput( $thisstatebodynode, @outputState );
		return;
	}

	#if this state is target of an INPredicate, then output the following stmt to @outputState
	@outputState = visitstatebodyNodePak->outputPredicateStmt( $iftarget, $thisstatebodynode, @outputState );

	#******************************
	#This statebodyNode at least has one TransNode.
	#I process all the TransNode of this statebodyNode and output them here. This part is complicated.
	#1st, get the eventlist of all the transitions, i.e. how many types of events this statebodyNode has, \
	#it decides how many sections I will output to @outputState, \
	#at the same time add the transtions to the transitionlist of this event type
	#2nd, for each event in this eventlist, process every transition in its transitionlist.
	#\This is a two-level nested loop
	#******************************
	#1st
	my $guardbool = 0;    #to test if there is any guard in these transitions or not
	                      #in order to know if I need to generate the guard symbol or not
	( $guardbool, @transeventlist ) = visitstatebodyNodePak->Formeventlist($thisstatebodynode);

	#2nd
	#1, generate the guard label of this statebodyNode
	#<state name>_G:  /*OR without this line if there is no guard in this statebodyNode*/
	@outputState = visitstatebodyNodePak->GuardlabelOutput( $thisstatebodynode, $guardbool, @outputState );

	#intra-object output
	@outputState = visitstatebodyNodePak->IntraObjectOutput( $thisstatebodynode, \@transeventlist, \@outputState );

	#output all transitions inside this statebodyNode
	@outputState =
	  visitstatebodyNodePak->outputTransitions( $thisvisitor, \@outputState, \@transeventlist, \@mtypelist, $iftarget,
												$thisstatebodynode );
}

#To analyze CStateNode and get the output to @GlobaloutputCState, another proctype.
sub visitCStateNode
{
	my ( $thisvisitor, $thiscstatenode ) = @_;
	my $ent;
	if ( !exists( $thiscstatenode->{child} ) )    #it does not have cstatebodyNode
	{

		#directly output the empty proctype to @GlobaloutputCState
		#haven't done yet
	} else
	{                                             #This CStateNode has children.
		my $cstatechild = $thiscstatenode->{child};
		foreach $ent (@$cstatechild)              #actually it only has one child, i.e, cstatebodyNode
		{

			#Next two lines were added to define the control channels for each cstate
			@GlobaloutputSignal = visitcstatebodyNodePak->GlobalSignalHeadOutput( $ent, @GlobaloutputSignal );
			$ent->Accept($thisvisitor);
		}
	}
}

#used by visitcstatebodyNode()
sub visitcstatebodyNodeReset
{
	undef(@GlobaloutputCState);    #the proctype result of this cstatebodyNode
	undef(@outputWholeState);
	undef(@outputCState);
	undef(@outputCStateID);
	undef(@outputCCState);
	undef(@outputCCStateIDint);      #every cstatebodyNode has one
	undef(@outputCCStateIDmtype);    #every cstatebodyNode has one
	undef(@outputAction);
	undef(@outputInit);
	undef(@outputActionEntry);
	undef(@outputActionExit);
	undef(@OutgoingTransitionlist);    #all the outgoing Transitions inside this cstatebodyNode.
	undef(@CStateoutputActionEntry);
	undef(@CStateoutputActionExit);

	#undef(@outputHistory);
}

#Basically it is similar to ASTVisitorForPromela.pm/visitclassbodyNode.
#In some sense it is simpler because it has less child types,
#\but it has TransNode as its child make things complicated.
#TransNode, StateNode, CStateNode & CCStateNode of this cstatebodyNode will be processed specially.
#\their output is different from the output in visitclassbodyNode
sub visitcstatebodyNode
{
	my ( $thisvisitor, $thiscstatebodynode ) = @_;

	#******************
	#Part1: reset some arrays
	#******************
	ASTVisitorForPromela->visitcstatebodyNodeReset;

	#******************
	#process of ActionNode()
	#******************
	#get result to @outputActionEntry and @outputActionExit
	#Because I need to collect all entry/exit ActionNodes in one cstatebodyNode respectively together
	visitcstatebodyNodePak->GetAllActions( $thisvisitor, $thiscstatebodynode, \@outputActionEntry, \@outputActionExit );

	#preserve @outputActionEntry to @CStateoutputActionEntry; @outputActionExit to @CStateoutputActionExit;
	@CStateoutputActionEntry = UniversalClass->jointwoarrays( \@outputActionEntry, \@CStateoutputActionEntry );
	@CStateoutputActionExit  = UniversalClass->jointwoarrays( \@outputActionExit,  \@CStateoutputActionExit );

	#******************
	#process HistoryNode
	#also update @mtypelist if necessary
	#******************
	#HistoryNode has three parts to output: @outputHistory (local), @HistorySelect (local) & @GlobalHistoryMtype
	my $ifHistory;
	my @HistorySelect;    #to hold the select section of History state
	( $ifHistory, undef, @mtypelist ) =
	  visitcstatebodyNodePak->ifHistoryExist( $thiscstatebodynode, \@HistorySelect, @mtypelist );

#******************
#Part2: sub visitcstatebodyNodePak->getOutgoingTransitions()
#Get all the outgoing Transitions inside this cstatebodyNode.
#$countTransNode is used to count how many TransNode in this cstatebodyNode.
#Obviously if $countTransNode gt 0, then @OutgoingTransitionlist is not empty.
#IF there is no TransNode in this cstatebodyNode then output is easy because I do not need to output
#\the output of TransNodes to StateNodes (recursion) of this cstatebodyNode.
#IF there is some TransNode in this cstatebodyNode,
#\I will (recursively) propagate them to the StateNodes inside this cstatebodyNode.
#Because these transitions are across the boundary of this cstatebodyNode, so output in this cstatebody, i.e.,
#\in @outputCState will be like:
#:: <classname>_q?<eventname> -> t?free;
#   ...
#   wait!_pid,st_<dest of the Transitions>;
#   goto exit;
#ALSO I will output the {dest} of all the TransNodes to @outputCState if there is any CStateNode inside this cstatebodyNode.
#The output will be like this:
#        :: m == st_<dest1 name> -> wait!_pid;st_<dest1 name>;
#           goto exit;
#        :: m == st_<dest2 name> -> wait!_pid;st_<dest2 name>;
#           goto exit;
#******************
	my $countTransNode = 0;
	( $countTransNode, @OutgoingTransitionlist ) = visitcstatebodyNodePak->getOutgoingTransitions($thiscstatebodynode);

	#Remove redundancy of @OutgoingTransitionlist  31/7/2002 3:11PM
	#and preserve @OutgoingTransitionlist to @WholeOutgoingTransitionlist
	@WholeOutgoingTransitionlist =
	  visitcstatebodyNodePak->PreserveOutgoingTransitionlist( \@OutgoingTransitionlist, @WholeOutgoingTransitionlist );
	visitcstatebodyNodePak->pushOutgoingTransitionlist( $thiscstatebodynode, $countTransNode, @OutgoingTransitionlist );

#**************************************
#Part 3:
#visit children of this cstatebodyNode & get its corresponding output
#TransNode, StateNode, CStateNode, CCStateNode will be processed specially,
#\because I will propagate TransNode children of this cstatebodyNode into the StateNodes or StateNodes inside CStateNode,
#\CStateNode inside CCStateNode (recursion).
#**************************************
	my $stmt = $thiscstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'InitNode' )
		{

			#get the output to @outputInit
			$ent->Accept($thisvisitor);

			#@outputInit: it will be output to @GlobaloutputCState at the end of this subroutine
		} elsif ( $ent->{object} eq 'ActionNode' )
		{
			next;
		} elsif ( $ent->{object} eq 'CStateNode' )
		{
			visitcstatebodyNodePak->RunCProctype( $ent, \@mtypelist, \@outputCStateID, \@outputWholeState,
												  \@WholeOutgoingTransitionlist );
		} elsif ( $ent->{object} eq 'JoinNode' )
		{

			#I merge this part into CCStateNode part, because these two parts are tightly related to each other
		} elsif ( $ent->{object} eq 'HistoryNode' )
		{

			#get the output to @outputHistory
			$ent->Accept($thisvisitor);

			#@outputHistory: it will be output to @GlobaloutputCState at the end of this subroutine
			#And also get @GlobalHistoryMtype
		} elsif ( $ent->{object} eq 'CCStateNode' )
		{
			visitcstatebodyNodePak->OutputCCState( $ent, \@mtypelist, \@outputCCStateIDint, \@outputCCStateIDmtype,
												   \@outputWholeState );
		} elsif ( $ent->{object} eq 'TransNode' )
		{

			#I will not do anything to TransNode directly inside this cstatebodyNode here.
			#I have got all the @OutgoingTransitionlist earlier in this sub.
		} elsif ( $ent->{object} eq 'StateNode' )
		{

			#According to the fact if there is any TransNode inside this cstatebodyNode, I have different output.
			#But I will not take care of these two situations here,
			#\I let visitStateNode & visitstatebodyNode take care of them.
			@outputCStateID = visitcstatebodyNodePak->AddTleafPID( $ent, @outputCStateID );

			#visit StateNode and get result in @outputState
			$ent->Accept($thisvisitor);

			#output content of this StateNode to @outputWholeState
			@outputWholeState =
			  visitcstatebodyNodePak->StateBlock( $ent, $ifHistory, \@outputWholeState, \@outputState );
		}

		#else
		#{warn "Bad cstatestmt type $ent->{object} in CState!"}
	}

	#**********************
	#Part 4:
	#To form the output of this CStateNode to @GlobaloutputCState
	#**********************
	@GlobaloutputCState = visitcstatebodyNodePak->CProctype(
															 $thiscstatebodynode,      \@GlobaloutputCState,
															 \@outputCStateID,         \@outputCCStateIDint,
															 \@outputCCStateIDmtype,   \@CStateoutputActionEntry,
															 \@CStateoutputActionExit, \@outputInit,
															 \@outputHistory,          \@HistorySelect,
															 \@outputWholeState
	);

	#To output @GlobaloutputCState to @outputClass, if any
	@outputClass = UniversalClass->jointwoarrays( \@GlobaloutputCState, \@outputClass );

	#*************************
	#Part 5:
	#I will analyze CStateNode and get the result here:
	#For every CStateNode, there will be one class right after this classbodyNode, @GlobaloutputCState holds the result
	#I will analyze CCStateNode and get the result here:
	#For every CCStateNode, there will be one class corresponding to every CStateNode in this CCStateNode
	#*************************
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'CStateNode' )
		{
			$ent->Accept($thisvisitor);
		} elsif ( $ent->{object} eq 'CCStateNode' )
		{
			$ent->Accept($thisvisitor);
		}
	}
}

sub visitCCStateNode
{
	my ( $thisvisitor, $thisccstatenode ) = @_;
	my $ent;
	if ( !exists( $thisccstatenode->{child} ) )
	{    #I am not sure the semantics here
		undef(@GlobaloutputCCState);
	} else
	{    #It has ccstatebodyNode
		my $ccstatechild = $thisccstatenode->{child};
		foreach $ent (@$ccstatechild)    #actually it only has one child
		{
			$ent->Accept($thisvisitor);
		}
	}
}

sub visitccstatebodyNode
{
	my ( $thisvisitor, $thisccstatebodynode ) = @_;
	undef(@GlobaloutputCCState);
	my $stmt = $thisccstatebodynode->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ( $ent->{object} eq 'CStateNode' )
		{
			$ent->Accept($thisvisitor);

			#@GlobaloutputCState holds the result and output to @outputClass in visitcstatebodyNode.
			#So I do not need to output @GlobaloutputCState to @GlobaloutputCCState.
		}

#elsif ($ent->{object} eq 'StateNode')
#{#I'm not sure the semantics here, I think this is an illegal child of CCStateNode
#}
#elsif ($ent->{object} eq 'ActionNode')
#{#A warning: this is not allowed!
#   my $myparent=$thisccstatebodynode->{parent}->{ID};
#   warn "Warning: Wrapper $myparent can't have Actions. Put the action in the contained                    #CompositeStates.";
#}
#else
#{warn "Warning: Bad type $ent->{object} in CCStateNode!"}
	}
}

#Each Initial node can have an empty transition body, e.g. Initial "" target1;
#Or it can have only one message.
#Every classbodyNode, cstatebodyNode has only one Initial node
#ccstatebodyNode does not have any Initial node
sub visitInitNode
{
	#SK 10/22/05 Fixed this so that the process termination work around is correct
	my ( $thisvisitor, $thisinitnode ) = @_;
	my $myparent     = $thisinitnode->{parent};
	my $myparenttype = $myparent->{object};
	undef(@outputInit);    #to delete the content of @outputInit
	if ( $myparenttype eq 'cstatebodyNode' )
	{                      
		push( @outputInit, "startCState:atomic{" );    #output the first to @outputInit
	}
	push( @outputInit, "/*Init state*/" );             #output the first to @outputInit
	if ( !exists( $thisinitnode->{tran} ) or ( $thisinitnode->{tran} eq '' ) )
	{                                                  #no transitionbodyNode OR have one empty transitionbodyNode
		my $ID = $thisinitnode->{ID};

		#resolve dest & output to @outputInit
		@outputInit = visitInitNodePak->ResolveDest( $thisinitnode, $myparenttype, @outputInit );

		#@outputInit holds all the result
	} elsif ( exists( $thisinitnode->{tran} ) && ( $thisinitnode->{tran} ne '' ) )
	{

		#output {tran} part to @outputtransitionbody
		my $tran = $thisinitnode->{tran};
		$tran->Accept($thisvisitor);                   #transitionbodyNode needs to write to @outputInit
		                                               #have one non-empty transitionbodyNode
		push( @outputInit, "/*Initial actions / messages */" );

		#output @outputtransitionbody to @outputInit
		@outputInit = UniversalClass->jointwoarrays( \@outputtransitionbody, \@outputInit );

		#@outputInit holds all the result
		@outputInit = visitInitNodePak->ResolveDest( $thisinitnode, $myparenttype, @outputInit );
	}
}

#Here HistoryNode is different from InitNode, because it includes two parts of output
#One is @outputHistory, another is @GlobalHistoryMtype
sub visitHistoryNode
{
	my ( $thisvisitor, $thishistorynode ) = @_;
	undef(@outputHistory);

	#push(@outputHistory,"/* History pseduostate construct */");
	if ( !exists( $thishistorynode->{tran} ) or ( $thishistorynode->{tran} eq '' ) )
	{    #no transitionbodyNode
		    #resolve dest & output to @GlobalHistoryMtype
		@GlobalHistoryMtype = visitHistoryNodePak->ResolveDest( $thishistorynode, @GlobalHistoryMtype );

		#@GlobalHistoryMtype will be output to
	} elsif ( exists( $thishistorynode->{tran} ) && ( $thishistorynode->{tran} ne '' ) )
	{

		#output {tran} part to @outputtransitionbody
		my $tran = $thishistorynode->{tran};
		$tran->Accept($thisvisitor);    #transitionbodyNode needs to write to @outputHistory
		                                #have one non-empty transitionbodyNode
		push( @outputHistory, "/* History initial actions/messages */" );

		#output @outputtransitionbody to @outputHistory
		@outputHistory = UniversalClass->jointwoarrays( \@outputtransitionbody, \@outputHistory );

		#@GlobalHistoryMtype holds the mtype of this HistoryNode
		@GlobalHistoryMtype = visitHistoryNodePak->ResolveDest( $thishistorynode, @GlobalHistoryMtype );
	}
}

sub visitTransNode
{
	my ( $thisvisitor, $thistransnode ) = @_;
	undef(@outputTrans);
	if ( $thistransnode->{tran} ne '' )
	{    #it has a non-empty transitionbody
		my $tran = $thistransnode->{tran};
		$tran->Accept($thisvisitor);

		#get result from @outputtransitionbody to @outputTrans
		@outputTrans = UniversalClass->jointwoarrays( \@outputtransitionbody, \@outputTrans );
	} else
	{    #it has an empty transitionbody
		    #output something to @outputTrans here, e.g. ":: 1 -> t?free;  goto close"
		my $dest = $thistransnode->{dest};
		push( @outputTrans, "        :: atomic{1 -> goto $dest; skip;}" );
	}
}

#semantics description:
#Events: the only legal 'events' are ENTRY, EXIT and DO
#no event variable
#Guards: no
#Actions: allowed
#Messages: allowed
sub visitActionNode
{
	my ( $thisvisitor, $thisactionnode ) = @_;
	undef(@outputAction);
	if ( exists( $thisactionnode->{tran} ) )
	{
		if ( $thisactionnode->{tran} ne '' )
		{

			#have one non-empty transitionbody
			my $transitionbody = $thisactionnode->{tran};
			$transitionbody->Accept($thisvisitor);

			#output @outputtransitionbody to @outputAction
			@outputAction = UniversalClass->jointwoarrays( \@outputtransitionbody, \@outputAction );
		}
	}
}

#SK 041503 Added to handle time invariant
#semantics description:
#Events: the only legal 'events' are ENTRY, EXIT and DO
#no event variable
#Guards: no
#Actions: allowed
#Messages: allowed
sub visittimeinvariantNode
{
	my ( $thisvisitor, $thistimeinvariantnode ) = @_;
	undef(@outputAction);

	#if(exists($thistimeinvariantnode->{timeinvariant}))
	#{
	#if ($thisactionnode->{tran} ne '')
	#{
	#have one non-empty transitionbody
	#my $transitionbody=$thistimeinvariantnode->{tran};
	#$transitionbody->Accept($thisvisitor);
	#output @outputtransitionbody to @outputAction
	$statetimeinvariant = $thistimeinvariantnode->{timeinvar};

	#print("sti:$statetimeinvariant\n");
	my $timeinvariantlength = length($statetimeinvariant);
	$statetimeinvariant = substr( $statetimeinvariant, 1, $timeinvariantlength - 2 );

	#print("sti2:$statetimeinvariant\n");
	#}
	#}
}

#SK 041503 End add
sub visitInstVarNode
{
	my ( $thisvisitor, $thisinstvarnode ) = @_;

	#output to @GlobaloutputInstVarBody and @outputInstVar
	#output {vtype}, {var} to @GlobaloutputInstVarBody
	#SK 041303 Added GlobalTimerInstVarOutput to capture timers
	@GlobaloutputInstVarBody = visitInstVarNodePak->GlobaloutputInstVarBody( $thisinstvarnode,  \@GlobalTimerInstVarOutput,
																		  \@GlobalTimerList, @GlobaloutputInstVarBody );

	#SK end change/add
	#output non-zero {initval} to @outputInstVar
	if ( exists( $thisinstvarnode->{initval} ) )
	{
		if ( $thisinstvarnode->{initval} ne 0 )
		{
			@outputInstVar = visitInstVarNodePak->outputInstVar( $thisinstvarnode, @outputInstVar );
		}
	}
}

#InitNode & HistoryNode cannot have either event or guard
sub visiteventNode
{
	my ( $thisvisitor, $thiseventnode ) = @_;
	undef(@outputTrans);
	my $event                 = $thiseventnode;
	my $thetransitionbodynode = $thiseventnode->{parent};
	my $eventtype             = $thiseventnode->{eventtype};
	if ( $thetransitionbodynode->{parent}->{object} eq 'ActionNode' )
	{    #output to @outputAction
		if ( ( $event->{eventname} ne 'entry' ) && ( $event ne 'exit' ) )
		{    #Bad event name
			    #warn "Warning: In ActionNode bad event name $event!"
		} elsif ( $event->{eventname} eq 'entry' )
		{       #entry actions
			    #Actions are atomic
		} elsif ( $event->{eventname} eq 'exit' )
		{       #exit actions
			    #Actions are atomic
		}
	} elsif ( $thetransitionbodynode->{parent}->{object} eq 'TransNode' )
	{           #output to @outputState, now I change it into @outputTrans
		    #1st, ready            ===>  :: _SYSTEMCLASS__q?ready -> t?free;
		    #2nd, carspeed(setspd) ===>  :: atomic{Control_q?carspeed ->Control_carspeed_p1?Control_V.setspd} -> t?free;
		if ( $eventtype eq 'normal' )    #non-when event
		{

			#add $eventname to @mtypelist
			@mtypelist = visiteventNodePak->addTomtypelist( $thiseventnode->{eventname}, @mtypelist );
			if ( $thiseventnode->{eventvar} eq '' )
			{                            #so only $eventname
				@outputTrans = visiteventNodePak->OnePartEventOutput( $thiseventnode, @outputTrans );
			} else
			{                            #$eventname($eventvar)
				@outputTrans = visiteventNodePak->TwoPartEventOutput( $thiseventnode, @outputTrans );
			}
		} elsif ( $eventtype eq 'when' )    #when-event
		{                                   #This part is target language dependent. Here I call ExprYaccForPromela.pm
			my $whenvar = $thiseventnode->{whenvar};
			ExprYaccForPromelaPak->PassRef($thiseventnode);
			my $returnvalue = ExprYaccForPromela->Parse("when($whenvar)");
			push( @outputTrans, "        :: atomic{$returnvalue -> " );
		}
	}
}

sub visitmessagesNode
{
	my ( $thisvisitor, $thismessagesnode ) = @_;
	undef(@outputmessages);
	if ( exists( $thismessagesnode->{child} ) )
	{
		if ( $thismessagesnode->{child} ne '' )
		{
			my $thischild = $thismessagesnode->{child};
			my $ent;
			foreach $ent (@$thischild)
			{

				#access each child node
				$ent->Accept($thisvisitor);

				#output @outputmessage to @outputmessages
				@outputmessages = UniversalClass->jointwoarrays( \@outputmessage, \@outputmessages );
			}
		}
	}
}

sub visitmessageNode
{
	my ( $thisvisitor, $thismessagenode ) = @_;
	undef(@outputmessage);
	if ( ( $thismessagenode->{msgclassname} ne '' ) && ( $thismessagenode->{msgsignalname} ne '' ) )
	{

		#global check semantics see if this class exists
		#visitmessageNodePak->CheckGlobalClassSemantics($thismessagenode);
		#if the class exists, if the class has this signal
		#visitmessageNodePak->CheckGlobalSignalSemantics($thismessagenode);
		my $msgclassname  = $thismessagenode->{msgclassname};
		my $msgsignalname = $thismessagenode->{msgsignalname};

		#add $msgsignalname to @mtypelist, it is a global signal name
		@mtypelist = visitmessageNodePak->addTomtypelist( $msgsignalname, @mtypelist );
		if ( $thismessagenode->{msgintvarname} ne '' )
		{    #ID '.' ID '(' numid ')'
			    #local check semantics to see if the local class has this InstVar
			my $msgintvarname = $thismessagenode->{msgintvarname};

			#my $returnvalue=visitmessageNodePak->CheckLocalInstVarSemantics($thismessagenode);
			my $classref = UniversalClass->SearchUpForDest( $thismessagenode, "ClassNode" );

			#output to @outputmessage
			@outputmessage = visitmessageNodePak->outputThreePartmessage(          $msgclassname, $msgsignalname, $msgintvarname,
																		  $classref,     @outputmessage );
		} else
		{       #ID '.' ID
			    #output to @outputmessage
			@outputmessage = visitmessageNodePak->outputTwoPartmessage( $msgclassname, $msgsignalname, @outputmessage );
		}
	} elsif ( $thismessagenode->{msgsignalname} ne '' )
	{           #ID
		        #local check semantics to see if the local class has this InstVar
		        #output to @outputmessage
		        #StateSend semantics
		my $msgsignalname = $thismessagenode->{msgsignalname};
		@outputmessage = visitmessageNodePak->outputOnePartmessage( $msgsignalname, @outputmessage );
	}
}

sub visittranactionNode
{
	my ( $thisvisitor, $thetranactionnode ) = @_;
	undef(@outputtranaction);
	if ( $thetranactionnode->{actiontype} eq 'newaction' )
	{           #NEW(ID)
		        #Output to @outputtranaction
		@outputtranaction = visittranactionNodePak->outputNewAction( $thetranactionnode, @outputtranaction );
	} elsif ( $thetranactionnode->{actiontype} eq 'sendmsg' )
	{           #SEND(message)
		my $content = $thetranactionnode->{message};
		$content->Accept($thisvisitor);

		#Output @outputmessage to @outputtranaction
		@outputtranaction = UniversalClass->jointwoarrays( \@outputmessage, \@outputtranaction );
	} elsif ( $thetranactionnode->{actiontype} eq 'assignstmt' )
	{           #ID ASSIGNOP EXPRESSION
		        #This part is target language dependent. Here I call ExprYaccForPromela.pm
		@outputtranaction = visittranactionNodePak->outputAssignment( $thetranactionnode, @outputtranaction );
	} elsif ( $thetranactionnode->{actiontype} eq 'printstmt' )
	{           #there are two situations: #PRINT(PRINTEXPRESSION) #PRINT(PRINTEXPRESSION,parmlist)
		        #This part is target language dependent. Here I call ExprYaccForPromela.pm
		@outputtranaction = visittranactionNodePak->outputPrintstmt( $thetranactionnode, @outputtranaction );
	} elsif ( $thetranactionnode->{actiontype} eq 'function' )
	{           #This part is target language dependent. Here I call ExprYaccForPromela.pm
		@outputtranaction = visittranactionNodePak->outputFunction( $thetranactionnode, @outputtranaction );
	}

	#else
	#{warn "\nBad tranactionnode type $thetranactionnode->{actiontype}!\n"}
}

sub visittranactionsNode
{
	my ( $thisvisitor, $thetranactionsnode ) = @_;
	undef(@outputtranactions);
	if ( exists( $thetranactionsnode->{child} ) )
	{
		if ( $thetranactionsnode->{child} ne '' )
		{
			my $thischild = $thetranactionsnode->{child};
			my $ent;
			foreach $ent (@$thischild)
			{

				#access each child node
				$ent->Accept($thisvisitor);

				#output @outputtranaction to @outputtranactions
				@outputtranactions = UniversalClass->jointwoarrays( \@outputtranaction, \@outputtranactions );
			}
		}
	}
}

#SK 041403 Added this function that is used to return the timer list to InsTvar so that it can distinguish InstVars from Timers
sub GetGlobalTimerList
{
	return @GlobalTimerList;
}

#SK 041403 end add
sub visittransitionbodyNode
{
	my ( $thisvisitor, $thetransitionbodynode ) = @_;
	undef(@outputtransitionbody);

	#event
	if ( $thetransitionbodynode->{event} ne '' )
	{
		my $event = $thetransitionbodynode->{event};
		$event->Accept($thisvisitor);
	}

	#guard
	if ( $thetransitionbodynode->{guard} ne '' )
	{

		#my $guard=$thetransitionbodynode->{guard};
	}

	#actions
	if ( $thetransitionbodynode->{actions} ne '' )
	{
		my $actions = $thetransitionbodynode->{actions};
		$actions->Accept($thisvisitor);

		#output @outputtranactions to @outputtransitionbody
		@outputtransitionbody = UniversalClass->jointwoarrays( \@outputtranactions, \@outputtransitionbody );
	}

	#messages
	if ( $thetransitionbodynode->{messages} ne '' )
	{
		my $messages = $thetransitionbodynode->{messages};
		$messages->Accept($thisvisitor);

		#output @outputmessages to @outputtransitionbody
		@outputtransitionbody = UniversalClass->jointwoarrays( \@outputmessages, \@outputtransitionbody );
	}
}
1;
