package xdeXmiParser;


import java.util.HashMap;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.traversal.DocumentTraversal;
import org.w3c.dom.traversal.NodeFilter;
import org.w3c.dom.traversal.NodeIterator;

import umlModel.Attribute;
import umlModel.CallEvent;
import umlModel.CompositeState;
import umlModel.Constraint;
import umlModel.DataType;
import umlModel.FinalState;
import umlModel.Model;
import umlModel.ModelElement;
import umlModel.Operation;
import umlModel.Parameter;
import umlModel.PseudoState;
import umlModel.StateMachine;
import umlModel.Stereotype;
import umlModel.StubState;
import umlModel.SubmachineState;
import umlModel.SynchState;
import umlModel.Transition;
import umlModel.UMLClass;
import umlModel.UninterpretedAction;

/**
 * Traverses the DOM tree and creates a skeleton element for each XMI ID.
 * 
 * @modelguid {CB41373F-1775-48D2-9C9B-DB3F95611D56}
 */
public class XmiIdResolver {
	/**
	 * @modelguid {67E74CF8-8190-42DD-8F4C-C03B6B3CAB88}
	 */
	private java.util.HashMap<String, ModelElement> modelElements;

	/**
	 * @modelguid {F84ADA02-4CEB-4D60-B5AD-9B7113E5A10E}
	 */
	public XmiIdResolver() {
		super();
		modelElements = new HashMap<String, ModelElement>();
	}

	public boolean isVerbose = true;

