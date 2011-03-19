/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PVisitors;

import h2PFoundation.AcceptReturnType;
import h2PNodes.ActionNode;
import h2PNodes.ClassBodyNode;
import h2PNodes.ClassNode;
import h2PNodes.CompositeStateBodyNode;
import h2PNodes.CompositeStateNode;
import h2PNodes.ConcurrentCompositeBodyNode;
import h2PNodes.ConcurrentCompositeNode;
import h2PNodes.DriverFileNode;
import h2PNodes.EnumNode;
import h2PNodes.EventNode;
import h2PNodes.HistoryNode;
import h2PNodes.InitNode;
import h2PNodes.InstanceVariableNode;
import h2PNodes.JoinNode;
import h2PNodes.MessageNode;
import h2PNodes.MessagesNode;
import h2PNodes.ModelBodyNode;
import h2PNodes.ModelNode;
import h2PNodes.NullNode;
import h2PNodes.SignalNode;
import h2PNodes.StateBodyNode;
import h2PNodes.StateNode;
import h2PNodes.TimeInvariantNode;
import h2PNodes.TransitionActionNode;
import h2PNodes.TransitionActionsNode;
import h2PNodes.TransitionBodyNode;
import h2PNodes.TransitionNode;
import h2PNodes.aNode;
import h2PVisitors.Parser.genericLex1;

import java.util.Iterator;
import java.util.Vector;

/**
 * Visitor class to generate the Promela code for each node in the HIL parse
 * tree.
 */
public class Hil2PromelaVisitor extends aVisitor {
	protected String stateTimeInvariant = "";

	protected int LEFTMARGIN = 10;

	protected Vector<Integer> tabVec = new Vector<Integer>();

	protected String mbnhSTR = "";

	protected int mbnhLASTLVL = 0;

	protected AcceptReturnType globalOutputs;

	protected PromelaStateVisitor psv;

	protected PromelaInPredicateVisitor pinpv;

	protected genericLex1 genLex;

	protected boolean pedantic;

	protected boolean printTransitionEntry;

	protected boolean simpleTransitionPrint;

	// TODO don't forget to implement SetNever!
	public Hil2PromelaVisitor() {
		super();
		callVisitNodeAlways = false; /* disable general node visitation function */
		globalOutputs = new AcceptReturnType();
		pinpv = new PromelaInPredicateVisitor(globalOutputs);
		psv = new PromelaStateVisitor(globalOutputs);
		genLex = new genericLex1();

		pedantic = true;
		printTransitionEntry = true;
		simpleTransitionPrint = false;

		int i, increment = 3;
		tabVec.addElement(new Integer(0));
		tabVec.addElement(new Integer(LEFTMARGIN));
		i = LEFTMARGIN + increment;
		while (i < 72) {
			tabVec.addElement(new Integer(i));
			i += increment;
		}
	}

	protected int tabFunc(int level) {
		if (level >= tabVec.size()) {
			return LEFTMARGIN;
		}
		return ((Integer) tabVec.get(level)).intValue();
	}

	protected void addToEnumList(EnumNode enumNode) {
		globalOutputs.addGen("EnumList", enumNode);
	}

	protected void addToMTypeList(String newType) {
		newType = newType.replace(".", "__");
		if (!globalOutputs.ifInArray("mTypeList", newType)) {
			globalOutputs.addStr("mTypeList", newType);
		}
	}

