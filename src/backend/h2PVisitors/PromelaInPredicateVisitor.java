package backend.h2PVisitors;


import java.util.Vector;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PNodes.ClassBodyNode;
import backend.h2PNodes.ClassNode;
import backend.h2PNodes.CompositeStateBodyNode;
import backend.h2PNodes.CompositeStateNode;
import backend.h2PNodes.ConcurrentCompositeBodyNode;
import backend.h2PNodes.ConcurrentCompositeNode;
import backend.h2PNodes.EventNode;
import backend.h2PNodes.ModelBodyNode;
import backend.h2PNodes.ModelNode;
import backend.h2PNodes.StateBodyNode;
import backend.h2PNodes.StateNode;
import backend.h2PNodes.TransitionBodyNode;
import backend.h2PNodes.TransitionNode;
import backend.h2PNodes.aNode;
import backend.h2PParser.UMLExpr;

/**
 * Uses the Expression Grammar to find "in" predicates in an expression
 * in order to build an INPredicateTarget list for a given model.
 */
public class PromelaInPredicateVisitor extends aVisitor {

	public AcceptReturnType INPredicateTarget;
	public UMLExpr ExpressionParser;
	
	public PromelaInPredicateVisitor(AcceptReturnType globalOutputs) {
		super();
		
		INPredicateTarget = new AcceptReturnType();
		callVisitNodeAlways = false; 
		ExpressionParser = new UMLExpr(globalOutputs);
		ExpressionParser.setPromelaInPVisitor(this);
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
			result = ExpressionParser.parse(tNode, tNode.getGuard());
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
			result = ExpressionParser.parse(tNode, "when(" + tNode.getWhenVariable() + ")");
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
