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
public class HistoryNode extends aNode {
    
    public TransitionBodyNode tbnChild;
    protected boolean hasTBNChildBoolean = false;
    
    /**
     * @param theID
     */
    public HistoryNode(String theID) {
        super(theID, "HistoryNode");
        // TODO Auto-generated constructor stub
    }
    

	public AcceptReturnType accept(aVisitor v) {
		return v.visitHistoryNode(this);
	}
    
    public boolean hasTBNChild() {
      return hasTBNChildBoolean;   
    }

	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("TransitionBodyNode")) {
			tbnChild = (TransitionBodyNode)newChild;
			hasTBNChildBoolean = true;
		}
	}
    
}
