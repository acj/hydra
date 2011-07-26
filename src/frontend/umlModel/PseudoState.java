package frontend.umlModel;


/**
 * 
 * @modelguid {56226642-2208-4258-A333-FB33D044FF64}
 */
public class PseudoState extends StateVertex {
	/**
	 * 
	 * @modelguid {F04F32E4-66B1-4FCC-8314-98551BF6BA56}
	 */
	public String kind;

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {C18BC9DC-CC07-4D0C-8EDA-17BC317CD864}
	 */
	public void accept(Visitor v) {
		//super.accept(v);
		
		v.visitPseudoState(this);
	}

}

