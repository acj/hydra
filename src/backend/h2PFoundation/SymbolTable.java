package backend.h2PFoundation;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

import backend.h2PFoundation.Symbol.SymbolType;

/**
 * Constructs a symbol table to support the HIL and UML parsers.
 */
public class SymbolTable {
	final static String INST_SEPARATOR = ".";
	
	private static HashMap<String, Symbol> symbols = new HashMap<String, Symbol>();
	
	/**
	 * Add a new symbol to the symbol table.
	 * @param name Name of symbol
	 * @param type Type of symbol
	 * @param dataType Data type of symbol (e.g., int)
	 * @param owningClass The class containing the symbol (if any)
	 */
	public static Symbol addSymbol(String name, SymbolType type, String dataType, String owningClass) {
		if (owningClass != "") {
			name = owningClass + "." + name;
		}
		if (symbols.containsKey(name)) {
			System.err.println("Warning: redefining existing symbol " + name);
		}
		Symbol sym = new Symbol(name, type, dataType, owningClass);
		symbols.put(name, sym);
		return sym;
	}
	
	/**
	 * Determine whether a symbol exists
	 * @param name Name of symbol
	 * @return True if the symbol exists; false if it does not exist
	 */
	public static Boolean symbolExists(String name) {
		return symbols.containsKey(name);
	}
	
	/**
	 * Determine whether a symbol exists
	 * @param name Name of symbol
	 * @param type Type of symbol
	 * @return True if the symbol exists; false if it does not exist
	 */
	public static Boolean symbolExists(String name, SymbolType type) {
		if (!symbols.containsKey(name)) {
			return false;
		} else if (symbols.get(name).type != type) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * Quickly determine whether a symbol of the given name, class, and type
	 * exists.
	 * 
	 * @param symName Name of symbol
	 * @param className Class containing symbol
	 * @param symType Type of symbol
	 * @return True if the specified symbol exists, false otherwise
	 */
	public static Boolean checkSymbolType(String symName, String className, SymbolType symType) {
		String fullName = className + "." + symName;
		return symbols.containsKey(fullName) &&
			symbols.get(fullName).getType() == symType;
	}
	
	/**
	 * Determine whether a symbol exists within a class
	 * @param symName Name of symbol
	 * @param className Name of class
	 * @return True if the symbol exists in the specified class; false if it does not
	 */
	public static Boolean symbolExistsInClass(String symName, String className) {
		if (className.equals("")) {
			return symbolExists(symName);
		} else {
			return symbols.containsKey(className + "." + symName);
		}
	}
	
	/**
	 * Determine whether a symbol exists within an enumerated type
	 * @param symName Name of symbol
	 * @param typeName Type of symbol
	 * @return True if the symbol exists within the enumerated type; false if it does not
	 */
	public static Boolean symbolExistsInEnum(String symName, String typeName) {
		return symbols.containsKey(typeName + "." + symName);
	}
	
	public static String getDataTypeOfAttribute(String instanceName,
												String containingClass) {
		if (symbolExistsInClass(instanceName, containingClass)) {
			Symbol sym = getSymbol(instanceName, containingClass, SymbolType.INSTVAR);
			assert(sym != null);
			return sym.getDataType();
		} else {
			return null;
		}
		
	}
	
	/**
	 * Determine the owning class of a symbol
	 * @param symName Name of symbol
	 * @return The name of the owning class (if one exists) for the symbol
	 */
	public static String getOwningClass(String symName) {
		if (symbols.containsKey(symName)) {
			return symbols.get(symName).owningContainer;
		} else {
			return "";
		}
	}
	
	/**
	 * Returns a symbol by name
	 * @param symName Name of symbol
	 * @return The symbol, if it exists; null otherwise
	 */
	public static Symbol getSymbol(String symName) {
		if (symbols.containsKey(symName)) {
			return symbols.get(symName);
		} else {
			return null;
		}
	}
	
	/**
	 * Returns a symbol by name, containing class, and type
	 * @param symName Name of symbol
	 * @param className Name of containing class
	 * @param type Name of type
	 * @return The symbol, if it exists; null otherwise
	 */
	public static Symbol getSymbol(String symName, String className, SymbolType type) {
		String fullName = className + "." + symName;
		if (symbols.containsKey(fullName)) {
			return symbols.get(fullName);
		} else {
			return null;
		}
	}
	
	/**
	 * Search the symbol table for a class that contains the symbol name.
	 * @param symName The name of the symbol of interest
	 * @return Name of the class containing the symbol, or an empty string if
	 * the symbol is not found.
	 */
	public static String searchForSymbol(String symName) {
		for (Iterator<String> it = symbols.keySet().iterator(); it.hasNext();) {
			String tempSym = it.next();
			// Look for the name of the symbol and be sure that it occurs at
			// the very end of the string to avoid false-positives.
			if (tempSym.contains(symName) &&
					tempSym.indexOf(symName) == tempSym.length() - symName.length()) {
				return getSymbol(tempSym).owningContainer;
			}
		}
		return "";
	}
	
	/**
	 * Get a list of classes defined in the symbol table.
	 * 
	 * @return Set containing all classes
	 */
	public static Set<Symbol> getClasses() {
		Set<Symbol> classes = new HashSet<Symbol>();
		for (String key : symbols.keySet()) {
			if (key.contains(INST_SEPARATOR)) {
				continue;
			}
			if (symbolExists(key, SymbolType.CLASS)) {
				classes.add(symbols.get(key));
			}
		}
		return classes;
	}
	
	/**
	 * Get a list of attribute symbols that are instances of classes.
	 * 
	 * @return Set of attribute symbols representing instances of classes.
	 */
	public static Set<Symbol> getClassInstanceAttributes() {
		Set<Symbol> instanceAttribs = new HashSet<Symbol>();
		for (String key : symbols.keySet()) {
			if (key.contains(INST_SEPARATOR)) {
				Symbol sym = getSymbol(key);
				if (symbolExists(sym.getDataType(), SymbolType.CLASS)) {
					instanceAttribs.add(sym);
				}
			}
		}
		return instanceAttribs;
	}
	
	
	public static HashMap<String, Symbol> getStateToCSMapping() {
		HashMap<String, Symbol> csMap = new HashMap<String, Symbol>();
		for (Symbol sym : symbols.values()) {
			if (sym.getType() == SymbolType.CCSTATE ||
					sym.getType() == SymbolType.CSTATE) {
				Vector<Symbol> states = (Vector<Symbol>)sym.getData("substates");
				for (Symbol state : states) {
					csMap.put(state.getName(), sym);
				}
			}
		}
		return csMap;
	}
}
