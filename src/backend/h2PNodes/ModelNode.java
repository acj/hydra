/*
 * Created on Jul 22, 2005
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
public class ModelNode extends aNode {
 
	public ModelBodyNode subnode;
	protected boolean hasModelBodyNodeBoolean = false;
	
    /**
     * @param theID
     */
    public ModelNode(String theID) {
        super(theID, "ModelNode");
        // TODO Auto-generated constructor stub
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitModelNode(this);
	}
	
	public boolean hasModelBodyNode() {
		return hasModelBodyNodeBoolean;
	}

	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("ModelBodyNode")) {
			subnode = (ModelBodyNode)newChild;
			hasModelBodyNodeBoolean = true;
		}
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName()
	 */
	public String getNodeName() {
		// TODO Auto-generated method stub
		return super.getNodeName(false, false);
	}

	
}
