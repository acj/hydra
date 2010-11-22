package promelaParser;

import java.io.File;

/**
 * 
 * @modelguid {216E017C-89C6-4B0B-B2EF-EAD4F959447D}
 */
public interface FormalModelFile {
	/**
	 * 
	 * @modelguid {B3B1DD5B-3B06-4EC4-89C9-A2658A793948}
	 */
	public String toString();

	/**
	 * 
	 * @modelguid {684F4EC8-2213-46C2-A72B-B13121882713}
	 */
	public File getFile();
	
	/** @modelguid {DF920B94-4015-40AC-9F16-E1038B9D411E} */
	public void setFile(File file);

}

