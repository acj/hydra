/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PVisitors.aVisitor;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TransitionNode extends aNode {
	
	private boolean hasTransitionBody;
	public TransitionBodyNode bodyChild;
	protected String destination = "";
	protected String destinationType = "";
    protected aNode formerCStateParent = null;
		
	/**
	 * @param theID
	 */
	public TransitionNode(String destinationVal) {
		super(noID(), "TransitionNode");
		// TODO Auto-generated constructor stub
        hasTransitionBody = false;
        destination = destinationVal;
	}
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitTransitionNode(this);
	}
	
	public boolean hasBody(){
		return hasTransitionBody;
	}
	
	//TODO implement these two!
	public String getDestination(){
		return destination;
	}
	
	// There's no reason TransitionNode can't figure
	// out its own destination Type! (ok so little reason)
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
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
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
}
