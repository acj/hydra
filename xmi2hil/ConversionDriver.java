/*
 * Created on Nov 16, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package xmi2hil;

import h2PFoundation.AcceptReturnType;
import h2PNodes.WorldUtilNode;
import h2PVisitors.Hil2PromelaVisitor;
import h2PVisitors.Parser.*;
import xmiParser.*;
import java.io.*;
import java.util.Iterator;
import java.util.List;

import umlModel.Model;
import umlModel.Visitor;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ConversionDriver {
    WorldUtilNode rootNode;
    Hil2PromelaVisitor funkyVisitor;
    UMLParser1 tHILParser;
    StringBuffer hilIntermediate;
    String promelaOutput = "";
    String inputFilename = "";
    boolean isSilent = false;
    
	/**
	 * 
	 */
	public ConversionDriver() {
		super();
		// TODO Auto-generated constructor stub
        
	}
    
    public ConversionDriver(String theInputFilename) {
        this();
        // TODO Auto-generated constructor stub
        inputFilename = theInputFilename;
    }
    
    // Multi-stage xmi-hil converter
    public void convert() throws ParseException  {
        if (inputFilename.length() == 0) {
          return;   
        }
        
        // Right now the parser only seems to read directly from a file
        // I hope this can change later
        XmiParserComponent parser=new XmiParserComponent();
        parser.isVerbose = !isSilent;
        File source=new File(inputFilename);

        if(!source.exists() && !isSilent)
        {
            System.out.println("xmi file '" + inputFilename + "' not found.");
            System.exit(0);
        }
        // Parse the XMI file
        parser.parse(source);
        
        Model model=parser.getUMLModel();

        // convert the UML model to a hil source
        Visitor v = new ToHilVisitor();
        v.visitModel(model);
        List data = ((ToHilVisitor) v).getData();
        Iterator it = data.iterator();

        // write the hil source to a string
        hilIntermediate = new StringBuffer();
        while (it.hasNext()) {
            hilIntermediate.append(((String) it.next()) + "\n");
        }

        // Finally convert the hil to a promela file
        Reader dataStream = new StringReader (hilIntermediate.toString());
        
        rootNode = new WorldUtilNode();
        tHILParser = new UMLParser1(dataStream);
        tHILParser.setRootNode(rootNode);
        funkyVisitor = new Hil2PromelaVisitor();

        tHILParser.spec(); // parse the HIL file
        promelaOutput = rootNode.accept(funkyVisitor).defV(); // visit!

    }

    public boolean save(String filename) {       
        AcceptReturnType outputString = new AcceptReturnType(promelaOutput);
        boolean retval = true;
        
        if (filename.length() > 0) {
          retval = outputString.writeFile("default", filename);
        } else {
           System.out.print (outputString.defV());   
        }
        return retval;
    }
    
    public boolean save (File f) {
        AcceptReturnType outputString = new AcceptReturnType(promelaOutput);
        boolean retval = true;
        // File source=new File(inputFilename);
        
        retval = outputString.writeFile("default", f);
        
        return retval;
    }

	public String getInputFilename() {
		return inputFilename;
	}

	public void setInputFilename(String inputFilename) {
		this.inputFilename = inputFilename;
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
}
