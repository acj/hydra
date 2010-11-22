package umlModel;
/**
 * 
 * @modelguid {B41A6A49-CDF7-49FE-8CCF-06674973D3F6}
 */
public class SynchState extends StateVertex {
	/** @modelguid {403BD03F-3620-42CE-ADC4-887959B865FC} */
	public int bound;

	/** @modelguid {99897A17-5B11-40F0-8424-62591FCDC479} */
	public void accept(Visitor v) {
			v.visitSynchState(this);
	}
}
