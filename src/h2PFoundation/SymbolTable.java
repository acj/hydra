package h2PFoundation;

import h2PFoundation.Symbol.SymbolType;

import java.util.HashMap;
import java.util.Iterator;

public class SymbolTable {
	private static HashMap<String, Symbol> symbols;
	
	public static void initialize() {
		symbols = new HashMap<String, Symbol>();
	}
	
	public static void addSymbol(String name, SymbolType type, String owningClass) {
		if (owningClass != "") {
			// Mangle the variable name to include the class name
			name = mangleSymbolName(name, owningClass);
		}
		if (symbols.containsKey(name)) {
			System.err.println("Warning: redefining existing symbol " + name);
		}
		Symbol sym = new Symbol(name, type, owningClass);
		symbols.put(name, sym);
	}
	
	public static Boolean symbolExists(String name) {
		return symbols.containsKey(name);
	}
	
	public static Boolean symbolExists(String name, SymbolType type) {
		if (!symbols.containsKey(name)) {
			return false;
		} else if (symbols.get(name).type != type) {
			return false;
		} else {
			return true;
		}
	}
	
	public static Boolean symbolExistsInClass(String symName, String className) {
		return symbols.containsKey(mangleSymbolName(symName, className));
	}
	
	public static String getOwningClass(String symName) {
		if (symbols.containsKey(symName)) {
			return symbols.get(symName).owningClass;
		} else {
			return "";
		}
	}
	
	public static Symbol getSymbol(String symName) {
		return symbols.get(symName);
	}
	
	public static String mangleSymbolName(String symName, String className) {
		return className + "!" + symName;
	}
	
	public static String searchForSymbol(String symName) {
		for (Iterator<String> it = symbols.keySet().iterator(); it.hasNext();) {
			String tempSym = it.next();
			// Look for the name of the symbol and be sure that it occurs at
			// the very end of the string to avoid false-positives.
			if (tempSym.contains(symName) &&
					tempSym.indexOf(symName) == tempSym.length() - symName.length()) {
				return getSymbol(tempSym).owningClass;
			}
		}
		return "";
	}
}
