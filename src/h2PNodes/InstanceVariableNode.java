package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.Symbol;
import h2PFoundation.SymbolTable;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;
import h2PParser.ParseException;

public class InstanceVariableNode extends aNode {
    private String vType = "";
    private String tVariable = "";
    private String initValue = "";
    private Symbol symbol;
    
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
        symbol = SymbolTable.addSymbol(newVar, SymbolType.INSTVAR, theVType, className);
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

	public Symbol getSymbol() {
        return symbol;
    }

    public String getNodeVal(String valName) {
		if (valName.equals("var")) {
			return getVar();
		}
		return super.getNodeVal(valName);
	}

	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return super.getNodeName(withClassName, withModelName, false) + this.getVar();		
	}
}
