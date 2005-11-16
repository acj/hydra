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
public class CompositeStateNode extends aNode {

    
	public CompositeStateBodyNode bodyNode = null;
	
    /**
     * @param theID
     */
    public CompositeStateNode(String theID) {
        super(theID, "CompositeStateNode");
        // TODO Auto-generated constructor stub
    }
    
/*	public void add(CompositeStateBodyNode tChild) {
		children.addElement(tChild);
	}*/
	
	public AcceptReturnType accept(aVisitor v) {
		return v.visitCompositeStateNode(this);
	}

	public void addChild(aNode newChild) {
		// TODO Auto-generated method stub
		super.addChild(newChild);
		
		if (newChild.getType().equals("CompositeStateBodyNode")) {
			bodyNode = (CompositeStateBodyNode)newChild;
		}
	}

}
