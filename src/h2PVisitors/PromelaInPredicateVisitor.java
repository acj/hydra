package h2PVisitors;

import h2PFoundation.AcceptReturnType;
import h2PNodes.ClassBodyNode;
import h2PNodes.ClassNode;
import h2PNodes.CompositeStateBodyNode;
import h2PNodes.CompositeStateNode;
import h2PNodes.ConcurrentCompositeBodyNode;
import h2PNodes.ConcurrentCompositeNode;
import h2PNodes.EventNode;
import h2PNodes.ModelBodyNode;
import h2PNodes.ModelNode;
import h2PNodes.StateBodyNode;
import h2PNodes.StateNode;
import h2PNodes.TransitionBodyNode;
import h2PNodes.TransitionNode;
import h2PNodes.aNode;
import h2PVisitors.Parser.UMLExpr;

import java.util.Vector;

// PromelaInPredicateVisitor
/*
 *  Uses the Expression Grammar to fin "in" predicates in an expression
 *  in order to buil an INPredicateTarget list for a given model.
 */
public class PromelaInPredicateVisitor extends aVisitor {

	public AcceptReturnType INPredicateTarget;
	public UMLExpr ExpressionParser;
	
	public PromelaInPredicateVisitor(AcceptReturnType globalOutputs) {
		super();
		
		INPredicateTarget = new AcceptReturnType();
		callVisitNodeAlways = false; 
		ExpressionParser = new UMLExpr(globalOutputs, this);
	}

	public void INTarget (ClassBodyNode tNode, String target) {
		AddNewINPredicate (tNode, target);
	}
	
	public void AddNewINPredicate (ClassBodyNode tNode, String target) {
		Vector<Object> vec = INPredicateTarget.getGen("default");
		AcceptReturnType INPredicateHash, InPredicateList;
		ClassBodyNode cbRef;
		
		for (int i = 0; i < vec.size(); i++) {
			INPredicateHash = (AcceptReturnType)vec.get(i);
			cbRef = (ClassBodyNode)INPredicateHash.getSingle("cbreference");
			if (tNode.getUniqueID().equals(cbRef.getUniqueID())) {
				InPredicateList = (AcceptReturnType)INPredicateHash.getSingle("list");
				if (!InPredicateList.ifInArray("default", target)) {
					InPredicateList.addStr("default", target);
				}
				return;
			}
		}
		
		// add new Entry.
		
		INPredicateHash = new AcceptReturnType();
		INPredicateHash.addSingle("cbreference", tNode);
		
		InPredicateList = new AcceptReturnType();
		InPredicateList.addStr("default", target);
	}
	
	public AcceptReturnType visitModelBodyNode(ModelBodyNode tNode) {
		AcceptReturnType tmpART = super.visitModelBodyNode(tNode);
		
		// really this merge will be empty!
		tmpART.merge(tNode.acceptChildrenOfType(this, "ClassNode"));
		
		tmpART.merge(INPredicateTarget); // sure! why not? let's make it easy to get!
		return tmpART;
	}

	public AcceptReturnType visitClassBodyNode(ClassBodyNode tNode) {
		AcceptReturnType tmpART = super.visitClassBodyNode(tNode);
		
		tmpART.merge(tNode.acceptChildrenOfType(this, "StateNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "CompositeStateNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "ConcurrentCompositeNode"));
		
		return tmpART;
	}

	public AcceptReturnType visitStateBodyNode(StateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitStateBodyNode(tNode);
		
		tmpART.merge(tNode.acceptChildrenOfType(this, "TransitionNode"));
		
		return tmpART;
	}

	public AcceptReturnType visitCompositeStateBodyNode(
			CompositeStateBodyNode tNode) {
		AcceptReturnType tmpART = super.visitCompositeStateBodyNode(tNode);
		
		tmpART.merge(tNode.acceptChildrenOfType(this, "CompositeStateNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "ConcurrentCompositeNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "TransitionNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "StateNode"));
		
		return tmpART;
	}

	public AcceptReturnType visitConcurrentCompositeBodyNode(
			ConcurrentCompositeBodyNode tNode) {
		AcceptReturnType tmpART = super.visitConcurrentCompositeBodyNode(tNode);
		
		tmpART.merge(tNode.acceptChildrenOfType(this, "CompositeStateNode"));
		tmpART.merge(tNode.acceptChildrenOfType(this, "StateNode"));
		
		return tmpART;
	}

	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		AcceptReturnType tmpART = super.visitTransitionNode(tNode);
		
		if (tNode.hasBody()) {
		  tmpART.merge(tNode.bodyChild.accept(this));
		}
		
		return tmpART;
	}

	public AcceptReturnType visitTransitionBodyNode(TransitionBodyNode tNode) {
		AcceptReturnType tmpART = super.visitTransitionBodyNode(tNode);
		
		if (tNode.hasEventNodeChild()) {
		  tmpART.merge(tNode.eventNodeChild.accept(this));
		}
		
		if (tNode.hasGuard()) {
			String result = "";
			
			/*
			 *  ExprYaccForPromelaPak->PassRef($thetransitionbodynode);
        my $result=ExprYaccForPromela->Parse("$thetransitionbodynode->{guard}");
			 *  
			 */
			result = ExpressionParser.Parse_Me(tNode, tNode.getGuard());
			if (result.length() == 0) {
				aNode classRef = searchUpForDest(tNode,"ClassNode");
				println("In Class [" + classRef.getID() + "], bad expression [" + tNode.getGuard() + ")]!");
				exit(); 
			}
		}
		
		return tmpART;
	}

	public AcceptReturnType visitEventNode(EventNode tNode) {
		AcceptReturnType tmpART = super.visitEventNode(tNode);
		
		if (tNode.getEventType().equals("when")) {
			String result = "";
			
			/*
			 *  ExprYaccForPromelaPak->PassRef($theeventnode);
        my $result=ExprYaccForPromela->Parse("when($theeventnode->{whenvar})");
			 *  
			 */
			result = ExpressionParser.Parse_Me(tNode, "when(" + tNode.getWhenVariable() + ")");
			if (result.length() == 0) {
				aNode classRef = searchUpForDest(tNode,"ClassNode");
				print("In Class [" + classRef.getID() + "], bad expression [when(" + tNode.getWhenVariable() + ")]!");
				exit(); 
			}
		}
		
		return tmpART;
	}

	public AcceptReturnType visitModelNode(ModelNode tNode) {
		return tNode.acceptChildren(this);
	}

	public AcceptReturnType visitClassNode(ClassNode tNode) {
		return tNode.acceptChildren(this);
	}

	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		return tNode.acceptChildren(this);
	}

	public AcceptReturnType visitConcurrentCompositeNode(
			ConcurrentCompositeNode tNode) {
		return tNode.acceptChildren(this);
	}

	public AcceptReturnType visitStateNode(StateNode tNode) {
		return super.visitStateNode(tNode);
	}

}