	/**
	 * @modelguid {FDEB2A4E-C466-4E3F-85E6-ED18B72EA458}
	 */
	public void readModelElements(Document doc) {
		if (isVerbose) {
			System.out.println("Creating model elements");
		}

		Node root = doc.getDocumentElement();
		int whattoshow = NodeFilter.SHOW_ALL;
		NodeFilter nodefilter = null;
		boolean expandreferences = false;

		DocumentTraversal traversal = (DocumentTraversal) doc;
		NodeIterator nit = traversal.createNodeIterator(root, whattoshow, nodefilter, expandreferences);

		// Traverse the DOM tree in DFS and create model elements for the IDs
		Node thisNode = nit.nextNode();

		while (thisNode != null) {
			ModelElement newElement = null;
			if (thisNode.getNodeType() == Node.ELEMENT_NODE) {
				NamedNodeMap attributes = thisNode.getAttributes();

				if (thisNode.getNodeName().equals("UML:Model")) {
					// UML Classes
					Model newModel = new Model();
					newElement = newModel;

				} else if (thisNode.getNodeName().equals("UML:Class")) {
					// UML Classes
					UMLClass newClass = new UMLClass();
					newElement = newClass;

					newClass.isActive = parseBoolean(attributes.getNamedItem("isActive").getNodeValue());

				} else if (thisNode.getNodeName().equals("UML:Operation")) {
					// An operation
					Operation newOp = new Operation();
					newElement = newOp;

					newOp.isAbstract = parseBoolean(attributes.getNamedItem("isAbstract").getNodeValue());
					newOp.isLeaf = parseBoolean(attributes.getNamedItem("isLeaf").getNodeValue());
					newOp.isRoot = parseBoolean(attributes.getNamedItem("isRoot").getNodeValue());
					newOp.concurrency = attributes.getNamedItem("concurrency").getNodeValue();
					newOp.isQuery = parseBoolean(attributes.getNamedItem("isQuery").getNodeValue());
					newOp.visibility = attributes.getNamedItem("visibility").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:Attribute")) {
					// An operation
					Attribute newAt = new Attribute();
					newElement = newAt;

					newAt.changeability = attributes.getNamedItem("changeability").getNodeValue();
					newAt.targetScope = attributes.getNamedItem("targetScope").getNodeValue();
					newAt.ownerScope = attributes.getNamedItem("ownerScope").getNodeValue();
					newAt.visibility = attributes.getNamedItem("visibility").getNodeValue();
					newAt.ordering = attributes.getNamedItem("ordering").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:Parameter")) {
					// A parameter, i.e. return value
					Parameter newPar = new Parameter();
					newElement = newPar;

					newPar.kind = attributes.getNamedItem("kind").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:StateMachine")) {
					// State machines
					StateMachine newSM = new StateMachine();
					newElement = newSM;

				} else if (thisNode.getNodeName().equals("UML:CompositeState")) {
					// A composite state
					CompositeState newCS = new CompositeState();
					newElement = newCS;
					newCS.isConcurrent = parseBoolean(attributes.getNamedItem("isConcurrent").getNodeValue());

				} else if (thisNode.getNodeName().equals("UML:Pseudostate")) {
					// A pseudo state, such as an initial state
					PseudoState newPS = new PseudoState();
					newElement = newPS;
					newPS.kind = attributes.getNamedItem("kind").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:FinalState")) {
					// A final state
					FinalState newFS = new FinalState();
					newElement = newFS;

				} else if (thisNode.getNodeName().equals("UML:Transition")) {
					// A transition
					Transition newTrans = new Transition();
					newElement = newTrans;

				} else if (thisNode.getNodeName().equals("UML:DataType")) {
					// A transition
					DataType newDT = new DataType();
					newElement = newDT;

				} else if (thisNode.getNodeName().equals("UML:UninterpretedAction")) {
					// A transition
					UninterpretedAction newUA = new UninterpretedAction();
					newElement = newUA;

				} else if (thisNode.getNodeName().equals("UML:CallEvent")) {
					// A transition
					CallEvent newCE = new CallEvent();
					newElement = newCE;

				} else if (thisNode.getNodeName().equals("UML:Constraint")) {
					// A new constraint (uses for the time invariants)
					Constraint newConst = new Constraint();
					newElement = newConst;

				} else if (thisNode.getNodeName().equals("UML:SubmachineState")) {
					// A submachine state
					SubmachineState newSms = new SubmachineState();
					newElement = newSms;

				} else if (thisNode.getNodeName().equals("UML:Stereotype")) {
					// A stereotype
					Stereotype newStype = new Stereotype();
					newElement = newStype;
					newStype.name = attributes.getNamedItem("name").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:FinalState")) {
					// A final state
					FinalState newFS = new FinalState();
					newElement = newFS;

				} else if (thisNode.getNodeName().equals("UML:StubState")) {
					// A stub state
					StubState newSS = new StubState();
					newElement = newSS;

					newSS.referenceState = attributes.getNamedItem("referenceState").getNodeValue();

				} else if (thisNode.getNodeName().equals("UML:SynchState")) {
					// A synch state (bound attribute not used by XDE)
					SynchState newSS = new SynchState();
					newElement = newSS;
				}

				// Add these basic values to all elements and add element to the hashmap with its ID as the key
				if (newElement != null) {
					if (attributes.getNamedItem("name") != null) {
						newElement.name = attributes.getNamedItem("name").getNodeValue();
					}

					if (attributes.getNamedItem("xmi.id") != null) {
						newElement.xmiID = attributes.getNamedItem("xmi.id").getNodeValue();
					}

					// Put in hash list
					modelElements.put(newElement.xmiID, newElement);
				} else {
					// System.err.println("Failed to identify " + thisNode.toString());
				}
			}

			// Iterate to the next node
			thisNode = nit.nextNode();
		}
		if (isVerbose) {
			System.out.println("Model element creation finished");
		}
	}

	/** @modelguid {421DA8A2-0A0B-485D-B02E-DE7D286FEED7} */
	private boolean parseBoolean(String name) {
		// Borrowed from JRE 5.0
		return ((name != null) && name.equalsIgnoreCase("true"));
	}

	/**
	 * @modelguid {0F57EFC3-CF9B-4617-B24F-A3A5CBF0C9E6}
	 */
	public ModelElement getElementWithId(String id) {
		ModelElement returnValue = null;
		returnValue = (ModelElement) modelElements.get(id);

		returnValue = (ModelElement) modelElements.get(id);

		if (returnValue == null) {
			// System.err.println("Failed to resolve id" + id);
			return null;
		}
		// else
		return returnValue;

	}

	/** @modelguid {6E2ADB9C-FD3A-411D-9CBC-7509925D4949} */
	public ModelElement getElementOfNode(Node node) {
		ModelElement returnValue = null;
		NamedNodeMap attributes = node.getAttributes();
		if (attributes != null && attributes.getNamedItem("xmi.id") != null) {
			returnValue = (ModelElement) modelElements.get(attributes.getNamedItem("xmi.id").getNodeValue());
		}

		if (returnValue == null) {
			// System.err.println("Failed to resolve " + node.toString());
			return null;
		}
		// else
		return returnValue;

	}

}
