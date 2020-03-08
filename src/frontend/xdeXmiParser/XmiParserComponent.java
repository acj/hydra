package frontend.xdeXmiParser;

import java.io.File;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.traversal.DocumentTraversal;
import org.w3c.dom.traversal.NodeFilter;
import org.w3c.dom.traversal.NodeIterator;


import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import frontend.umlModel.Action;
import frontend.umlModel.ActionExpression;
import frontend.umlModel.Attribute;
import frontend.umlModel.BehavioralFeature;
import frontend.umlModel.BooleanExpression;
import frontend.umlModel.CallEvent;
import frontend.umlModel.Classifier;
import frontend.umlModel.CompositeState;
import frontend.umlModel.Constraint;
import frontend.umlModel.Expression;
import frontend.umlModel.Guard;
import frontend.umlModel.Model;
import frontend.umlModel.ModelElement;
import frontend.umlModel.Namespace;
import frontend.umlModel.Operation;
import frontend.umlModel.Parameter;
import frontend.umlModel.State;
import frontend.umlModel.StateMachine;
import frontend.umlModel.StateVertex;
import frontend.umlModel.Stereotype;
import frontend.umlModel.StubState;
import frontend.umlModel.SubmachineState;
import frontend.umlModel.Transition;
import frontend.umlModel.UMLClass;
import frontend.umlModel.UninterpretedAction;

/**
 * Performs the work of parsing XMI data and constructing a
 * faithful model of the UML model that is encoded in the XMI.
 * 
 * @modelguid {4F11A787-BEE6-4D3C-A92E-D8F8C04618B4}
 */
public class XmiParserComponent {

	/**
	 * @modelguid {875E69C2-CCD8-4E9F-B534-DCF874817FB7}
	 */
	private XmiIdResolver myResolver;

	/** @modelguid {35BAFD45-0AA2-4496-917F-9D0DBE78DA1E} */
	private Model theUMLModel = null;

	/** @modelguid {35D1A1A0-FC7D-4F83-BBCD-0B4FBFB08CDD} */
	public Model getUMLModel() {
		// Return the last parsed and constructed UML model
		return theUMLModel;
	}

    public boolean isVerbose = true;
    
	/** @modelguid {6D150003-60F1-461B-8700-F4D36F5EE0F3} */
	public boolean parse(File xmiFile) {
        if (isVerbose) {
            System.out.println("Parsing " + xmiFile);
        }

		Document doc = null;
		Node root = null;
		int whattoshow = 0;
		NodeFilter nodefilter = null;
		boolean expandreferences = false;
		DOMParser parser = null;

		// Open XML file and parse it, creating the Grammar representation
		try {
			parser = new DOMParser();
			parser.parse(xmiFile.toString());
			doc = parser.getDocument();
			root = doc.getDocumentElement();
			whattoshow = NodeFilter.SHOW_ALL;
            if (isVerbose) {
            	System.out.println("Xerces parsing complete");
            }
		} catch (Exception ex) {
			System.err.println(ex);
		}

		// Instantiate a new XmiIdResolver
		myResolver = new XmiIdResolver();
        myResolver.isVerbose = isVerbose;
		myResolver.readModelElements(doc);

		// Create a new document traversal
		DocumentTraversal traversal = (DocumentTraversal) doc;
		NodeIterator nit = traversal.createNodeIterator(root, whattoshow, nodefilter, expandreferences);
		theUMLModel = null;

		Node thisNode = nit.nextNode();

		// Skip the header as it does not contain any information we are intesrested in
		while (!thisNode.getNodeName().equals("UML:Model")) {
			thisNode = nit.nextNode();
		}

		if (thisNode.getNodeType() == Node.ELEMENT_NODE) {
			if (thisNode.getNodeName().equals("UML:Model")) {
				theUMLModel = (Model) myResolver.getElementOfNode(thisNode);
				theUMLModel.setFile(xmiFile);
				while (thisNode.hasChildNodes()) {
					Node theChild = thisNode.getFirstChild();
					processXMINode(theChild, theUMLModel);
				}
			}
		} else {
            if (isVerbose) {
            	System.err.println("UML model not found!");
            }
			return false;
		}

		return true;
	}

