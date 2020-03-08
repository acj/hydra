package frontend.umlModel;

import java.util.ArrayList;

/**
 * 
 * @modelguid {59ECD1B8-0692-4C85-BEC5-0929152D71E1}
 */
public abstract class ModelElement extends Element {
	/**
	 * 
	 * @modelguid {AC60DF99-4672-409D-892C-56A0286761BE}
	 */
	public String name;

//	/**
//	 * 
//	 * @modelguid {2BE120BD-F117-439A-8B66-27D8C25F96CC}
//	 */
//	public boolean isSpecification;

	/**
	 * 
	 * @modelguid {20B3C1F9-73E9-4D68-ACC3-6E41340E8ECB}
	 */
	public String xmiID;

	/** @modelguid {7158BACA-C8EB-4E50-A4B0-D60A6BEC939D} */
	public Namespace namespace;

	/**
	 * 
	 * @modelguid {CBD256A7-FF2B-4041-BBDF-367DE0FA7477}
	 */
	public Action effect;

	/**
	 * 
	 * @modelguid {E47372DC-3253-4623-9D7C-07B95C7EA904}
	 */
	public java.util.ArrayList constraint;

	/**
	 * 
	 * @modelguid {1D0CF67C-D660-4714-8DD4-3EF6A5C21370}
	 */
	public java.util.ArrayList stereotype;

	/** @modelguid {24DDAE0C-7124-4890-A420-4FFEF8F9917D} */
	public String toString() {
		return name;
	}
	
	/** @modelguid {E35FAC3D-D926-44F7-B794-8D007A9B622E} */
	public ModelElement()
	{
		super();
		constraint=new ArrayList();
		stereotype=new ArrayList();
	}
}
