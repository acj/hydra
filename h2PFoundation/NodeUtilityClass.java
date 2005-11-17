package h2PFoundation;

import h2PNodes.ClassBodyNode;
import h2PNodes.aNode;

import java.util.ArrayList;
import java.util.Vector;

public class NodeUtilityClass {

	public NodeUtilityClass() {
		super();
	}

	/*------------------------------------------------------------*/
	/* U tility F unctions
	 * 		These functions are non-instance-dependent utility
	 * functions for use by all visitors.  Similar to Hydra perl's
	 * universal class.  Think of this class as stateless.
	 */
	/*------------------------------------------------------------*/
	// just a facy way of adding a newline to a printed string
	public String strln (String s){
		return s + "\n";
	}
	
	public String strln(){
		return strln("");
	}

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
	
	/*
	public aNode getWorldRootNode(aNode source) {
		return searchUpForDest (source, "WorldUtilNode");
	}
	*/
	
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
	
	public Vector getTokenizedStrToVec(String dataStr, String token) {
		Vector vec = new Vector();
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
		Vector vec = getTokenizedStrToVec(dataStr, token);
		
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
			tmpStr += entities[i] /*+ "\n"*/;
		}
		// tmpStr += "\n";
		tmpStr = theType + " " + tmpStr;
		return tmpStr;
	}
	
	public String FormatOutputType(String theType, String outputData) {
		return FormatOutputSeparateType (theType, ", ", outputData);
	}
	
    public ArrayList VectorToArrayList(Vector v) {
         ArrayList ret = new ArrayList(v);
         
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
}
