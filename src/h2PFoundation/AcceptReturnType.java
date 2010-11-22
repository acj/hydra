package h2PFoundation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;


/*
 *  Generic Return Type for aVisitor's Accept routine.
 *  It is intended to contain a set of strings referenced
 *  by a hash.   It also contains an optional generic
 *  hash that can be used to return any object type (held in a 
 *  vector for multiple objects).
 *  For convenience it also contains a default String type
 *  to return stuff.
 *  Note: the Generic and String Hash tables are *independent*
 *  and so they permit the same hash code for two different
 *  objects.  However, different functions are used to access
 *  the two hashes, thus making it harder to confuse the two.
 *  One difference: while addStr will merge new strings with old,
 *  addGen can only replace the old object with the new one.
 *  The hashtables are optional in order to avoid creating
 *  unecessary classes.
 * 
 *  Order of string concatenations:
 *  All calls here append strings to the end of the current data.
 *  This mimmics the functionality of UniversalClass->jointwoarrays
 *  which appends $array1 to the end of $array2.  And so the string
 *  being appended to actually will refer to itself as the second
 *  parameter in the function.
 *  i.e. @outputAction = jointwoarrays(@outputtransitionbody, @outputAction);
 *  here outputAction has the transition body appended to it.  Using 
 *  AcceptReturnType we have:
 *  [AcceptReturnType].merge([TransitionBodyNode].Accept());
 *  [AcceptReturnType].moveStrKey ("transitions", "Actions");
 * 
 */
public class AcceptReturnType extends NodeUtilityClass {

	// Generic Data Hashes:
	protected Hashtable stringHash; // stores a hash of strings  
	protected Hashtable genHash; // stores a hash of vectors of objects
	protected Hashtable singleHash; // stores a hash of objects
	
	// default string value, equivalent to getStr("default")
	protected String defaultValue = "";
	protected int readBufferSize = 5000;

	public AcceptReturnType() {
	}
	
	public AcceptReturnType(String defValue) {
		this();
		defaultValue = defValue;
	}

	/* ----------------- String Operations ----------------- */
	public String defV() {
		return defaultValue;
	}

	// No longer of use
	public void mergeDefV(String moreDefV) {
		//defaultValue += moreDefV;
		addStr("default", moreDefV);
	}

	// Returns a string that matches the given Hashkey
	public String getStr (String hashKey) {
        /* the "default" value and defaultValue are now the same! */
        if (hashKey.equals("default")) {
           return defaultValue;   
        }
		if (stringHash == null) {
			stringHash = new Hashtable();
		}
		String tmpStr = (String)stringHash.get(hashKey); // for now.
		if (tmpStr == null) {
			return "";
		} else {
			return tmpStr;
		}
	}

	// Appends the new string hashValue to the current value
	// of the String indicated by the Hashkey 
	public void addStr(String hashKey, String hashValue) {
		String tmpStr = getStr(hashKey);
		
        if (tmpStr.length() > 0) { // add delimiter between them 
            tmpStr = strln (tmpStr) + hashValue;
        } else {
            tmpStr = hashValue;   
        }
        if (hashKey.equals("default")) {
            defaultValue = tmpStr;
        } else {
          replaceStr(hashKey, tmpStr);   
        }
	}
	
    // Add a string with (possibly) a terminating newline character 
    public void addStrln(String hashKey, String hashValue) {
        String tmpStr = hashValue;
        if (hashValue.length() > 0) {
            if (hashValue.charAt(hashValue.length() - 1) == '\n') {
                tmpStr = hashValue.substring(0, hashValue.length() - 1);
            }
        }
        addStr(hashKey, tmpStr);
    }
    
	// Replaces the current value of the String for the given Hashkey with the new value.
    private void replaceStr (String hashKey, String newValue) {
      stringHash.remove(hashKey);
      stringHash.put(hashKey, newValue);
    }
	
	public void clearDefV() {
		defaultValue = "";
	}
	
    // deletes the string value of the given Hashkey
	public void removeStrKey(String hashKey) {
        if (hashKey.equals("default")) {
          defaultValue = "";
          return;
        }
		if (stringHash == null) {
			return;
		}
		stringHash.remove(hashKey);
	}
	
    public void replaceSrtKey(String hashKey, String newValue) {
    	removeStrKey(hashKey);
    	addStr (hashKey, newValue);
    }
    
	public void moveStrKey (String oldHashKey, String newHashKey) {
		String tmpStr = getStr(oldHashKey);
		removeStrKey(oldHashKey);
		addStr(newHashKey, tmpStr);		
	}
	
	public String []getStrSplit (String hashKey) {
		return getStrSplitOnToken(hashKey, "\n");
	}
	
	public String []getStrSplitOnToken (String hashKey, String token) {
		String tmpStr = getStr(hashKey);

		return getTokenizedStrToArray(tmpStr, token);
	}
	
	// search for a string in a specified hashkey delimited by newlines
	public boolean ifInArray(String hashKey, String searchVal) {
		String entities[] = getStrSplit (hashKey);
		
		for (int i = 0; i < entities.length; i++) {
			if (entities[i].equals(searchVal)) {
				return true;
			}
		}
		return false;
	}

    
	/* ----------------- Object Vector ----------------- */
	public Vector getGen (String hashKey) {
		if (genHash == null) {
			genHash = new Hashtable();
		}
		Vector vec = (Vector) genHash.get(hashKey);
		if (vec == null) {
			vec = new Vector();
			genHash.put(hashKey, vec);
		}
		return vec;
	}
	
	public void addGen (String hashKey, Object hashValue) {
		Vector vec = getGen (hashKey);
		vec.addElement(hashValue);
	}
	
