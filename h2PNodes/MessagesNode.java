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
public class MessagesNode extends aNode {

    /**
     * @param theID
     */
    public MessagesNode() {
        super(noID(), "MessagesNode");
        // TODO Auto-generated constructor stub
    }

	public AcceptReturnType accept(aVisitor v) {
		return v.visitMessagesNode(this);
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
	public String getDescription() {
        // returns the transition's description.
        String tmpStr = "";
        for (int i = 0; i < children.size(); i++) {
          aNode childNode = (aNode) children.get(i);
          tmpStr += "^" + childNode.getDescription();
        }
        return tmpStr;
	}
}
