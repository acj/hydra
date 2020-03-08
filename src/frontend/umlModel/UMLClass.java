package frontend.umlModel;


/** @modelguid {F826F915-34B0-402E-8630-F6CCB98C89BB} */
public class UMLClass extends Classifier {
	/**
	 * 
	 * @modelguid {51FC713A-370A-4489-B399-84B941A30EE6}
	 */
	public boolean isActive;

	/* (non-Javadoc)
	 * @see xmiParser.ModelElement#accept(umlModel.Visitor)
	 * @modelguid {3BD48F60-3CC9-481E-8E39-3E83098CE008}
	 */
	public void accept(Visitor v) {
		// TODO Auto-generated method stub
		super.accept(v);
		
		v.visitClass(this);
	}

}

