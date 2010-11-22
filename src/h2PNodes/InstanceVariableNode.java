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
public class InstanceVariableNode extends aNode {
    
    private String vType = "";
    private String tVariable = "";
    private String initValue = "";
    
    /**
     * @param theID
     */
    public InstanceVariableNode(String theVType, String newVar, String anInitValue) {
        super(noID(), "InstanceVariableNode");
        // TODO Auto-generated constructor stub
        vType = theVType;
        tVariable = newVar;
        initValue = anInitValue;
    }
    

	public AcceptReturnType accept(aVisitor v) {
		return v.visitInstanceVariableNode(this);
	}
    
    public String getVType(){
      return vType;   
    }
    
    public String getVar(){
      return tVariable;   
    }
    
    public String getInitValue() {
      return initValue;   
    }


	public String getNodeVal(String valName) {
		// TODO Auto-generated method stub
		if (valName.equals("var")) {
			return getVar();
		}
		return super.getNodeVal(valName);
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName(boolean, boolean, boolean)
	 */
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return super.getNodeName(withClassName, withModelName, false) + this.getVar();		
	}


}
