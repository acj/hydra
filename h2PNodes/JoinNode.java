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
public class JoinNode extends aNode {

    protected String fromID = "";
    protected String toID = "";
    
    /**
     * @param theID
     */
    public JoinNode(String theID, String theFromID, String theToID) {
        super(theID, "JoinNode");
        // TODO Auto-generated constructor stub
        fromID = theFromID;
        toID = theToID;
    }
    
    public String getFromID() {
      return fromID;   
    }
    
    public String getToID () {
      return toID;   
    }
    

    public AcceptReturnType accept(aVisitor v) {
		return v.visitJoinNode(this);
	}

}
