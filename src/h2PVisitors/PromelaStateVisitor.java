package h2PVisitors;

import h2PFoundation.AcceptReturnType;
import h2PNodes.CompositeStateNode;
import h2PNodes.ConcurrentCompositeNode;
import h2PNodes.StateNode;
import h2PNodes.TransitionNode;
import h2PNodes.aNode;

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
	
	// if necessary: (it's not.)
	public AcceptReturnType getOutputART () {
		return outsideOutput;
	}
	
	// TODO i should double check, but I *think* i got this one right.
    // TODO eliminate
	public boolean ifInArray (AcceptReturnType anART, String hashKey, String searchVal) {
        // Note: the original code assumed that a global copy of the output was kept,
        // here this is no longer necessary as we only look at partial copies of the output
        // we can thus limit to looking at the actual output we're generating!
        
        /*
		String entities[] = anART.getStrSplit(hashKey);
		
		/*if (entities.length == 4) { //TODO what the heck!?
			return false;
		}* / // we don't need THIS anymore! 
		AcceptReturnType tmpART = new AcceptReturnType();
		
		for (int i = 0; i < entities.length; i++) {
			if (i >= 4) {
				tmpART.addStr(hashKey, entities[i]);
			}
        return tmpART.ifInArray(hashKey, searchVal);
		}*/
        return anART.ifInArray(hashKey, searchVal);        
	}
	
	public aNode SearchIncluding (aNode tNode, String dest) {
		if (tNode.getID().equals(dest)) {
			if (tNode.getType().equals("StateNode") || tNode.getType().equals("CompositeStateNode") 
					|| tNode.getType().equals("ConcurrentCompositeNode")) {
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
			if (SorCSorCCS.getUniqueID().equals(CSNode.getUniqueID())) {
				outputString = strln ("        :: atomic{m == st_" + dest + " -> goto to_" + dest + "; skip;};");
				if (!ifInArray(outsideOutput, "CState", outputString)) {
					outsideOutput.addStr("CState", outputString);
				}
				if (!outsideOutput.ifInArray("mTypeList", "st_" + dest)) {
					outsideOutput.addStr("mTypeList", "st_" + dest);
				}
				
			}
			return tmpART; // (if 2nd if fails... ) #don't output anything
		}
		// #get $classNode
		aNode classNode = searchUpForDest(tNode, "ClassNode");
		SorCSorCCS = SearchIncluding(classNode, dest); //#inner function, search if $dest is in the subtree of $modelbodyNode (including) or not
		if (SorCSorCCS != null) {
			if (SorCSorCCS.getType().equals("StateNode")) {
				outputString = "        :: atomic{m == st_" + dest + " -> goto " + dest + "; skip;};";
				if (!ifInArray(outsideOutput, "CState", outputString)) {
					outsideOutput.addStr("CState", outputString);
				}
				if (!outsideOutput.ifInArray("mTypeList", "st_" + dest)) {
					outsideOutput.addStr("mTypeList", "st_" + dest);
				}
			}
			if (SorCSorCCS.getType().equals("CompositeStateNode") 
					|| SorCSorCCS.getType().equals("ConcurrentCompositeNode")) {
				outputString = "        :: atomic{m == st_" + dest + " -> goto to_" + dest + "; skip;};";
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
		// }
		
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
				// TODO check to see if the "outgoing" requirement is necessary here.
/*				TransitionNode tnNode = (TransitionNode)childNode;
				if (!tnNode.getDestinationType().equals("Outgoing")) {*
				tmpART.merge(tnNode.accept(this));
//				} */
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
				// TODO check to see if the "outgoing" requirement is necessary here. too!
			}
		}
		
		return tmpART;
	}

}
