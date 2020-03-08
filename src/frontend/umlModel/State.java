package frontend.umlModel;


import java.util.ArrayList;

/**
 * 
 * @modelguid {0D871910-CF13-4A02-917E-E8BBB3BC6824}
 */
public class State extends StateVertex {
	/**
	 * 
	 * @modelguid {04DAA39D-BDCD-4FC2-8886-2884EB5D037D}
	 */
	public Action exit;

	/**
	 * 
	 * @modelguid {790D52CF-F202-432F-A087-82D77FB5C25A}
	 */
	public Action entry;

	/**
	 * 
	 * @modelguid {E9885263-A194-469A-919B-2D5634F724B1}
	 */
	public Action doActivity;

	/**
	 * 
	 * @modelguid {263FD1D7-749E-4409-914E-7B66DA579D7C}
	 */
	public java.util.ArrayList internalTransition;
	/**
	 * 
	 * @modelguid {F9105BAF-AB5E-44B7-B928-742A295D6552}
	 */
	public Event deferrableEvent;

	
	/** @modelguid {5772AAED-D8D0-4DCD-B7B1-2776A27876B9} */
	public State()
	{
		internalTransition=new ArrayList();
	}

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {167E4304-73C2-4FD6-8C26-35EFBBA60B4E}
	 */
	public void accept(Visitor v) {
		//super.accept(v);

		v.visitState(this);
	}

}

