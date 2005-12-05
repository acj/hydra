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
public class EventNode extends aNode {
	private String eventName = "";
    private String eventVariable = "";
    private String whenVariable = "";
    private String eventType = "";
    
    /**
     * @param theID
     */
    public EventNode(String theEventName, String theEventType, String theEventOrWhenVariable) {
        super(noID(), "EventNode");
        // TODO Auto-generated constructor stub
        eventName = theEventName;
        eventType = theEventType;
        eventVariable = theEventOrWhenVariable;
        whenVariable = theEventOrWhenVariable;
    }
    
   
	public AcceptReturnType accept(aVisitor v) {
		return v.visitEventNode(this);
	}
	
	public String getName() {
		return eventName;
	}
    
    public String getVariable(){
      return eventVariable;   
    }
    
    public String getWhenVariable() {
      return whenVariable;   
    }
    
    public String getEventType() {
      return eventType;
    }

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
	public String getDescription() {
        // returns the transition's description.
        String tmpStr = "";
        if (eventType.equals("normal")) {
        	tmpStr += eventName + "(" + eventVariable + ")";   
        }
        if (eventType.equals("when")) {
            tmpStr += "when (" + eventVariable + ")";   
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