	public void addGenVec (String hashKey, Vector hashValues) {
		if (genHash == null) {
			genHash = new Hashtable();
		}
		Vector vec = getGen (hashKey);
		for (int i = 0; i < hashValues.size(); i++) {
		  vec.addElement(hashValues.get(i));
		}		
	}
	
	/* ----------------- Single Object Hashes ----------------- */
	public void addSingle(String hashKey, Object hashValue) {
		if (singleHash == null) {
			singleHash = new Hashtable();
		}
		//hashTableRemove(singleHash,hashKey);
		singleHash.remove(hashKey);
		singleHash.put(hashKey, hashValue);
	}
	
	public Object getSingle (String hashKey) {
		if (singleHash == null) {
			singleHash = new Hashtable();
		}
		
		Object obj = singleHash.get(hashKey);
		return obj;
	}
	
	public void removeGenKey(String hashKey) {
		if (genHash == null) {
			return;
		}
		// hashTableRemove(genHash,hashKey);
		genHash.remove(hashKey);
	}
	
	/* ----------------- Utility Functions ----------------- */
	public void merge(AcceptReturnType newART) {
		//defaultValue += newART.defaultValue;
		mergeDefV(newART.defaultValue);

		Enumeration eHV;
		if (newART.stringHash != null) {
		  eHV = newART.stringHash.keys();
		
		  while (eHV.hasMoreElements()) {
			String nextHash = (String)eHV.nextElement();
			addStr(nextHash, newART.getStr(nextHash));
		  }
		}
		
		if (newART.genHash != null) {
		  eHV = newART.genHash.keys();
		
		  while (eHV.hasMoreElements()) {
			String nextHash = (String)eHV.nextElement();
			addGenVec(nextHash, newART.getGen(nextHash));
		  }
		}

		if (newART.singleHash != null) {
		  eHV = newART.singleHash.keys();
		
		  while (eHV.hasMoreElements()) {
			String nextHash = (String)eHV.nextElement();
			addSingle(nextHash, newART.getSingle(nextHash));
		  }
		}
	}

	// Loads the contents of a file into a given hashkey
	public boolean readFile (String hashKey, String filename) {
		boolean success = true;
		
		String finalStr = "";
		
		try {
			FileInputStream fis = new FileInputStream(filename);
			
			byte buffer[] = new byte[readBufferSize];
			StringBuffer strbuf = new StringBuffer (readBufferSize);
			int i, readsize;
			
			readsize = fis.read(buffer);
			while (readsize != -1) {
				for (i = 0; i < readsize; i++) {
					strbuf.setCharAt(i, (char)buffer[i]);
				}
				finalStr += strbuf.substring(0, readsize);
				readsize = fis.read(buffer);				
			}	
			fis.close();
			addStr(hashKey, finalStr);
		} catch (FileNotFoundException fnfe) {
			success = false;
		} catch (IOException iofe) {
			success = false;
		}
		return success;
	}
	
    // Loads the contents of a file into a given hashkey
    public boolean writeFile (String hashKey, File f) {
        boolean success = false;
        
        try {
          FileOutputStream fos = new FileOutputStream(f);
        
          success = writeFile(hashKey, fos);
        } catch (FileNotFoundException fnfe) {
            success = false;
        }
        return success;
    }
    
    public boolean writeFile (String hashKey, String filename) {
        boolean success = false;
        
        try {
          FileOutputStream fos = new FileOutputStream(filename);
        
          success = writeFile(hashKey, fos);
        } catch (FileNotFoundException fnfe) {
            success = false;
        }
        return success;
    }

    public boolean writeFile (String hashKey, FileOutputStream fos) {
        boolean success = true;
        
        String finalStr = "";
        
        try {
            //FileOutputStream fos = new FileOutputStream(filename);
            
            byte buffer[] = new byte[readBufferSize];
            StringBuffer strbuf = new StringBuffer (getStr(hashKey));
            int i, idx, writesize, leftToWrite;
            
            leftToWrite = strbuf.length();
            i = 0;
            while (leftToWrite > 0) {
                writesize = readBufferSize;
                if (readBufferSize > leftToWrite) {
                  writesize = leftToWrite;   
                }
                for (idx = 0; idx < writesize; idx++, i++) {
                    buffer[idx] = (byte)strbuf.charAt(i);
                }
                fos.write(buffer, 0, writesize);
                leftToWrite -= writesize;
            }
            fos.flush();
            fos.close();
        } catch (FileNotFoundException fnfe) {
            success = false;
        } catch (IOException iofe) {
            success = false;
        }
        return success;
    }
    
	// Static Utility functions:
	public static AcceptReturnType nil(){
		return retString("");
	}

	public static AcceptReturnType retString(String data) {
		AcceptReturnType tmpART = new AcceptReturnType(data);
		return tmpART;
	}
	
	// for testing purposes.
	public String getAllInfo () {
		String tmpStr = "";
		int vecCount;

		tmpStr += "default: " + defaultValue + "\n";
		if (singleHash == null) {
			vecCount = 0;
		} else {
			vecCount = singleHash.size();
		}
		tmpStr += "Single Vector Count: " + vecCount + "\n";

		if (genHash == null) {
			vecCount = 0;
		} else {
			vecCount = genHash.size();
		}
		tmpStr += "General Vector Count: " + vecCount + "\n";
		
		if (stringHash == null) {
			vecCount = 0;
		} else {
			vecCount = stringHash.size();
		}
		tmpStr += "String Vector Count: " + vecCount + "\n";
		

		if (stringHash != null) {
			Enumeration eHV;
			eHV = stringHash.keys();
		
			while (eHV.hasMoreElements()) {
				String nextHash = (String)eHV.nextElement();
				tmpStr += "/* *** " + nextHash + "*** */\n" + getStr(nextHash) + "\n";
			}
		}
		return tmpStr;
	}
}
