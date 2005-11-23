/*
 * Created on Sep 30, 2005
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
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ASTErrorChecker extends aVisitor {

	/**
	 * the AST Error Checka!
	 */
	public ASTErrorChecker() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitActionNode(h2PNodes.ActionNode)
	 */
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitActionNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitClassBodyNode(h2PNodes.ClassBodyNode)
	 */
	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		int initNodeCount = 0;
		
		String nodeName = tNode.getParent().getID();
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
			if (childNode.getType().equals("TimeInvariantNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
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
		String nodeName = tNode.getID();
		
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "Class: (" + nodeName + ") Has too many children.");
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
		
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
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
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
		
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "CompositeState: (" + nodeName + ") Has too many children.");
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
		
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
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
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
		
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "ConcurrentComposite: (" + nodeName + ") Has too many children.");
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
		// TODO Auto-generated method stub
		return super.visitDriverFileNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitEventNode(h2PNodes.EventNode)
	 */
	public AcceptReturnType visitEventNode(EventNode tNode) {
		// TODO Auto-generated method stub
		return super.visitEventNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitHistoryNode(h2PNodes.HistoryNode)
	 */
	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		// TODO Auto-generated method stub
		return super.visitHistoryNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitInitNode(h2PNodes.InitNode)
	 */
	public AcceptReturnType visitInitNode(InitNode tNode) {
		// TODO Auto-generated method stub
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();

		//TODO:
		/*
		 *     my $found=UniversalClass->IfinParent($parentbodyref,"StateNode",$initID);
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

		 */
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "Init: (" + nodeName + ") Has too many children.");
			if (!tNode.hasTransitionBodyNode()) {
				tART.addStr("errors", "Init: (" + nodeName + ") Has has children but no transition.");
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
		// TODO Auto-generated method stub
		return super.visitInstanceVariableNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitJoinNode(h2PNodes.JoinNode)
	 */
	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		// TODO Auto-generated method stub
		return super.visitJoinNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessageNode(h2PNodes.MessageNode)
	 */
	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		// TODO Auto-generated method stub
		return super.visitMessageNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitMessagesNode(h2PNodes.MessagesNode)
	 */
	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		// TODO Auto-generated method stub
		return super.visitMessagesNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitModelBodyNode(h2PNodes.ModelBodyNode)
	 */
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		
		String nodeName = tNode.getParent().getID();
		for (int i = 0; i < tNode.children.size(); i++) {
			boolean validChild = false;
			aNode childNode = (aNode)tNode.children.get(i);
			if (childNode.getType().equals("ClassNode")) {
				validChild = true;
				tART.merge(childNode.accept(this));
			}
			if (childNode.getType().equals("DriverFileNode")) {
				validChild = true;				
			}
			if (childNode.getType().equals("NullNode")) {
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
		String nodeName = tNode.getID();
		
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "Model: (" + nodeName + ") Has too many children.");
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
		// TODO Auto-generated method stub
		return super.visitNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitNullNode(h2PNodes.NullNode)
	 */
	public AcceptReturnType visitNullNode(NullNode tNode) {
		// TODO Auto-generated method stub
		return super.visitNullNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitSignalNode(h2PNodes.SignalNode)
	 */
	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		// TODO Auto-generated method stub
		return super.visitSignalNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateBodyNode(h2PNodes.StateBodyNode)
	 */
	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		int transitionCount = 0;
		
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
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
		return tART;
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitStateNode(h2PNodes.StateNode)
	 */
	public AcceptReturnType visitStateNode(StateNode tNode) {
		AcceptReturnType tART = new AcceptReturnType();
		String nodeName = searchUpForDest (tNode, "ClassNode").getID() + "." + tNode.getParent().getID();
		
		// the model only has one child: a body node.
		if (tNode.children.size() > 1) {
			tART.addStr("errors", "State: (" + nodeName + ") Has too many children.");
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
		// TODO Auto-generated method stub
		return super.visitTimeInvariantNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionNode(h2PNodes.TransitionActionNode)
	 */
	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionActionNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionActionsNode(h2PNodes.TransitionActionsNode)
	 */
	public AcceptReturnType visitTransitionActionsNode(TransitionActionsNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionActionsNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionBodyNode(h2PNodes.TransitionBodyNode)
	 */
	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionBodyNode(tNode);
	}

	/* (non-Javadoc)
	 * @see h2PVisitors.aVisitor#visitTransitionNode(h2PNodes.TransitionNode)
	 */
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		// TODO Auto-generated method stub
		return super.visitTransitionNode(tNode);
	}

}
