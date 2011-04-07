package h2PVisitors;

import h2PFoundation.AcceptReturnType;
import h2PNodes.CompositeStateNode;
import h2PNodes.ConcurrentCompositeNode;
import h2PNodes.StateNode;
import h2PNodes.TransitionNode;
import h2PNodes.aNode;

/**
 * Supports Hil2PromelaVisitor by generating Promela code for composite
 * states.
 */
public class PromelaStateVisitor extends aVisitor {
	protected aNode CSNode = null;
	protected AcceptReturnType outsideOutput;
	
	public PromelaStateVisitor() {
		super();
		callVisitNodeAlways = false; 
		// by default the output is empty.
		outsideOutput = new AcceptReturnType();
	}

	public PromelaStateVisitor(AcceptReturnType anOutputART) {
		this();
		setOutputART(anOutputART);
	}

	public void setNodeToTest (aNode theTestNode) {
		CSNode = theTestNode;
	}
	
	public void setOutputART (AcceptReturnType theART) {
		outsideOutput = theART;
	}
	
	public AcceptReturnType getOutputART () {
		return outsideOutput;
	}
	
	public boolean ifInArray (AcceptReturnType anART, String hashKey, String searchVal) {
        return anART.ifInArray(hashKey, searchVal);        
	}
	
	public aNode SearchIncluding (aNode tNode, String dest) {
		if (tNode.getID().equals(dest)) {
			if (tNode.getType().equals("StateNode") ||
					tNode.getType().equals("CompositeStateNode") ||
					tNode.getType().equals("ConcurrentCompositeNode")) {
				return tNode;
			}
		}
		
		for (int i = 0; i < tNode.children.size(); i++) { // there should only be one child
			aNode body = (aNode)tNode.children.get(i);
			for (int j = 0; j < body.children.size(); j++) {
				aNode retVal = SearchIncluding ((aNode)body.children.get(j), dest);
				if (retVal != null) {
					return retVal;
				}
			}
		}
		return null;
	}
	
	public aNode SearchExcluding (aNode tNode, String dest) {
		aNode tmpNode = SearchIncluding (tNode, dest);
		
		if (tmpNode == null) {
			return null;
		}
		if (tmpNode.getUniqueID().equals(tNode.getUniqueID())) {
			return null;
		}
		return tmpNode;
	}
	
	public AcceptReturnType visitTransitionNode(TransitionNode tNode) {
		AcceptReturnType tmpART = super.visitTransitionNode(tNode);		
		
		String dest = tNode.getDestination(); 
		String outputString = "";
		
		aNode SorCSorCCS = SearchIncluding(CSNode, dest);
		if (SorCSorCCS != null) {
			// We found the destination within the same composite state
			if (SorCSorCCS.getUniqueID().equals(CSNode.getUniqueID())) {
				outputString = strln ("        " +
						":: atomic{m == st_" + dest + " ->" +
						" goto to_" + dest + "; skip;};");
				if (!ifInArray(outsideOutput, "CState", outputString)) {
					outsideOutput.addStr("CState", outputString);
				}
				if (!outsideOutput.ifInArray("mTypeList", "st_" + dest)) {
					outsideOutput.addStr("mTypeList", "st_" + dest);
				}
			}
			return tmpART;
		}
		// The destination lies outside the current state
		aNode classNode = searchUpForDest(tNode, "ClassNode");
		SorCSorCCS = SearchIncluding(classNode, dest);
		if (SorCSorCCS != null) {
			if (SorCSorCCS.getType().equals("StateNode")) {
				// TODO: Needs to provide a mechanism to jump to a simple
				// state within another composite state if that's where we need
				// to go
				outputString = "        :: atomic{m == st_" + dest + " ->" +
					" goto " + dest + "; skip;};";
				if (!ifInArray(outsideOutput, "CState", outputString)) {
					outsideOutput.addStr("CState", outputString);
				}
				if (!outsideOutput.ifInArray("mTypeList", "st_" + dest)) {
					outsideOutput.addStr("mTypeList", "st_" + dest);
				}
			}
			if (SorCSorCCS.getType().equals("CompositeStateNode") 
					|| SorCSorCCS.getType().equals("ConcurrentCompositeNode")) {
				outputString = "        :: atomic{m == st_" + dest + " ->"
					+ " goto to_" + dest + "; skip;};";
				if (!ifInArray(outsideOutput, "CState", outputString)) {
					outsideOutput.addStr("CState", outputString);
				}
				if (!outsideOutput.ifInArray("mTypeList", "st_" + dest)) {
					outsideOutput.addStr("mTypeList", "st_" + dest);
				}
			}
		}
		return tmpART;
	}

	public AcceptReturnType visitStateNode(StateNode tNode) {
		AcceptReturnType tmpART = super.visitStateNode(tNode);		
		
		if (tNode.bodyNode == null) { return tmpART; }
		for (int j = 0; j < tNode.bodyNode.children.size(); j++) {
			aNode childNode = (aNode) tNode.bodyNode.children.get(j);
				
			if (childNode.getType().equals("TransitionNode")) {
				TransitionNode tnNode = (TransitionNode)childNode;
				if (!tnNode.getDestinationType().equals("Outgoing")) {
					tmpART.merge(tnNode.accept(this));
				}
			}
		}
		return tmpART;
	}

	public AcceptReturnType visitCompositeStateNode(CompositeStateNode tNode) {
		AcceptReturnType tmpART = super.visitCompositeStateNode(tNode);		
		
		if (tNode.bodyNode == null) { return tmpART; }
		for (int j = 0; j < tNode.bodyNode.children.size(); j++) {
			aNode childNode = (aNode) tNode.bodyNode.children.get(j);
				
			if (   (childNode.getType().equals("TransitionNode"))     || (childNode.getType().equals("StateNode"))
			    || (childNode.getType().equals("CompositeStateNode")) || (childNode.getType().equals("ConcurrentCompositeNode"))) {
				tmpART.merge(childNode.accept(this));
			}
		}
		return tmpART;
	}

	public AcceptReturnType visitConcurrentCompositeNode(
			ConcurrentCompositeNode tNode) {
		AcceptReturnType tmpART = super.visitConcurrentCompositeNode(tNode);		
		
		if (tNode.bodyNode == null) { return tmpART; }
		for (int j = 0; j < tNode.bodyNode.children.size(); j++) {
			aNode childNode = (aNode) tNode.bodyNode.children.get(j);
				
			if (childNode.getType().equals("CompositeStateNode"))  {
				tmpART.merge(childNode.accept(this));
			}
		}
		return tmpART;
	}
}
