package backend.h2PNodes;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PVisitors.aVisitor;

public class TransitionNode extends aNode {
	
	private boolean hasTransitionBody;
	public TransitionBodyNode bodyChild;
	protected String destination = "";
	protected String destinationType = "";
    protected aNode formerCStateParent = null;
    
	public TransitionNode(String destinationVal) {
		super(noID(), "TransitionNode");
        hasTransitionBody = false;
        destination = destinationVal;
	}
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitTransitionNode(this);
	}
	
	public boolean hasBody(){
		return hasTransitionBody;
	}
	
	public String getDestination(){
		return destination;
	}
	
	public String getDestinationType(){
		return destinationType;
	}
	
	public void setDestinationType(String newDestType){
		destinationType = newDestType;
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("TransitionBodyNode")) {
			bodyChild = (TransitionBodyNode)newChild;
			hasTransitionBody = true;
		}
	}
	
    public void setFormerCStateParent (CompositeStateBodyNode tNode) {
        formerCStateParent = tNode;   
    }
    
    public aNode getFormerCStateParent () {
        return formerCStateParent;
    }
    
	public String getDescription() {
		// returns the transition's description.
        String dest, tmpStr = "";
        dest = searchUpForDest(this, "ClassNode").getID() + "." + getDestination();
        tmpStr = "Transition to " + dest;
        if (hasTransitionBody) {
          tmpStr += " " + bodyChild.getDescription();   
        }
		return tmpStr;
	}
	
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		if (this.hasParent()) {
			return this.getParent().getNodeName(withClassName, withModelName, withID);
		} else {
			return super.getNodeName(withClassName, withModelName, withID);
		}
	}
}
