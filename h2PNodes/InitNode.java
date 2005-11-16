/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PVisitors.*;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InitNode extends aNode {

    public TransitionBodyNode subnode;
    private boolean hasTBNInit = false;
    
    /**
     * @param theID
     */
    public InitNode(String theID) {
        super(theID, "InitNode");
        // TODO Auto-generated constructor stub
    }
    

	public AcceptReturnType accept(aVisitor v) {
		return v.visitInitNode(this);
	}
    
    public boolean hasTransitionBodyNode() {
      return hasTBNInit;  
    }

	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("TransitionBodyNode")) {
			subnode = (TransitionBodyNode)newChild;
			hasTBNInit = true;
		}
	}

}
