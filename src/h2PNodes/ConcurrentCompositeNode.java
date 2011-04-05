package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.Symbol;
import h2PFoundation.SymbolTable;
import h2PVisitors.aVisitor;

public class ConcurrentCompositeNode extends aNode {
	private Symbol symbol;
	public ConcurrentCompositeBodyNode bodyNode = null;
	
    /**
     * @param theID
     */
    public ConcurrentCompositeNode(String theID) {
        super(theID, "ConcurrentCompositeNode");
        symbol = SymbolTable.addSymbol(theID, Symbol.SymbolType.CCSTATE, "", "");
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitConcurrentCompositeNode(this);
	}

	public void addChild(aNode newChild) {
		super.addChild(newChild);
		
		if (newChild.getType().equals("ConcurrentCompositeBodyNode")) {
			bodyNode = (ConcurrentCompositeBodyNode) newChild;
		}
	}
	
	public Symbol getSymbol() {
		return symbol;
	}
	
	public boolean hasBodyNode() {
		return (bodyNode != null);
	}

}
