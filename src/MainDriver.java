import h2PFoundation.NodeUtilityClass;
import h2PVisitors.Parser.ParseException;
import xmi2hil.ConversionDriver;

/*
 * MainDriver
 * 
 * Driver class for bootstrapping Hydra.
 */
public class MainDriver {

	/**
	 * Launch Hydra using arguments from the command line.
	 * 
	 * @param args Command line arguments.
	 */
	public static void main(String[] args) throws ParseException {
		String filename = "";
        String outputFilename = "";
        String hilIntFilename = "";
        
        if (args.length == 0) {
        	printUsage();
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
        
        ConversionDriver cvd = new ConversionDriver(filename);
		
        NodeUtilityClass nuc = new NodeUtilityClass();
        
	    try {
	    	cvd.setHilIntermediateFilename(hilIntFilename);
            cvd.convert();
            if (!cvd.hasErrors()) { // save file only if error free
            	cvd.save(outputFilename);
            	System.err.println("\nOutput written to " + outputFilename);
            }
		} catch (ParseException x) {
		    	System.out.println("Parse Error. Exiting.");
		    	throw x;
		}
	}

	private static void printUsage() {
		System.err.println("Hydra v4.0\n\n" +
				"Usage: java -jar hydra.jar <model XMI input> <Promela output> [intermediate HIL output]\n\n" +
				"Hydra was developed by the Software Engineering and Network Systems Group\n" +
				"at Michigan State University.");
	}
}
