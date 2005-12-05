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
public class TransitionBodyNode extends aNode {

	public EventNode eventNodeChild = null;
	public TransitionActionsNode actionsChild = null; //tentative.
	public MessagesNode messagesChild = null;
    protected boolean hasEventNodeChildBoolean = false;
    protected boolean hasActionsChildBoolean = false;
    protected boolean hasMessagesBoolean = false;
    protected String guard = "";
    // public Vector transitionList;

    /**
	 * @param theID
	 */
	public TransitionBodyNode(String theGuard) {
		super(noID(), "TransitionBodyNode", true);
		// TODO Auto-generated constructor stub
		guard = theGuard;
		// transitionList = new Vector();
	}
    
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#accept(h2PVisitors.aVisitor)
	 */
	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
		return v.visitTransitionBodyNode(this);
	}
	
	public boolean hasEventNodeChild() {
		return hasEventNodeChildBoolean;
	}
	
	public boolean hasActionsChild() {
		return hasActionsChildBoolean;
	}
	
	public boolean hasMessagesChild() {
		return hasMessagesBoolean;
	}
    
    public boolean hasGuard() {
        return (guard.length() > 0);
    }
    
    public String getGuard() {
    	return guard;
    }
    
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("EventNode")) {
			eventNodeChild = (EventNode)newChild;
			hasEventNodeChildBoolean = true;
		}
		if (newChild.getType().equals("TransitionActionsNode")) {
			actionsChild = (TransitionActionsNode)newChild;
			hasActionsChildBoolean = true;
		}
		if (newChild.getType().equals("MessagesNode")) {
			messagesChild = (MessagesNode)newChild;
			hasMessagesBoolean = true;
		}
	}
	
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
	public String getDescription() {
        // returns the transition's description.
        String tmpStr = "(";
        if (hasEventNodeChild()) {
            tmpStr += "evt:" + eventNodeChild.getDescription();
        }
        tmpStr += getGuard();
        if (hasActionsChild()) {
            tmpStr += actionsChild.getDescription();
        }
        if (hasMessagesChild()) {
        	tmpStr += messagesChild.getDescription(); 
        }
        return tmpStr + ")";
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName()
	 */
}
