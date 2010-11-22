package umlModel;


/** @modelguid {41522F76-1A83-4D4D-A4BB-946A680C6F5C} */
public class Parameter extends ModelElement {
	/** @modelguid {4202EF97-BA18-4EA5-81C9-0AA6FD3FFD5E} */
	public Expression defaultValue;

	/** @modelguid {97F1FA43-1B38-4B2A-AAE4-9EA7FEA6DD32} */
	public String kind;
	/**
	 * 
	 * @modelguid {B53F486F-556C-44B4-9789-FAC4BA2C7229}
	 */
	public Classifier type;

	
	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {DAB42751-80F4-4A57-A8AD-1AD638E72BD0}
	 */
	public void accept(Visitor v) {
		// TODO Auto-generated method stub
		super.accept(v);
		
		v.visitParameter(this);
	}

}

