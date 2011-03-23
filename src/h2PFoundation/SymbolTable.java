package h2PFoundation;

import h2PFoundation.Symbol.SymbolType;

import java.util.HashMap;
import java.util.Iterator;

/**
 * Constructs a symbol table to support the HIL and UML parsers.
 */
public class SymbolTable {
	private static HashMap<String, Symbol> symbols = new HashMap<String, Symbol>();
	
	/**
	 * Add a new symbol to the symbol table.
	 * @param name Name of symbol
	 * @param type Type of symbol
	 * @param dataType Data type of symbol (e.g., int)
	 * @param owningClass The class containing the symbol (if any)
	 */
	public static void addSymbol(String name, SymbolType type, String dataType, String owningClass) {
		if (owningClass != "") {
			// Mangle the variable name to include the class name
			name = mangleSymbolName(name, owningClass, type);
		}
		if (symbols.containsKey(name)) {
			System.err.println("Warning: redefining existing symbol " + name);
		}
		Symbol sym = new Symbol(name, type, dataType, owningClass);
		symbols.put(name, sym);
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
		String mangledName = mangleSymbolName(symName, className, symType);
		return symbols.containsKey(mangledName) &&
			symbols.get(mangledName).getType() == symType;
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
			return symbols.containsKey(mangleSymbolName(symName, className, SymbolType.CLASS));
		}
	}
	
	/**
	 * Determine whether a symbol exists within an enumerated type
	 * @param symName Name of symbol
	 * @param typeName Type of symbol
	 * @return True if the symbol exists within the enumerated type; false if it does not
	 */
	public static Boolean symbolExistsInEnum(String symName, String typeName) {
		return symbols.containsKey(mangleSymbolName(symName, typeName, SymbolType.ENUM));
	}
	
	public static String getDataTypeOfAttribute(String instanceName,
												String containingClass) {
		if (symbolExistsInClass(instanceName, containingClass)) {
			Symbol sym = getSymbol(instanceName, containingClass, SymbolType.INSTVAR);
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
			return symbols.get(symName).owningClass;
		} else {
			return "";
		}
	}
	
	/**
	 * Returns a symbol by name
	 * @param symName Name of symbol
	 * @return The symbol, if it exists; null otherwise
	 */
	private static Symbol getSymbol(String symName) {
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
		String mangledName = mangleSymbolName(symName, className, type);
		if (symbols.containsKey(mangledName)) {
			return symbols.get(mangledName);
		} else {
			return null;
		}
	}
	
	/**
	 * Mangles the symbol name as a function of the symbol's class, name, and type
	 * @param symName Name of the symbol
	 * @param className Class containing the symbol
	 * @param type Type of the symbol
	 * @return Mangled symbol name
	 */
	private static String mangleSymbolName(String symName, String className, SymbolType type) {
		if (type.equals(SymbolType.ENUM)) {
			// For enumerated types
			return className + "#" + symName;
		} else {
			return className + "!" + symName;
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
				return getSymbol(tempSym).owningClass;
			}
		}
		return "";
	}
}
