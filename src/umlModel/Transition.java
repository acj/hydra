package umlModel;



/**
 * 
 * @modelguid {45020DAD-AC5D-4F46-BB75-D890A4D53AF6}
 */
public class Transition extends ModelElement {
	/**
	 * 
	 * @modelguid {FAB5E8EF-E108-48D0-998B-88BCE8059843}
	 */
	public StateVertex source;

	/**
	 * 
	 * @modelguid {B1C01AE5-B8C6-4A8C-84A0-1203175C3C53}
	 */
	public StateVertex target;

	/**
	 * 
	 * @modelguid {78D2B6EA-2075-41F8-A2F9-CF077DAEB194}
	 */
	public Event trigger;

	/**
	 * 
	 * @modelguid {BC0877D2-0143-4839-B594-04F8922F0912}
	 */
	public Guard guard;

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {22835A31-708D-4E2E-A7BF-2EE3F988D184}
	 */
	public void accept(Visitor v) {
		super.accept(v);
		
		v.visitTransition(this);
	}

}

