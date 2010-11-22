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
public class StateNode extends aNode {

	public StateBodyNode bodyNode = null;
    /**
     * @param theID
     */
    public StateNode(String theID) {
        super(theID, "StateNode");
        // TODO Auto-generated constructor stub
    }
   

	public AcceptReturnType accept(aVisitor v) {
		return v.visitStateNode(this);
	}


	public void addChild(aNode newChild) {
		// TODO Auto-generated method stub
		super.addChild(newChild);
		if (newChild.getType().equals("StateBodyNode")) {
			bodyNode = (StateBodyNode)newChild;
		}
	}
	
	public boolean hasBodyNode (){
		return (bodyNode != null);
	}

}
