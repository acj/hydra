package frontend.xmi2hil;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;

import frontend.umlModel.ActionExpression;
import frontend.umlModel.Attribute;
import frontend.umlModel.BooleanExpression;
import frontend.umlModel.CallEvent;
import frontend.umlModel.CompositeState;
import frontend.umlModel.DataType;
import frontend.umlModel.Expression;
import frontend.umlModel.FinalState;
import frontend.umlModel.Guard;
import frontend.umlModel.Model;
import frontend.umlModel.ModelElement;
import frontend.umlModel.Operation;
import frontend.umlModel.Parameter;
import frontend.umlModel.PseudoState;
import frontend.umlModel.SimpleState;
import frontend.umlModel.State;
import frontend.umlModel.StateMachine;
import frontend.umlModel.StateVertex;
import frontend.umlModel.Transition;
import frontend.umlModel.UMLClass;
import frontend.umlModel.UninterpretedAction;
import frontend.umlModel.Visitor;


/**
 * Performs validation of the UML model that is built from XMI data.
 *  
 * @modelguid {C7CD8188-A5AF-4FDB-9754-F712A3E48175}
 */
public class UmlModelValidator extends Visitor {

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitActionExpression(xmiParser.ActionExpression)
	 * @modelguid {BF83D59D-4214-4B10-BEAB-8FD0B68841AD}
	 */
	public void visitActionExpression(ActionExpression e) {
		super.visitActionExpression(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitAttribute(xmiParser.Attribute)
	 * @modelguid {74E873D6-EA57-41A0-BFED-D32408E5E563}
	 */
	public void visitAttribute(Attribute e) {
		//Get the initialValue if there is one
		if (e.initialValue != null) {
			e.initialValue.accept(this);
		}

	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitBooleanExpression(xmiParser.BooleanExpression)
	 * @modelguid {2A22081D-6E2A-4D87-81AA-C74A1C0C727C}
	 */
	public void visitBooleanExpression(BooleanExpression e) {
		super.visitBooleanExpression(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitCallEvent(xmiParser.CallEvent)
	 * @modelguid {9F4C69F8-EB12-4E08-B339-AF45A7A03CE4}
	 */
	public void visitCallEvent(CallEvent e) {
		super.visitCallEvent(e);
	}
	
	/** @modelguid {58A48FF4-9949-4456-A52D-1C80B12C3A16} */
	String currentClassName;
	/** @modelguid {AD37F34E-2097-4978-9995-E367E31207AB} */
	String currentStateName;

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitClass(xmiParser.Class)
	 * @modelguid {DD1C5C38-5315-4129-89EF-5E2B35B9859C}
	 */
	public void visitClass(UMLClass e) {
		String className=e.name;
		currentClassName=e.name;
		
		if(!className.matches("[a-zA-Z_][a-zA-Z0-9_]*"))
		{
			System.err.println("Syntax error in class name: "+className);
		}

		//Iterate the features, i.e. attributes and operations
		Iterator<?> it = e.feature.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}

		//Then go to the state machine
		it = e.ownedElement.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitCompositeState(xmiParser.CompositeState)
	 * @modelguid {DF343D9E-EF45-4867-BB97-6337484B2A1C}
	 */
	public void visitCompositeState(CompositeState e) {
		//	super.visitCompositeState(e);

		if (e.subvertex.size() == 0) {
			//We have a single state, no container
			String statename = e.name;
			 if(!statename.matches("[a-zA-Z_]\\w*"))
			 {
				 System.err.println("Syntax error in state name: " + statename + " in container: " + e.container.name); 
			 }

			//Write entry and exit actions
			if (e.entry != null) {
				String entryAction = e.entry.script.body;
				if (entryAction != null && !entryAction.equals("")) {
				}
			}

			if (e.exit != null) {
				String exitAction = e.entry.script.body;
				if (exitAction != null && !exitAction.equals("")) {
				}
			}

			//Generate the transitions			
			Iterator<?> it = e.outgoing.iterator();
			while (it.hasNext()) {
				Transition trans = (Transition) it.next();
				trans.accept(this);
			}
		} else {
			//We have a container state

			//Make sure we do not have the top container here
			//The top container will be the only one with container == null
			if (e.container != null) {
				//data.add("\tCompositeState " + compositeName + " {");
			}
			Iterator<?> it = e.subvertex.values().iterator();
			while (it.hasNext()) {
				StateVertex sv = (StateVertex) it.next();
				sv.accept(this);
			}

			//Again, do not add this for the top container
			if (e.container != null) {
				//data.add("\t}");
			}
		}
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitDataType(xmiParser.DataType)
	 * @modelguid {C6CE4318-6498-4D1D-A67F-8E2C5878E5FA}
	 */
	public void visitDataType(DataType e) {
		super.visitDataType(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitFinalState(xmiParser.FinalState)
	 * @modelguid {8D803F6E-8F82-4610-9743-62D437FD255B}
	 */
	public void visitFinalState(FinalState e) {
		super.visitFinalState(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitGuard(xmiParser.Guard)
	 * @modelguid {87046A62-AD81-43E2-9C3B-AC2075255311}
	 */
	public void visitGuard(Guard e) {
		super.visitGuard(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitModel(xmiParser.Model)
	 * @modelguid {58629D2D-97B5-444D-A2D9-4DBDEBFCDED8}
	 */
	public void visitModel(Model e) {
		Iterator<?> it = e.ownedElement.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitOperation(xmiParser.Operation)
	 * @modelguid {1E6D37E4-FF15-44AD-AF49-897573F1E1EC}
	 */
	public void visitOperation(Operation e) {
		String operationName=e.name;
		
		if(!operationName.matches("[a-zA-Z][a-zA-Z0-9]*"))
		{
			System.err.println("Syntax error in operation name: " + operationName);
		}
		
		//Visit all parameters
		Iterator<?> it = e.parameter.iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}
		
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitParameter(xmiParser.Parameter)
	 * @modelguid {5E91A64B-5F9F-4CDE-B0C6-3188246AE2DC}
	 */
	public void visitParameter(Parameter e) {
		if(!e.type.name.matches("[a-zA-Z][a-zA-Z0-9]*"))
		{
			System.err.println("Syntax error in parameter: " + e.type.name);
		}
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitPseudotate(xmiParser.PseudoState)
	 * @modelguid {6360D8A1-45E1-4931-851A-005E71F18C25}
	 */
	public void visitPseudoState(PseudoState e) {
		if (!e.kind.equals("initial")) {
			//We only handle initial states
			return;
		}
		
		if(e.outgoing.size()==0)
		{
			System.err.println("Error: Initial state in container [" + e.container.name + "] of class [" + currentClassName + "] has no outgoing transitions.");    
		}

		Iterator<?> it = e.outgoing.iterator();
		int i = 0;

		while (it.hasNext()) {
			i++;
			Transition trans = (Transition) it.next();

			String action = "";
			if (trans.effect != null) {
				action = trans.effect.script.body;
				// TODO: Do something with this return value.
				boolean syntaxCheckPassed = syntaxCheckAction(action);
			}
		}
	}

	/** @modelguid {4545D8A8-365A-4085-8466-A6AA174EA62D} */
	private boolean syntaxCheckAction(String action) {

		//Remove all blanks
		action=action.replaceAll(" ","");

		StringTokenizer st = new StringTokenizer(action, " ;");

		ArrayList<String> actions = new ArrayList<String>();
		ArrayList<String> signals = new ArrayList<String>();

		while (st.hasMoreElements()) {
			String thisAction = st.nextToken();

			// First we shave off the () if we have not parameters (Hydra wants it like that)
			if (thisAction.endsWith("()")) {
				thisAction = thisAction.substring(0, thisAction.length() - 2);
			}

			// Separate actions from signals
			if (thisAction.startsWith("^")) {
				signals.add(thisAction);
			} else {
				actions.add(thisAction);
			}
		}

//		// Process the actions first
//		Iterator<String> it = actions.iterator();
//		while (it.hasNext()) {
//			//String thisAction = (String) it.next();
//			// TODO: Check syntax
//		}
//
//		// Then do the signals
//		it = signals.iterator();
//		while (it.hasNext()) {
//			//String thisSignal = (String) it.next();
//			// TODO: Check syntax
//		}

		return true;
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitSimpleState(xmiParser.SimpleState)
	 * @modelguid {4913AE2C-A50E-4CC7-B71A-95789E6BBDA6}
	 */
	public void visitSimpleState(SimpleState e) {
		super.visitSimpleState(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitState(xmiParser.State)
	 * @modelguid {D8DF3CAB-9E72-4449-AC9E-DE41497A091D}
	 */
	public void visitState(State e) {
		if (e instanceof CompositeState) {
			CompositeState cs = (CompositeState) e;
			cs.accept(this);
		}
		//else... XDE does not create any normal states
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitStateMachine(xmiParser.StateMachine)
	 * @modelguid {61B01AD2-234D-44CC-A22B-E440CF7A0793}
	 */
	public void visitStateMachine(StateMachine e) {
		super.visitStateMachine(e);

		e.top.accept(this);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitTransition(xmiParser.Transition)
	 * @modelguid {996C4305-A279-4296-89E2-FB670C465836}
	 */
	public void visitTransition(Transition e) {
		String trigger;
		String guard;
		String action;
		String target;

		if (e.trigger != null) {
			trigger = e.trigger.name;
		}
		if (e.guard != null) {
			guard = e.guard.expression.body;
		}
		if (e.effect != null) {
			action = e.effect.script.body;
			// TODO: Do something with this return value
			boolean syntaxCheckPassed = syntaxCheckAction(action);
		}
		if (e.target != null) {
			target = e.target.name;
		}
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitUninterpretedAction(xmiParser.UninterpretedAction)
	 * @modelguid {C6BF2394-5B85-4416-A99D-5FA0CC0FDF8A}
	 */
	public void visitUninterpretedAction(UninterpretedAction e) {
		super.visitUninterpretedAction(e);
	}

	/* (non-Javadoc)
	 * @see xmi2hil.Visitor#visitExpression(xmiParser.Expression)
	 * @modelguid {FB3CEFA1-B253-4150-9756-C89481651DA1}
	 */
	public void visitExpression(Expression e) {
		super.visitExpression(e);
	}

}