	/** @modelguid {7E10E396-FF28-4752-9A35-02B8C652D4EA} */
	private void processAttribute(Node node, ModelElement newElement, NamedNodeMap attributes) {
		// A parameter, i.e. return value
		Attribute newAt = (Attribute) newElement;
		if (attributes.getNamedItem("type") != null)
		// There is a type defined
		{
			String typeID = attributes.getNamedItem("type").getNodeValue();
			Object returnV = myResolver.getElementWithId(typeID);
			newAt.type = (Classifier) returnV;
		}

		Node initialValueNode = null;
		while (node.hasChildNodes()) {
			initialValueNode = node.getFirstChild();

			if (!initialValueNode.getNodeName().equals("UML:Attribute.initialValue")) {
				node.removeChild(initialValueNode);
			} else {
				break;
			}
		}

		// There is an initial value, get it
		if (initialValueNode != null) {
			Node boolExprNode = initialValueNode.getFirstChild();
			while (!boolExprNode.getNodeName().equals("UML:Expression")) {
				initialValueNode.removeChild(boolExprNode);
				boolExprNode = initialValueNode.getFirstChild();
			}

			NamedNodeMap boolExpAttributes = boolExprNode.getAttributes();
			String body = boolExpAttributes.getNamedItem("body").getNodeValue();
			String language = boolExpAttributes.getNamedItem("language").getNodeValue();

			Expression newEx = new Expression();
			newAt.initialValue = newEx;
			newEx.body = body;
			newEx.language = language;
		}
	}

