package backend.h2PVisitors;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PNodes.ActionNode;
import backend.h2PNodes.ClassBodyNode;
import backend.h2PNodes.ClassNode;
import backend.h2PNodes.CompositeStateBodyNode;
import backend.h2PNodes.CompositeStateNode;
import backend.h2PNodes.ConcurrentCompositeBodyNode;
import backend.h2PNodes.ConcurrentCompositeNode;
import backend.h2PNodes.DriverFileNode;
import backend.h2PNodes.EnumNode;
import backend.h2PNodes.EventNode;
import backend.h2PNodes.HistoryNode;
import backend.h2PNodes.InitNode;
import backend.h2PNodes.InstanceVariableNode;
import backend.h2PNodes.JoinNode;
import backend.h2PNodes.MessageNode;
import backend.h2PNodes.MessagesNode;
import backend.h2PNodes.ModelBodyNode;
import backend.h2PNodes.ModelNode;
import backend.h2PNodes.NullNode;
import backend.h2PNodes.SignalNode;
import backend.h2PNodes.StateBodyNode;
import backend.h2PNodes.StateNode;
import backend.h2PNodes.TimeInvariantNode;
import backend.h2PNodes.TransitionActionNode;
import backend.h2PNodes.TransitionActionsNode;
import backend.h2PNodes.TransitionBodyNode;
import backend.h2PNodes.TransitionNode;
import backend.h2PNodes.WorldUtilNode;
import backend.h2PNodes.aNode;


/**
 * Handles the flattening of composite states.
 */
public class CStateFlattenerVisitor extends aVisitor {

	WorldUtilNode rootNode = null;
	
	public CStateFlattenerVisitor(WorldUtilNode theRootNode) {
		super();
		rootNode = theRootNode;
		callVisitNodeAlways = false;
	}

	public boolean canBeFlattened (CompositeStateNode tNode) {
		return false;
	}
	
	public boolean canBeFlattened (CompositeStateBodyNode tNode) {
		return canBeFlattened((CompositeStateNode)tNode.getParent());
	}
	
	// returns true if the node passed is a Composite State Body Node
	// and it is "flatennable" 
	public boolean isFlattenableAsParent (aNode tNode) {
		if (!tNode.getType().equals("CompositeStateBodyNode")) {
			return false;
		}
		return (canBeFlattened((CompositeStateNode)tNode));
	}
	
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		return super.visitActionNode(tNode);
	}

	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType retART = super.visitClassBodyNode(tNode);
		
		retART.merge(tNode.acceptChildren(this));
		
		return retART;
	}

	public AcceptReturnType visitClassNode(ClassNode tNode) {
		AcceptReturnType retART = super.visitClassNode(tNode);
		
		retART.merge(tNode.acceptChildren(this));
		
		return retART;
	}

	public AcceptReturnType visitCompositeStateBodyNode(
			CompositeStateBodyNode tNode) {
		AcceptReturnType dumbART = super.visitCompositeStateBodyNode(tNode);
		
		// merge composite state children first.
		dumbART.merge(tNode.acceptChildrenOfType(this, "CompositeStateNode"));

		// change init nodes into States.
		dumbART.merge(tNode.acceptChildrenOfType(this, "InitNode"));
		
		// finally flatten CC children
		dumbART.merge(tNode.acceptChildrenOfType(this, "ConcurrentCompositeNode"));
		return dumbART;
	}

	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		AcceptReturnType retART = super.visitCompositeStateNode(tNode);
		
		retART.merge(tNode.acceptChildren(this));
		
		return retART;
	}

	public AcceptReturnType visitConcurrentCompositeBodyNode(
			ConcurrentCompositeBodyNode tNode) {
		AcceptReturnType retART = super.visitConcurrentCompositeBodyNode(tNode);
		
		retART.merge(tNode.acceptChildren(this));
		
		return retART;
	}

	public AcceptReturnType visitConcurrentCompositeNode(
			ConcurrentCompositeNode tNode) {
		AcceptReturnType retART = super.visitConcurrentCompositeNode(tNode);
		
		retART.merge(tNode.acceptChildren(this));
		
		return retART;
	}

	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
		return super.visitDriverFileNode(tNode);
	}

	public AcceptReturnType visitEnumNode(EnumNode tNode) {
		return super.visitEnumNode(tNode);
	}
	public AcceptReturnType visitEventNode(EventNode tNode) {
		return super.visitEventNode(tNode);
	}

	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		return super.visitHistoryNode(tNode);
	}

	public AcceptReturnType visitInitNode(InitNode tNode) {
		// Check to see if this init node is the child of a compositeState node
		// that is in the process of being flattened.
		CompositeStateBodyNode tParent = (CompositeStateBodyNode)tNode.getParent(); 
		if (!isFlattenableAsParent(tParent)) {
			return super.visitInitNode(tNode);								
		}
		AcceptReturnType retART = super.visitInitNode(tNode);
		
		// Create a new state node (and its body!)
		// Give the state the name of the composite state.
		StateNode newSNode = new StateNode(tParent.getID());
		StateBodyNode newSBNode = new StateBodyNode();
		// add the body to the state.
		rootNode.addChildToNode(newSNode, newSBNode);
		
		// Create a new transition Node! With its destination be whatever
		// the Init Node's destination would've been.
		TransitionNode newTransNode = new TransitionNode(tNode.getID());
		// Add the Transition to the state body.
		rootNode.addChildToNode(newSBNode, newTransNode);
		
		if (tNode.hasTransitionBodyNode()) {
  		  // Add this Init node's transition body to the new transition node
	      // This gives the transition a new parent.
		  rootNode.addChildToNode(newTransNode, tNode.subnode);
		}
		
		// Add the new state to the current composite state, since
		// the destination will obviously be renamed.
		rootNode.addChildToNode(tParent, newSNode);
		
		return retART;
	}

	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		return super.visitInstanceVariableNode(tNode);
	}

	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		return super.visitJoinNode(tNode);
	}

	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		return super.visitMessageNode(tNode);
	}

	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		return super.visitMessagesNode(tNode);
	}

	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType retART = super.visitModelBodyNode(tNode);
		retART.merge(tNode.acceptChildren(this));
		return retART;
	}

	public AcceptReturnType visitModelNode(ModelNode tNode) {
		AcceptReturnType retART = super.visitModelNode(tNode);
		retART.merge(tNode.acceptChildren(this));
		return retART;
	}

	public AcceptReturnType visitNode(aNode tNode) {
		return super.visitNode(tNode);
	}

	public AcceptReturnType visitNullNode(NullNode tNode) {
		return super.visitNullNode(tNode);
	}

	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		return super.visitSignalNode(tNode);
	}

	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		return super.visitStateBodyNode(tNode);
	}

	public AcceptReturnType visitStateNode(StateNode tNode) {
		return super.visitStateNode(tNode);
	}

	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		return super.visitTimeInvariantNode(tNode);
	}

	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		return super.visitTransitionActionNode(tNode);
	}

	public AcceptReturnType visitTransitionActionsNode(
			TransitionActionsNode tNode) {
		return super.visitTransitionActionsNode(tNode);
	}

	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		return super.visitTransitionBodyNode(tNode);
	}

	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		return super.visitTransitionNode(tNode);
	}	
}
