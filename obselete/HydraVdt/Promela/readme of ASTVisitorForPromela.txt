#This file includes description of some class variables inside ASTVisitorForPromela.pm.

#*************
#This class includes the general subroutines I used a lot in this visitor, and other Pak files.
#e.g., jointwoarrays, SearchUpForDest, etc.
#*************
use UniversalClass;
use LTLYacc;  #reused from SPIN/LTLYacc.pm
#*************
#ExprYaccForPromela.pm: This class is used to process the guard expressions, action expressions, etc.
#ExprYaccForPromelaPak.pm: This class is the Pak file of ExprYaccForPromela.pm. It includes several functions needed in ExprYaccForPromela.pm.
#*************
use ExprYaccForPromela;
use ExprYaccForPromelaPak;
#*************
#Here are the Pak files for visit<..>Node subroutines in this class.
#Not all the visit<..>Node subroutines have a Pak file.
#If there are a lot of functions needed when I visit a kind of Node, 
#\I create a Pak file for this Node to make this class simpler.
#*************
use visitmodelbodyNodePak;
use visitclassbodyNodePak;
use visitcstatebodyNodePak;
use visitInitNodePak;
use visitActionNodePak;
use visitmessageNodePak;
use visittranactionNodePak;
use visitInstVarNodePak;
use visitSignalNodePak;
use visitStateNodePak;
use visitstatebodyNodePak;
#use visitTransNodePak;
use visiteventNodePak;
#*************
#It is a ref to the output file. I get the name of this file from hydra file. 
#You can see sub PassOutputFileName() in this class for this purpose.
#*************
my $modelnum1outputfile;

#*************
#Here are the arrays holding the result when I visit some nodes.
#They are the key points of this class.
#*************
#@mtypelist (GLOBAL) : to hold the mtype of model-level without any format. So when I output it, I will add format.
#visitmodelbodyNodePak->mtypelistOutput($modelnum1outputfile,@mtypelist);
#*************
#@outputInit (LOCAL) : to hold the output of Initial stmt (can only have one, if none, there should be warning) in either 
#classbodyNode or cstatebodyNode.
#*************
#@outputAction (LOCAL) : to temporarily hold the output of one Action stmt in either 
#statebodyNode, cstatebodyNode or ccstatebodyNode.
#*************
#@outputActionEntry (LOCAL) : to hold the output of one Action stmt in either 
#statebodyNode, cstatebodyNode or ccstatebodyNode.
#*************
#@outputActionExit (LOCAL) : to hold the output of one Action stmt in either 
#statebodyNode, cstatebodyNode or ccstatebodyNode.
#*************
#@outputClass (LOCAL) : to hold the output of one class. Obviously it includes several parts.
#After visiting each class in visitmodelbodyNode, I will output @outputClass to @outputWholeClass.
#Also I will output @GlobaloutputInstVar to @GlobalInstVarSignal, @GlobaloutputSigal to @GlobalInstVarSignal.
#If one class includes cstates, then the proctype outputs will be included in that class, 
#\i.e, @outputClass holds the whole output of this class.
#*************
#@outputWholeClass (GLOBAL) : to hold the output of all the classes, cstates. 
#If one class includes cstates, then the proctype outputs will be included in that class, 
#\i.e, @outputClass holds the whole output of this class.
#*************
#@outputState (LOCAL) : to hold the output of ONE StateNode in a ClassNode or CStateNode or CCStateNode.
#*************
#@outputWholeState (LOCAL) : to hold the output of all StateNodes, CStateNodes, and CCStateNodes in a ClassNode 
#\or CStateNode or CCStateNode.
#*************
#@outputTrans (LOCAL) : to hold the output of one TransNode in a StateNode or CStateNode. 
#In StateNode, I will output it to @outputState.
#The meaning of TransNode in CStateNode is different from that in StateNode. So the process is also different.
#See this in sub visitcstatebodyNode() in this class.
#*************
#@outputCState (LOCAL) : to hold the output of one CStateNode in a ClassNode or CStateNode.
#*************
#@outputCCState (LOCAL) : to hold the output of one CCStateNode in a ClassNode or CStateNode.
#*************
#@outputCStateID (LOCAL) : to hold the pids of CStateNode in a ClassNode or CStateNode without format.
#So when I output it to @outputClass or @GlobaloutputCState, I will add format.
#See sub visitclassbodyNode() & sub visitcstatebodyNode().
#*************
#@outputCCStateIDint (LOCAL) : to hold the pids of CStateNodes in a CCStateNode.
#*************
#@outputCCStateIDmtype (LOCAL) : to hold the codes of CStateNodes in a CCStateNode.
#*************
my @mtypelist;
my @outputInit;
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
#****************
#@GlobaloutputInstVar (GLOBAL) : to hold the global output of all the InstVars for ONE class. e.g. typedef {}...
#It comes from @GlobaloutputInstVarBody by adding some head and end. It will be output to @GlobalInstVarSignal.
#@GlobaloutputInstVarBody (GLOBAL) : to hold the main part in @GlobaloutputInstVar.
#****************
my @GlobaloutputInstVar;
my @GlobaloutputInstVarBody;
#****************
#@outputInstVar (LOCAL): to hold the local output of one class if there is any InstVar with non-zero initial value
#****************
my @outputInstVar;
#****************
#@GlobaloutputSignal (GLOBAL) : to hold the global output of all the signals for ONE class, every class has one.
#****************
my @GlobaloutputSignal;
#****************
#@GlobalInstVarSignal (GLOBAL) : to merge @GlobaloutputInstVar and @GlobaloutputSignal, the whole modelbodyNode only has one.
#****************
my @GlobalInstVarSignal; 
#****************
#@GlobaloutputCCState (LOCAL) : to hold the new proctypes that comes from CState children of this CCState.
#****************
my @GlobaloutputCCState; 
#****************
#@GlobaloutputCState (LOCAL) : to hold the new proctype that comes from this CState.
#****************
my @GlobaloutputCState;
#****************
#@outputtransitionbody (LOCAL) : to hold the output of the transition body of four kinds of nodes: 
#\InitNode, ActionNode, TransNode, HistoryNode.
#****************
my @outputtransitionbody;
#****************
#@outputmessages (LOCAL) : to hold the output of ALL the messages in a transition body.
#@outputmessage (LOCAL) : to hold the output of ONE message in a transition body.
#****************
my @outputmessages;
my @outputmessage;
#****************
#@outputtranactions (LOCAL) : to hold the output of ALL the actions in a transition body.
#@outputtranaction (LOCAL) : to hold the output of ONE action in a transition body.
#****************
my @outputtranactions;
my @outputtranaction;
#****************
#@transeventlist (LOCAL) :  to hold how many event types of events one statebodyNode has. 
#Every entry is a hash, including two entries: {event} & {transitionlist}, 
#{transitionlist} is a ref to an array of transitions having the {event} as their event.
#****************
my @transeventlist; 
#****************
#@OutgoingTransitionlist (LOCAL) : to hold all the outgoing transitions inside ONE CStateNode. 
#Each entry is a ref to a transition.
#****************
my @OutgoingTransitionlist;

#inserted
my @WholeOutgoingTransitionlist; #to hold all the outgoing transitions of a CStateNode & all its CStateNodes children

#inserted
my @INPredicateTarget;  #to hold all the INPredicate targets of every class
			#every entry is a hash which including a ref to a classbodyNode and a list of INPredicate Targets

#inserted 
my @CStateoutputActionEntry;
my @CStateoutputActionExit;

#reused from SPIN/Context.pm
my @NEVER;
my @DEFINES;
my $driverfileID;