	protected void printTestART(AcceptReturnType theART) {
		print(theART.getAllInfo());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitNode(h2PNodes.aNode)
	 */
	public AcceptReturnType visitNode(aNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitActionNode(h2PNodes.ActionNode)
	 */
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasTransitionBodyNode()) {
			tmpART.merge(tNode.subnode.accept(this)); // go to transition body
														// node's accept
			tmpART.moveStrKey("transitions", "Action");
		}
		return tmpART; // outputs to @outputAction
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitClassNode(h2PNodes.ClassNode)
	 */
	public AcceptReturnType visitClassNode(ClassNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasClassBodyNode()) {
			tmpART.merge(tNode.subnode.accept(this)); // called by modelbody
														// node.
		}

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * h2PVisitors.aVisitor#visitCompositeStateNode(h2PNodes.CompositeStateNode)
	 */
	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		int i;
		for (i = 0; i < tNode.children.size(); i++) {
			aNode aChild = (aNode) tNode.children.get(i);
			if (aChild.getType().equals("CompositeStateBodyNode")) {
				CompositeStateBodyNode csbn = (CompositeStateBodyNode) aChild;
				// from: @GlobaloutputSignal =
				// visitcstatebodyNodePak->GlobalSignalHeadOutput( $ent,
				// @GlobaloutputSignal
				// );

				tmpStr += strln("chan " + csbn.getParent().getID()
						+ "_C=[0] of {bit};");
				tmpStr += strln("chan " + csbn.getParent().getID()
						+ "_start=[0] of {bit};");
				tmpART.addStrln("Signal", tmpStr); // had wrong name!
				tmpART.merge(csbn.accept(this));
			}
		}

		return tmpART; // outputs to @GlobaloutputSignal
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeNode(h2PNodes.
	 * ConcurrentCompositeNode)
	 */
	public AcceptReturnType visitConcurrentCompositeNode(
			ConcurrentCompositeNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		tmpART.merge(tNode.acceptChildren(this));

		return tmpART; // seems to output to @GlobaloutputCCState
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitDriverFileNode(h2PNodes.DriverFileNode)
	 */
	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		tmpART.mergeDefV(tNode.getID());

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitEnumNode(h2PNodes.EnumNode)
	 */
	public AcceptReturnType visitEnumNode(EnumNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		addToEnumList(tNode);

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitEventNode(h2PNodes.EventNode)
	 */
	public AcceptReturnType visitEventNode(EventNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		// Do sanity check on the event
		pinpv.ExpressionParser.Parse_Me(tNode, tNode.getDescription());

		String grandpaType = tNode.getParent().getParent().getType();
		if (grandpaType.equals("ActionNode")) {
			tmpART.addStrln("Action", tmpStr);
		} // if (grandpaType.equals("ActionNode"))
		if (grandpaType.equals("TransitionNode")) {
			if (tNode.getEventType().equals("normal")) {

				String classRefID = searchUpForDest(tNode, "ClassNode").getID();

				String tmpStateTimeInvariant = stateTimeInvariant;
				/*
				 * --> my $statetimeinvariant=ASTVisitorForPromela->
				 * GetstatetimeinvariantAndUndef();
				 */
				if (tmpStateTimeInvariant.length() > 0) {
					// push(@outputState," :: atomic{Timer_V.$statetimeinvariant && $temp1?$eventname ->");
					tmpStr += strln("        :: atomic{" + classRefID + "_q?"
							+ tNode.getName() + " -> Timer_V."
							+ tmpStateTimeInvariant + " -> ");
				} else {
					// push(@outputState," :: atomic{$temp1?$eventname ->");
					// one part has a trailing space, two part does not!
					tmpStr += strln("        :: atomic{" + classRefID + "_q?"
							+ classRefID + "__sig__" + tNode.getName() + " -> ");
				}

				// Determine whether an argument is being passed with this
				// signal
				if (tNode.getVariable().length() > 0) {
					tmpStr += strln("                   " + classRefID + "_"
							+ tNode.getName() + "_p1?" + classRefID + "_V."
							+ tNode.getVariable());
					tmpStr += strln("                   -> ");
					/*
					 * perl @outputTrans =
					 * visiteventNodePak->TwoPartEventOutput( $thiseventnode,
					 * @outputTrans );
					 */
				}
			} // if (tNode.getEventType().equals("normal"))
			if (tNode.getEventType().equals("when")) {
				String retVal = pinpv.ExpressionParser.Parse_Me(tNode, "when("
						+ tNode.getWhenVariable() + ")");
				tmpStr += strln("        :: atomic{" + retVal + " -> ");
			} // if (tNode.getEventType().equals("when"))
			tmpART.addStrln("Trans", tmpStr);
		} // if (grandpaType.equals("TransitionNode"))

		return tmpART; // output to @outputTrans
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitHistoryNode(h2PNodes.HistoryNode)
	 */
	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		if (tNode.hasTBNChild()) {
			tmpART.addStrln("History",
					strln("/* History initial actions/messages * /"));
			tmpART.merge(tNode.tbnChild.accept(this));
			tmpART.moveStrKey("transitions", "History");
		}

		// ResolveDest:
		aNode tCBN = searchUpForDest(tNode, "CompositeStateBodyNode");

		for (int i = 0; i < tCBN.children.size(); i++) {
			aNode entity = (aNode) tCBN.children.get(i);
			if (tNode.getID().equals(entity.getID())) {
				if (entity.getType().equals("StateNode")) {
					// push(@GlobalHistoryMtype,"mtype H_$cstateID=st_$entID;");
					tmpStr += strln("mtype H_" + tCBN.getParent().getID()
							+ "=st_" + entity.getID() + ";");
				}
				if ((entity.getType().equals("CompositeStateNode"))
						|| (entity.getType().equals("ConcurrentCompositeNode"))) {
					// push(@GlobalHistoryMtype,"mtype H_$cstateID=to_$entID;");
					tmpStr += strln("mtype H_" + tCBN.getParent().getID()
							+ "=to_" + entity.getID() + ";");
				}
			}
		}
		tmpART.addStrln("globalHistory", tmpStr);

		return tmpART;
		// returns var outputHistory. (from tbn accept)
		// also returns GlobalHistoryMtype (from ResolveDest)
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitInitNode(h2PNodes.InitNode)
	 */
	public AcceptReturnType visitInitNode(InitNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		if (tNode.getParent().getType().equals("CompositeStateBodyNode")) {
			tmpART.addStr("Init", "startCState: atomic{");
		}
		tmpART.addStrln("Init", strln("/*Init state*/"));

		if (tNode.hasTransitionBodyNode()) {
			tmpART.addStrln("Init", strln("/*Initial actions / messages */"));
			tmpART.merge(tNode.subnode.accept(this));
			tmpART.moveStrKey("transitions", "Init");
			/*
			 * Array join order is as follows: outputInit +=
			 * "/ Initial actions.../" then UniversalClass->jointwoarrays
			 * effectively appends the output from the TransitionBodyNode
			 * *after* the live above.
			 */
		}

		aNode aParent = tNode.getParent();
		for (int i = 0; i < aParent.children.size(); i++) {
			aNode entity = (aNode) aParent.children.get(i);
			if (entity.getID().equals(tNode.getID())) {
				if (entity.getType().equals("CompositeStateNode")) {
					tmpART.addStr("Init", "        goto to_" + tNode.getID()
							+ "; skip;};");
					i = aParent.children.size(); // break out of for loop
				}
				if (entity.getType().equals("ConcurrentCompositeStateNode")) {
					tmpART.addStr("Init", "        goto to_" + tNode.getID()
							+ "; skip;};");
					i = aParent.children.size(); // break out of for loop
				}
				if (entity.getType().equals("StateNode")) {
					tmpART.addStr("Init", "        goto  " + tNode.getID()
							+ "; skip;};");
					i = aParent.children.size(); // break out of for loop
				}
			}
		}
		return tmpART; // outputs to @outputInit
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * h2PVisitors.aVisitor#visitInstanceVariableNode(h2PNodes.InstanceVariableNode
	 * )
	 */
	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		if (!(tNode.getVType().equals("timer"))) {
			String correctedType = "int";
			if (tNode.getVType().equals("bool")) {
				correctedType = "bool";
			}
			tmpART.addStrln("InstVarBody", strln("        " + correctedType
					+ " " + tNode.getVar() + ";"));
		} else {
			tmpART.addStrln("InstVarOutput",
					strln("       short " + tNode.getVar() + "=-1;"));
			tmpART.addStrln("TimerList", strln(tNode.getVar()));
			globalOutputs.addStrln("TimerList", strln(tNode.getVar())); // needed
																		// by
																		// the
																		// UML
																		// expression
																		// parser
		}

		if ((tNode.getInitValue().length() > 0)) {
			aNode instanceVariableReference = FindLocalDestNode(tNode,
					"InstanceVariableNode", "var", tNode.getVar());

			String className = instanceVariableReference.getParent()
					.getParent().getID();
			String tmpStr = strln("        " + className + "_V."
					+ tNode.getVar() + " = " + tNode.getInitValue() + ";");
			tmpART.addStrln("InstVar", tmpStr);
		}
		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitJoinNode(h2PNodes.JoinNode)
	 */
	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		AcceptReturnType tmpART = super.visitJoinNode(tNode);
		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitMessageNode(h2PNodes.MessageNode)
	 */
	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		if (tNode.getSignalName().length() > 0) {
			// Check semantics to see if the local class has this InstVar
			aNode destCN = searchUpForDest(tNode, "ClassNode");
			Boolean intVarIsLocal; // Whether the argument is an mtype or an
									// instance variable
			String className = tNode.getClassName();
			if (className == "") {
				className = destCN.getID();
				intVarIsLocal = true;
			} else {
				intVarIsLocal = false;
			}

			if (className.length() > 0) {
				if (tNode.getIntVarName().length() > 0) {
					// With signal argument
					String intVarName = pinpv.ExpressionParser.Parse_Me(tNode,
							tNode.getIntVarName());
					String temp1, temp2;

					temp1 = " " + className + "_" + tNode.getSignalName()
							+ "_p1!";
					temp2 = intVarName + "; " + className + "_q!"
							+ className + "__sig__" + tNode.getSignalName() +
							";";

					// Determine whether $msgintvarname is an ID (the first
					// character is [A-Z][a-z]) or a NUM (all characters are
					// [0-9]+).
					char testAt = tNode.getIntVarName().toUpperCase().charAt(0);
					if ((testAt >= '0') && (testAt <= '9') || (testAt == '-')) {
						// IntVarName is a number
						tmpStr += strln(temp1 + temp2);
					} else {
						// IntVarName is an ID
						if (intVarIsLocal) {
							tmpStr += strln("atomic{" + temp1 + temp2 + "};");
						} else {
							tmpStr += strln("atomic{" + temp1 + destCN.getID()
									+ "_V." + temp2 + "};");
						}
					}
				} else {
					// No signal argument
					tmpStr += strln("        " + className + "_q!"
							+ className + "__sig__" + tNode.getSignalName() +
							";");
				}
			} else {
				tmpStr += strln("        run event(" + tNode.getSignalName()
						+ ");");

			}
		}

		tmpART.addStrln("default", tmpStr);
		return tmpART; // outputs to @outputmessage
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitMessagesNode(h2PNodes.MessagesNode)
	 */
	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		tmpART.merge(tNode.acceptChildren(this));

		return tmpART; // merges all @outputmessage into one @outputmessages
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitModelNode(h2PNodes.ModelNode)
	 */
	public AcceptReturnType visitModelNode(ModelNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		if (tNode.hasModelBodyNode()) {
			tmpART.merge(tNode.subnode.accept(this));
		}
		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitNullNode(h2PNodes.NullNode)
	 */
	public AcceptReturnType visitNullNode(NullNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitSignalNode(h2PNodes.SignalNode)
	 */
	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		addToMTypeList(tNode.getClassName() + "__sig__" + tNode.getName());

		if (tNode.getSignalType().length() > 0) {
			String className = tNode.getParent().getParent().getID();
			tmpART.addStr("Signal", "chan " + className + "_" + tNode.getName()
					+ "_p1=[5] of {" + tNode.getSignalType() + "};");
		}

		return tmpART; // output to @GlobaloutputSignal
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitStateNode(h2PNodes.StateNode)
	 */
	public AcceptReturnType visitStateNode(StateNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		if (tNode.bodyNode != null) {
			tmpART.merge(tNode.bodyNode.accept(this));
		}

		if (tNode.children.size() == 0) { // has no children
			tmpStr += strln("        }");
			tmpStr += strln("        if");
			tmpStr += strln("        :: skip -> false");
			tmpStr += strln("        fi;");
			tmpART.addStrln("State", tmpStr);
		}
		return tmpART; // output to @outputState
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * h2PVisitors.aVisitor#visitTransitionActionNode(h2PNodes.TransitionActionNode
	 * )
	 */
	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		String actType = tNode.getActionType();
		if (actType.equals("newaction")) {
			// Check action semantics
			pinpv.ExpressionParser.Parse_Me(tNode, tNode.getContent());
			tmpStr += strln("        run " + tNode.getContent() + "();");
		}
		if (actType.equals("sendmsg")) {
			if (tNode.hasMessageChild()) {
				tmpART.merge(tNode.messageChild.accept(this));
			}
		}
		if (actType.equals("assignstmt")) {
			// T ODO from visittranactionNodePak->outputAssignment
			String retVal = pinpv.ExpressionParser.Parse_Me(tNode,
					tNode.getAssignment());
			tmpStr += strln("        " + retVal);
		}
		if (actType.equals("printstmt")) {
			String dPrintContent = tNode.getPrintContent();
			dPrintContent = "\""
					+ dPrintContent.substring(1, dPrintContent.length() - 1)
					+ "\"";
			String retVal = "";
			if (tNode.getParamList().length() > 0) {
				retVal = ","
						+ pinpv.ExpressionParser.Parse_Me(tNode,
								tNode.getParamList());
			}
			tmpStr += strln("        printf(" + dPrintContent + retVal + ");");
		}
		if (actType.equals("function")) {
			String retVal = "";
			retVal = pinpv.ExpressionParser.Parse_Me(tNode,
					tNode.getFunctionID() +
						"(" + tNode.getParamList() + ")");
			tmpStr += strln("        " + retVal);
		}

		tmpART.addStrln("default", tmpStr);
		return tmpART; // output to @outputtranaction
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitTransitionActionsNode(h2PNodes.
	 * TransitionActionsNode)
	 */
	public AcceptReturnType visitTransitionActionsNode(
			TransitionActionsNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		tmpART.merge(tNode.acceptChildren(this));

		return tmpART; // output to @outputtranactions from a concatenation of
						// @outputtranaction
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitTransitionNode(h2PNodes.TransitionNode)
	 */
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		if (tNode.hasBody()) {
			tmpART.merge(tNode.bodyChild.accept(this));
			tmpART.moveStrKey("transitions", "Trans");
		} else {
			// empty transition body
			tmpART.addStrln("Trans", strln("        :: atomic{1 -> goto "
					+ tNode.getDestination() + "; skip;}"));
		}

		return tmpART; // output to @outputTrans (merges @outputtransitionbody)
	}

	public AcceptReturnType cbnhOutputClassHead(ClassBodyNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();

		String classname = tNode.getParent().getID();
		tmpART.addStr("Class", "");
		tmpART.addStr("Class", "");

		tmpART.addStr("Class", "active " + "proctype " + classname + "()");
		tmpART.addStr("Class", "{");
		if (tNode.hasStateMachine()) {
			tmpART.addStr("Class", "atomic{");
			tmpART.addStr("Class", "mtype m;");
		}

		return tmpART;
	}

	public AcceptReturnType cbnhOutputClassEnd() {
		AcceptReturnType tmpART = new AcceptReturnType();

		tmpART.addStr("Class", "exit: skip");
		tmpART.addStr("Class", "}");

		return tmpART;
	}

	public AcceptReturnType cbnhGlobalSignalHeadOutput(ClassBodyNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();

		String classID = tNode.getParent().getID();
		tmpART.addStr("Signal", "chan " + classID + "_q=[5] of {mtype};");
		tmpART.addStr("Signal", "chan " + classID + "_C=[0] of {bit};");

		return tmpART;
	}

	public AcceptReturnType cbnhEmptyCStateOutput() {
		AcceptReturnType tmpART = new AcceptReturnType();

		tmpART.addStr("CState", "/* Link to composite state */");
		tmpART.addStr("CState", "to_:      _pid = run (m);");
		tmpART.addStr("CState", "        wait??eval(_pid),m;");

		return tmpART;
	}

	public AcceptReturnType cbnhCStateHeadOutput(aNode tNode,
			boolean isFromClassCall) {
		AcceptReturnType tmpART = new AcceptReturnType();

		String cstatename = tNode.getID();

		tmpART.addStr("CState", "/* Link to composite state " + cstatename
				+ " */");
		String tmpStr = "atomic{skip;";

		// Make it look like the original perl Hydra output
		String padding1 = " ";
		if ((!isFromClassCall) && pedantic) {
			padding1 = "";
		}
		tmpART.addStr("CState", "to_" + cstatename + ": " + tmpStr + " "
				+ cstatename + "_start!1;}");
		tmpART.addStr("CState", "        atomic{" + cstatename + "_C?1;"
				+ padding1 + "wait??" + cstatename + "_pid,m;}");
		tmpART.addStr("CState", "        if"); // TODO why does this NOT appear
												// in the perl promela?

		return tmpART;
	}

	public AcceptReturnType cbnhAnalyzeCStateNode(aNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();

		psv.setNodeToTest(tNode);

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode bodyChild = (aNode) tNode.children.get(i);
			for (int j = 0; j < bodyChild.children.size(); j++) {
				aNode childNode = (aNode) bodyChild.children.get(j);
				if ((childNode.getType().equals("StateNode"))
						|| (childNode.getType().equals("CompositeStateNode"))
						|| (childNode.getType()
								.equals("ConcurrentCompositeNode"))
						|| (childNode.getType().equals("TransitionNode"))) {
					childNode.accept(psv); // output is passed through the
											// outputART
				}
			}
		}

		tmpART.addStr("CState", globalOutputs.getStr("CState"));
		globalOutputs.removeStrKey("CState");

		return tmpART;
	}

	// (verify) there are only minor differences between the ClassBodyNode
	// and CompositeStateBodyNode versions of this function so I'm coding
	// it so it can handle both!
	public AcceptReturnType cbnhAnalyzeCCStateNode(
			ConcurrentCompositeNode tNode, boolean isFromClassCall) {
		AcceptReturnType tmpART = new AcceptReturnType();

		tmpART.addStr("CCState", "to_" + tNode.getID() + ":");

		// if (tNode.bodyNode == null) { return tmpART; }
		if (tNode.bodyNode != null) {
			for (int i = 0; i < tNode.bodyNode.children.size(); i++) {
				aNode childNode = (aNode) tNode.bodyNode.children.get(i);
				if (childNode.getType().equals("CompositeStateNode")) {
					CompositeStateNode csNode = (CompositeStateNode) childNode;
					if (csNode.bodyNode != null) {
						/*
						 * TODO (source of CCSB bugs?) the CState version of the
						 * code calls UniversalClass->jointwostrings which is
						 * NOT defined in universal Class!
						 */
						tmpART.addStr("CCState", "to_" + csNode.getID() + ":");

						String temp20 = csNode.getID() + "_pid";
						String temp30 = csNode.getID() + "_C!1";
						String temp40 = csNode.getID() + "_C?1";
						if (isFromClassCall) {
							tmpART.addStr("CCStateTemp1", "\t" + csNode.getID()
									+ "_start!1;");
						} else {
							tmpART.addStr("CCStateTemp1", "        " + temp20
									+ " = run " + csNode.getID() + "(none);");
						}
						tmpART.addStr("CCStateID", temp20);

						temp30 = csNode.getID() + "_code";
						if (isFromClassCall) {
							tmpART.addStr("CCStateTemp2", "        atomic{"
									+ temp40 + ";wait??" + temp20 + ","
									+ temp30 + ";}");
						} else {
							tmpART.addStr("CCStateTemp2", "        wait??"
									+ temp20 + "," + temp30 + ";}");
						}
						tmpART.addStr("CCStateIDmtype", temp30);

					} else {
						tmpART.addStr("CCState", "to_:");
						tmpART.addStr("CCStateTemp1",
								"        _pid = run (none);");
						tmpART.addStr("CCStateID", "_pid");
						tmpART.addStr("CCStateTemp2",
								"        wait??eval(_pid),_code;}");
						tmpART.addStr("CCStateIDmtype", "_code");
					}
				}
				if (!globalOutputs.ifInArray("mTypeList", "none")) {
					globalOutputs.addStr("mTypeList", "none");
				}
			}
		}

		tmpART.addStr("CCState", "        atomic {");
		tmpART.moveStrKey("CCStateTemp1", "CCState");
		tmpART.addStr("CCState", "        }");

		tmpART.moveStrKey("CCStateTemp2", "CCState");

		return tmpART;
	}

	public AcceptReturnType cbnhAnalyzeJoinNode(ConcurrentCompositeNode tNode,
			String myParent) {
		AcceptReturnType tmpART = new AcceptReturnType();

		aNode myParentRef = searchUpForDest(tNode, myParent);

		for (int i = 0; i < myParentRef.children.size(); i++) {
			aNode childNode = (aNode) myParentRef.children.get(i);

			if (childNode.getType().equals("JoinNode")) {
				JoinNode jNode = (JoinNode) childNode;

				if (jNode.getFromID().equals(tNode.getID())) {
					String temp20 = "st_" + jNode.getID();

					if (tNode.bodyNode != null) {
						for (int j = 0; j < tNode.bodyNode.children.size(); j++) {
							aNode tempCNode = (aNode) tNode.bodyNode.children
									.get(j);
							if (tempCNode.getType()
									.equals("CompositeStateNode")) {
								String temp100 = "";
								CompositeStateNode tmpCSNode = (CompositeStateNode) tempCNode;
								if (tmpCSNode.bodyNode != null) {
									temp100 += tmpCSNode.getID();
								}
								temp100 += "_code";
								tmpART.addStr("tempjoin1", temp100 + " == "
										+ temp20);
							}
						}
					}

					String temp200 = "        ::";
					String temp2000 = FormatOutputSeparateType(temp200, " && ",
							tmpART.getStr("tempjoin1"));
					tmpART.removeStrKey("tempjoin1");
					tmpART.addStr("tempjoin", temp2000);

				}
			}
		}
		String tmpStr = tmpART.getStr("tempjoin");
		tmpART.removeStrKey("tempjoin");

		if (tmpStr.length() > 0) {
			tmpART.addStr("CCState", "        do");
			tmpART.addStr("CCState", tmpStr);
			tmpART.addStr("CCState", "        od;");
			tmpART.addStr("found", "true");
		} else {
			tmpART.addStr("CCState", "        assert(0);");
			tmpART.addStr("found", "false");
		}

		return tmpART;
	}

	public void cbnhStateBlock(aNode entNode, AcceptReturnType tmpART) {
		String stateID = entNode.getID();

		aNode tParent = searchUpForDest(entNode, "ClassNode");

		tmpART.addStr("WholeState", "/* State " + stateID + " */");
		tmpART.addStr("WholeState", stateID + ":    " + "atomic{skip;"
				+ " printf(\"in state " + tParent.getID() + "." + stateID
				+ "\\n\");");
		tmpART.moveStrKey("State", "WholeState");
	}

	public void cbnhRunCProctype(aNode tNode, aNode childNode,
			AcceptReturnType tmpART, boolean isFromClassCall) {
		if (childNode.children.size() > 0) {
			// Inline ADDPID
			tmpART.addStr("CStateID", childNode.getID() + "_pid");
			tmpART.merge(cbnhCStateHeadOutput(childNode, isFromClassCall));
			tmpART.merge(cbnhAnalyzeCStateNode(childNode));

			String CS_entities[] = tmpART.getStrSplit("CState");
			String temp100 = CS_entities[CS_entities.length - 1];
			String comparison = "        if";
			String recomposition = "";
			for (int i = 0; i < CS_entities.length - 1; i++) {
				recomposition += strln(CS_entities[i]);
			}
			tmpART.removeStrKey("CState");
			tmpART.addStrln("CState", recomposition);

			if (!temp100.equals(comparison)) {
				// Inline CStateEndOutput
				tmpART.addStr("CState", temp100);
				tmpART.addStr("CState", "        fi;");
			}
			if (!isFromClassCall) {
				csbhOutputTBridgeAndPID(tmpART);
			}
		} else {
			tmpART.addStr("CStateID", "_pid");
			tmpART.merge(cbnhEmptyCStateOutput());
		}

		tmpART.moveStrKey("CState", "WholeState");

	}

	public AcceptReturnType cbnhOutputCCState(ConcurrentCompositeNode ccNode,
			boolean isFromClassCall) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (ccNode.bodyNode != null) {
			tmpART.merge(cbnhAnalyzeCCStateNode(ccNode, isFromClassCall));
			tmpART.merge(cbnhAnalyzeJoinNode(ccNode, "ClassBodyNode"));

			if (!tmpART.getStr("found").equals("true")) {
				aNode classRef = searchUpForDest(ccNode, "ClassNode");
				println("Warning: In Class ["
						+ classRef.getID()
						+ "], $object ["
						+ ccNode.getID()
						+ "], join missing (these threads can never be joined.)");
			}
			tmpART.removeStrKey("found");
		}
		tmpART.moveStrKey("CCState", "WholeState");

		return tmpART;
	}

	public AcceptReturnType cbnhGetClassINPredicatelist(ClassBodyNode tNode,
			AcceptReturnType INPredicateTarget) {
		AcceptReturnType INPredicateHash, INPredicateList = new AcceptReturnType(); // default
																					// to
																					// empty
																					// list.
		Vector<?> vec = INPredicateTarget.getGen("default");
		ClassBodyNode cbRef;

		for (int i = 0; i < vec.size(); i++) {
			INPredicateHash = (AcceptReturnType) vec.get(i);
			cbRef = (ClassBodyNode) INPredicateHash.getSingle("cbreference");
			if (tNode.getUniqueID().equals(cbRef.getUniqueID())) {
				INPredicateList = (AcceptReturnType) INPredicateHash
						.getSingle("list");
				i = vec.size(); // break! There should only be one predicate
								// list per class ref.
			}
		}

		return INPredicateList;
	}

	public void cbnhAddFormatToINPredicate(AcceptReturnType INPredicateList) {
		String entities[] = INPredicateList.getStrSplit("default");
		INPredicateList.moveStrKey("default", "original-InPredicate");
		for (int i = 0; i < entities.length; i++) {
			INPredicateList.addStr("default", "        bool st_" + entities[i]
					+ ";");
		}
	}

	public void cbnhFormGlobalOutputInstVar(ClassBodyNode tNode,
			AcceptReturnType INPredicateTarget, AcceptReturnType tmpART) {

		AcceptReturnType INPredicateList = cbnhGetClassINPredicatelist(tNode,
				INPredicateTarget);

		// Modified GlobaloutputInstVarHead: (inline)
		String className = tNode.getParent().getID();
		if (!className.equals("_SYSTEMCLASS_")) {
			tmpART.addStr("InstVarGlobal", "typedef " + className + "_T {");
			tmpART.addStr("InstVarGlobal", "        bool timerwait;");
		}

		tmpART.moveStrKey("InstVarBody", "InstVarGlobal");
		cbnhAddFormatToINPredicate(INPredicateList);
		tmpART.addStr("InstVarGlobal", INPredicateList.getStr("default"));

		// Modified GlobaloutputInstVarEnd: (inline)
		if (!className.equals("_SYSTEMCLASS_")) {
			tmpART.addStr("InstVarGlobal", "        }");
			tmpART.addStr("InstVarGlobal", className + "_T " + className
					+ "_V;");
			tmpART.addStr("InstVarGlobal", "");
		}
	}

	public void cbnhProcType(ClassBodyNode tNode, AcceptReturnType currART) {
		currART.merge(cbnhOutputClassHead(tNode));
		String tmpStr = "";

		tmpStr = currART.getStr("CStateID");
		if (tmpStr.length() > 0) {
			tmpStr = FormatOutputType("int", tmpStr);
			currART.removeStrKey("CStateID");
			currART.addStr("Class", tmpStr);
		}

		tmpStr = currART.getStr("CCStateID");
		if (tmpStr.length() > 0) {
			tmpStr = FormatOutputType("int", tmpStr);
			currART.removeStrKey("CCStateID");
			currART.addStr("Class", tmpStr);

			tmpStr = currART.getStr("CCStateIDmtype");
			tmpStr = FormatOutputType("mtype", tmpStr);
			currART.removeStrKey("CCStateIDmtype");
			currART.addStr("Class", tmpStr);
		}

		currART.moveStrKey("InstVar", "Class");
		currART.moveStrKey("Init", "Class");
		currART.moveStrKey("WholeState", "Class");

		currART.merge(cbnhOutputClassEnd());

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitClassBodyNode(h2PNodes.ClassBodyNode)
	 */
	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		int countSignalNumber = 0;

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("InitNode")) {
				tmpART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("InstanceVariableNode")) {
				tmpART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("SignalNode")) {
				countSignalNumber++;
				if (countSignalNumber == 1) {
					tmpART.merge(cbnhGlobalSignalHeadOutput(tNode));
				}
				tmpART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("StateNode")) {
				tmpART.merge(childNode.accept(this));
				cbnhStateBlock(childNode, tmpART);
			}
			if (childNode.getType().equals("CompositeStateNode")) {
				cbnhRunCProctype(tNode, childNode, tmpART, true);
			}
			// Also handles JoinNode
			if (childNode.getType().equals("ConcurrentCompositeNode")) {
				tmpART.merge(cbnhOutputCCState(
						(ConcurrentCompositeNode) childNode, true));
			}
			// Commented out in original
			// if (childNode.getType().equals("HistoryNode")) {
			// tmpART.merge(childNode.accept(this));
			// }
		}

		AcceptReturnType INPredicateTarget;
		INPredicateTarget = (AcceptReturnType) globalOutputs
				.getSingle("INPredicateTarget");
		cbnhFormGlobalOutputInstVar(tNode, INPredicateTarget, tmpART);
		cbnhProcType(tNode, tmpART);

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("CompositeStateNode")
					|| childNode.getType().equals("ConcurrentCompositeNode")) {
				tmpART.merge(childNode.accept(this));
			}
		}

		return tmpART;
	}

