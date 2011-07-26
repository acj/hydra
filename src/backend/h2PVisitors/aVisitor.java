/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package backend.h2PVisitors;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.NodeUtilityClass;
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
import backend.h2PNodes.aNode;

/**
 * Abstract visitor class.
 */
public abstract class aVisitor extends NodeUtilityClass {
	protected boolean callVisitNodeAlways; /* defaults to true */

	/**
	 * 
	 */
	public aVisitor() {
		super();
		callVisitNodeAlways = true;
	}

	// We use the AcceptReturnType class in order to allow visitors to
	// return data of any type and structure, although it will be primarily
	// used for string hashes.
	public AcceptReturnType visitNode(aNode tNode) {
		// This allows visitors to do something general with their nodes
		return AcceptReturnType.nil();
	}

	// visitModelNode takes care of modelNode
	public AcceptReturnType visitModelNode(ModelNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}

	// visitModelBodyNode takes care of modelbodyNode
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		// else
		return AcceptReturnType.nil();

	}

	// visitClassNode takes care of ClassNode
	public AcceptReturnType visitClassNode(ClassNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}

	// visitClassBodyNode takes care of classbodyNode
	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}

	// from DriverfileNode.pm
	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}

	// from SignalNode.pm
	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of ccStateNode
	public AcceptReturnType visitConcurrentCompositeNode(ConcurrentCompositeNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of ccstatebodyNode
	public AcceptReturnType visitConcurrentCompositeBodyNode(ConcurrentCompositeBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of cstateNode
	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of cstatebodyNode
	public AcceptReturnType visitCompositeStateBodyNode(CompositeStateBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}
	
	// -- takes care of enumNode
	public AcceptReturnType visitEnumNode(EnumNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of stateNode
	public AcceptReturnType visitStateNode(StateNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// -- takes care of statebodyNode
	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// InitNode.pm
	public AcceptReturnType visitInitNode(InitNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// HistoryNode.pm
	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// JoinNode.pm
	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// This class replaces TransNode
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// This class replaces transisitionbody
	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// ActionNode.pm
	public AcceptReturnType visitActionNode(ActionNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// InstVarNode.pm
	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// NullNode.pm
	public AcceptReturnType visitNullNode(NullNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// eventNode.pm
	public AcceptReturnType visitEventNode(EventNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// tranactionsNode.pm
	public AcceptReturnType visitTransitionActionsNode(TransitionActionsNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// tranactionNode.pm
	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// messageNode.pm
	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
//		else
		return AcceptReturnType.nil();
	}

	// messagesNode.pm
	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}

	// timeinvariantnode.pm
	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		if (callVisitNodeAlways) {
			return visitNode(tNode);
		}
		//else
		return AcceptReturnType.nil();
	}
}