	/** @modelguid {2BD1F209-95A5-4D65-B2B8-C0AD3B13B776} */
	private void processBehavioralFeatureParameter(Node node, ModelElement prevElement) {
		// Tells us that a parameter is coming, usually a return value
		BehavioralFeature bf = (BehavioralFeature) prevElement;
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			ModelElement returnValue = processXMINode(theChild, null);
			if (returnValue != null) {
				bf.parameter.add(returnValue);
			}
		}
	}

	/** @modelguid {73303997-BDE7-479A-B280-174028D71B4B} */
	private void processClass(Node node, ModelElement newElement) {
		// UML Classes
		UMLClass newClass = (UMLClass) newElement;
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			processXMINode(theChild, newClass);
		}
	}

	/** @modelguid {0170B19A-0886-45CE-88E4-44F34A2720C9} */
	private void processClassifierFeature(Node node, ModelElement prevElement) {
		// Features, structural (variables) and behavioral (operations)
		Classifier cla = (Classifier) prevElement;
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			ModelElement returnValue = processXMINode(theChild, null);
			if (returnValue != null) {
				cla.feature.put(returnValue, returnValue);
			}
		}
	}

	/** @modelguid {54674610-196A-40BD-AE35-4F8AB844DDAD} */
	private void processCompositeState(Node node, ModelElement newElement) {
		// TODO deferrable event missing
		// TODO internal transition missing

		// A composite state
		CompositeState newCS = (CompositeState) newElement;

		// A composite state can have several children and serves as a container for these children (container is
		// added below)
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			processXMINode(theChild, newCS);
		}
	}

	/** @modelguid {BB118F6A-92D7-44D7-B9E4-BE419EF19F2E} */
	private void processCompositeStateSubvertex(Node node, ModelElement prevElement) {
		// A composite state
		CompositeState cs = (CompositeState) prevElement;

		// A composite state can have several children and serves as a container for these children (container is
		// added below)
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			StateVertex returnValue = (StateVertex) processXMINode(theChild, cs);
			if (returnValue != null) {
				cs.subvertex.put(returnValue.name, returnValue);
				returnValue.container = cs;
			}
		}
	}

	/** @modelguid {001CADBF-6B0E-4DA1-946F-282CC00DCDE6} */
	private void processConstraint(Node node, ModelElement newElement) {
		// The top of the state machine
		Constraint constr = ((Constraint) newElement);

		// Get the constrained element and make the associations
		NamedNodeMap constraintAttributes = node.getAttributes();
		String constrainedElementID = constraintAttributes.getNamedItem("constrainedElement").getNodeValue();
		ModelElement constrainedElement = myResolver.getElementWithId(constrainedElementID);
		constr.constrainedElement = constrainedElement;
		constrainedElement.constraint.add(constr);

		Node constraintBodyNode = node.getFirstChild();
		while (!constraintBodyNode.getNodeName().equals("UML:Constraint.body")) {
			node.removeChild(constraintBodyNode);
			constraintBodyNode = node.getFirstChild();
		}

		// Now add the boolean expression for the constraint
		Node boolExprNode = constraintBodyNode.getFirstChild();
		while (!boolExprNode.getNodeName().equals("UML:BooleanExpression")) {
			constraintBodyNode.removeChild(boolExprNode);
			boolExprNode = constraintBodyNode.getFirstChild();
		}

		NamedNodeMap boolExpAttributes = boolExprNode.getAttributes();
		String body = boolExpAttributes.getNamedItem("body").getNodeValue();
		String language = boolExpAttributes.getNamedItem("language").getNodeValue();

		BooleanExpression newBE = new BooleanExpression();
		constr.body = newBE;
		newBE.body = body;
		newBE.language = language;
	}

	/** @modelguid {F0CCAC4A-CE37-4A73-8345-548FDDEEFFAB} */
	private ModelElement processGuard(Node node, ModelElement prevElement) {
		ModelElement newElement;
		{
			// A transition guard
			Transition theTrans = (Transition) prevElement;

			Node guardNode = node.getFirstChild();
			while (!guardNode.getNodeName().equals("UML:Guard")) {
				node.removeChild(guardNode);
				guardNode = node.getFirstChild();
			}

			Guard newGuard = new Guard();
			theTrans.guard = newGuard;

			Node guardExpressionNode = guardNode.getFirstChild();
			while (!guardExpressionNode.getNodeName().equals("UML:Guard.expression")) {
				guardNode.removeChild(guardExpressionNode);
				guardExpressionNode = guardNode.getFirstChild();
			}

			Node boolExprNode = guardExpressionNode.getFirstChild();
			while (!boolExprNode.getNodeName().equals("UML:BooleanExpression")) {
				guardExpressionNode.removeChild(boolExprNode);
				boolExprNode = guardExpressionNode.getFirstChild();
			}

			NamedNodeMap boolExpAttributes = boolExprNode.getAttributes();
			String body = boolExpAttributes.getNamedItem("body").getNodeValue();
			String language = boolExpAttributes.getNamedItem("language").getNodeValue();

			BooleanExpression newBE = new BooleanExpression();
			newGuard.expression = newBE;
			newBE.body = body;
			newBE.language = language;

			// It has no ID, so we need to return it
			newElement = newGuard;

		}
		return newElement;
	}

	/** @modelguid {EA6D6073-ACD8-42DC-8DBB-08CB2CEF5049} */
	private void processNamespaceOwnedElement(Node node, ModelElement prevElement) {
		// Owned elements
		Namespace ns = (Namespace) prevElement;
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			ModelElement returnValue = processXMINode(theChild, null);
			if (returnValue != null) {
				ns.ownedElement.put(returnValue.name, returnValue);
			}
		}
	}

	/** @modelguid {7A4A3F7B-770E-415C-9460-1E016D0F10DD} */
	private void processOperation(Node node, ModelElement newElement) {
		// An operation
		Operation newOp = (Operation) newElement;
		// Children are parameters of the operation
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			ModelElement returnValue = processXMINode(theChild, newOp);
			if (returnValue != null) {
				newOp.parameter.add(returnValue);
			}
		}
	}

	/** @modelguid {A9C9D37A-4266-455B-AF34-4D0F29208A17} */
	private void processParameter(ModelElement newElement, NamedNodeMap attributes) {
		// A parameter, i.e. return value
		Parameter newPar = (Parameter) newElement;
		if (attributes.getNamedItem("type") != null)
		// There is a type defined
		{
			String typeID = attributes.getNamedItem("type").getNodeValue();
			Object returnV = myResolver.getElementWithId(typeID);
			newPar.type = (Classifier) returnV;
		}
	}

	/** @modelguid {405D2157-4AAD-4161-BF1C-319B4FB69625} */
	private void processStateDoActivity(Node node, ModelElement prevElement) {
		// A do activity
		State state = (State) prevElement;

		Node doActivityNode = node.getFirstChild();
		while (!doActivityNode.getNodeName().equals("UML:UninterpretedAction")) {
			node.removeChild(doActivityNode);
			doActivityNode = node.getFirstChild();
		}

		Action returnValue = (Action) processXMINode(doActivityNode, null);
		if (returnValue != null) {
			state.doActivity = returnValue;
		}
	}

	/** @modelguid {C48CA646-5146-4123-9126-DD1DBB7D1EAF} */
	private void processStateEntry(Node node, ModelElement prevElement) {
		// An entry action
		State state = (State) prevElement;

		Node entryNode = node.getFirstChild();
		while (!entryNode.getNodeName().equals("UML:UninterpretedAction")) {
			node.removeChild(entryNode);
			entryNode = node.getFirstChild();
		}

		Action returnValue = (Action) processXMINode(entryNode, null);
		if (returnValue != null) {
			state.entry = returnValue;
		}
	}

	/** @modelguid {3931CAC2-63C2-49EF-9913-5B05F2DBEE43} */
	private void processStateExit(Node node, ModelElement prevElement) {
		// An axit action
		State state = (State) prevElement;

		Node exitNode = node.getFirstChild();
		while (!exitNode.getNodeName().equals("UML:UninterpretedAction")) {
			node.removeChild(exitNode);
			exitNode = node.getFirstChild();
		}

		Action returnValue = (Action) processXMINode(exitNode, null);
		if (returnValue != null) {
			state.exit = returnValue;
		}
	}

	/** @modelguid {1965A08E-5E36-4076-83E0-975E4609977F} */
	private void processStateMachine(Node node, ModelElement newElement) {
		// State machines
		StateMachine newSM = (StateMachine) newElement;
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			processXMINode(theChild, newSM);
		}
	}

	/** @modelguid {6E83BC1A-125D-4729-BEB1-88C7A6556BB1} */
	private void processStateMachineTop(Node node, ModelElement prevElement) {
		// The top of the state machine
		StateMachine sm = ((StateMachine) prevElement);
		// One child will point us to the top
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			ModelElement returnValue = processXMINode(theChild, null);
			if (returnValue != null) {
				sm.top = (State) returnValue;
			}
		}
	}

	/** @modelguid {2A2D8D23-7725-4F34-BD27-ACA176FEABE0} */
	private void processStateMachineTransitions(Node node, ModelElement prevElement) {
		// The top of the state machine
		StateMachine sm = ((StateMachine) prevElement);
		// One child will point us to the top
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			Transition returnValue = (Transition) processXMINode(theChild, null);
			if (returnValue != null) {
				sm.transitions.add(returnValue);
			}
		}

	}

	/** @modelguid {696EB861-7385-4A11-8F10-15BBF40F6B70} */
	private void processTransition(Node node, ModelElement newElement, NamedNodeMap attributes) {
		// A transition
		Transition newTran = (Transition) newElement;
		String sourceID = attributes.getNamedItem("source").getNodeValue();
		String targetID = attributes.getNamedItem("target").getNodeValue();

		// Set the source and target of the transition
		newTran.source = (StateVertex) myResolver.getElementWithId(sourceID);
		newTran.target = (StateVertex) myResolver.getElementWithId(targetID);

		// Sanity check
		if (newTran.source == null || newTran.target == null) {
			System.err.println("Source or target of transition " + newTran + " not found!");
			System.exit(0);
		}

		// Add the transition to the set of incoming and outgoing transitions of the respective states
		newTran.source.outgoing.add(newTran);
		newTran.target.incoming.add(newTran);

		// Adding the transition for now to the container of the source
		newTran.source.container.internalTransition.add(newTran);

		// A transition can have guards, effect, and triggers as childs
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			processXMINode(theChild, newTran);
		}
	}

	/** @modelguid {D2940DAF-1CB4-4002-9F2C-C732B031AC5F} */
	private void processTransitionEffect(Node node, ModelElement prevElement) {
		// A transition effect
		Transition theTrans = (Transition) prevElement;

		Node uninterpretedActionNode = node.getFirstChild();

		// We need to remove all nodes until we get to the action node
		while (!uninterpretedActionNode.getNodeName().equals("UML:UninterpretedAction")) {
			node.removeChild(uninterpretedActionNode);
			uninterpretedActionNode = node.getFirstChild();
		}

		Action transitionEffect = (Action) processXMINode(uninterpretedActionNode, null);
		theTrans.effect = transitionEffect;
	}

	/** @modelguid {52F17222-21F6-448F-9C1E-58290C42E86D} */
	private ModelElement processTransitionTrigger(Node node, ModelElement prevElement) {
		ModelElement newElement;
		{
			// A transition trigger, 0 or 1
			Transition theTrans = (Transition) prevElement;

			Node eventNode = node.getFirstChild();
			while (!eventNode.getNodeName().equals("UML:Event")) {
				node.removeChild(eventNode);
				eventNode = node.getFirstChild();
			}

			// An event
			Node modelElementNode = eventNode.getFirstChild();
			while (!modelElementNode.getNodeName().equals("UML:ModelElement.namespace")) {
				eventNode.removeChild(modelElementNode);
				modelElementNode = eventNode.getFirstChild();
			}

			// I did not really understand the purpose of the name space here, but this works
			Node namespaceNode = modelElementNode.getFirstChild();
			while (!namespaceNode.getNodeName().equals("UML:Namespace")) {
				modelElementNode.removeChild(namespaceNode);
				namespaceNode = modelElementNode.getFirstChild();
			}

			// I did not really understand the purpose of the name space here, but this works
			Node ownedElementNode = namespaceNode.getFirstChild();
			while (!ownedElementNode.getNodeName().equals("UML:Namespace.ownedElement")) {
				namespaceNode.removeChild(ownedElementNode);
				ownedElementNode = namespaceNode.getFirstChild();
			}

			Node callEventNode = ownedElementNode.getFirstChild();
			while (!callEventNode.getNodeName().equals("UML:CallEvent")) {
				ownedElementNode.removeChild(callEventNode);
				callEventNode = ownedElementNode.getFirstChild();
			}

			// A call event
			// Get the call event from the resolver
			NamedNodeMap ceAttrib = callEventNode.getAttributes();
			String callEventID = ceAttrib.getNamedItem("xmi.id").getNodeValue();
			CallEvent ce = (CallEvent) myResolver.getElementWithId(callEventID);

			// Get the operation of the call event and set it
			if (ceAttrib.getNamedItem("operation") == null) {
				System.err.println("ERROR: Operation reference used in transition not defined! Typo in Model? Validate it!");
				return null;
			} else {
				String operationID = ceAttrib.getNamedItem("operation").getNodeValue();
				ce.operation = (Operation) myResolver.getElementWithId(operationID);
			}

			// Set the trigger of the transition to the new call event
			theTrans.trigger = ce;

			newElement = ce;
		}
		return newElement;
	}

	/** @modelguid {9A03AFC6-669E-4175-8DFF-B3E1D1784FC4} */
	private void processUninterpretedAction(Node node, ModelElement newElement) {
		// An uninterpreted action
		UninterpretedAction ua = (UninterpretedAction) newElement;
		ActionExpression newAE = new ActionExpression();
		ua.script = newAE;

		Node actionScriptNode = node.getFirstChild();
		if (actionScriptNode == null) {
			// Sometimes we get an empty, uninterpreted action in the XMI file
			// We need to intercept that and then return
			return;
		}

		while (!actionScriptNode.getNodeName().equals("UML:Action.script")) {
			node.removeChild(actionScriptNode);
			actionScriptNode = node.getFirstChild();
		}

		Node actionExprNode = actionScriptNode.getFirstChild();
		while (!actionExprNode.getNodeName().equals("UML:ActionExpression")) {
			actionScriptNode.removeChild(actionExprNode);
			actionExprNode = actionScriptNode.getFirstChild();
		}

		NamedNodeMap actionExpAttributes = actionExprNode.getAttributes();
		String body = actionExpAttributes.getNamedItem("body").getNodeValue();
		String language = actionExpAttributes.getNamedItem("language").getNodeValue();

		newAE.body = body;
		newAE.language = language;
	}

	/** @modelguid {EDB55B6B-22FD-4923-8DC8-2806BE45799D} */
	private ModelElement processXMINode(Node node, ModelElement prevElement) {
		ModelElement newElement = null;

		if (node.getNodeType() == Node.TEXT_NODE) {
			// Text nodes are not used in XMI and just clutter up the tree
			// We will do nothing here, they will be removed below
			// System.out.println(node.getTextContent());
		} else if (node.getNodeType() == Node.ELEMENT_NODE) {
			// Identify the current node type and create a part
			newElement = myResolver.getElementOfNode(node);
			NamedNodeMap attributes = node.getAttributes();

			if (node.getNodeName().equals("UML:Namespace.ownedElement"))
				processNamespaceOwnedElement(node, prevElement);

			else if (node.getNodeName().equals("UML:Class"))
				processClass(node, newElement);

			else if (node.getNodeName().equals("UML:Classifier.feature"))
				processClassifierFeature(node, prevElement);

			else if (node.getNodeName().equals("UML:Operation"))
				processOperation(node, newElement);

			else if (node.getNodeName().equals("UML:BehavioralFeature.parameter"))
				processBehavioralFeatureParameter(node, prevElement);

			else if (node.getNodeName().equals("UML:Parameter"))
				processParameter(newElement, attributes);

			else if (node.getNodeName().equals("UML:Attribute"))
				processAttribute(node, newElement, attributes);

			else if (node.getNodeName().equals("UML:StateMachine"))
				processStateMachine(node, newElement);

			else if (node.getNodeName().equals("UML:StateMachine.top"))
				processStateMachineTop(node, prevElement);

			else if (node.getNodeName().equals("UML:CompositeState"))
				processCompositeState(node, newElement);

			else if (node.getNodeName().equals("UML:CompositeState.subvertex"))
				processCompositeStateSubvertex(node, prevElement);

			else if (node.getNodeName().equals("UML:Pseudostate")) {
				processPseudoState(node, prevElement);

			} else if (node.getNodeName().equals("UML:StateMachine.transitions"))
				processStateMachineTransitions(node, prevElement);

			else if (node.getNodeName().equals("UML:Transition"))
				processTransition(node, newElement, attributes);

			else if (node.getNodeName().equals("UML:Transition.guard"))
				newElement = processGuard(node, prevElement);

			else if (node.getNodeName().equals("UML:Transition.effect"))
				processTransitionEffect(node, prevElement);

			else if (node.getNodeName().equals("UML:Transition.trigger"))
				newElement = processTransitionTrigger(node, prevElement);

			else if (node.getNodeName().equals("UML:State.doActivity"))
				processStateDoActivity(node, prevElement);

			else if (node.getNodeName().equals("UML:State.entry"))
				processStateEntry(node, prevElement);

			else if (node.getNodeName().equals("UML:ModelElement.stereotype"))
				processStereotype(node, prevElement);
			
			else if (node.getNodeName().equals("UML:State.exit"))
				processStateExit(node, prevElement);

			else if (node.getNodeName().equals("UML:UninterpretedAction"))
				processUninterpretedAction(node, newElement);

			else if (node.getNodeName().equals("UML:Constraint"))
				processConstraint(node, newElement);

			else if (node.getNodeName().equals("UML:StubState"))
				processStubState(node, newElement, attributes);

			else if (node.getNodeName().equals("UML:FinalState")) // OK
				processFinalState(node, newElement);

			else if (node.getNodeName().equals("UML:SubmachineState"))
				processSubmachineState(node, newElement, attributes);

			else if (node.getNodeName().equals("UML:SynchState"))
				processSynchStateState(node, newElement);

			else {
				// If there is something we don't know, we will do nothing (below, the node, and thereby all its
				// children, will be removed from the parent
			}
		}

		// Remove this node (amd with it all the children) from the dom tree as we have parsed (or ignored) it
		node.getParentNode().removeChild(node);

		return newElement;
	}

	private void processStereotype(Node node, ModelElement prevElement) {
		Node stNode = node.getFirstChild();
		while (!stNode.getNodeName().equals("UML:Stereotype")) {
			node.removeChild(stNode);
			stNode = node.getFirstChild();
		}
		
		NamedNodeMap attributes = stNode.getAttributes();
		
		String stID = attributes.getNamedItem("xmi.id").getNodeValue();
		Stereotype stereotype=(Stereotype) myResolver.getElementWithId(stID);

		//Create associations
		stereotype.extendedElement.add(prevElement);
		prevElement.stereotype.add(stereotype);
	}

	private void processPseudoState(Node node, ModelElement prevElement) {
		// A pseudo state, such as an initial state
		// We don't need to do anything here, since the transition handling will add an outgoings transitions to
		// the initial state
	}

	/**
	 * @param node
	 * @param newElement
	 * @modelguid {644C89C5-AD48-4556-B65D-128D3E5CB7AF}
	 */
	private void processSynchStateState(Node node, ModelElement newElement) {
		// A synch state
		// We don't need to do anything here, since the transition handling will add outgoing and incoming transitions
		// to
		// the synch state
	}

	/**
	 * @param node
	 * @param newElement
	 * @modelguid {FD76837B-43AE-4AAA-9BA7-90276F13DB2A}
	 */
	private void processSubmachineState(Node node, ModelElement newElement, NamedNodeMap attributes) {
		// A submachine state
		SubmachineState newSms = (SubmachineState) newElement;

		// In addition, the submachine may also have a reference to one other state machine
		String submachineRef = attributes.getNamedItem("submachine").getNodeValue();
		newSms.submachine = (StateMachine) myResolver.getElementWithId(submachineRef);

		// A submachine state can have several children and serves as a container for these children (container is
		// added below)
		while (node.hasChildNodes()) {
			Node theChild = node.getFirstChild();
			processXMINode(theChild, newSms);
		}
	}

	/**
	 * @param node
	 * @param newElement
	 * @modelguid {DECCA0D0-E1CA-4A14-803F-AD003E5A0265}
	 */
	private void processFinalState(Node node, ModelElement newElement) {
		// A final state
		// We don't need to do anything here, since the transition handling will add incoming transitions to
		// the final state
	}

	/**
	 * @param node
	 * @param newElement
	 * @modelguid {2F6A1694-E01F-4F33-807B-A71EF0D10672}
	 */
	private void processStubState(Node node, ModelElement newElement, NamedNodeMap attributes) {
		// For a stub state we need to store the referenced state
		StubState ss = (StubState) newElement;
		ss.referenceState = attributes.getNamedItem("referenceState").getNodeValue();
	}
}