package backend.h2PNodes;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.Symbol;
import backend.h2PFoundation.SymbolTable;
import backend.h2PVisitors.aVisitor;

public class CompositeStateNode extends aNode {
	private Symbol symbol;
	public CompositeStateBodyNode bodyNode = null;
	
    /**
     * @param theID
     */
    public CompositeStateNode(String theID) {
        super(theID, "CompositeStateNode");
        symbol = SymbolTable.addSymbol(theID, Symbol.SymbolType.CSTATE, "", "");
    }
	
	public AcceptReturnType accept(aVisitor v) {
		return v.visitCompositeStateNode(this);
	}

	public void addChild(aNode newChild) {
		super.addChild(newChild);
		
		if (newChild.getType().equals("CompositeStateBodyNode")) {
			bodyNode = (CompositeStateBodyNode)newChild;
		}
	}
	
	public Symbol getSymbol() {
		return symbol;
	}

	public boolean hasBodyNode() {
		return (bodyNode != null);
	}
}
