package frontend.umlModel;
/**
 * 
 * @modelguid {50FE9E40-CA27-4918-8036-AE6BB2234B81}
 */
public class Expression extends Element {
	/**
	 * 
	 * @modelguid {309A3711-D4AD-478E-B46A-C6A228A046FE}
	 */
	public String language;

	/**
	 * 
	 * @modelguid {596F39D1-2D5E-414D-970D-20CD1E8B9B7C}
	 */
	public String body;

	/** @modelguid {D98E482E-C9B1-43CB-9994-E120069CDF3C} */
	public Expression() {
		super();
		
		//Initialize body and language as empty strings
		body="";
		language="";
	}

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {E696E9CF-E042-4D77-8E74-35B79A86BAFD}
	 */
	public void accept(Visitor v) {
		super.accept(v);
		
		v.visitExpression(this);
	}

}

