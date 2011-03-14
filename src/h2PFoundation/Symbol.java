package h2PFoundation;

/**
 * Defines the data structure for symbols in the symbol table.
 */
public class Symbol {
	SymbolType type;
	String name; // e.g., "MyClass"
	String dataType;
	String owningClass;

	public static enum SymbolType { CLASS, ENUM, INSTVAR, GLOBVAR, SIGNAL };

	public Symbol(String n, SymbolType t, String dt, String oc) {
		name = n;
		type = t;
		dataType = dt;
		owningClass = oc;
	}

	public SymbolType getType() {
		return type;
	}
	
	public String getName() {
		return name;
	}
	
	public String getDataType() {
		return dataType;
	}

	public String getOwningClass() {
		return owningClass;
	}
}
