/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.Symbol;
import h2PFoundation.SymbolTable;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;
import h2PVisitors.Parser.ParseException;

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
     * @throws ParseException 
     */
    public InstanceVariableNode(String theVType, String newVar, String anInitValue, String className) throws ParseException {
        super(noID(), "InstanceVariableNode");
        vType = theVType;
        tVariable = newVar;
        initValue = anInitValue;
        
        if (SymbolTable.symbolExists(newVar, Symbol.SymbolType.CLASS)) {
        	System.err.println("Error: name collision between instance variable `" +
        			newVar + "' and an existing class.");
        	throw new ParseException();
        }
        SymbolTable.addSymbol(newVar, SymbolType.INSTVAR, theVType, className);
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