	public void csbhStateBlock(aNode entNode, boolean ifHistory,
			AcceptReturnType tmpART) {
		String stateID = entNode.getID();

		aNode tParent = searchUpForDest(entNode, "ClassNode");

		tmpART.addStr("WholeState", "/* State " + stateID + " */");
		tmpART.addStr("WholeState", stateID
				+ ":    atomic{skip; printf(\"in state " + tParent.getID()
				+ "." + stateID + "\\n\");");

		if (ifHistory) {
			aNode cStateRef = searchUpForDest(entNode, "CompositeStateNode");
			tmpART.addStr("WholeState", "        H_" + cStateRef.getID()
					+ " = st_" + stateID + ";  /* Save state for history */");
		}

		tmpART.moveStrKey("State", "WholeState");

	}

	public void csbhPushDownToStateNode(CompositeStateBodyNode tNode,
			StateNode SNode) {
		// Children are added anyway so just create body node if needed
		if (SNode.bodyNode == null) {
			StateBodyNode newbodyNode = new StateBodyNode();
			SNode.addChild(newbodyNode);
			newbodyNode.addToRootNode();
		}

		for (int j = 0; j < tNode.transitionNodeChildren.size(); j++) {
			TransitionNode transNode = (TransitionNode) tNode.transitionNodeChildren
					.get(j);
			transNode.setDestinationType("Outgoing");
			// Automatically moves parent to former parent
			SNode.bodyNode.addChild(transNode);
			// Keep track of state transitions former CompositeStateBody parent.
			transNode.setFormerCStateParent(tNode);
		}
	}

