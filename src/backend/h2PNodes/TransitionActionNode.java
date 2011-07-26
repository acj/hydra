package backend.h2PNodes;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PVisitors.aVisitor;

public class TransitionActionNode extends aNode {
	
	public MessageNode messageChild;
	protected boolean hasMessageChildBoolean = false;
	protected String actionType = "";
	protected String content = "";
	protected String assignment = "";
	protected String paramList = "";
	protected String functionID = "";
    
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
			// Prepend the class name, if we have one
			if (!thirdParam.equals("")) {
				functionID = thirdParam + "." + firstParam;
			}
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
	
	public String getAssignment() {
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
