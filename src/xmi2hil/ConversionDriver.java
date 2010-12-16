/*
 * Created on Nov 16, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package xmi2hil;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.NodeUtilityClass;
import h2PNodes.WorldUtilNode;
import h2PVisitors.Hil2PromelaVisitor;
import h2PVisitors.ASTErrorChecker;
import h2PVisitors.Parser.ParseException;
import h2PVisitors.Parser.HILParser;

import java.io.File;
import java.io.Reader;
import java.io.StringReader;
import java.util.Iterator;
import java.util.List;

import umlModel.Model;
import umlModel.Visitor;
import xmiParser.XmiParserComponent;

/**
 * Instruments the conversion of XMI data into the Hydra Intermediate
 * Language (HIL) and writing the result to disk.
 */
public class ConversionDriver extends NodeUtilityClass {
    WorldUtilNode rootNode;
    Hil2PromelaVisitor funkyVisitor;
    HILParser tHILParser;
    StringBuffer hilIntermediate;
    AcceptReturnType errors;
    String promelaOutput = "";
    protected String hilIntermediateFilename = "";
    String inputFilename = "";
    File sourceFile = null;
    boolean isSilent = false;
    boolean ignoreErrors = false;
    boolean makeHilIntermediate = false;
    
	/**
	 * Default constructor
	 */
	public ConversionDriver() {
		super();
		errors = new AcceptReturnType();
	}
    
    public ConversionDriver(String theInputFilename) {
        this(new File(theInputFilename));
        setInputFilename(theInputFilename);
    }
    
    public ConversionDriver(File theInputFile) {
        this();
        setSourceFile(theInputFile);
    }
    
   // Multi-stage xmi-hil converter
    public void convert() throws ParseException  {
        if (inputFilename.length() == 0) {
          return;   
        }
        
        XmiParserComponent parser=new XmiParserComponent();
        parser.isVerbose = !isSilent;

        if(!sourceFile.exists() && !isSilent)
        {
            System.out.println("xmi file '" + inputFilename + "' not found.");
            System.exit(0);
        }
        // Parse the XMI file
        parser.parse(sourceFile);
        
        Model model=parser.getUMLModel();

        // convert the UML model to a hil source
        Visitor v = new ToHilVisitor();
        v.visitModel(model);
        List<String> data = ((ToHilVisitor) v).getData();
        Iterator<String> it = data.iterator();

        // write the hil source to a string
        hilIntermediate = new StringBuffer();
        while (it.hasNext()) {
            hilIntermediate.append(((String) it.next()) + "\n");
        }
        // write the hil to an intermediate file if requested
        if (this.isMakeHilIntermediate()) {
        	save (this.getHilIntermediateFilename(), hilIntermediate.toString());
        }

        // Finally convert the hil to a promela file
        Reader dataStream = new StringReader (hilIntermediate.toString());
        
        rootNode = new WorldUtilNode();
        tHILParser = new HILParser(dataStream);
        tHILParser.setRootNode(rootNode);
        ASTErrorChecker errorChecker = new ASTErrorChecker();       
        funkyVisitor = new Hil2PromelaVisitor();

        tHILParser.spec(); // parse the HIL file
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
                promelaOutput = rootNode.accept(funkyVisitor).defV(); // visit!        		
        	}
        } else {
          // visit only on no errors.
          promelaOutput = rootNode.accept(funkyVisitor).defV(); // visit!
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
        // File source=new File(inputFilename);
        
        if (f == null) { // output to stdin if the parameter is null.
            print (outputString.defV());   
        } else {
            retval = outputString.writeFile("default", f);            
        }
          
        
        return retval;
    }

	public String getInputFilename() {
		return inputFilename;
	}

	public void setInputFilename(String inputFilename) {
		//this.inputFilename = inputFilename;
        setSourceFile(new File (inputFilename));
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
	 * @return Returns the sourceFile.
	 */
	public File getSourceFile() {
		return sourceFile;
	}
	/**
	 * @param sourceFile The sourceFile to set.
	 */
	public void setSourceFile(File sourceFile) {
		this.sourceFile = sourceFile;
        this.inputFilename = sourceFile.toString();
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

	public boolean isMakeHilIntermediate() {
		return makeHilIntermediate;
	}

	public void setMakeHilIntermediate(boolean makeHilIntermediate) {
		this.makeHilIntermediate = makeHilIntermediate;
	}

	public String getHilIntermediateFilename() {
		return hilIntermediateFilename;
	}

	public void setHilIntermediateFilename(String hilIntermediateFilename) {
		if (hilIntermediateFilename.length() > 0) {
		    makeHilIntermediate = true;
		} else {
			makeHilIntermediate = false;
		}
		this.hilIntermediateFilename = hilIntermediateFilename;
	}
}
