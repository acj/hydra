package frontend.umlModel;


import java.util.TreeMap;

/** @modelguid {D152D7D4-52DA-4F58-A4D7-2D76204C7891} */
public class CompositeState extends State {
	/**
	 * 
	 * @modelguid {1BA139E2-AA9B-49BB-AA06-115D5D9FB397}
	 */
	public java.util.TreeMap subvertex;

	/**
	 * 
	 * @modelguid {4B97A26B-FDEE-425C-A4F0-5FD84C17872C}
	 */
	public boolean isConcurrent;

	/**
	 * 
	 * @modelguid {B221CCAC-5B95-4D1E-BCBF-F30269851B20}
	 */
	public boolean isRegion;
	
	/** @modelguid {FC906A18-6291-454F-A286-3DF002CCE851} */
	public CompositeState()
	{
		subvertex=new TreeMap();
	}

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {07F29460-742F-4B19-BC98-1576C715DB74}
	 */
	public void accept(Visitor v) {
		//Don't call super, it's state		
		//super.accept(v);
	
		v.visitCompositeState(this);
	}

}

