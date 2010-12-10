/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.SymbolTable;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SignalNode extends aNode {
    
    private String name = "";
    private String sigType = "";
    
    /**
     * @param theID
     */
    public SignalNode(String signame) {
        super(noID(), "SignalNode");
        // TODO Auto-generated constructor stub
        name = signame;
    }
    
    public SignalNode(String sigName, String signalType, String className) {
        this(sigName);
        sigType = signalType;
        SymbolTable.addSymbol(sigName, SymbolType.SIGNAL, className);
    }
    

	public AcceptReturnType accept(aVisitor v) {
		return v.visitSignalNode(this);
	}
    
    public String getName() {
      return name;   
    }
    
    public String getSignalType(){
      return sigType;    
    }

	public String getNodeVal(String valName) {
		// TODO Auto-generated method stub
		if (valName.equals("name")) {
			return getName();
		}
		return super.getNodeVal(valName);
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName(boolean, boolean, boolean)
	 */
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return super.getNodeName(withClassName, withModelName, false) + this.getName();
	}


}
