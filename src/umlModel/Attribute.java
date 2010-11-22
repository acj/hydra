package umlModel;


/**
 * 
 * @modelguid {DF27B9CA-440F-4176-A533-2F52C5E0FEFF}
 */
public class Attribute extends StructuralFeature {
	/**
	 * 
	 * @modelguid {EEC4E538-EB96-41B8-87C0-55797CA929CA}
	 */
	public Expression initialValue;

	/* (non-Javadoc)
	 * @see xmiParser.ModelElement#accept(umlModel.Visitor)
	 * @modelguid {0C40660E-2C05-449E-82A6-A20026840369}
	 */
	public void accept(Visitor v) {
		// TODO Auto-generated method stub
		super.accept(v);
		
		v.visitAttribute(this);
	}

}

