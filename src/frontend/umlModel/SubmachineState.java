package frontend.umlModel;
/**
 * 
 * @modelguid {F3A25969-2941-4E6A-82DE-33E30229248A}
 */
public class SubmachineState extends CompositeState {
	/**
	 * 
	 * @modelguid {C6693F35-0AD1-4641-AA88-10A0BB6B800A}
	 */
	public StateMachine submachine;
	
	public void accept(Visitor v) {
		v.visitSubmachineState(this);
	}

}

