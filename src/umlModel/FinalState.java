package umlModel;
/** @modelguid {9F6709F6-811E-4E6E-B41E-ECCA3CB81D2B} */
public class FinalState extends State {
	/** @modelguid {6E1734E6-B5B1-4CBA-A5C3-69F99C8BAE36} */
	public void accept(Visitor v) {
		//super.accept(v);
		v.visitFinalState(this);
	}
}

