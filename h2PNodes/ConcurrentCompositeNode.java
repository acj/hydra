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
public class ConcurrentCompositeNode extends aNode {
	
	public ConcurrentCompositeBodyNode bodyNode = null;
	
    /**
     * @param theID
     */
    public ConcurrentCompositeNode(String theID) {
        super(theID, "ConcurrentCompositeNode");
        // TODO Auto-generated constructor stub
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitConcurrentCompositeNode(this);
	}

	public void addChild(aNode newChild) {
		// TODO Auto-generated method stub
		super.addChild(newChild);
		
		if (newChild.getType().equals("ConcurrentCompositeBodyNode")) {
			bodyNode = (ConcurrentCompositeBodyNode) newChild;
		}
	}

}
