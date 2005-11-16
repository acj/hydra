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
public class TransitionActionNode extends aNode {
	
	public MessageNode messageChild;
	protected boolean hasMessageChildBoolean = false;
	protected String actionType = "";
	protected String content = "";
	protected String assignment = "";
	protected String paramList = "";
	protected String functionID = "";
    
    /**
     * @param theID
     */
    public TransitionActionNode(String firstParam) {
        this (firstParam, "", "", "");
    }

    public TransitionActionNode(String firstParam, String secondParam) {
        this (firstParam, secondParam, "", "");
    }

    public TransitionActionNode(String firstParam, String secondParam, String thirdParam) {
        this (firstParam, secondParam, thirdParam, "");
    }

    public TransitionActionNode(String theActionType, String firstParam, String secondParam, String thirdParam) {
        super(noID(), "TransitionActionNode");
        actionType = theActionType;
        if (actionType.equals("newaction")) {
          content = firstParam;
        }
        if (actionType.equals("sendmsg")) {
        	// do nothing! }
        }
        if (actionType.equals("assignstmt")) {
          assignment = firstParam;
        }
        if (actionType.equals("printstmt")) {
          content = firstParam;
          paramList = secondParam;
        }
        if (actionType.equals("function")) {
          functionID = firstParam;
          paramList = secondParam;
        }
    }
    

	public String getActionType() {
	  return actionType;	
	}
	
	public String getContent() {
		return content;
	}
	
	public String getPrintContent() {
		return content;
	}
	
	public String getAssignment () {
		return assignment;
	}
	
	public String getParamList() {
		return paramList;
	}
	
	public String getFunctionID() {
		return functionID;
	}
	
	public AcceptReturnType accept(aVisitor v) {
		return v.visitTransitionActionNode(this);
	}

	public boolean hasMessageChild() {
		return hasMessageChildBoolean;
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("MessageNode")) {
			messageChild = (MessageNode)newChild;
			hasMessageChildBoolean = true;
		}
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
	public String getDescription() {
        // returns the transition's description.
        String tmpStr = "";
        if (actionType.equals("newaction")) {
            tmpStr += "new (" + content + ")";
        }
        if (actionType.equals("sendmsg")) {
            tmpStr += "send (" + messageChild.getDescription() + ")";
        }
        if (actionType.equals("printstmt")) {
            tmpStr += "print ('"+content + "'," + paramList + ")";
        }
        if (actionType.equals("assignstmt")) {
            tmpStr += assignment;
        }
        if (actionType.equals("function")) {
       	    tmpStr += functionID + " (" + paramList + ")";
        }
        return tmpStr;
	}
}
