package h2PFoundation;

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
