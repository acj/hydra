package h2PFoundation;

import h2PNodes.ClassBodyNode;
import h2PNodes.aNode;

import java.util.ArrayList;
import java.util.Vector;

/**
 * Handles common functionality for all visitor instances.
 */
public class NodeUtilityClass {

	public NodeUtilityClass() {
		super();
	}

	// just a fancy way of adding a newline to a printed string
	public String strln (String s){
		return s + "\n";
	}
	
	public String strln(){
		return strln("");
	}

	/*
	 * Climb up the tree of nodes to find a node of the specified type.
	 */
	public aNode searchUpForDest(aNode source, String destType) {
		aNode retDest = source;
		
		while (!retDest.getType().equals(destType)) {
			retDest = retDest.getParent();
			if (retDest == null) { // safety protocol.
				return null;
			}
		}
		
		return retDest;
	}
	
	/* prints part of the promela file to the current output stream*/
	public void print (String s) {
		System.out.print(s);
	}
	
	public void println (String s) {
		print (s + "\n");
	}
	
	public void exit() {
		System.exit(100);
	}

	public String repeatStr (String s, int repetitions) {
		String result = "";
		
		for (int i = 0; i < repetitions; i++) {
			result += s;
		}
		return result;
	}
	
	/*
	 * Locates the child node (if any) that matches the given parameters.
	 * 
	 * NOTE! The parameters in this function are slightly different from the UniversalClass.FindLocalDestNode
	 * version! Namely the entryName and NodeId parameters are switched!
	 */
	public aNode FindLocalDestNode (aNode tNode, String nodeType, String entryName, String nodeEntryVal) {
		
		ClassBodyNode searchNode = (ClassBodyNode)searchUpForDest(tNode, "ClassBodyNode");
		
		for (int i = 0; i < searchNode.children.size(); i++) {
			aNode childNode = (aNode) searchNode.children.get(i);
			if (childNode.getType().equals(nodeType)) {
				if (childNode.getNodeVal(entryName).equals(nodeEntryVal)) {
					return childNode;
				}
			}
		}
		return null;
	}
	
	public Vector<String> getTokenizedStrToVec(String dataStr, String token) {
		Vector<String> vec = new Vector<String>();
		int startP, i;
		String currStr = "";

		if (token.length() == 0) { // handle empty tokens
			vec.add(dataStr);
			return vec;
		}
		
		startP = 0;
		for (i = 0; i < dataStr.length() - token.length() + 1; i++) {
			if (dataStr.substring(i, i+token.length()).equals(token)) {
				currStr = dataStr.substring(startP, i);
				startP = i+token.length();
				vec.addElement(currStr);
			}
		}
		// add last element that may not have been included in list if string
		// does not end with the token.
		if (startP < dataStr.length()) {
			currStr = dataStr.substring(startP, dataStr.length());
			vec.addElement(currStr);
		}
		return vec;
	}
	
	public String[] getTokenizedStrToArray(String dataStr, String token) {
		Vector<String> vec = getTokenizedStrToVec(dataStr, token);
		
		String retVal[] = new String[vec.size()];
		for (int i = 0; i < vec.size(); i++) {
			retVal [i] = (String) vec.get(i);
		}
		return retVal;

	}

	public String FormatOutputSeparateType (String theType, String separator, String outputData) {
		String entities[] = getTokenizedStrToArray(outputData, "\n");
		
		for (int i = 0; i < entities.length; i++) {
			if (i != entities.length - 1) {
				entities[i] += separator;
			} else { // last item
				entities[i] += ";";
			}
		}
		
		String tmpStr = "";
		
		for (int i = 0; i < entities.length; i++) {
			tmpStr += entities[i];
		}
		tmpStr = theType + " " + tmpStr;
		return tmpStr;
	}
	
	public String FormatOutputType(String theType, String outputData) {
		return FormatOutputSeparateType (theType, ", ", outputData);
	}
	
    public ArrayList<?> VectorToArrayList(Vector<?> v) {
         ArrayList<?> ret = new ArrayList<Object>(v);
         
         return ret;
    }
	/*------------------------------------------------------------*/

    // adds escape characters for strings that need to be included
    // inside a printf statement. It escapes double quotes and 
    // backslashes by default.
    public String escapeStr (String source){
        return escapeStr(source, false);
    }
    
    public String escapeStr (String source, boolean escapeSingleQuotes){
      String tmpStr = "";
      
      for (int i = 0; i < source.length(); i++) {
         if ((source.charAt(i) == '"') || (source.charAt(i) == '\\')) {
           tmpStr += '\\';  
         }
         if ((source.charAt(i) == '\'') && (escapeSingleQuotes)) {
           tmpStr += '\\';  
         }
         tmpStr += source.charAt(i);
      }
      return tmpStr;   
    }
    
    public aNode ifInParentAsNode(aNode parentObject, String searchType, String varName, String searchName) {
    	
    	for (int i = 0; i < parentObject.children.size(); i++) {
    		aNode childNode = (aNode) parentObject.children.get(i);
    		if ((childNode.getType().equals(searchType)) && (childNode.getNodeVal(varName).equals(searchName))) {
    			return childNode;
    		}
    	}
    	return null;
    }
    
    public aNode ifInParentAsNode(aNode parentObject, String searchType, String searchName) {
    	return ifInParentAsNode(parentObject, searchType, "ID", searchName);
    }
    
    public boolean ifInParent(aNode parentObject, String searchType, String varName, String searchName) {
    	return (ifInParentAsNode(parentObject, searchType, varName, searchName) != null);
    }
    
    public boolean ifInParent(aNode parentObject, String searchType, String searchName) {
    	return ifInParent(parentObject, searchType, "ID", searchName);
    }
    
    // returns true if a string represents an integer.    
    public boolean isNum (String str) {
    	int pos = 0;
    	char c;
    	
    	if (str.length() == 0) { return false; }
    	if (str.charAt(0) == '-') {
    		if (str.length() == 1) {
    			return false;
    		}
    		pos = 1;
    	}
    	for (int i = pos; i < str.length(); i++) {
    		c = str.charAt(i);
    		if ((c < '0') || (c > '9')) {
    			return false; // not a number.
    		}
    	}
    	return true;
    }
}
