package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.SymbolTable;
import h2PFoundation.Symbol.SymbolType;
import h2PVisitors.aVisitor;

public class SignalNode extends aNode {
    private String name = "";
    private String sigType = "";
    private String className = "";

    public SignalNode(String signame) {
        super(noID(), "SignalNode");
        name = signame;
    }
    
    public SignalNode(String sigName, String signalType, String className) {
        this(sigName);
        this.name = sigName;
        this.sigType = signalType;
        this.className = className;
        SymbolTable.addSymbol(sigName, SymbolType.SIGNAL, signalType, className);
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
    
    public String getClassName(){
        return className;
    }

	public String getNodeVal(String valName) {
		if (valName.equals("name")) {
			return getName();
		}
		return super.getNodeVal(valName);
	}

	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return super.getNodeName(withClassName, withModelName, false) + this.getName();
	}


}
