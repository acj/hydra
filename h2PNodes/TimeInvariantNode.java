/*
 * Created on Jul 25, 2005
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
public class TimeInvariantNode extends aNode {

    /**
     * @param theID
     */
	
	private String timeInvariant = ""; // TODO! double check!
	private String timeInvarType = "";
	
    public TimeInvariantNode(String tiType, String timeInvariantExpression) {
        super(noID(), "TimeInvariantNode");
        // TODO Auto-generated constructor stub
        timeInvariant = timeInvariantExpression;
        timeInvarType = tiType;
    }
    
    public String getTimeInvariant () {
    	return timeInvariant;
    }
    
    public String getTimeInvariantType () {
    	return timeInvarType;
    }
    
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitTimeInvariantNode(this);
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName(boolean, boolean, boolean)
	 */
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		if (this.hasParent()) {
			return this.getParent().getNodeName(withClassName, withModelName, withID);
		} else {
			return super.getNodeName(withClassName, withModelName, withID);
		}
	}

}
