package frontend.umlModel;
/**
 * 
 * @modelguid {38A1C439-5A7B-4680-B25B-EEC26C3D21B1}
 */
public class StubState extends StateVertex {
	/** @modelguid {4BBFDB7A-97E0-419D-9026-CB0019356EB5} */
	public String referenceState;

	/** @modelguid {84EAF9EC-4907-4465-8550-FC191089D034} */
	public void accept(Visitor v) {
			v.visitStubState(this);
	}

}

