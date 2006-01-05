package xmi2hil;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import umlModel.ActionExpression;
import umlModel.Attribute;
import umlModel.BooleanExpression;
import umlModel.CallEvent;
import umlModel.CompositeState;
import umlModel.Constraint;
import umlModel.DataType;
import umlModel.Expression;
import umlModel.FinalState;
import umlModel.Guard;
import umlModel.Model;
import umlModel.ModelElement;
import umlModel.Operation;
import umlModel.Parameter;
import umlModel.PseudoState;
import umlModel.SimpleState;
import umlModel.State;
import umlModel.StateMachine;
import umlModel.StateVertex;
import umlModel.Transition;
import umlModel.UMLClass;
import umlModel.UninterpretedAction;
import umlModel.Visitor;

/**
 * 
 * @modelguid {2812E3EA-C920-4765-83A7-68594E3D46C9}
 */
public class ToHilVisitor extends Visitor {

	/** @modelguid {E83DB14C-D9A2-4E1D-AD01-955B538FF775} */
	private String tempString;

	/** @modelguid {0302A65E-E86D-435B-9F75-9ACD77739933} */
	private ArrayList tempList;

	/** @modelguid {B4FAB7B7-B60D-415D-A5E1-9F470C3E33E5} */
	private List data;

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitActionExpression(xmiParser.ActionExpression) @modelguid
	 *      {25BC9078-BCE7-4FEE-9B4B-A66595DCE200} @modelguid {25BC9078-BCE7-4FEE-9B4B-A66595DCE200}
	 */
	public void visitActionExpression(ActionExpression e) {
		// TODO Auto-generated method stub
		super.visitActionExpression(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitAttribute(xmiParser.Attribute) @modelguid {AA3CA29B-1DD4-4A4E-BEC0-8D33BE4E6C60}
	 */
	public void visitAttribute(Attribute e) {
		// TODO Auto-generated method stub
		// super.visitAttribute(e);

		// Get the initialValue if there is one
		if (e.initialValue != null) {
			e.initialValue.accept(this);
		}

		// Sanity checks
		if (e.type == null) {
			System.err.println("Have a variable (" + e.name + ") without type here! Correct it!");
			return;
		}

		if (e.name == null) {
			System.err.println("Have a type (" + e.type.name + ") without variable name here! Correct it!");
			return;
		}

		// Write the instance var, with out without initial value
		if (tempString != null && !tempString.equals("")) {
			data.add("\tInstanceVar " + e.type.name + " " + e.name + " := " + tempString + " ;");
		} else {
			data.add("\tInstanceVar " + e.type.name + " " + e.name + " ;");
		}

		tempString = null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitBooleanExpression(xmiParser.BooleanExpression) @modelguid
	 *      {2D2E64EE-3A64-4391-9C29-756C69FCC57E} @modelguid {2D2E64EE-3A64-4391-9C29-756C69FCC57E}
	 */
	public void visitBooleanExpression(BooleanExpression e) {
		// TODO Auto-generated method stub
		super.visitBooleanExpression(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitCallEvent(xmiParser.CallEvent) @modelguid {6BFA0B85-1DAE-448F-A2BA-7F162FCB113F}
	 */
	public void visitCallEvent(CallEvent e) {
		// TODO Auto-generated method stub
		super.visitCallEvent(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitClass(xmiParser.Class) @modelguid {AC1B1BB8-CA84-44E7-B967-DDF14D4A6071}
	 */
	public void visitClass(UMLClass e) {
		// super.visitClass(e);

		data.add("Class " + e.name + " {");

		// Iterate the features, i.e. attributes and operations
		Iterator it = e.feature.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}

		// Then go to the state machine
		it = e.ownedElement.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}

		data.add("}");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitCompositeState(xmiParser.CompositeState) @modelguid
	 *      {99E0CEBB-9986-4BF9-8C29-6A6AC38D2CA5} @modelguid {99E0CEBB-9986-4BF9-8C29-6A6AC38D2CA5}
	 */
	public void visitCompositeState(CompositeState e) {
		// super.visitCompositeState(e);

		if (e.subvertex.size() == 0) {
			// We have a single state, no container
			String statename = e.name;
			data.add("\tState " + statename + "  {");

			// Write entry and exit actions
			if (e.entry != null) {
				String entryAction = e.entry.script.body;
				if (entryAction != null && !entryAction.equals("")) {
					data.add("\tAction \"entry/" + entryAction + "\" ;");
				}
			}

			if (e.exit != null) {
				String exitAction = e.entry.script.body;
				if (exitAction != null && !exitAction.equals("")) {
					data.add("\tAction \"exit/" + exitAction + "\" ;");
				}
			}

			// Attach the timeinvariants
			// WARNING assumes that the costraint is a time invariant
			// only processes the first constraint for now
			if (e.constraint.size() != 0) {
				Constraint constr = (Constraint) e.constraint.get(0);
				data.add("\t\tInvariant \"timeinvar / {" + constr.body.body + "} \" ;");
			}

			// Generate the transitions
			Iterator it = e.outgoing.iterator();
			while (it.hasNext()) {
				Transition trans = (Transition) it.next();
				trans.accept(this);
			}

			data.add("\t}");
		} else {
			// We have a container state
			String compositeName = e.name;

			String statetype = null;

			// Depending on whether we have a concurrent state or not, we will have different names
			if (e.isConcurrent) {
				statetype = "ConcurrentState";
			} else {
				statetype = "CompositeState";
			}

			// Make sure we do not have the top container here
			// The top container will be the only one with container == null
			if (e.container != null) {
				data.add("\t" + statetype + " " + compositeName + " {");
			}

			// Generate the transitions
			Iterator it = e.outgoing.iterator();
			while (it.hasNext()) {
				Transition trans = (Transition) it.next();
				trans.accept(this);
			}

			it = e.subvertex.values().iterator();
			while (it.hasNext()) {
				StateVertex sv = (StateVertex) it.next();
				sv.accept(this);
			}

			// Again, do not add this for the top container
			if (e.container != null) {
				data.add("\t}");
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitDataType(xmiParser.DataType) @modelguid {66181506-751F-40F8-B21C-D5D22E59BF4D}
	 */
	public void visitDataType(DataType e) {
		// TODO Auto-generated method stub
		super.visitDataType(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitFinalState(xmiParser.FinalState) @modelguid {37735AD5-1F69-4E94-9FAA-7B7D1F9B4A60}
	 */
	public void visitFinalState(FinalState e) {
		// TODO Auto-generated method stub
		super.visitFinalState(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitGuard(xmiParser.Guard) @modelguid {F40D8817-3578-4E47-863C-5DB32F6AFB3D}
	 */
	public void visitGuard(Guard e) {
		// TODO Auto-generated method stub
		super.visitGuard(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitModel(xmiParser.Model) @modelguid {5DD58A0A-DA38-466C-B87D-8380BAABA58F}
	 */
	public void visitModel(Model e) {
		// super.visitModel(e);

		data = new ArrayList();

		data.add("Formalize as promela ;");
		
		//Need to remove spaces from the name, otherwise Hydra gives an error
		//Replace spaces with _
		String modelName=e.name;
		modelName=modelName.replaceAll(" ","_");
		data.add("Model " + modelName + "{");

		Iterator it = e.ownedElement.values().iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}

		data.add("");
		data.add("}");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitOperation(xmiParser.Operation) @modelguid {EE37F5D7-8685-4A52-A095-79DD3E878CD9}
	 */
	public void visitOperation(Operation e) {
		// super.visitOperation(e);

		// Gather parameters, don't worry about return value for HIL
		tempList = new ArrayList();
		Iterator it = e.parameter.iterator();
		while (it.hasNext()) {
			((ModelElement) it.next()).accept(this);
		}

		StringBuffer parameters = new StringBuffer("");

		Iterator parIt = tempList.iterator();
		while (parIt.hasNext()) {
			String thisParamter = (String) parIt.next();
			parameters.append(thisParamter + ", ");
		}

		// Remove the last comma again
		if (parameters.length() > 0) {
			int lastComma = parameters.lastIndexOf(",");
			parameters.replace(lastComma, parameters.length(), "");
		}

		tempList = null;

		data.add("\tSignal " + e.name + "(" + parameters + " ) ;");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitParameter(xmiParser.Parameter) @modelguid {A297F408-F28E-4499-8750-A1ED80D8604F}
	 */
	public void visitParameter(Parameter e) {
		// TODO Auto-generated method stub
		// super.visitParameter(e);

		// Hydra does not care about return values
		if (!e.kind.equals("return")) {
			tempList.add(e.type.name);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitPseudotate(xmiParser.PseudoState) @modelguid {25657E58-B9DE-4A8D-BC5C-6A74AC219CFF}
	 */
	public void visitPseudotate(PseudoState e) {
		// super.visitPseudotate(e);

		if (!e.kind.equals("initial")) {
			// We only handle initial states
			return;
		}

		Iterator it = e.outgoing.iterator();
		int i = 0;

		while (it.hasNext()) {
			i++;
			Transition trans = (Transition) it.next();

			String action = "";
			if (trans.effect != null) {
				action = trans.effect.script.body;
				action = preprocessAction(action);
			}

			String target = trans.target.name;

			data.add("\tInitial  \"" + action + "\" " + target + " ;");
		}
	}

	/** @modelguid {47DF82AB-E4D1-4A83-ABD0-DD89EEFBF9F7} */
	private String preprocessAction(String action) {
		// Remove all blanks
		action = action.replaceAll(" ", "");
		
		//Replace all %, that we used for division because of XDE problems, with /
		action = action.replaceAll("%", "/");

		StringTokenizer st = new StringTokenizer(action, " ;");
		StringBuffer actionString = new StringBuffer();

		ArrayList actions = new ArrayList();
		ArrayList signals = new ArrayList();

		while (st.hasMoreElements()) {
			String thisAction = st.nextToken();

			// First we shave off the () if we have not parameters (Hydra wants it like that
			if (thisAction.endsWith("()")) {
				thisAction = thisAction.substring(0, thisAction.length() - 2);
			}

			// Seperate actions from signals
			if (thisAction.startsWith("^")) {
				signals.add(thisAction);
			} else {
				actions.add(thisAction);
			}
		}

		// Process the actions first
		// If we have any actions, prefix / and seperate actions by " ;"
		if (actions.size() != 0) {
			actionString.append("/");
		}
		Iterator it = actions.iterator();
		while (it.hasNext()) {
			String thisAction = (String) it.next();
			// Append to the output
			actionString.append(thisAction + "; ");
		}
		// When we are done, remove the last '; ' again
		if (actionString.length() > 0) {
			actionString.replace(actionString.length() - 2, actionString.length(), "");
		}

		// Then do the signals
		it = signals.iterator();
		while (it.hasNext()) {
			String thisSignal = (String) it.next();
			// Append to the output
			actionString.append(thisSignal);
		}

		return actionString.toString();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitSimpleState(xmiParser.SimpleState) @modelguid {DAED55E9-CF3C-4305-9CD2-A00EDBFA902B}
	 */
	public void visitSimpleState(SimpleState e) {
		// TODO Auto-generated method stub
		super.visitSimpleState(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitState(xmiParser.State) @modelguid {353DC03D-8211-4B8B-8A0D-E4BD8169BC1F}
	 */
	public void visitState(State e) {
		// super.visitState(e);

		if (e instanceof CompositeState) {
			CompositeState cs = (CompositeState) e;
			cs.accept(this);
		}
		// else... XDE does not create any normal states
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitStateMachine(xmiParser.StateMachine) @modelguid
	 *      {E48FCE1C-D780-4F4B-8F56-663867D86233} @modelguid {E48FCE1C-D780-4F4B-8F56-663867D86233}
	 */
	public void visitStateMachine(StateMachine e) {
		// TODO Auto-generated method stub
		super.visitStateMachine(e);

		e.top.accept(this);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitTransition(xmiParser.Transition) @modelguid {4377D3A3-2865-4BDA-8AB2-DAB362781557}
	 */
	public void visitTransition(Transition e) {
		// super.visitTransition(e);

		String trigger = "";
		String guard = "";
		String action = "";
		String target = "";

		if (e.trigger != null) {
			trigger = e.trigger.name;

			// That's where the parameters will end up in
			tempList = new ArrayList();

			CallEvent triggerEvent = null;

			if (e.trigger instanceof CallEvent) {
				triggerEvent = (CallEvent) e.trigger;
			} else {
				System.err.println("Expected a call event!");
				System.exit(0);
			}

			if (triggerEvent.operation == null) {
				System.err.println("Check triggerEvent " + triggerEvent
						+ ", if it seems normal try to delete, save, and rename (XDE bug!)");
			} else if (triggerEvent.operation.parameter != null) {
				Iterator pit = triggerEvent.operation.parameter.iterator();
				while (pit.hasNext()) {
					Parameter par = (Parameter) pit.next();
					if (!par.kind.equals("return")) {
						tempList.add(par.name);
					}
				}

				// Now read the parameters
				if (tempList.size() != 0) {
					trigger = trigger + "(";

					Iterator tempIt = tempList.iterator();
					while (tempIt.hasNext()) {
						String thisPar = (String) tempIt.next();
						trigger = trigger + (thisPar + ",");
					}
					// Remove last comma
					if (trigger.charAt(trigger.length() - 1) == ',') {
						trigger = trigger.substring(0, trigger.length() - 1);
					}

					trigger = trigger + ")";
				}
			}
			tempList = null;
		}

		if (e.guard != null) {
			guard = e.guard.expression.body;
		}
		if (e.effect != null) {
			action = e.effect.script.body;
			action = preprocessAction(action);
		}
		if (e.target != null) {
			target = e.target.name;
		}

		if (guard.equals("")) {
			data.add("\t\tTransition \"" + trigger + action + "\" to " + target + " ;");
		} else {
			data.add("\t\tTransition \"" + trigger + "[" + guard + "]" + action + "\" to " + target + " ;");
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitUninterpretedAction(xmiParser.UninterpretedAction) @modelguid
	 *      {737735CA-249F-4FD6-928F-3070EAF57C72} @modelguid {737735CA-249F-4FD6-928F-3070EAF57C72}
	 */
	public void visitUninterpretedAction(UninterpretedAction e) {
		// TODO Auto-generated method stub
		super.visitUninterpretedAction(e);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#hashCode() @modelguid {6D9C3D8B-3E87-430F-B35C-0B9C7215636A}
	 */
	public int hashCode() {
		// TODO Auto-generated method stub
		return super.hashCode();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#equals(java.lang.Object) @modelguid {211A89D7-B0C8-44E9-A3F7-4F7CF0B4C4BD}
	 */
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return super.equals(obj);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Object#toString() @modelguid {2ABB2DB4-AECB-453D-858A-4CC2910B94CF}
	 */
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see xmi2hil.Visitor#visitExpression(xmiParser.Expression) @modelguid {4DA9250E-ADA1-45C2-BBE7-E6C366BC25C6}
	 */
	public void visitExpression(Expression e) {
		super.visitExpression(e);

		tempString = e.body;
	}

	/** @modelguid {A2552BB6-09B0-4B2B-B117-D1DC93D8349D} */
	public List getData() {
		return data;
	}

}
