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

/**
 * Performs a battery of checks on the semantics of the parsed AST.  Any
 * major problems are reported.
 */
public class ASTErrorChecker extends aVisitor {

	
	// TODO
	/*
	 * Left To do... 
	 *   Event - (done)
	 *   TransitionAction
	 *   Message
	 */
	/**
	 * Default constructor
	 */
	public ASTErrorChecker() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitActionNode(h2PNodes.ActionNode)
	 */
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		// the model only has one (optional) child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
			  tART.addStr("errors", "Action: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasTransitionBodyNode()) {
				tART.addStr("errors", "Action: (" + nodeName + ") Has has children but no transition body.");
			} else {
				tART.merge(tNode.subnode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitClassBodyNode(h2PNodes.ClassBodyNode)
	 */
	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		int initNodeCount = 0;
		
		String nodeName = tNode.getNodeName();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("InitNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				initNodeCount++;
			}
			if (childNode.getType().equals("StateNode") || 
				childNode.getType().equals("CompositeStateNode") ||
				childNode.getType().equals("ConcurrentCompositeNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			/* commented out: only states can have one time invariant
			if (childNode.getType().equals("TimeInvariantNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			*/
			if (childNode.getType().equals("InstanceVariableNode")) {
				validChild = true;				
			}
			if (childNode.getType().equals("SignalNode")) {
				validChild = true;				
			}
			if (childNode.getType().equals("JoinNode")) {
				validChild = true;				
			}
			if (!validChild) {
				tART.addStr("errors", "ClassBody: (" + nodeName +
						") Invalid Child Type. Node " + i + " of type " + childNode.getType() + ".");
			}
		}
		
		if (initNodeCount == 0) {
			tART.addStr("warnings", "ClassBody: ("+ nodeName +
					") No Init State found.");
		}
		if (initNodeCount > 1) {
			tART.addStr("errors", "ClassBody: ("+ nodeName +
					") Multiple Init States found.");
		}
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitClassNode(h2PNodes.ClassNode)
	 */
	public AcceptReturnType visitClassNode(ClassNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		
		// the model only has one child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
  			  tART.addStr("errors", "Class: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasClassBodyNode()) {
				tART.addStr("errors", "Class: (" + nodeName + ") Has has children but no body.");
			} else {
				tART.merge(tNode.subnode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitCompositeStateBodyNode(h2PNodes.CompositeStateBodyNode)
	 */
	public AcceptReturnType visitCompositeStateBodyNode(CompositeStateBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		int transitionCount = 0;	
		int initNodeCount = 0;
		int historyNodeCount = 0;
		
		String nodeName = tNode.getNodeName();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("InitNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				initNodeCount++;
			}
			if (childNode.getType().equals("ActionNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("HistoryNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				historyNodeCount++;
			}
			if (childNode.getType().equals("TransitionNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				transitionCount++;
			}
			if (childNode.getType().equals("StateNode") || 
				childNode.getType().equals("CompositeStateNode") ||
				childNode.getType().equals("ConcurrentCompositeNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			if (!validChild) {
				tART.addStr("errors", "CompositeStateBody: (" + nodeName +
						") Invalid Child Type. Node " + i + " of type " + childNode.getType() + ".");
			}
		}
		
		if (initNodeCount == 0) {
			tART.addStr("warnings", "CompositeStateBody: ("+ nodeName +
					") No Init State found.");
		}
		if (initNodeCount > 1) {
			tART.addStr("errors", "CompositeStateBody: ("+ nodeName +
					") Multiple Init States found.");
		}
		if (transitionCount == 0) {
			tART.addStr("warnings", "CompositeStateBody: ("+ nodeName +
					") No outgoing Transitions found.");
		}
		
		return tART;

	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitCompositeStateNode(h2PNodes.CompositeStateNode)
	 */
	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		
		// the model only has one child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
				tART.addStr("errors", "CompositeState: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasBodyNode()) {
				tART.addStr("errors", "CompositeState: (" + nodeName + ") Has has children but no body.");
			} else {
				tART.merge(tNode.bodyNode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeBodyNode(h2PNodes.ConcurrentCompositeBodyNode)
	 */
	public AcceptReturnType visitConcurrentCompositeBodyNode(ConcurrentCompositeBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		
		String nodeName = tNode.getNodeName();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("CompositeStateNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			if (!validChild) {
				tART.addStr("errors", "ConcurrentCompositeBody: (" + nodeName +
						") Invalid Child Type. Node " + i + " of type " + childNode.getType() + ".");
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitConcurrentCompositeNode(h2PNodes.ConcurrentCompositeNode)
	 */
	public AcceptReturnType visitConcurrentCompositeNode(ConcurrentCompositeNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		
		// the model only has one child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
				tART.addStr("errors", "ConcurrentComposite: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasBodyNode()) {
				tART.addStr("errors", "ConcurrentComposite: (" + nodeName + ") Has has children but no body.");
			} else {
				tART.merge(tNode.bodyNode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitDriverFileNode(h2PNodes.DriverFileNode)
	 */
	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
		return super.visitDriverFileNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitEnumNode(h2PNodes.EnumNode)
	 */
	public AcceptReturnType visitEnumNode(EnumNode tNode) {
		return super.visitEnumNode(tNode);
	}
	
	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitEventNode(h2PNodes.EventNode)
	 */
	public AcceptReturnType visitEventNode(EventNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		TransitionBodyNode tBody = (TransitionBodyNode) searchUpForDest(tNode, "TransitionBodyNode");
		aNode classBodyRef = searchUpForDest (tNode, "ClassBodyNode");
		String nodeName = tNode.getNodeName();
		
		if (tBody.getParent().getType().equals("ActionNode")) {
			if ((!tNode.getName().equals("entry")) && (!tNode.getName().equals("exit"))) {
				tART.addStr("errors", "Event: (" + nodeName + ") Illegal Action Event (only entry/exit events allowed)).");
			}
			if (tNode.getVariable().length() > 0) {
				tART.addStr("errors", "Event: (" + nodeName + ") Action Events cannot have variables.");
			}
		} else {
			if (tNode.getName().length() > 0) {
				if (FindLocalDestNode(tNode, "SignalNode", "name", tNode.getName()) == null) {
					//TODO why a warning and not an error?
					  tART.addStr("warnings", "Event: (" + nodeName + ") Signal [" 
							  + tNode.getName() + "] is undeclared.");
				}
			}
			if (tNode.getVariable().length() > 0) {
				if (!ifInParent(classBodyRef, "InstanceVariableNode", "var", tNode.getVariable())) {
				  tART.addStr("errors", "Event: (" + nodeName + ") Undeclared instance variable used.");
				}
			}
		}

		if (tNode.children.size() > 0) {
			tART.addStr("errors", "Event: (" + nodeName + ") Has children nodes.");			
		}
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitHistoryNode(h2PNodes.HistoryNode)
	 */
	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		String historyID = tNode.getID();
		aNode parentRef = tNode.getParent();
		
		boolean found;
		
		found = ifInParent(parentRef, "StateNode", historyID);
		if (!found) {
		  found = ifInParent(parentRef, "CompositeStateNode", historyID);
		}
		if (!found) {
		  found = ifInParent(parentRef, "ConcurrentCompositeNode", historyID);
		}
		if (!found) {
			tART.addStr("errors", "History: (" + nodeName + ") State [" + historyID + "] not found.");
		}

		// the model only has one (optional) child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
			  tART.addStr("errors", "History: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasTBNChild()) {
				tART.addStr("errors", "History: (" + nodeName + ") Has children but no transition body.");
			} else {
				tART.merge(tNode.tbnChild.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitInitNode(h2PNodes.InitNode)
	 */
	public AcceptReturnType visitInitNode(InitNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		String initID = tNode.getID();
		aNode parentRef = tNode.getParent();
		
		boolean found;
		
		found = ifInParent(parentRef, "StateNode", initID);
		if (!found) {
		  found = ifInParent(parentRef, "CompositeStateNode", initID);
		}
		if (!found) {
		  found = ifInParent(parentRef, "ConcurrentCompositeNode", initID);
		}
		if (!found) {
			tART.addStr("errors", "Init: (" + nodeName + ") State [" + initID + "] not found.");
		}

		// the model only has one (optional) child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
			  tART.addStr("errors", "Init: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasTransitionBodyNode()) {
				tART.addStr("errors", "Init: (" + nodeName + ") Has has children but no transition body.");
			} else {
				tART.merge(tNode.subnode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitInstanceVariableNode(h2PNodes.InstanceVariableNode)
	 */
	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		return super.visitInstanceVariableNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitJoinNode(h2PNodes.JoinNode)
	 */
	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		return super.visitJoinNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessageNode(h2PNodes.MessageNode)
	 */
	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		aNode modelBodyRef = searchUpForDest (tNode, "ModelBodyNode");
		String nodeName = tNode.getNodeName();

		if (tNode.getClassName().length() > 0) {
			ClassNode targetClass = (ClassNode) ifInParentAsNode(modelBodyRef, "ClassNode", tNode.getClassName());
			if (targetClass != null) {
				if (!targetClass.hasClassBodyNode()) {
					  tART.addStr("warnings", "Message: (" + nodeName + ") Target Class [" + tNode.getClassName() 
							  + "] has no body.");				
				}
			}
			if (tNode.getSignalName().length() == 0) {
				  tART.addStr("errors", "Message: (" + nodeName + ") Class [" + tNode.getClassName() 
						  + "] Delimits No Signal.");
			}
		}
		
		if (tNode.children.size() > 0) {
			tART.addStr("errors", "Message: (" + nodeName + ") Has children nodes.");			
		}
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessagesNode(h2PNodes.MessagesNode)
	 */
	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("MessageNode")) {
				tART.merge(childNode.accept(this));
			} else {
  			   	tART.addStr("errors", "Messages: (" + nodeName + ") has child not of type MessageNode.");
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitModelBodyNode(h2PNodes.ModelBodyNode)
	 */
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		
		String nodeName = tNode.getNodeName();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("ClassNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			} else if (childNode.getType().equals("DriverFileNode")) {
				validChild = true;				
			} else if (childNode.getType().equals("EnumNode")) {
				validChild = true;
				//tART.merge(childNode.accept(this));
			} else if (childNode.getType().equals("NullNode")) {
				validChild = true;				
			}
			if (!validChild) {
				tART.addStr("errors", "ModelBody: (" + nodeName +
						") Invalid Child Type. Node " + i + " of type " + childNode.getType() + ".");
			}
		}
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitModelNode(h2PNodes.ModelNode)
	 */
	public AcceptReturnType visitModelNode(ModelNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		
		// the model only has one child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
				tART.addStr("errors", "Model: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasModelBodyNode()) {
				tART.addStr("errors", "Model: (" + nodeName + ") Has has children but no body.");
			} else {
				tART.merge(tNode.subnode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitNode(h2PNodes.aNode)
	 */
	public AcceptReturnType visitNode(aNode tNode) {
		return super.visitNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitNullNode(h2PNodes.NullNode)
	 */
	public AcceptReturnType visitNullNode(NullNode tNode) {
		return super.visitNullNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitSignalNode(h2PNodes.SignalNode)
	 */
	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		// TODO should this check for duplicate signals?
		return super.visitSignalNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateBodyNode(h2PNodes.StateBodyNode)
	 */
	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		int transitionCount = 0;
		int timeInvarCount = 0;
		
		String nodeName = tNode.getNodeName();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("TransitionNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				transitionCount++;
			}
			if (childNode.getType().equals("ActionNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("TimeInvariantNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
				timeInvarCount++;
			}
			if (!validChild) {
				tART.addStr("errors", "StateBody: (" + nodeName +
						") Invalid Child Type. Node " + i + " of type " + childNode.getType() + ".");
			}
		}
		
		if (transitionCount == 0) {
			tART.addStr("warnings", "StateBody: ("+ nodeName +
					") No outgoing Transitions found.");
		}
		if (timeInvarCount > 1) {
			tART.addStr("errors", "StateBody: (" + nodeName +
				") Only 1 time invariant allowed per state.  " + timeInvarCount + " found.");
		}
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateNode(h2PNodes.StateNode)
	 */
	public AcceptReturnType visitStateNode(StateNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		
		// the model only has one child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
				tART.addStr("errors", "State: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasBodyNode()) {
				tART.addStr("errors", "State: (" + nodeName + ") Has has children but no body.");
			} else {
				tART.merge(tNode.bodyNode.accept(this));
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTimeInvariantNode(h2PNodes.TimeInvariantNode)
	 */
	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		return tNode.acceptChildren(this);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionNode(h2PNodes.TransitionActionNode)
	 */
	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();
		boolean validActionType = false;
		boolean isMessageType = false;

		if (tNode.getActionType().equals("newaction")) {
			validActionType = true;
		}
		
		if (tNode.getActionType().equals("sendmsg")) {
			validActionType = true;
			isMessageType = true;
			if (!tNode.hasMessageChild()) {
				tART.addStr("errors", "TransitionAction: (" + nodeName 
						+ ") Action of Type [sendmsg] has no Message child.");
			}
		}
		if (tNode.getActionType().equals("assignstmt")) {
			validActionType = true;
		}
		if (tNode.getActionType().equals("printstmt")) {
			validActionType = true;
		}
		if (tNode.getActionType().equals("function")) {
			validActionType = true;
		}
		if (!validActionType) {
			  tART.addStr("errors", "TransitionAction: (" + nodeName + ") Invalid Action type: ["
					  + tNode.getActionType() + "].");
		}
		
		// the model only has one child: a message node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
  			  tART.addStr("errors", "TransitionAction: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasMessageChild()) {
				tART.addStr("errors", "TransitionAction: (" + nodeName + ") Has has children but message.");
			} else {
				tART.merge(tNode.messageChild.accept(this));
				if (!isMessageType) {
					tART.addStr("errors", "TransitionAction: (" + nodeName 
							+ ") Has has message child but has no Action of Type [sendmsg].");					
				}
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionsNode(h2PNodes.TransitionActionsNode)
	 */
	public AcceptReturnType visitTransitionActionsNode(TransitionActionsNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		for (int i = 0; i < tNode.children.size(); i++) {
			aNode childNode = (aNode) tNode.children.get(i);
			if (childNode.getType().equals("TransitionActionNode")) {
				tART.merge(childNode.accept(this));
			} else {
  			   	tART.addStr("errors", "TransitionActions: (" + nodeName + ") has child not of type TransitionActionNode.");
			}
		}
		
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionBodyNode(h2PNodes.TransitionBodyNode)
	 */
	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		
		String nodeName = tNode.getNodeName();
		String parentType = tNode.getParent().getType();
		
		if (tNode.hasEventNodeChild()) {
			if (parentType.equals("InitNode") || parentType.equals("HistoryNode")) {
				  tART.addStr("errors", "TransitionBody: (" + nodeName + ") the " + parentType 
						  + " [" + tNode.getParent().getID() + "] cannot have an event.");
			} else {
				tART.merge(tNode.eventNodeChild.accept(this));
			}
		}
		if (tNode.getGuard().length() > 0) {
			if (parentType.equals("InitNode") || 
				parentType.equals("HistoryNode") ||
				parentType.equals("ActionNode")) {
				  tART.addStr("errors", "TransitionBody: (" + nodeName + ") the " + parentType 
						  + " [" + tNode.getParent().getID() + "] cannot have a guard.");
			}
			
		}
		
		if (tNode.hasActionsChild()) {
			tART.merge(tNode.actionsChild.accept(this));
		}
		if (tNode.hasMessagesChild()) {
			tART.merge(tNode.messagesChild.accept(this));
		}
		
		return tART;
		
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionNode(h2PNodes.TransitionNode)
	 */
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = tNode.getNodeName();

		// the model only has one (optional) child: a body node.
		if (tNode.children.size() >= 1) {
			if (tNode.children.size() > 1) {
			  tART.addStr("errors", "Transition: (" + nodeName + ") Has too many children.");
			}
			if (!tNode.hasBody()) {
				tART.addStr("errors", "Transition: (" + nodeName + ") Has has children but no transition body.");
			} else {
				tART.merge(tNode.bodyChild.accept(this));
			}
		}
		
		return tART;
	}

}
