package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.Symbol;
import h2PFoundation.SymbolTable;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;

public class ClassNode extends aNode {
	public ClassBodyNode subnode;
	private Symbol symbol;
	protected boolean hasClassBodyNodeBoolean = false;
	
    public ClassNode(String theID) {
        super(theID, "ClassNode");
        symbol = SymbolTable.addSymbol(theID, SymbolType.CLASS, "", "");
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitClassNode(this);
	}
	
	public boolean hasClassBodyNode() {
		return hasClassBodyNodeBoolean;
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("ClassBodyNode")) {
			subnode = (ClassBodyNode)newChild;
			hasClassBodyNodeBoolean = true;
		}
	}
	
	public String getNodeName() {
		return super.getNodeName(false, true);
	}
	
	public Symbol getSymbol() {
		return symbol;
	}
}
