/*
 *
 */
package h2PNodes;

import java.util.Vector;

import h2PFoundation.*;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;

/**
 * 
 */
public class EnumNode extends aNode {
    
    private String enumTypeName = "";
    private Vector<String> enums;
    
    /**
     * @param theID
     */
    public EnumNode(String name) {
        super(noID(), "EnumNode");
        enums = new Vector<String>();
        enumTypeName = name;
        SymbolTable.addSymbol(name, SymbolType.ENUM, "", "");
    }

	public AcceptReturnType accept(aVisitor v) {
		return v.visitEnumNode(this);
	}
	
	public void addEnum(String enumName) {
		enums.add(enumName);
		SymbolTable.addSymbol(enumName, SymbolType.ENUM, enumTypeName, enumTypeName);
	}
    
    public String getEnumTypeName(){
      return enumTypeName;
    }
    
    public Vector<String> getEnums() {
    	return enums;
    }

	public String getNodeVal(String valName) {
		if (valName.equals("var")) {
			return getEnumTypeName();
		}
		return super.getNodeVal(valName);
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName(boolean, boolean, boolean)
	 */
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return super.getNodeName(withClassName, withModelName, false) + this.getEnumTypeName();		
	}


}
