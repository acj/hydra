package umlModel;


import java.util.ArrayList;

/**
 * 
 * @modelguid {E66B7819-310E-430A-8979-097A9E01C3EF}
 */
public abstract class StateVertex extends ModelElement {
	/**
	 * 
	 * @modelguid {6811E509-905D-4361-8D93-D290FC8B3FBA}
	 */
	public  java.util.ArrayList outgoing;

	/**
	 * 
	 * @modelguid {3B1FF803-A630-4AD4-A101-C2A5831701B3}
	 */
	public  java.util.ArrayList incoming;

	/**
	 * 
	 * @modelguid {866C941D-FA94-4BF1-9670-CD6422FF0BB0}
	 */
	public  CompositeState container;
	
	/** @modelguid {1B229570-4790-44AA-82A7-B0E8825ED8FC} */
	public StateVertex()
	{
		incoming=new ArrayList();
		outgoing=new ArrayList();
	}
	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {F6DF2949-BCC0-49E9-98CA-5DA8CAD06FEE}
	 */
	public void accept(Visitor v) {
		//super.accept(v);
		
		if (this instanceof State) {

			((State) this).accept(v);
		}
		else if (this instanceof PseudoState)
		{
			((PseudoState) this).accept(v);	
		}
	}

}

