/*
 * Created on Jul 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package backend.h2PNodes;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PVisitors.aVisitor;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

/* now THIS is overkill! */
public class ConcurrentCompositeBodyNode extends aNode {

    
    /**
     * @param theID
     */
    public ConcurrentCompositeBodyNode() {
        super(noID(), "ConcurrentCompositeBodyNode", true);
        // TODO Auto-generated constructor stub
    }
    
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitConcurrentCompositeBodyNode(this);
	}
}
