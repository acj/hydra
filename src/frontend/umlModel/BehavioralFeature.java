package frontend.umlModel;

import java.util.ArrayList;

/**
 * 
 * @modelguid {001CBB2B-7C5F-4112-8737-CD06A60E1185}
 */
public abstract class BehavioralFeature extends Feature {
	/**
	 * 
	 * @modelguid {BCDD99DA-E340-41D5-8F98-5FCFC387D8E7}
	 */
	public boolean isQuery;

	/**
	 * 
	 * @modelguid {99841AED-12C2-4046-A99F-78D19E67B144}
	 */
	public java.util.ArrayList parameter;
	
	/** @modelguid {116E18D4-26F3-421A-AFF1-49CF325CB6E0} */
	public BehavioralFeature()
	{
		parameter=new ArrayList();
	}

}

