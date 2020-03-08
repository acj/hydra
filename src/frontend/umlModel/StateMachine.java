package frontend.umlModel;


import java.util.ArrayList;

/** @modelguid {FAD834CA-461D-47F0-95F1-51CB4E1B12EE} */
public class StateMachine extends ModelElement {
	/**
	 * 
	 * @modelguid {B3D0FD54-0959-47B9-AB52-89C891278681}
	 */
	public ArrayList transitions;

	/**
	 * 
	 * @modelguid {03278816-E1C9-49DF-9296-A78556CB08E9}
	 */
	public State top;
	
	/** @modelguid {EDE57166-AFAF-4BD3-89DF-2C8547B7FC03} */
	public StateMachine ()
	{
		transitions=new ArrayList();
	}

	/* (non-Javadoc)
	 * @see umlModel.Element#accept(umlModel.Visitor)
	 * @modelguid {826C6278-7E30-4FB7-9127-A83419725F99}
	 */
	public void accept(Visitor v) {
		super.accept(v);
		
		v.visitStateMachine(this);
	}

}

