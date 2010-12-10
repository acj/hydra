/*
 * Created on Jul 3, 2005
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package xmi2hil;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import umlModel.Model;
import umlModel.Visitor;


/**
 * @author konradsa
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 * @modelguid {21811F9F-0F8C-460D-B6A7-D30FFADD5C57}
 */
public class HilWriter {

	/** @modelguid {BD199D39-7858-4689-A1EE-F27E17F51BDE} */
	public void writeToHilFile(Model umlModel, File target) {

		//TODO fixc the validator, gets me in an infinite loop as of now
		//Validate the model
		//Visitor v=new UmlModelValidator();
		//v.visitModel(umlModel);
		
		//Generate the HIL file
		Visitor v = new ToHilVisitor();
		v.visitModel(umlModel);
		List<?> data = ((ToHilVisitor) v).getData();

		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(target));

			Iterator<?> it = data.iterator();

			while (it.hasNext()) {

				out.write((String) it.next());
				out.newLine();
			}
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	
	}

}
