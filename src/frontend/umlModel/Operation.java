package frontend.umlModel;


/**
 * 
 * @modelguid {5F94F5D3-3776-49A0-8F25-0E002CCAFEC0}
 */
public class Operation extends BehavioralFeature {
	/**
	 * 
	 * @modelguid {F999E955-F7B5-4E51-8596-1D06C225D16A}
	 */
	public String concurrency;

	/**
	 * 
	 * @modelguid {DBD19388-9303-4D68-87FD-D2ED88926B2A}
	 */
	public boolean isRoot;

	/**
	 * 
	 * @modelguid {D9CE28D5-DF92-4807-BBB7-D81291F40139}
	 */
	public boolean isLeaf;

	/**
	 * 
	 * @modelguid {612C59DD-7506-4A31-94C7-43B0B1B58976}
	 */
	public boolean isAbstract;

	/**
	 * 
	 * @modelguid {F0BF30FE-58C4-449B-99FD-4E61E405D191}
	 */
	public String specification;
	

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {2A745783-0FEE-483C-8C87-4A075F92B3A9}
	 */
	public void accept(Visitor v) {
		// TODO Auto-generated method stub
		super.accept(v);
		
		v.visitOperation(this);
	}

}

