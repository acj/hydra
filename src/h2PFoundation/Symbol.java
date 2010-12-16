package h2PFoundation;

/**
 * Defines the data structure for symbols in the symbol table.
 */
public class Symbol {
	SymbolType type;
	String name; // e.g., "MyClass"
	String owningClass;

	public static enum SymbolType { CLASS, INSTVAR, GLOBVAR, SIGNAL };

	public Symbol(String n, SymbolType t, String oc) {
		name = n;
		type = t;
		owningClass = oc;
	}
}
