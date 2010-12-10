/*
 * Created on Jul 23, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PVisitors.aVisitor;

import java.util.Vector;


/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CompositeStateBodyNode extends aNode {

	// TODO verify that this only has one history child
    protected HistoryNode tHistoryChild = null;
    protected boolean hasHistoryNodeVar = false;
    public Vector<aNode> transitionNodeChildren;

    /**
     * @param theID
     */
    public CompositeStateBodyNode() {
        super(noID(), "CompositeStateBodyNode", true);
        // TODO Auto-generated constructor stub
        transitionNodeChildren = new Vector<aNode>();
    }
    
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitCompositeStateBodyNode(this);
	}
    
    public boolean hasHistoryNode () {
      return hasHistoryNodeVar;   
    }
    
    public HistoryNode getHistoryNode () {
    	return tHistoryChild;
    }

    public void addChild(aNode newChild){
        super.addChild(newChild);
        if (newChild.getType().equals("HistoryNode")) {
            tHistoryChild = (HistoryNode)newChild;
            hasHistoryNodeVar = true;
        }
        if (newChild.getType().equals("TransitionNode")) {
            transitionNodeChildren.addElement(newChild);            
        }
    }

}
