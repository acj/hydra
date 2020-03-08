package backend.hil2Promela;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.NodeUtilityClass;
import backend.h2PNodes.WorldUtilNode;
import backend.h2PParser.HILParser;
import backend.h2PParser.ParseException;
import backend.h2PVisitors.ASTErrorChecker;
import backend.h2PVisitors.Hil2PromelaVisitor;

/**
 * Instruments the conversion of HIL data into Promela and writing the result
 * to disk.
 */
public class ConversionDriver extends NodeUtilityClass {
    WorldUtilNode rootNode;
    Hil2PromelaVisitor h2pVisitor;
    HILParser tHILParser;
	AcceptReturnType errors;
	String hilInput = "";
    String promelaOutput = "";
    File inputFile;
    boolean isSilent = false;
    boolean ignoreErrors = false;
    
	/**
	 * Default constructor
	 */
	public ConversionDriver() {
		super();
		errors = new AcceptReturnType();
	}
    
    public ConversionDriver(File inputFile) {
        this.inputFile = inputFile;
    }
    
    public void convert() throws ParseException  {
        assert(inputFile != null || !hilInput.equals(""));
        
        if (hilInput.equals("")) {
	    	byte[] buffer = new byte[(int) inputFile.length()];
	        FileInputStream f;
			try {
				f = new FileInputStream(inputFile);
				f.read(buffer);
				hilInput = new String(buffer);
			} catch (FileNotFoundException e) {
				System.err.println("File does not exist: `" + inputFile.getName() + "'");
				System.exit(1);
			}
			catch (IOException e) {
				System.err.println("Error reading file: `" + inputFile.getName() + "'");
				System.exit(1);
			}
        }
		Reader dataStream = new StringReader (hilInput);
        rootNode = new WorldUtilNode();
        tHILParser = new HILParser(dataStream);
        tHILParser.setRootNode(rootNode);
        ASTErrorChecker errorChecker = new ASTErrorChecker();       
        h2pVisitor = new Hil2PromelaVisitor();

        println("*** Checking model for errors ***");
        tHILParser.parse(); // parse the HIL file
        // check for errors.
        errors = rootNode.accept(errorChecker); // visit!
        String tErrors = errors.getStr("errors");
        String tWarnings = errors.getStr("warnings");
        promelaOutput = "";
        if (tErrors.length() > 0) {
        	promelaOutput = "";
        	if (!isSilent) {
        		println("There are Errors in the model:");
        		println(tErrors);
        	}
        	if (ignoreErrors) {
        		// ignore errors, visit anyway.
                promelaOutput = rootNode.accept(h2pVisitor).defV(); // visit!        		
        	}
        } else {
          // visit only on no errors.
          println("*** Checking state transitions for errors ***");
          promelaOutput = rootNode.accept(h2pVisitor).defV(); // visit!
        }
        if (tWarnings.length() > 0) {
        	if (!isSilent) {
        		println("");
        		println("There are Warnings in the model:");
        		println(tWarnings);
        	}
        }
    }

    public boolean hasErrors() {
    	return (errors.getStr("errors").length() > 0);
    }
    
    public boolean save(String filename) {
    	return save(filename, promelaOutput);
    }
    
    public boolean save(String filename, String dataOutputStr) {       
        AcceptReturnType outputString = new AcceptReturnType(dataOutputStr);
        boolean retval = true;
        
        if (filename.length() > 0) {
          retval = outputString.writeFile("default", filename);
        } else {
           print (outputString.defV());   
        }
        return retval;
    }
    
    public boolean save (File f) {
    	return save(f, promelaOutput);
    }
    
    public boolean save (File f, String dataOutputStr) {
        AcceptReturnType outputString = new AcceptReturnType(dataOutputStr);
        boolean retval = true;
        
        if (f == null) { // use standard output if the parameter is null.
            print (outputString.defV());   
        } else {
            retval = outputString.writeFile("default", f);            
        }
          
        
        return retval;
    }

	public File getInputFile() {
		return inputFile;
	}

	public void setInputFilename(File inputFile) {
		this.inputFile = inputFile;
	}

	public boolean isSilent() {
		return isSilent;
	}

	public void setSilent(boolean isSilent) {
		this.isSilent = isSilent;
	}

	public String getPromelaOutput() {
		return promelaOutput;
	}

	public void setPromelaOutput(String promelaOutput) {
		this.promelaOutput = promelaOutput;
	}
	
	/**
	 * @param sourceFile The sourceFile to set.
	 */
	public void setSourceFile(File sourceFile) {
        this.inputFile = sourceFile;
	}

	/**
	 * @return Returns the ignoreErrors.
	 */
	public boolean isIgnoreErrors() {
		return ignoreErrors;
	}

	/**
	 * @param ignoreErrors The ignoreErrors to set.
	 */
	public void setIgnoreErrors(boolean ignoreErrors) {
		this.ignoreErrors = ignoreErrors;
	}
	
    public String getHILInput() {
		return hilInput;
	}

	public void setHILInput(String hilInput) {
		this.hilInput = hilInput;
	}
}
