package backend.PrologAnalysis;


import java.util.Set;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.Symbol;
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
import backend.h2PParser.UMLExpr;
import backend.h2PParser.genericLex1;
import backend.h2PVisitors.aVisitor;

/**
 * Visitor class to generate the Promela code for each node in the HIL parse
 * tree.
 */
public class PrologAnalysisVisitor extends aVisitor {
	protected genericLex1 genLex;
	protected UMLExpr exprParser;

	public PrologAnalysisVisitor() {
		super();
		AcceptReturnType globalOutputs = new AcceptReturnType();
		genLex = new genericLex1();
		exprParser = new UMLExpr(globalOutputs);
	}

	public AcceptReturnType visitNode(aNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitActionNode(ActionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasTransitionBodyNode()) {
            tmpART.merge(tNode.subnode.accept(this));
		}
		return tmpART;
	}

	public AcceptReturnType visitClassNode(ClassNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasClassBodyNode()) {
            tmpART.merge(tNode.classBodyNode.accept(this));
		}
		return tmpART;
	}

	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitConcurrentCompositeNode(
			ConcurrentCompositeNode tNode) {
	    AcceptReturnType tmpART = super.visitNode(tNode);
		return tmpART;
	}

	public AcceptReturnType visitDriverFileNode(DriverFileNode tNode) {
	    AcceptReturnType tmpART = super.visitNode(tNode);
		return tmpART;
	}

	public AcceptReturnType visitEnumNode(EnumNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitEventNode(EventNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		// Do sanity check on the event
		exprParser.parse(tNode, tNode.getDescription());
		System.err.println("Event!");
		Set<Symbol> referencedSyms = exprParser.getReferencedSymbols();
		for (Symbol sym : referencedSyms) {
		    System.err.println("Event sym: " + sym.getName());
		}
		return tmpART;
	}

	public AcceptReturnType visitHistoryNode(HistoryNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitInitNode(InitNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasTransitionBodyNode()) {
            tmpART.merge(tNode.subnode.accept(this));
		}
		return tmpART;
	}

	public AcceptReturnType visitInstanceVariableNode(InstanceVariableNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitJoinNode(JoinNode tNode) {
		AcceptReturnType tmpART = super.visitJoinNode(tNode);
		return tmpART;
	}

	public AcceptReturnType visitMessageNode(MessageNode tNode) {
		assert(tNode.getSignalName().length() > 0);
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (! tNode.getIntVarName().equals("")) {
		    exprParser.parse(tNode,	tNode.getIntVarName());
		}

		return tmpART;
	}

	public AcceptReturnType visitMessagesNode(MessagesNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		// TODO: Parse message text
		tmpART.merge(tNode.acceptChildren(this));
		return tmpART;
	}

	public AcceptReturnType visitModelNode(ModelNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
        if (tNode.hasModelBodyNode()) {
            tmpART.merge(tNode.subnode.accept(this));
        }
		String finalString = "";
        return AcceptReturnType.retString(finalString);
	}

	public AcceptReturnType visitNullNode(NullNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		return tmpART;
	}

	public AcceptReturnType visitSignalNode(SignalNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitStateNode(StateNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.bodyNode != null) {
            tmpART.merge(tNode.bodyNode.accept(this));
        }
		return tmpART;
	}

	public AcceptReturnType visitTransitionActionNode(TransitionActionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		String tmpStr = "";
		System.err.println("Transition!");
		String actType = tNode.getActionType();
		if (actType.equals("newaction")) {
		    String retVal = exprParser.parse(tNode, tNode.getContent());
		}
		if (actType.equals("sendmsg")) {
            if (tNode.hasMessageChild()) {
                tmpART.merge(tNode.messageChild.accept(this));
            }
        }
		if (actType.equals("assignstmt")) {
			String retVal = exprParser.parse(tNode,	tNode.getAssignment());
		}
		if (actType.equals("function")) {
			String retVal = exprParser.parse(tNode, tNode.getFunctionID() + "(" + tNode.getParamList() + ")");
		}

		return tmpART;
	}

	public AcceptReturnType visitTransitionActionsNode(
			TransitionActionsNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		// TODO: Parse action text
		System.err.println("Action: " + tNode.getDescription());
        tmpART.merge(tNode.acceptChildren(this));

		return tmpART;
	}

	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		if (tNode.hasBody()) {
            tmpART.merge(tNode.bodyChild.accept(this));
        }
		return tmpART;
	}

	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
        for (int i = 0; i < tNode.children.size(); i++) {
            aNode childNode = (aNode) tNode.children.get(i);
            if (childNode.getType().equals("InitNode")) {
                tmpART.merge(childNode.accept(this));
            }
            if (childNode.getType().equals("InstanceVariableNode")) {
                tmpART.merge(childNode.accept(this));
            }
            if (childNode.getType().equals("SignalNode")) {
                tmpART.merge(childNode.accept(this));
            }
            if (childNode.getType().equals("StateNode")) {
                tmpART.merge(childNode.accept(this));
            }
        }
		return tmpART;
	}

	public AcceptReturnType visitCompositeStateBodyNode(
			CompositeStateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		
		return tmpART;
	}

	public AcceptReturnType visitConcurrentCompositeBodyNode(
			ConcurrentCompositeBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;
	}

	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
        for (int i = 0; i < tNode.children.size(); i++) {
            aNode childNode = (aNode) tNode.children.get(i);
            if (childNode.getType().equals("ClassNode")) {
                tmpART.merge(childNode.accept(this));
            }
            if (childNode.getType().equals("DriverFileNode")) {
                childNode.accept(this).defV();
            }
            if (childNode.getType().equals("EnumNode")) {
                tmpART.merge(childNode.accept(this));
            }
        }
		return tmpART;
	}

	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		for (int i = 0; i < tNode.children.size(); i++) {
		    aNode childNode = (aNode) (tNode.children.get(i));

		    if (childNode.getType().equals("ActionNode")) {
		        ActionNode actNode = (ActionNode) childNode;
		        actNode.accept(this);
		    } else if (childNode.getType().equals("TransitionNode")) {
                TransitionNode tranNode = (TransitionNode) childNode;
                if (tranNode.hasBody()) {
                    if (tranNode.bodyChild.hasEventNodeChild()) {
                        tranNode.accept(this);
                    }
                }
            } else {
                System.err.println("Unhandled node type: " + childNode.getType());
            }
		}
		return tmpART;
	}

	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);
		// TODO: Check guard via tNode.getGuard()
        if (tNode.hasEventNodeChild()) {
            tmpART.merge(tNode.eventNodeChild.accept(this));
        }
        // These are TransitionActions Children
        if (tNode.hasActionsChild()) {
            tmpART.merge(tNode.actionsChild.accept(this));
        }
        if (tNode.hasMessagesChild()) {
            tmpART.merge(tNode.messagesChild.accept(this));
        }
		return tmpART;
	}

	public AcceptReturnType visitTimeInvariantNode(TimeInvariantNode tNode) {
		AcceptReturnType tmpART = super.visitNode(tNode);

		return tmpART;

	}
}
