/*
 * Created on Jul 23, 2005
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
public class ClassBodyNode extends aNode {

    /**
     * @param theID
     */
    public ClassBodyNode() {
        super(noID(), "ClassBodyNode", true);
        // TODO Auto-generated constructor stub
    }
    

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitClassBodyNode(this);
	}
    
    public boolean hasStateMachine () {
      // boolean retVal = false;
      
      for (int i = 0; i < children.size(); i++) {
        aNode childNode = (aNode) children.get(i);
        if (childNode.getType().equals("StateNode") ||
            childNode.getType().equals("CompositeStateNode") ||
            childNode.getType().equals("ConcurrentCompositeNode")) {
          return true;
        }
      }
      
      return false;   
    }
}
