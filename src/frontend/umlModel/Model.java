package frontend.umlModel;

import java.io.File;



/**
 * 
 * @modelguid {7F58C353-8640-4D37-A300-42053DDA5183}
 */
public class Model extends Namespace implements FormalModelFile{
	/* (non-Javadoc)
	 * @see xmiParser.ModelElement#accept(umlModel.Visitor)
	 * @modelguid {BF81ADEE-3E37-48E9-8BCD-D2A58C466942}
	 */
	 
	 private File xmiFile;
	 
	/** @modelguid {8CDC37FE-9306-41C7-931D-D55E0BCDE60D} */
	public void accept(Visitor v) {
		super.accept(v);
		
		v.visitModel(this);
	}

	/* (non-Javadoc)
	 * @see umlModel.FormalModelFile#getFile()
	 * @modelguid {03A24AA3-7FEF-484D-9B32-0C1C3D24DDA3}
	 */
	public File getFile() {
		return xmiFile;
	}

	/* (non-Javadoc)
	 * @see umlModel.FormalModelFile#setFile(java.io.File)
	 * @modelguid {A2E31EBC-9CF2-4B9D-8BC0-3B8B5A131ED6}
	 */
	public void setFile(File file) {
		xmiFile=file;		
	}

}

