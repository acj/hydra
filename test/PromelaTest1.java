

//import h2PVisitors.*;
import h2PFoundation.NodeUtilityClass;
import h2PVisitors.Parser.ParseException;

import xmi2hil.ConversionDriver;

/*
 * PromelaTest1
 * 
 * Test Driver program for tmpPromelaVisitor.
 * It can accept an optional argument, which if present
 * it will read the input from the specified name in the
 * parameter.
 * 
 * This class instantiates a WorldRootNode to store the
 * structure, a Hil2PromelaVisitor, to visit the structure,
 * and a HIL file parser.  
 * Once the HIL file is read into the rootNode, the node's
 * accept function is called with the instance of
 * Hil2PromelaVisitor as its visitor class.
 */
public class PromelaTest1 {

	/**
	 * @param args
	 */
	/**
	 * initial param arg for testing:
	 * E:\apps\eclipse\sandbox\tmpPromelaVisitor\nestedcompositeExit1C.xyz
	 */
	public static void main(String[] args) throws ParseException {
        ConversionDriver cvd;
		String filename = "";
        String outputFilename = "";
        String hilIntFilename = "";
        NodeUtilityClass nuc = new NodeUtilityClass();
//       boolean outputToFile = false;
//        AcceptReturnType outputString; // = new AcceptReturnType();
		
/*		InputStream ios = System.in; // input sourcee, default, standard in
		if (args.length > 0) { // read from a file if argument present.
			filename = args[0];
			try {
			  FileInputStream fis = new FileInputStream(filename);
			  ios = fis;
			} catch (FileNotFoundException fnfe) {
			  System.out.println("Error. File '" + filename + "' Not found. Exiting.");
			}
            if (args.length > 1) {
                outputFilename = args[1];
//              outputToFile = true;   
            }
		}*/
		// outputString.readFile("default", filename);
        
        if (args.length == 0) {
           System.out.println ("Please enter an input filename in the first argument. ");
           System.exit(0);
        } else {
        	filename = args[0];
        	if (args.length > 1) {
        		outputFilename = args[1];
        	}
        	if (args.length > 2) {
        		hilIntFilename = args[2];
        	}
        }
        
        cvd = new ConversionDriver(filename);
		
        nuc.println("***** Starting HydraVJ v3.01 (10/24/2005)*******\n");
        nuc.println("***** Warning: Contains Hack around Process Termination Bug! *******\n");
        nuc.println("***** Warning: All processes active! *******\n");
	    try {
	    	cvd.setHilIntermediateFilename(hilIntFilename);
            cvd.convert();
            if (!cvd.hasErrors()) { // save file only if error free
              cvd.save(outputFilename);
            }
            /*
            outputString = new AcceptReturnType(cvd.promelaOutput);
            if (outputString.defV().length() > 0) {
                if (!outputToFile) {
                  nuc.print (outputString.defV());   
                } else {
                    outputString.writeFile("default", args[1]);
                }
            }*/
		} catch (ParseException x) {
		    	System.out.println("Parse Error. Exiting.");
		    	throw x;
		}
	}

}
