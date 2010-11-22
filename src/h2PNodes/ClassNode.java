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
public class ClassNode extends aNode {
 
	public ClassBodyNode subnode;
	protected boolean hasClassBodyNodeBoolean = false;
	
    /**
     * @param theID
     */
    public ClassNode(String theID) {
        super(theID, "ClassNode");
        // TODO Auto-generated constructor stub
    }
    

	public AcceptReturnType accept(aVisitor v) {
		return v.visitClassNode(this);
	}
	
	public boolean hasClassBodyNode() {
		return hasClassBodyNodeBoolean;
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("ClassBodyNode")) {
			subnode = (ClassBodyNode)newChild;
			hasClassBodyNodeBoolean = true;
		}
	}


	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName()
	 */
	public String getNodeName() {
		// TODO Auto-generated method stub
		return super.getNodeName(false, true);
	}


}