	public void csbhPushDownToCandCCStateNode(CompositeStateBodyNode tNode,
			aNode CSNode, boolean isCStateNode) {
		aNode bodyNode = null;
		if (isCStateNode) {
			bodyNode = ((CompositeStateNode) CSNode).bodyNode;
		} else {
			// it's of type ConcurrentComposite
			bodyNode = ((ConcurrentCompositeNode) CSNode).bodyNode;
		}
		if (bodyNode != null) {
			for (int i = 0; i < bodyNode.children.size(); i++) {
				aNode childNode = (aNode) bodyNode.children.get(i);
				if ((isCStateNode) && (childNode.getType().equals("StateNode"))) {
					csbhPushDownToStateNode(tNode, (StateNode) childNode);
				}
				if (childNode.getType().equals("CompositeStateNode")) {
					csbhPushDownToCandCCStateNode(tNode, childNode, true);
				}
				if ((isCStateNode)
						&& (childNode.getType()
								.equals("ConcurrentCompositeNode"))) {
					csbhPushDownToCandCCStateNode(tNode, childNode, false);
				}
			}
		}
	}

	public void csbhPushOutgoingTransitionlist(CompositeStateBodyNode tNode) {
		if (tNode.transitionNodeChildren.size() > 0) {
			csbhPushDownToCandCCStateNode(tNode,
					(CompositeStateNode) tNode.getParent(), true);
		}
	}

	public void csbhAddTleafPID(StateNode tNode, AcceptReturnType tmpART) {
		if (tNode.bodyNode != null) {
			for (int i = 0; i < tNode.bodyNode.children.size(); i++) {
				aNode childNode = (aNode) tNode.bodyNode.children.get(i);
				if (childNode.getType().equals("TransitionNode")) {
					if (((TransitionNode) childNode).getDestinationType()
							.equals("Outgoing")) {
						// Outputs not the real former parent's ID, but the
						// composite state's former parent
						String cStateID = ((TransitionNode) childNode)
								.getFormerCStateParent().getParent().getID()
								+ "_pid";
						if (!tmpART.ifInArray("CStateID", cStateID)) {
							tmpART.addStr("CStateID", cStateID);
						}
					}
				}
			}
		}
	}

	public void csbhOutputTBridgeAndPID(AcceptReturnType anART) {
		Vector<?> vec = anART.getGen("WholeOutgoingTransitionlist");
		if (vec.size() > 0) {
			String tempStr = "";
			for (int i = 0; i < vec.size(); i++) {
				TransitionNode transNode = (TransitionNode) vec.get(i);
				String temp = "st_" + transNode.getDestination();
				String temp2 = "";
				tempStr += strln("        :: atomic{m == " + temp
						+ " -> wait!_pid," + temp + "; " + temp2
						+ "; goto exit; skip;};");
				temp = transNode.getFormerCStateParent().getParent().getID()
						+ "_pid";
				if (!anART.ifInArray("CStateID", temp)) {
					anART.addStr("CStateID", temp);
				}
			}
			String entities[] = anART.getStrSplit("CState");
			entities[entities.length - 1] = tempStr; // add to end
			anART.removeStrKey("CState");
			for (int i = 0; i < entities.length; i++) {
				anART.addStr("CState", entities[i]);
			}
			anART.addStr("CState", "        fi;");
		}
	}

	public AcceptReturnType csbhOutputClassHead(CompositeStateBodyNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();

		String classname = tNode.getParent().getID();
		tmpART.addStr("CState", "");
		tmpART.addStr("CState", "");
		tmpART.addStr("CState", "active proctype " + classname
				+ "(mtype state)");
		tmpART.addStr("CState", "{atomic{");
		tmpART.addStr("CState", "mtype m;");

		return tmpART;
	}

