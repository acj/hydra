package h2PFoundation;

import java.util.HashMap;
import java.util.Vector;

/**
 * Defines the data structure for symbols in the symbol table.
 */
public class Symbol {
	SymbolType type;
	String name; // e.g., "MyClass"
	String dataType;
	String owningContainer;
	HashMap<String, Object> data;

	public static enum SymbolType {
		CLASS, ENUM, GLOBVAR, INSTVAR, SIGNAL, CSTATE, CCSTATE, STATE
	};

	public Symbol(String n, SymbolType t, String dt, String oc) {
		name = n;
		type = t;
		dataType = dt;
		owningContainer = oc;
		data = new HashMap<String, Object>();
		
		if (t == SymbolType.CLASS) {
			// Track symbols that are instances of this class 
			data.put("instances", new Vector<Symbol>());
		} else if (t == SymbolType.CSTATE || t == SymbolType.CCSTATE) {
			// Track substates within this composite state
			data.put("substates", new Vector<Symbol>());
		}
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

	public String getOwningContainer() {
		return owningContainer;
	}
	
	public Object getData(String key) {
		if (data.containsKey(key)) {
			return data.get(key);
		} else {
			return null;
		}
	}
	
	public void putData(String key, Object value) {
		data.put(key, value);
	}
	
	public void addClassInstance(Symbol classInstance) {
		Vector<Symbol> instances = (Vector<Symbol>)data.get("instances");
		if (!instances.contains(classInstance)) {
			instances.add(classInstance);
		}
	}
	
	public int getNumberOfInstances() {
		Vector<Symbol> instances = (Vector<Symbol>)data.get("instances");
		// +1 to account for the static/original class
		return instances.size() + 1;
	}
	
	public int getIndexOfInstance(Symbol sym) {
		Vector<Symbol> instances = (Vector<Symbol>)data.get("instances");
		if (instances.contains(sym)) {
			// +1 to account for the static/original class, which has index 0
			return instances.indexOf(sym) + 1;
		} else {
			return -1;
		}
	}
}
