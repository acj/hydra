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
public class MessageNode extends aNode {
    
    private String className = "";
    private String signalName = "";
    private String intVarName = "";
    
    /**
     * @param theID
     */
    public MessageNode(String theClassName, String theSignalName, String theIntVarName) {
        super(noID(), "MessageNode");
        // TODO Auto-generated constructor stub
        className = theClassName;
        signalName = theSignalName;
        intVarName = theIntVarName;
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitMessageNode(this);
	}

    public String getClassName() {
      return className;   
    }
    
    public String getSignalName() {
      return signalName;   
    }
    
    public String getIntVarName() {
      return intVarName;   
    }
	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getDescription()
	 */
	public String getDescription() {
        // returns the transition's description.
        String tmpStr = "";
        if (className.length() > 0) {
            tmpStr += className + ".";   
          }
        tmpStr += signalName;
        if (intVarName.length() > 0) {
           tmpStr += "(" + intVarName + ")";   
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