	public void csbhCProcType(CompositeStateBodyNode tNode,
			AcceptReturnType currART) {
		currART.merge(csbhOutputClassHead(tNode));
		String tmpStr = "";

		tmpStr = currART.getStr("CStateID");
		if (tmpStr.length() > 0) {
			tmpStr = FormatOutputType("int", tmpStr);
			currART.removeStrKey("CStateID");
			currART.addStr("CState", tmpStr);
		}

		tmpStr = currART.getStr("CCStateID");
		if (tmpStr.length() > 0) {
			tmpStr = FormatOutputType("int", tmpStr);
			currART.removeStrKey("CCStateID");
			currART.addStr("CState", tmpStr);

			tmpStr = currART.getStr("CCStateIDmtype");
			tmpStr = FormatOutputType("mtype", tmpStr);
			currART.removeStrKey("CCStateIDmtype");
			currART.addStr("CState", tmpStr);
		}

		currART.addStr("CState", "goto exit;" + "}");
		currART.moveStrKey("entry", "CState");

		String tempHistory = currART.getStr("History")
				+ currART.getStr("HistorySelect");
		currART.removeStrKey("History");
		currART.removeStrKey("HistorySelect");

		if (currART.getStr("Init").length() > 0) {
			currART.moveStrKey("Init", "CState");
		} else {
			if (tempHistory.length() > 0) {
				currART.addStr("CState", "/* History pseduostate construct */");
				currART.addStr("CState", tempHistory);
			}
		}
		currART.moveStrKey("WholeState", "CState");
		currART.addStr("CState", "exit:        " + tNode.getParent().getID()
				+ "_start?1->goto startCState;");

		currART.moveStrKey("exit", "CState");
		// outputClassEnd
		currART.addStr("CState", "}");

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitCompositeStateBodyNode(h2PNodes.
	 * CompositeStateBodyNode)
	 */
	public AcceptReturnType visitCompositeStateBodyNode(
			CompositeStateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		tmpART.merge(sbnhGetAllActions(tNode));

		if (tNode.hasHistoryNode()) {
			String tempHistory = ""; // same as HistorySelect for now.
			for (int i = 0; i < tNode.children.size(); i++) {
				aNode childNode = (aNode) tNode.children.get(i);
				if (childNode.getType().equals("InitNode")) {
					addToMTypeList("st_Init");
				}

				if (childNode.getType().equals("StateNode")
						|| childNode.getType().equals("CompositeStateNode")
						|| childNode.getType()
								.equals("ConcurrentCompositeNode")) {

					addToMTypeList("st_" + childNode.getID());
					String commonPart = "        :: H_"
							+ tNode.getParent().getID() + " == " + "st_"
							+ childNode.getID();
					if (childNode.getType().equals("StateNode")) {
						tempHistory += strln(commonPart + "  ->  goto "
								+ childNode.getID() + ";");
					} else {
						tempHistory += strln(commonPart + "  ->  goto to_"
								+ childNode.getID() + "; skip;");
					}
				}
			}
			if (tempHistory.length() != 0) {
				tempHistory = strln("        ifyu") + tempHistory
						+ strln("        fi;");
			}
			tmpART.addStrln("HistorySelect", tempHistory);
		}

		// PreserveOutgoingTransitionlist:
		for (int i = 0; i < tNode.transitionNodeChildren.size(); i++) {
			TransitionNode currTransNode = (TransitionNode) tNode.transitionNodeChildren
					.get(i);
			boolean found = false;
			Vector<?> vec = tmpART.getGen("WholeOutgoingTransitionlist");
			for (int j = 0; j < vec.size(); j++) {
				TransitionNode comparisonTransNode = (TransitionNode) vec
						.get(j);
				if (currTransNode.getDestination().equals(
						comparisonTransNode.getDestination())) {
					found = true;
					j = vec.size();
				}
			}
			if (!found) {
				tmpART.addGen("WholeOutgoingTransitionlist", currTransNode);
			}
		}
		csbhPushOutgoingTransitionlist(tNode);

		// Part 3
		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("InitNode")) {
				tmpART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("CompositeStateNode")) {
				cbnhRunCProctype(tNode, childNode, tmpART, false);
			}
			if (childNode.getType().equals("HistoryNode")) {
				tmpART.merge(childNode.accept(this));
			}
			// Also handles JoinNode
			if (childNode.getType().equals("ConcurrentCompositeNode")) {
				tmpART.merge(cbnhOutputCCState(
						(ConcurrentCompositeNode) childNode, false));
			}
			if (childNode.getType().equals("StateNode")) {
				csbhAddTleafPID((StateNode) childNode, tmpART);
				tmpART.merge(childNode.accept(this));
				csbhStateBlock(childNode, tNode.hasHistoryNode(), tmpART);
			}
		}
		csbhCProcType(tNode, tmpART);
		tmpART.moveStrKey("CState", "Class");

