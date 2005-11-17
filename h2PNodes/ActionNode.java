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
public class ActionNode extends aNode {
	public TransitionBodyNode subnode; // Perl equiv={tran}
	protected boolean hasTransitionBodyNode = false;
	
	/**
	 * @param theID
	 */
	public ActionNode(String theID) {
		super(theID, "ActionNode");
	}
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitActionNode(this);
	}
	
	public boolean hasTransitionBodyNode() {
		return hasTransitionBodyNode;
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("TransitionBodyNode")) {
			subnode = (TransitionBodyNode)newChild;
			hasTransitionBodyNode = true;
		}
	}

}
