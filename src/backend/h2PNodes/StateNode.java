package backend.h2PNodes;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.Symbol;
import backend.h2PFoundation.SymbolTable;
import backend.h2PVisitors.aVisitor;

public class StateNode extends aNode {
	private Symbol symbol;
	public StateBodyNode bodyNode = null;
    /**
     * @param theID
     */
    public StateNode(String theID) {
        super(theID, "StateNode");
        symbol = SymbolTable.addSymbol(theID, Symbol.SymbolType.STATE, "", "");
    }
   

	public AcceptReturnType accept(aVisitor v) {
		return v.visitStateNode(this);
	}


	public void addChild(aNode newChild) {
		super.addChild(newChild);
		if (newChild.getType().equals("StateBodyNode")) {
			bodyNode = (StateBodyNode)newChild;
		}
	}
	
	public Symbol getSymbol() {
		return symbol;
	}
	
	public boolean hasBodyNode (){
		return (bodyNode != null);
	}
}
