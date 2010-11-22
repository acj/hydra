/*
 * Created on Jul 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PVisitors.aVisitor;

import java.util.Vector;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class StateBodyNode extends aNode {

	public Vector transitionNodeChildren;
	public Vector actionNodeChildren;
	
    /**
     * @param theID
     */
    public StateBodyNode() {
        super(noID(), "StateBodyNode", true);
        // TODO Auto-generated constructor stub
        transitionNodeChildren = new Vector();
        actionNodeChildren = new Vector();
    }
    
    // transitionNodeChildren and actionNodeChildren are 
    // just pointers to objects of their respective types.
    public void addChild(aNode newChild){
        super.addChild(newChild);
        if (newChild.getType().equals("ActionNode")) {
            actionNodeChildren.addElement(newChild);            
        }
        if (newChild.getType().equals("TransitionNode")) {
            transitionNodeChildren.addElement(newChild);            
        }
    }
    
    
	// StateBodyNode's children are its transitionNodes ?? <-- too vague
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitStateBodyNode(this);
	}
	
	/*
	public String getDestType () {
		return "";
	}
	*/
}
