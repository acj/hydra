import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

import backend.h2PFoundation.NodeUtilityClass;
import backend.h2PParser.ParseException;


/*
 * MainDriver
 * 
 * Driver class for bootstrapping Hydra.
 */
public class Main {
	enum Mode { CHECK_XMI, XMI_TO_HIL, XMI_TO_PROMELA, HIL_TO_PROMELA };
	/**
	 * Launch Hydra using arguments from the command line.
	 * 
	 * @param args Command line arguments.
	 */
	public static void main(String[] args) throws ParseException {
		String sourceFilename = "";
        String sinkFilename = "";
        Mode mode = Mode.XMI_TO_PROMELA;
        if (args.length != 3) {
        	printUsage();
			System.exit(0);
        } else {
        	if (args[0].equals("-c")) {
        		mode = Mode.CHECK_XMI;
        	} else if (args[0].equals("-h")) {
        		mode = Mode.XMI_TO_HIL; 
        	} else if (args[0].equals("-p")) {
        		mode = Mode.HIL_TO_PROMELA;
        	} else if (args[0].equals("-x")) {
        		mode = Mode.XMI_TO_PROMELA;
        	}
        	sourceFilename = args[1];
        	sinkFilename = args[2];
        }
        
        File sourceFile = new File(sourceFilename);
        File sinkFile = new File(sinkFilename);
        switch (mode) {
	        case CHECK_XMI:
	        {
	        	// TODO
	        	System.err.println("XMI check is not yet implemented.");
	        	System.exit(1);
	        }
	        case XMI_TO_HIL:
	        {
	        	convertXMItoHIL(sourceFile, sinkFile);
	        	break;
	        }
	        case HIL_TO_PROMELA:
	        {
	        	convertHILtoPromela(sourceFile, sinkFile);
	        	break;
	        }
	        case XMI_TO_PROMELA:
	        {
	        	convertXMItoPromela(sourceFile, sinkFile);
	        }
        }
	    System.exit(0);
	}
	
	private static void convertXMItoHIL(File sourceFile, File sinkFile) {
    	frontend.xmi2hil.ConversionDriver x2hDriver = new frontend.xmi2hil.ConversionDriver(sourceFile);
    	String intermediateFilename = sourceFile.getName();
    	intermediateFilename = intermediateFilename.replace(".xmi", "") + ".hil";
    	x2hDriver.setHilIntermediateFilename(intermediateFilename);
		try {
			x2hDriver.convert();
			x2hDriver.save(sinkFile);
			System.out.println("\nOutput written to " + sinkFile);
		} catch (ParseException e) {
			System.err.println("Error parsing `" + sourceFile + "'");
			e.printStackTrace();
			System.exit(1);
		}
	}

	private static void convertXMItoPromela(File sourceFile, File sinkFile) {
    	frontend.xmi2hil.ConversionDriver x2hDriver = new frontend.xmi2hil.ConversionDriver(sourceFile);
    	String intermediateFilename = sourceFile.getName();
    	intermediateFilename = intermediateFilename.replace(".xmi", "") + ".hil";
    	x2hDriver.setHilIntermediateFilename(intermediateFilename);
    	String hilText = "";
		try {
			hilText = x2hDriver.convert();
		} catch (ParseException e) {
			System.err.println("Error parsing `" + sourceFile + "'");
			e.printStackTrace();
			System.exit(1);
		}
		
        convertHILtoPromela(hilText, sinkFile);
	}
	
	private static void convertHILtoPromela(String hilText, File sinkFile) {
        backend.hil2Promela.ConversionDriver h2pDriver = new backend.hil2Promela.ConversionDriver();
        h2pDriver.setHILInput(hilText);
        try {
			h2pDriver.convert();
			if (h2pDriver.save(sinkFile)) {
				System.out.println("Output written to " + sinkFile);
			} else {
				System.err.println("Error writing output to `" + sinkFile + "'");
				System.exit(1);
			}
		} catch (ParseException e) {
			System.err.println("Error parsing HIL data");
			e.printStackTrace();
			System.exit(1);
		}
	}
	
	private static void convertHILtoPromela(File sourceFile, File sinkFile) {
        backend.hil2Promela.ConversionDriver h2pDriver = new backend.hil2Promela.ConversionDriver(sourceFile);
        try {
			h2pDriver.convert();
			if (h2pDriver.save(sinkFile)) {
				System.out.println("Output written to " + sinkFile);
			} else {
				System.err.println("Error writing output to `" + sinkFile + "'");
				System.exit(1);
			}
		} catch (ParseException e) {
			System.err.println("Error parsing `" + sourceFile + "'");
			e.printStackTrace();
			System.exit(1);
		}
	}

	private static void printUsage() {
		// TODO: Extract the current git revision's SHA and present it here
		//		 along with the normal version number.
		System.err.println("Hydra v4.0\n\n" +
				"Usage: java -jar hydra.jar <mode flag> <input file> <output file>\n\n" +
				"Flags:\n" +
				"\t-c\tCheck XMI model for errors\n" +
				"\t-h\tConvert XMI file to Hydra Intermediate Language (advanced)\n" +
				"\t-p\tConvert Hydra Intermediate Language to Promela (advanced)\n" +
				"\t-x\tConvert XMI file to Promela\n\n" +
				"Hydra was developed by the Software Engineering and Network Systems Group\n" +
				"at Michigan State University.");
	}
}
