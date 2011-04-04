package xmi2hil;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.NodeUtilityClass;
import h2PNodes.WorldUtilNode;
import h2PVisitors.Hil2PromelaVisitor;
import h2PVisitors.Parser.ParseException;
import h2PVisitors.Parser.HILParser;

import java.io.File;
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
    protected String hilIntermediateFilename = "";
    String inputFilename = "";
    File sourceFile = null;
    boolean isSilent = false;
    boolean makeHilIntermediate = false;
    
	/**
	 * Default constructor
	 */
	public ConversionDriver() {
		super();
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
    public String convert() throws ParseException  {
        assert(inputFilename != "");
        
        XmiParserComponent parser = new XmiParserComponent();
        parser.isVerbose = !isSilent;

        if(!sourceFile.exists() && !isSilent)
        {
            System.out.println("File does not exist: `" + inputFilename + "'.");
            System.exit(1);
        }
        // Parse the XMI file
        parser.parse(sourceFile);
        
        Model model = parser.getUMLModel();

        // convert the UML model to a hil source
        Visitor v = new ToHilVisitor();
        v.visitModel(model);
        List<String> data = ((ToHilVisitor) v).getData();
        Iterator<String> it = data.iterator();

        // Write the HILsource to a string
        hilIntermediate = new StringBuffer();
        while (it.hasNext()) {
            hilIntermediate.append(((String) it.next()) + "\n");
        }
        // Write the HIL to an intermediate file if requested
        if (this.isMakeHilIntermediate()) {
        	save (this.getHilIntermediateFilename(), hilIntermediate.toString());
        }
        
        return hilIntermediate.toString();
    }
    
    public boolean save(String filename) {
    	return save(filename, hilIntermediate.toString());
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
    	return save(f, hilIntermediate.toString());
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
