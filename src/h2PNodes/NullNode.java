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
public class NullNode extends aNode {

    /**
     * @param theID
     */
    public NullNode(String theID) {
        super(theID, "NullNode");
    }
   

	public AcceptReturnType accept(aVisitor v) {
		return v.visitNullNode(this);
	}

}