		// Part 5
		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("CompositeStateNode")
					|| childNode.getType().equals("ConcurrentCompositeNode")) {
				tmpART.merge(childNode.accept(this));
			}
		}

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeBodyNode(h2PNodes.
	 * ConcurrentCompositeBodyNode)
	 */
	public AcceptReturnType visitConcurrentCompositeBodyNode(
			ConcurrentCompositeBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		// Children are of CompositeStateNode apparently
		tmpART.merge(tNode.acceptChildren(this));

		return tmpART;
	}

	protected String mbnhMakeOut(int level, String txt) {
		String out, label, rest;
		int margin;
		AcceptReturnType retART;

		label = rest = "";
		retART = genLex.Parse_Me("make_out", txt);
		if (retART.getStr("error").length() == 0) {
			label = retART.getStr("label");
			rest = retART.getStr("rest");
		}

		if (label.length() > LEFTMARGIN) {
			margin = label.length() + 1;
		} else {
			margin = LEFTMARGIN;
		}
		if (label.length() > 0) {
			out = label + repeatStr(" ", margin - label.length()) + rest;
		} else {
			out = repeatStr(" ", tabFunc(level)) + txt;
		}
		return out;
	}

	protected AcceptReturnType mbnhCut(String str, int len) {
		int inq = 0;
		int p, lasti = 0;
		String ret, rest;
		AcceptReturnType tmpART = new AcceptReturnType();

		for (int i = 0; i < str.length(); i++) {
			if (str.charAt(i) == '"') {
				inq = ++inq % 2;
			}
			if (inq == 0) {
				if (str.charAt(i) == ' ') {
					if (i + 1 > len) {
						if (lasti != 0) {
							p = lasti;
						} else {
							p = i;
						}
						ret = str.substring(0, p);
						rest = str.substring(p + 1);
						tmpART.addStr("ret", ret);
						tmpART.addStr("rest", rest);
						return tmpART;
					} else {
						lasti = i;
					}
				}
			}
		}
		if (lasti != 0) {
			tmpART.addStr("ret", str.substring(0, lasti));
			tmpART.addStr("rest", str.substring(lasti + 1));
		} else {
			tmpART.addStr("ret", str);
			tmpART.addStr("rest", "");
		}
		return tmpART;
	}

	protected String mbnhPut(int level, String txt) {
		String out, x;
		String tmpStr = "";
		int level2;
		int textMargin = 99999;

		out = mbnhMakeOut(level, txt);
		if (mbnhSTR.length() > 0) {
			out += mbnhSTR;
		}
		if ((level == 0) && (mbnhLASTLVL != 0)) {
			level = mbnhLASTLVL;
		}
		level2 = level;
		if (out.length() > textMargin) {
			int marker = 0;
			while (out.charAt(marker) == ' ') {
				marker++;
			}
			out = out.substring(marker);

			while (out.length() > (textMargin - tabFunc(level2))) {
				AcceptReturnType tmpART = mbnhCut(out, textMargin
						- tabFunc(level2));
				x = tmpART.getStr("ret");
				out = tmpART.getStr("rest");
				tmpStr += strln(repeatStr(" ", tabFunc(level2)) + x);
				level2 = level + 1;
			}
			if (out.length() > 0) {
				tmpStr += strln(repeatStr(" ", tabFunc(level2)) + out);
			}
		} else {
			tmpStr += strln(out);
		}
		mbnhSTR = "";
		mbnhLASTLVL = 0;
		return tmpStr;
	}

	protected void mbnhPutNR(int level, String txt) {
		if (mbnhSTR.length() == 0) {
			mbnhLASTLVL = level;
			mbnhSTR = mbnhMakeOut(level, txt);
		} else {
			mbnhSTR += mbnhMakeOut(0, txt);
		}
	}

	protected String mbnhMacroGlobalOutput() {
		String tmpStr = "";

		tmpStr += mbnhPut(0, "#define min(x,y) (x<y->x:y)");
		tmpStr += mbnhPut(0, "#define max(x,y) (x>y->x:y)");
		return tmpStr;
	}

	protected String mbnhNeverDefinitionOutput(AcceptReturnType tmpinfo) {
		String tmpStr = "";

		String entries[] = tmpinfo.getStrSplit("DEFINES");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, entries[i]);
		}
		return tmpStr;
	}

	protected String mbnhChanGlobalOutput() {
		String tmpStr = "";

		tmpStr += mbnhPut(0, "chan evq=[10] of {mtype,int};");
		tmpStr += mbnhPut(0, "chan evt=[10] of {mtype,int};");
		tmpStr += mbnhPut(0, "chan wait=[1] of {int,mtype};");

		return tmpStr;
	}
	
	protected String enumListOutput() {
		String tmpStr = "";
		Vector<Object> enums = (Vector<Object>)globalOutputs.getGen("EnumList");
		for (Iterator<Object> it = enums.iterator(); it.hasNext(); ) {
			EnumNode node = (EnumNode)it.next();
			int enum_ndx = 1;
			for (Iterator<String> it_enum = node.getEnums().iterator(); it_enum.hasNext(); ) { 
				tmpStr += mbnhPut(0, "#define " + node.getEnumTypeName() +
						"__" + it_enum.next() + "\t" + enum_ndx);
				enum_ndx++;
			}
		}
		return tmpStr;
	}

	protected String mtypeListOutput() {
		String tmpStr = "";
		int i;
		String tempMTL[] = globalOutputs.getStrSplit("mTypeList");

		for (i = 0; i < (tempMTL.length - 1); i++) {
			tempMTL[i] = tempMTL[i] + ", ";
		}

		int idx, wholeleng, leng;
		int mod, divisor = 2;
		Vector<String> tmpout1 = new Vector<String>();
		String temp1 = "";

		mod = tempMTL.length % divisor;
		leng = (tempMTL.length - mod) / divisor;
		wholeleng = leng * divisor;
		idx = 0;
		for (i = 1; i <= wholeleng; i++) {
			temp1 += tempMTL[idx]/* + "!" */;
			idx++;
			if ((i % divisor) == 0) {
				tmpout1.addElement(temp1);
				temp1 = "";
			}
		}

		temp1 = "";
		for (; idx < tempMTL.length; idx++) {
			temp1 += tempMTL[idx];
		}
		tmpout1.addElement(temp1);

		tmpStr += mbnhPut(0, "mtype={");
		for (i = 0; i < tmpout1.size(); i++) {
			tmpStr += mbnhPut(0, "        " + (String) tmpout1.get(i));
		}
		tmpStr += mbnhPut(0, "};");

		return tmpStr;
	}

	protected String mbnhInstVarSignalOutput(AcceptReturnType tmpinfo) {
		String tmpStr = "";

		String entries[] = tmpinfo.getStrSplit("InstVarSignal");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, entries[i]);
		}

		return tmpStr;
	}

	protected String mbnhDriverFile(AcceptReturnType tmpinfo) {
		String tmpStr = "";

		String filename = tmpinfo.getStr("driverFileID");

		if (filename.length() == 0) {
			return "";
		}

		AcceptReturnType fileART = new AcceptReturnType();
		if (!fileART.readFile("file", filename)) {
			println("Error. Driver File '" + filename + "' Not found. Exiting.");
			exit();
		}
		String entries[] = fileART.getStrSplit("file");
		tmpStr += mbnhPut(0, "");
		tmpStr += mbnhPut(0, "/* User specified driver file */");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, entries[i]);
		}

		tmpStr += mbnhPut(0, "");

		return tmpStr;
	}

	protected String mbnhWholeClassOutput(AcceptReturnType tmpinfo) {
		String tmpStr = "";

		String entries[] = tmpinfo.getStrSplit("Class");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, entries[i]);
		}

		return tmpStr;
	}

	protected String mbnhTimerProcessOutput(AcceptReturnType tmpinfo) {
		String entries[] = tmpinfo.getStrSplit("TimerList");

		// Check if we have timers in the model
		// If yes, output the timer process
		if (entries == null || entries.length == 0) {
			return "";
		}
		// else

		// We add a property timer to the timer list, need to make a new array
		// and copy it over
		String[] newEntries = new String[entries.length + 1];
		System.arraycopy(entries, 0, newEntries, 0, entries.length);
		newEntries[entries.length] = "propTimer";
		// Swap entries_new and entries
		entries = newEntries;

		String tmpStr = "";
		tmpStr += mbnhPut(0, "#define UPPERBOUND 25");
		tmpStr += mbnhPut(0, "/* This is the timer process */");
		tmpStr += mbnhPut(0,
				"/* It increments timers and unlocks waiting processes */");
		tmpStr += mbnhPut(0, "active proctype Timer()");
		tmpStr += mbnhPut(0, "{");
		tmpStr += mbnhPut(0, "        do");
		tmpStr += mbnhPut(0, "        :: atomic{timeout ->");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, "                             if");
			// Added an upper bound here that will be written by DRAMA
			tmpStr += mbnhPut(0, "                             :: Timer_V."
					+ entries[i] + ">=0  && Timer_V." + entries[i]
					+ "<UPPERBOUND");
			tmpStr += mbnhPut(0, "                                -> Timer_V."
					+ entries[i] + "++;");
			tmpStr += mbnhPut(0,
					"                             :: else -> skip;");
			tmpStr += mbnhPut(0, "                             fi;");
		}

		entries = tmpinfo.getStrSplit("ProcessList");

		for (int i = 0; i < entries.length; i++) {
			if (!entries[i].equals("_SYSTEMCLASS_")) {
				tmpStr += mbnhPut(0, "                             "
						+ entries[i] + "_V.timerwait=0;");
			}
		}

		tmpStr += mbnhPut(0, "                      }");
		tmpStr += mbnhPut(0, "         od");
		tmpStr += mbnhPut(0, "}");
		tmpStr += mbnhPut(0, "");

		return tmpStr;
	}

	protected String mbnhNeverClaim(AcceptReturnType tmpinfo) {
		String tmpStr = "";

		String entries[] = tmpinfo.getStrSplit("NEVER");

		for (int i = 0; i < entries.length; i++) {
			tmpStr += mbnhPut(0, entries[i]);
		}

		return tmpStr;
	}

	protected String mbnhOutputModelBodyNode(AcceptReturnType anART) {
		String tmpStr = "";

		tmpStr += mbnhMacroGlobalOutput();
		tmpStr += mbnhNeverDefinitionOutput(anART);
		tmpStr += mbnhChanGlobalOutput();
		tmpStr += enumListOutput();
		tmpStr += mtypeListOutput();
		tmpStr += mbnhInstVarSignalOutput(anART);
		tmpStr += mbnhDriverFile(anART);
		tmpStr += mbnhWholeClassOutput(anART);
		tmpStr += mbnhTimerProcessOutput(anART);
		tmpStr += mbnhNeverClaim(anART);

		return tmpStr;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitModelBodyNode(h2PNodes.ModelBodyNode)
	 */
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		AcceptReturnType INPredicateTarget = tNode.accept(pinpv);
		globalOutputs.addSingle("INPredicateTarget", INPredicateTarget);

		String DriverFileID = "";

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("ClassNode")) {
				tmpART.addStr("ProcessList", childNode.getID());
				tmpART.merge(childNode.accept(this));
				tmpART.moveStrKey("globalHistory", "InstVarSignal");
				tmpART.moveStrKey("InstVarGlobal", "InstVarSignal");
				tmpART.moveStrKey("Signal", "InstVarSignal");
			}
			if (childNode.getType().equals("DriverFileNode")) {
				DriverFileID = childNode.accept(this).defV();
				tmpART.addStr("driverFileID", DriverFileID);
			}
			if (childNode.getType().equals("EnumNode")) {
				tmpART.merge(childNode.accept(this));
			}
		}

		String tmpStr = "";
		tmpStr += strln("typedef Timer_T {");
		// A propTimer to be able to analyze real-time properties
		tmpStr += strln("short propTimer=-1;");
		tmpStr += tmpART.getStr("InstVarOutput");
		tmpART.removeStrKey("InstVarOutput");

		tmpStr += strln("        }");
		tmpStr += strln("Timer_T Timer_V;");
		tmpStr += strln();

		tmpStr += tmpART.getStr("InstVarSignal");
		tmpART.replaceSrtKey("InstVarSignal", tmpStr); // see variable
														// references.

		String finalString = mbnhOutputModelBodyNode(tmpART);

		return AcceptReturnType.retString(finalString);
	}

	public boolean sbnhIfINPredicateTarget(StateBodyNode tNode,
			AcceptReturnType INPredicateTarget) {
		ClassBodyNode classBodyRef = (ClassBodyNode) searchUpForDest(tNode,
				"ClassBodyNode");

		Vector<?> vec = INPredicateTarget.getGen("default");
		AcceptReturnType INPredicateHash, InPredicateList;
		ClassBodyNode cbRef;

		for (int i = 0; i < vec.size(); i++) {
			INPredicateHash = (AcceptReturnType) vec.get(i);
			cbRef = (ClassBodyNode) INPredicateHash.getSingle("cbreference");
			if (classBodyRef.getUniqueID().equals(cbRef.getUniqueID())) {
				InPredicateList = (AcceptReturnType) INPredicateHash
						.getSingle("list");
				if (!InPredicateList.ifInArray("default", tNode.getParent()
						.getID())) {
					return true;
				}
			}
		}

		return false;
	}

	// State body node helper(s)
	public AcceptReturnType sbnhResolveTransDest(StateBodyNode tNode,
			String dest) {
		AcceptReturnType tmpART = new AcceptReturnType();

		aNode SorCSorCCS = null;

		// Returns the State node's CompisteState or Class node parent.
		aNode stateNodeParent = tNode.getParent().getParent().getParent();

		SorCSorCCS = psv.SearchIncluding(stateNodeParent, dest);

		tmpART.addStr("isOutgoing", "false");
		if (SorCSorCCS != null) {
			if (SorCSorCCS.getUniqueID().equals(stateNodeParent.getUniqueID())) {
				tmpART.replaceSrtKey("isOutgoing", "true");
			} else {
				tmpART.addSingle("SorCSorCCS", SorCSorCCS);
			}
		} else {
			if (stateNodeParent.getType().equals("CompositeStateNode")) {
				aNode classParent = searchUpForDest(tNode, "ClassNode");
				SorCSorCCS = psv.SearchIncluding(classParent, dest);
				if (SorCSorCCS != null) {
					tmpART.replaceSrtKey("isOutgoing", "true");
				}
			}
		}

		return tmpART;
	}

	public void sbnhFind_DestType(TransitionNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (tNode.getDestinationType().length() == 0) {
			// This TransitionNode is guaranteed to have a StateBody Node parent
			// simply because of the visitor code we're working on! (statebody)
			tmpART.merge(sbnhResolveTransDest(
					(StateBodyNode) tNode.getParent(), tNode.getDestination()));

			if (tmpART.getStr("isOutgoing").equals("true")) {
				tNode.setDestinationType("Outgoing");
			} else {
				aNode SorCSorCCS = (aNode) tmpART.getSingle("SorCSorCCS");
				if (SorCSorCCS != null) {
					if (SorCSorCCS.getType().equals("StateNode")) {
						tNode.setDestinationType("SS");
					}
					if ((SorCSorCCS.getType().equals("CompositeStateNode"))
							|| (SorCSorCCS.getType()
									.equals("ConcurrentCompositeNode"))) {
						tNode.setDestinationType("CS");
					}
				}
			}
		}
	}

	public void sbnhSearchForEventType(TransitionNode tNode, String eventType,
			AcceptReturnType transEventList) {
		AcceptReturnType TELentitity, transitionList;

		sbnhFind_DestType(tNode);
		Vector<?> vec = transEventList.getGen("default");
		for (int i = 0; i < vec.size(); i++) {
			TELentitity = (AcceptReturnType) vec.get(i);
			if (TELentitity.getStr("event").equals(eventType)) {
				transitionList = (AcceptReturnType) TELentitity
						.getSingle("transitionlist");
				transitionList.addGen("default", tNode);
				return;
			}
		}

		// Did not find eventType in transition event list, add new entry
		TELentitity = new AcceptReturnType();

		TELentitity.addStr("event", eventType);
		transitionList = new AcceptReturnType();

		transitionList.addGen("default", tNode);
		TELentitity.addSingle("transitionlist", transitionList);

		transEventList.addGen("default", TELentitity);
	}

	public void sbnhCompareEvent(TransitionNode tNode, EventNode event,
			AcceptReturnType transEventList) {
		AcceptReturnType TELentitity, transitionList;

		sbnhFind_DestType(tNode);

		Vector<?> vec = transEventList.getGen("default");
		for (int i = 0; i < vec.size(); i++) {
			TELentitity = (AcceptReturnType) vec.get(i);
			String eNodeSrc = TELentitity.getStr("event");
			if (eNodeSrc.substring(0, 2).equals("e_")) {
				EventNode evtNode = (EventNode) TELentitity.getSingle("event");
				if (event.getEventType().equals(evtNode.getEventType())) {
					boolean same = false;
					if (event.getEventType().equals("normal")) {
						same = (event.getName().equals(evtNode.getName()))
								&& (event.getVariable().equals(evtNode
										.getVariable()));
					}
					if (event.getEventType().equals("when")) {
						same = (event.getWhenVariable().equals(evtNode
								.getWhenVariable()));
					}
					if (same) {
						// They are the "same" event!
						transitionList = (AcceptReturnType) TELentitity
								.getSingle("transitionlist");
						transitionList.addGen("default", tNode);
						return;
					}
				}
			}
		}

		// Did not find eventType in transition event list, add new entry
		TELentitity = new AcceptReturnType();

		TELentitity.addStr("event", "e_" + event.getUniqueID());
		TELentitity.addSingle("event", event);
		transitionList = new AcceptReturnType();

		transitionList.addGen("default", tNode);
		TELentitity.addSingle("transitionlist", transitionList);

		transEventList.addGen("default", TELentitity);

	}

	public AcceptReturnType sbnhFormeventlist(StateBodyNode tNode) {
		AcceptReturnType transitionEventList = new AcceptReturnType();
		boolean guardbool = false;

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("TransitionNode")) {
				TransitionNode tranNode = (TransitionNode) childNode;
				if (tranNode.hasBody()) {
					if (tranNode.bodyChild.hasEventNodeChild()) {
						sbnhCompareEvent(tranNode,
								tranNode.bodyChild.eventNodeChild,
								transitionEventList);
					} else {
						// Empty event list
						sbnhSearchForEventType(tranNode, "NOEVENT",
								transitionEventList);
					}
					guardbool = tranNode.bodyChild.hasGuard();
				} else {
					// Empty transition body
					sbnhSearchForEventType(tranNode, "EMPTYTRANS",
							transitionEventList);
				}
			}
		}

		if (guardbool) {
			transitionEventList.addStr("guardbool", "true");
		} else {
			transitionEventList.addStr("guardbool", "false");
		}

		return transitionEventList;
	}

	public String sbnhGetTransitionDescriptionAction(TransitionNode transNode) {
		String descStr = transNode.getDescription() + " ";
		String puttyString = "";
		String coutString = "";

		for (int i = 0; i < descStr.length(); i++) {
			puttyString += ", ";
			coutString += "%c";
			char c = descStr.charAt(i);
			puttyString += "'";
			if (c == '\\') {
				puttyString += "\\";
			}
			if (c == '\'') {
				puttyString += "\\";
			}
			puttyString += c + "\\n\"";
		}
		coutString = '"' + coutString + '"';

		String tempStr = "printf(" + coutString + puttyString + ");";
		if (!simpleTransitionPrint) {
			tempStr = "printf (" + '"' + escapeStr(descStr) + "\\n\"" + ");";
		}

		return tempStr;
	}

	public AcceptReturnType sbnhOutput_Dest(StateBodyNode tNode,
			TransitionNode transNode, boolean hasGuard, boolean checkMTypeList) {
		String desc = "";
		String dest = "";
		String destType = "";

		if (transNode != null) {
			dest = transNode.getDestination();
			destType = transNode.getDestinationType();
			desc = sbnhGetTransitionDescriptionAction(transNode);
		}
		if (!printTransitionEntry) {
			desc = ""; // for comparison.
		}
		return sbnhOutput_Dest(tNode, desc, dest, destType, hasGuard,
				checkMTypeList);
	}

	public AcceptReturnType sbnhOutput_Dest(StateBodyNode tNode,
			String transNodeDesc, String dest, String destType,
			boolean hasGuard, boolean checkMTypeList) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (destType.equals("SS")) {
			if (!hasGuard) {
				tmpART.addStr("State", "           " + transNodeDesc + "goto "
						+ dest + "; skip;}");
			} else {
				tmpART.addStr("State", "              " + transNodeDesc
						+ "goto " + dest + "; skip;}");
			}
			return tmpART;
		}
		if (destType.equals("CS")) {
			if (!hasGuard) {
				tmpART.addStr("State", "           " + transNodeDesc
						+ "goto to_" + dest + "; skip;}");
			} else {
				tmpART.addStr("State", "              " + transNodeDesc
						+ "goto to_" + dest + "; skip;}");
			}
			return tmpART;
		}
		boolean tempFound = (checkMTypeList)
				&& globalOutputs.ifInArray("mTypeList", "st_" + dest);

		aNode temp3 = tNode;

		// TODO because of ID issues this should check for StateNode and
		// CompositeStateNode ONLY!
		while (temp3.getType().equals("StateBodyNode")
				|| temp3.getType().equals("StateNode")
				|| temp3.getType().equals("CompositeStateBodyNode")) {
			temp3 = temp3.getParent();
		}
		if (!tempFound) {
			globalOutputs.addStr("mTypeList", "st_" + dest);
		}
		if (!hasGuard) {
			tmpART.addStr("State", "           wait!_pid,st_" + dest + "; "
					+ temp3.getID() + "_C!1; " + transNodeDesc
					+ "goto exit; skip;}");
		} else {
			tmpART.addStr("State", "              wait!_pid,st_" + dest + "; "
					+ temp3.getID() + "_C!1; " + transNodeDesc
					+ "goto exit; skip;}");
		}

		return tmpART;
	}

	public AcceptReturnType sbnhTransitionEndOutput(aNode destNode) {
		AcceptReturnType tmpART = new AcceptReturnType();
		String timeArray[];
		int timeArrayVals[];
		int i;

		if (stateTimeInvariant.length() > 0) {
			timeArray = getTokenizedStrToArray(stateTimeInvariant, "<=");

			String filler1, filler2;
			boolean noOutput = false;
			boolean foundLessThan = false;

			filler1 = "<=";
			filler2 = ">";

			if (timeArray[1].length() == 0) {
				timeArray = getTokenizedStrToArray(stateTimeInvariant, "<");

				filler1 = "<";
				filler2 = ">=";

				foundLessThan = true;
			}

			timeArrayVals = new int[timeArray.length];
			for (i = 0; i < timeArray.length; i++) {
				try {
					timeArrayVals[i] = Integer.parseInt(timeArray[i]);
				} catch (Exception e) {
					timeArrayVals[i] = 0;
				}
			}
			timeArrayVals[1] -= 1;
			timeArray[1] = Integer.toString(timeArrayVals[1]);

			if (timeArrayVals[1] < 0) {
				noOutput = true;
			}
			if ((foundLessThan) && (timeArrayVals[1] <= 0)) {
				noOutput = true;
			}

			if (!noOutput) {
				String className = searchUpForDest(destNode, "ClassNode")
						.getID();

				tmpART.addStr("State", "           :: atomic{Timer_V."
						+ timeArray[0] + filler1 + timeArray[1] + " -> "
						+ className + "_V.timerwait = 1;");
				tmpART.addStr("State", "              " + className
						+ "_V.timerwait == 0 -> goto "
						+ destNode.getParent().getID() + "_G;}");

				timeArrayVals[1] += 1;
				timeArray[1] = Integer.toString(timeArrayVals[1]);
				tmpART.addStr("State", "           :: atomic{Timer_V."
						+ timeArray[0] + filler2 + timeArray[1] + " ->");
				tmpART.addStr("State", "              Timer_V." + timeArray[0]
						+ "=-2; assert(0); false;}");

			}
		}
		tmpART.addStr("State", "        fi;");

		return tmpART;
	}

	public AcceptReturnType sbnhOutputINPredicateZero(StateBodyNode tNode,
			boolean ifTarget) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (ifTarget) {
			aNode classRef = searchUpForDest(tNode, "ClassNode");
			tmpART.addStr("State", "           " + classRef.getID()
					+ "outputINPreidcateZero_V.st_" + tNode.getParent().getID()
					+ " = 0;");
		}

		return tmpART;
	}

	public AcceptReturnType sbnhOutputGuard(TransitionBodyNode transRef,
			boolean hasEvent, AcceptReturnType hasGuardParam,
			boolean isFirstGuard) {
		AcceptReturnType tmpART = new AcceptReturnType();
		String guardString = transRef.getGuard();

		if (guardString.length() == 0) {
			return tmpART;
		}

		// There IS a guard!
		Boolean hg = new Boolean(true);
		hasGuardParam.addSingle("default", hg);

		if ((hasEvent) && isFirstGuard) {
			tmpART.addStr("State", "           if");
		}

		String guardExpr = "";
		guardExpr = pinpv.ExpressionParser.Parse_Me(transRef, guardString);

		if (guardExpr.length() == 0) {
			aNode classRef = searchUpForDest(transRef, "ClassNode");
			println("In Class [" + classRef.getID() + "], bad expression ["
					+ guardString + "].");
			exit();
			return tmpART; // never called;
		}
		if (stateTimeInvariant.length() == 0) {
			tmpART.addStr("State", "           :: atomic{" + guardExpr + " ->");
		} else {
			tmpART.addStr("State", "           :: atomic{Timer_V."
					+ stateTimeInvariant + " && " + guardExpr + " ->");
		}

		return tmpART;
	}

	public AcceptReturnType sbnhOutputActionMsgs(aNode nodeRef, boolean hasGuard) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (nodeRef != null) {
			tmpART.merge(nodeRef.accept(this));
			// The type of output does not matter since both
			// messages and actions output to defV

			String entities[] = tmpART.getStrSplit("default");
			tmpART.removeStrKey("default");
			String tmpStr;
			for (int i = 0; i < entities.length; i++) {
				if (!hasGuard) { // no guard
					tmpStr = "   " + entities[i];
				} else {
					tmpStr = "      " + entities[i];
				}
				tmpART.addStr("State", tmpStr);
			}
		}

		return tmpART;
	}

	public AcceptReturnType sbnhOutputGuardEnd(StateBodyNode tNode,
			boolean hasEvent, EventNode event, boolean hasGuard) {
		AcceptReturnType tmpART = new AcceptReturnType();

		if (hasGuard) {
			if (hasEvent) {
				if (event.getEventType().equals("when")) {
					String returnValue = "";
					returnValue = pinpv.ExpressionParser.Parse_Me(event,
							"when(" + event.getWhenVariable() + ")");
					tmpART.addStr("State", "           :: else -> !("
							+ returnValue + ") -> goto "
							+ tNode.getParent().getID() + "_G; skip;");
				} else {
					// "normal" event
					tmpART.addStr("State", "           :: else -> goto "
							+ tNode.getParent().getID() + "_G; skip;");
				}
				tmpART.addStr("State", "           fi}");
			}
		}

		return tmpART;
	}

	public void sbnhOutputTransitions(StateBodyNode tNode,
			AcceptReturnType anART, AcceptReturnType transitionEventList,
			boolean ifTarget) {
		AcceptReturnType TELentitity, transitionList;
		anART.addStr("State", "        if");
		boolean emptyTrans;
		String transitionMarkerStr = "";
		String tmpStr = "";

		Vector<?> vec = transitionEventList.getGen("default");
		for (int i = 0; i < vec.size(); i++) {
			TELentitity = (AcceptReturnType) vec.get(i);
			String evtNodeSrc = TELentitity.getStr("event");
			EventNode evtNode = null;
			transitionList = (AcceptReturnType) TELentitity
					.getSingle("transitionlist");

			if (evtNodeSrc.substring(0, 2).equals("e_")) {
				evtNode = (EventNode) TELentitity.getSingle("event");
			}

			emptyTrans = false;
			if (evtNodeSrc.equals("EMPTYTRANS")) {
				// sub EMPTYTRANSoutputState
				emptyTrans = true;

				Vector<?> tlvec = transitionList.getGen("default");
				for (int j = 0; j < tlvec.size(); j++) {
					TransitionNode transNode = (TransitionNode) tlvec.get(j);
					String stTimeInvariant = stateTimeInvariant.substring(0); // TODO
																				// undef!?
					tmpStr = "        :: atomic{" + transitionMarkerStr;
					if (stTimeInvariant.length() == 0) {
						tmpStr += "1 -> ";
					} else {
						tmpStr += "Timer_V." + stTimeInvariant + " -> ";
					}
					anART.addStr("State", tmpStr);
					anART.merge(sbnhOutput_Dest(tNode, transNode, false, true));
				}
			}
			if (evtNode != null) {
				// Will only happen if neither of the two options above are
				// true.
				anART.merge(evtNode.accept(this)); // (part of iffirst != 1)
				if (evtNode.getEventType().equals("normal")) {
					aNode localRet = FindLocalDestNode(tNode, "SignalNode",
							"name", evtNode.getName());
					if (localRet != null) {
						anART.moveStrKey("Trans", "State");
					} else {
						anART.addStr("State", "        :: atomic{"
								+ transitionMarkerStr + "evt??"
								+ evtNode.getName().replace(".", "__sig__")
								+ ",eval(_pid) -> ");
					}
				} else {
					anART.moveStrKey("Trans", "State");
				}
			}

			if (!emptyTrans) {
				anART.merge(sbnhOutputINPredicateZero(tNode, ifTarget));
				boolean hasGuard = false;
				boolean hasGuards = false;
				AcceptReturnType hasGuardParam = new AcceptReturnType();

				Vector<?> tlvec = transitionList.getGen("default");
				for (int j = 0; j < tlvec.size(); j++) {
					TransitionNode transNode = (TransitionNode) tlvec.get(j);
					hasGuardParam.addSingle("default", new Boolean(false));

					anART.merge(sbnhOutputGuard(transNode.bodyChild,
							!evtNodeSrc.equals("NOEVENT"), hasGuardParam,
							j == 0));
					hasGuard = ((Boolean) hasGuardParam.getSingle("default"))
							.booleanValue();
					hasGuards = hasGuards || hasGuard;

					if (!hasGuard) {
						if (evtNodeSrc.equals("NOEVENT")) {
							String stTimeInvariant = stateTimeInvariant;

							tmpStr = "        :: atomic{" + transitionMarkerStr;
							if (stTimeInvariant.length() == 0) {
								tmpStr += "1 -> ";
							} else {
								tmpStr += "Timer_V." + stTimeInvariant + " -> ";
							}
							anART.addStr("State", tmpStr);
						} else {
							if (j != 0) {
								anART.merge(evtNode.accept(this));
								anART.moveStrKey("Trans", "State");
							}
						}
					}

					anART.merge(sbnhOutputActionMsgs(
							transNode.bodyChild.actionsChild, hasGuard));
					anART.merge(sbnhOutputActionMsgs(
							transNode.bodyChild.messagesChild, hasGuard));
					anART.merge(sbnhOutput_Dest(tNode, transNode, hasGuard,
							true));
				}

				anART.merge(sbnhOutputGuardEnd(tNode,
						!evtNodeSrc.equals("NOEVENT"), evtNode, hasGuards));

			}
		}

		anART.merge(sbnhTransitionEndOutput(tNode));
	}

	public AcceptReturnType sbnhGetAllActions(aNode tNode) {
		AcceptReturnType tmpART = new AcceptReturnType();
		int i;
		String tmpEntryActions, tmpExitActions, tmpres;
		tmpEntryActions = "";
		tmpExitActions = "";
		for (i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) (tNode.children.get(i));

			if (childNode.getType().equals("ActionNode")) {
				ActionNode actNode = (ActionNode) childNode;
				AcceptReturnType tmpART2;

				tmpART2 = actNode.accept(this);
				tmpres = tmpART2.getStr("Action");
				tmpART2.removeStrKey("Action");
				tmpART.merge(tmpART2);

				if (actNode.hasTransitionBodyNode()) {
					if (actNode.subnode.hasEventNodeChild()) {
						if (actNode.subnode.eventNodeChild.getName().equals(
								"entry")) {
							tmpEntryActions += tmpres;
						}
						if (actNode.subnode.eventNodeChild.getName().equals(
								"exit")) {
							tmpExitActions += tmpres;
						}
					}
				}

			}
			if (childNode.getType().equals("TimeInvariantNode")
					&& tNode.getType().equals("StateBodyNode")) {
				tmpART.merge(childNode.accept(this));
			}
		}

		if (tmpEntryActions.length() > 0) {
			tmpEntryActions = strln("/* entry actions */") + tmpEntryActions
					+ strln("        }");
		} else {
			if (tNode.getType().equals("StateBodyNode")) {
				tmpEntryActions += strln("        }");
			}
		}
		if (tmpExitActions.length() > 0) {
			tmpExitActions = strln("/* exit actions */")
					+ strln("        atomic {") + tmpExitActions
					+ strln("        }");
		}
		tmpART.addStrln("entry", tmpEntryActions);
		tmpART.addStrln("exit", tmpExitActions);

		return tmpART;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see h2PVisitors.aVisitor#visitStateBodyNode(h2PNodes.StateBodyNode)
	 */
	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";

		int tNodeCount = tNode.transitionNodeChildren.size(); // number of
																// Transition
																// h2PNodes

		boolean inPredicateTarget = sbnhIfINPredicateTarget(tNode,
				(AcceptReturnType) globalOutputs.getSingle("INPredicateTarget"));

		AcceptReturnType tmpART2 = sbnhGetAllActions(tNode);
		tmpStr += strln(tmpART2.getStr("entry"))
				+ strln(tmpART2.getStr("exit"));

		if (tNodeCount == 0) {
			// Has no transitions, only actions
			tmpStr += strln("        if");
			tmpStr += strln("        :: skip -> false");
			tmpStr += strln("        fi;");
			tmpART.addStrln("State", tmpStr);
		} else {
			// There's at least one TransitionNode!
			if (inPredicateTarget) {
				aNode tCN = searchUpForDest(tNode, "ClassNode");

				tmpStr += strln("        " + tCN.getID()
						+ "outputPredicateStatement_V.st_"
						+ tNode.getParent().getID() + " = 1;");
			}
			AcceptReturnType transitionEventList = sbnhFormeventlist(tNode);

			if (tNode.getParent().getID().equals("ValueReceived")) {
				// debug Code
				int i = 4;
				i++;
			}
			tmpStr += strln("        " + tNode.getParent().getID() + "_G:");
			Vector<?> vec = transitionEventList.getGen("default");

			for (int i = 0; i < vec.size(); i++) {
				AcceptReturnType TELentitity = (AcceptReturnType) vec.get(i);
				if (TELentitity.getStr("event").substring(0, 2).equals("e_")) {
					EventNode evtNode = (EventNode) TELentitity
							.getSingle("event");
					if (evtNode.getType().equals("normal")) {
						aNode retVal = FindLocalDestNode(tNode, "SignalNode",
								"name", evtNode.getName());
						if (retVal == null) {
							tmpStr += strln("        evq!" + evtNode.getName()
									+ ",_pid;");
						}
					}
				}
			}

			tmpART.addStrln("State", tmpStr);
			sbnhOutputTransitions(tNode, tmpART, transitionEventList,
					inPredicateTarget);
		}
		stateTimeInvariant = "";

		return tmpART; // output to @outputState
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * h2PVisitors.aVisitor#visitTransitionBodyNode(h2PNodes.TransitionBodyNode)
	 */
	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		if (tNode.hasEventNodeChild()) {
			tmpART.merge(tNode.eventNodeChild.accept(this));
		}
		// These are TransitionActions Children
		if (tNode.hasActionsChild()) {
			tmpART.merge(tNode.actionsChild.accept(this));
			tmpART.moveStrKey("default", "transitions");
		}
		if (tNode.hasMessagesChild()) {
			tmpART.merge(tNode.messagesChild.accept(this));
			tmpART.moveStrKey("default", "transitions");
		}
		return tmpART; // output to @outputtransitionbody
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * h2PVisitors.aVisitor#visitTimeInvariantNode(h2PNodes.TimeInvariantNode)
	 */
	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		// There is more to the time invariant in the original code. Investigate
		// if needed.
		stateTimeInvariant = tNode.getTimeInvariant();
		stateTimeInvariant = stateTimeInvariant.substring(1,
				stateTimeInvariant.length() - 1);

		tmpART.addStr("stateTimeInvariant", stateTimeInvariant);
		return tmpART;

	}
}
