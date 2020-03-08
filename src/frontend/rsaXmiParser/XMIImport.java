package frontend.rsaXmiParser;

import java.io.*;
import java.util.Iterator;
import java.util.Stack;
import java.util.TreeMap;
import java.util.Vector;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

/**
 * A class for parsing XMI model data created by Rational Software Modeler or
 * Rational Software Architect.
 * 
 * XMI version: 2.1
 * UML version: 2.2
 */
public class XMIImport {
    class State {
    	String id;
    	String name;
    	
    	public State(String id, String name) {
    		this.id = id;
    		this.name = name;
    	}
    }
    
    class Transition {
    	String source;
    	String destination;
    	String expression;
    	
    	public Transition(String src, String dst, String expr) {
    		source = src;
    		destination = dst;
    		expression = expr;
    	}
    }
    
    class EnumeratedType {
    	String name;
    	int next_int;
    	TreeMap<String, Integer> literals;
    	
    	public EnumeratedType(String name) {
    		this.name = name;
    		next_int = 0;
    		literals = new TreeMap<String, Integer>();
    	}
    	
    	public void addLiteral(String name) {
    		literals.put(name, next_int++);
    	}
    	
    	public int getLiteralValue(String name) {
    		return literals.get(name);
    	}
    }

    public static void main(String[] args) {
    	XMIImport imp = new XMIImport();
    	
    	if (args.length < 1) {
    		System.err.println("Usage: " + imp.getClass().getName() + " <input.xmi>");
    		System.exit(1);
    	} else {
    		try {
				imp.Import(args[0]);
			} catch (FileNotFoundException e) {
				System.err.println("No such file: " + args[0]);
			} catch (IOException e) {
				System.err.println("Couldn't write to output file");
				e.printStackTrace();
			}
    	}
    }
    
	public void Import(String Filename) throws IOException {
        // variables
		BufferedWriter termOut = new BufferedWriter(new FileWriter("terminals.txt"));
		BufferedWriter hilOut = new BufferedWriter(new FileWriter("model.hil"));

        // create parser
		DOMParser parser = null;
        try {
        	parser = new DOMParser();
        }
        catch (Exception e) {
            System.err.println("error: Unable to instantiate parser");
            e.printStackTrace();
            System.exit(-1);
        }

        // Set up HIL headers
        hilOut.write("Formalize as promela ;\n");
        hilOut.write("Model model {\n");
        
        // Parse some XML!
        //
        // This code is written in accordance with the XMI 1.3 specification.
        // XMI 1.1 is documented at http://www.zvon.org/xxl/XMI/Output/ and is
        // a convenient reference.
        try {
            Vector<Node> classNodes = new Vector<Node>();
            TreeMap<String, EnumeratedType> enumTypes = new TreeMap<String, EnumeratedType>();
            TreeMap<String, String> typeIds = new TreeMap<String, String>(); // xmi.id -> name
            TreeMap<String, String> classInherits = new TreeMap<String, String>(); // subclass -> superclass
            parser.parse(Filename);
            Document document = parser.getDocument();
            
            // Extract enumerations and primitive types
            NodeList enumNodes = document.getElementsByTagName("packagedElement");
            for (int ndx=0; ndx<enumNodes.getLength(); ++ndx) {
                Node eNode = enumNodes.item(ndx);
                Node eNameNode = eNode.getAttributes().getNamedItem("name");
                if (eNameNode != null && 
                        eNameNode.getNodeValue().equals("RoseUserDefinedTypes")) {
                    for (int p_ndx=0; p_ndx<eNode.getChildNodes().getLength(); p_ndx++) {
                        Node primTypeNode = eNode.getChildNodes().item(p_ndx);
                        if (primTypeNode.getAttributes() != null &&
                                primTypeNode.getAttributes().getNamedItem("xmi:id") != null &&
                                primTypeNode.getAttributes().getNamedItem("name") != null) {
                            String xmiId = primTypeNode.getAttributes().getNamedItem("xmi:id").getNodeValue();
                            String name = primTypeNode.getAttributes().getNamedItem("name").getNodeValue();
                            typeIds.put(xmiId, name);
                            EnumeratedType et = new EnumeratedType(name);
                            hilOut.write("\tEnum " + name + " (DEFAULT);\n");
                            enumTypes.put(name, et);
                        }
                    }
                }
            }
            
            // Extract classes from the model
            NodeList allPackagedNodes = document.getElementsByTagName("packagedElement");
            for (int ndx=0; ndx<allPackagedNodes.getLength(); ++ndx) {
                Node n = allPackagedNodes.item(ndx);
                Node typeNode = n.getAttributes().getNamedItem("xmi:type");
                Node nameNode = n.getAttributes().getNamedItem("name");
                if (typeNode != null && nameNode != null) {
                    String nodeId = n.getAttributes().getNamedItem("xmi:id").getNodeValue();
                    String nodeName = n.getAttributes().getNamedItem("name").getNodeValue();
                    typeIds.put(nodeId, nodeName);
                }
            	if (typeNode != null && typeNode.getNodeValue().equals("uml:Class")) {
            		classNodes.add(n);            		
            	}
            }
            
            // Extract generalizations
            NodeList genNodes = document.getElementsByTagName("generalization");
            for (int ndx=0; ndx<genNodes.getLength(); ++ndx) {
                Node gNode = genNodes.item(ndx); 
            	String inheritId = 
            		gNode.getAttributes().getNamedItem("general").getNodeValue();
            	Node parentNode = gNode.getParentNode();
            	String childId = 
            		parentNode.getAttributes().getNamedItem("xmi:id").getNodeValue();
            	String parentName = typeIds.get(inheritId);
            	String childName = typeIds.get(childId);
            	classInherits.put(childName, parentName);
            }
            
            // Extract operations and attributes from each class
            for (int cl_ndx=0; cl_ndx<classNodes.size(); ++cl_ndx) {
                Node cNode = classNodes.get(cl_ndx);
            	NodeList opNodes = cNode.getChildNodes();
            	String classId = cNode.getAttributes().getNamedItem("xmi:id").getNodeValue();
            	String className = cNode.getAttributes().getNamedItem("name").getNodeValue();
            	typeIds.put(classId, className);
            	termOut.write("classname " + className + "\n");
            	// Take care of class inheritance
            	if (classInherits.containsKey(className)) {
            		hilOut.write("\tClass " + className + " < "
            				+ classInherits.get(className) + " {\n");
            	} else {
            		hilOut.write("\tClass " + className + " {\n");
            	}
            	int numFeatures = opNodes.getLength();
            	for (int op_ndx=0; op_ndx<numFeatures; ++op_ndx) {
            	    Node cChildNode = opNodes.item(op_ndx);
            	    
	            	if (cChildNode.getNodeName().equals("ownedOperation")) {
        				String operName = cChildNode.getAttributes().getNamedItem("name").getNodeValue();
        				termOut.write("operation " + operName + "\n");
        				hilOut.write("\t\tSignal " + operName + "(int);\n");
           			} else if (cChildNode.getNodeName().equals("ownedAttribute")) {
        				String attribName = cChildNode.getAttributes().getNamedItem("name").getNodeValue();
        				// TODO: Drill into child nodes to get type
        				//String attribType = cChildNode.getAttributes().getNamedItem("type").getNodeValue();
        				String attribType = "";
        				termOut.write("attribute " + attribName + "\n");
        				
        				if (typeIds.containsKey(attribType)) {
        					hilOut.write("\t\tInstanceVar " + typeIds.get(attribType) +
        							" " + attribName + " := 0 ;\n");
        				} else {
        					System.err.println("Could not find type for attribute " + 
        							attribName + " (type xmi.id = " + attribType + ")");
        					hilOut.write("\t\tInstanceVar int " + attribName + " := 0 ;\n");
        				}
	            	} else if (cChildNode.getNodeName().equals("ownedBehavior")) {
	            		NodeList elementNodes = cChildNode.getChildNodes();
	            		
	            		// Nesting can go to arbitrary depth in state machines,
	            		// but we are only interested in states and transitions.
	            		
	            		// Now look for StateMachine nodes
	            		int numElements = elementNodes.getLength();
	            		for (int element_ndx=0; element_ndx<numElements; ++element_ndx) {
	            			if (elementNodes.item(element_ndx).getNodeName() == "UML:StateMachine") {
	            				//String smName = elementNodes.item(element_ndx).getAttributes().getNamedItem("name").getNodeValue();
	            				//hilOut.write("statemachine " + smName + "\n");
	            				
	            				// Extract transitions first
	            				TreeMap<String, Vector<Transition>> transMap = new TreeMap<String, Vector<Transition>>();
	            				NodeList smChildNodes = elementNodes.item(element_ndx).getChildNodes();
	            				int numSmc = smChildNodes.getLength();
	            				
	            				for (int smc_ndx=0; smc_ndx<numSmc; smc_ndx++) {
	            					if (smChildNodes.item(smc_ndx).getNodeName() == "UML:StateMachine.transitions") {
	            						NodeList transitionNodes = smChildNodes.item(smc_ndx).getChildNodes(); 
	            						for (int tr_ndx=0; tr_ndx<transitionNodes.getLength(); tr_ndx++) {
	            							Node trNode = transitionNodes.item(tr_ndx);
	            							if (trNode.getNodeName() == "UML:Transition") {
	            								// Source and destination of this transition
	            								String src = trNode.getAttributes().getNamedItem("source").getNodeValue();
	            								String dst = trNode.getAttributes().getNamedItem("target").getNodeValue();
	            								// Expression (events, guard, and effect)
	            								String expr = "";
	            								NodeList trChildNodes = trNode.getChildNodes();
	            								for (int trc_ndx=0; trc_ndx<trChildNodes.getLength(); trc_ndx++) {
	            									if (trChildNodes.item(trc_ndx).getNodeName() == "UML:ModelElement.taggedValue") {
	            										NodeList taggedValueChildNodes = trChildNodes.item(trc_ndx).getChildNodes();
	            										for (int tvc_ndx=0; tvc_ndx<taggedValueChildNodes.getLength(); tvc_ndx++) {
	            											if (taggedValueChildNodes.item(tvc_ndx).getNodeName() == "UML:TaggedValue") {
	            												expr = taggedValueChildNodes.item(tvc_ndx).getAttributes().getNamedItem("value").getNodeValue();
	            												if (expr.contains("CDATA")) {
	            													expr = ""; // Remove spurious comments
	            												}
	            												expr = expr.replaceAll("\n", "").replaceAll("\r", "");
	            											}
	            										}
	            									}
	            								}
	            								Vector<Transition> targets;
	            								if (transMap.containsKey(src)) {
	            									targets = transMap.get(src);
	            								} else {
	            									targets = new Vector<Transition>();
	            								}
	            								targets.add(new Transition(src, dst, expr));
	            								transMap.put(src, targets);
	            								
	            								// TODO: UML:Transition.effect and UML:Transition.guard
	            							}
	            						}	            						
	            					}
	            				}

	            				// Now extract states
	            				//
	            				// The composite states in a StateMachine node
	            				// can be nested.  We maintain a stack of these
	            				// that must be empty before we can conclude
	            				// that all states have been accounted for.
	            				//TreeMap<String, String> idToStateNameMap = new TreeMap<String, String>();
	            				for (int smc_ndx=0; smc_ndx<numSmc; smc_ndx++) {
	            					if (smChildNodes.item(smc_ndx).getNodeName() == "UML:StateMachine.top") {
	            						Stack<Node> stateNodes = new Stack<Node>();
	            						
	            						Node topNode = smChildNodes.item(smc_ndx);
	            						NodeList topChildren = topNode.getChildNodes();
	            						int numTopc = topChildren.getLength();
	            						for (int topc_ndx=0; topc_ndx<numTopc; topc_ndx++) {
	            							if (topChildren.item(topc_ndx).getNodeName() == "UML:CompositeState") {
	            								stateNodes.push(topChildren.item(topc_ndx));
	            							}
	            						}
	            						
	            						// Process the stack
	            						while (!stateNodes.empty()) {
	            							Node sn = stateNodes.pop();
	            							NodeList stateChildren = sn.getChildNodes();
	            							/*
	            							if (stateChildren.getLength() > 3) {
	            								System.err.println("Exception: CompositeState has more than one child (should be a single UML:CompositeState.subvertex)!  Found " + stateChildren.getLength() + " children.");
	            								System.err.println(stateChildren);
	            							}
	            							*/
	            							
	            							if ( ! sn.getAttributes().getNamedItem("name").getNodeValue().equals("ROOT")) {
	            								hilOut.write("\t\tCompositeState " + sn.getAttributes().getNamedItem("xmi.id").getNodeValue() + " {\n");	            								
	            							}
	            							for (int s_ndx=0; s_ndx<stateChildren.getLength(); s_ndx++) {
	            								Node subvertNode = stateChildren.item(s_ndx);
	            								if (subvertNode.getNodeName() == "UML:CompositeState.subvertex") {
	            									NodeList subvertChildren = subvertNode.getChildNodes();
	            									for (int subv_ndx=0; subv_ndx<subvertChildren.getLength(); subv_ndx++) {
	            										Node subvertChild = subvertChildren.item(subv_ndx);
		            									if (subvertChild.getNodeName() == "UML:CompositeState") {
			            									stateNodes.push(subvertChild);
			            								} else if (subvertChild.getNodeName() == "UML:SimpleState") {
			            									hilOut.write("\t\t\tState " + subvertChild.getAttributes().getNamedItem("xmi.id").getNodeValue() + " {\n");
			            									String stateId = subvertChild.getAttributes().getNamedItem("xmi.id").getNodeValue();
			            									Vector<Transition> outTrans = transMap.get(stateId);
			            									for (Iterator<Transition> it = outTrans.iterator(); it.hasNext(); ) {
			            										Transition trans = it.next();
			            										hilOut.write("\t\t\t\tTransition \"" + trans.expression + "\" to " + trans.destination + ";\n");
			            									}
			            									hilOut.write("\t\t\t}\n");
			            								} else if (subvertChild.getNodeName() == "UML:Pseudostate") {
			            									String pseudoType = subvertChild.getAttributes().getNamedItem("kind").getNodeValue();
			            									if (pseudoType.equals("initial")) {
			            										hilOut.write("\t\t\tInitial \"\" " + subvertChild.getAttributes().getNamedItem("xmi.id").getNodeValue() + ";\n");
			            									} else if (pseudoType.equals("branch")) {
			            										//hilOut.write("\t\t\t// Branch point\n");
			            									}
			            									hilOut.write("\t\t\tState " + subvertChild.getAttributes().getNamedItem("xmi.id").getNodeValue() + " {\n");
			            									String stateId = subvertChild.getAttributes().getNamedItem("xmi.id").getNodeValue();
			            									Vector<Transition> outTrans = transMap.get(stateId);
			            									for (Iterator<Transition> it = outTrans.iterator(); it.hasNext(); ) {
			            										Transition trans = it.next();
			            										hilOut.write("\t\t\t\tTransition \"" + trans.expression + "\" to " + trans.destination + ";\n");
			            									}
			            									hilOut.write("\t\t\t}\n");
			            								}
	            									}
	            								}
	            							}
	            							if ( ! sn.getAttributes().getNamedItem("name").getNodeValue().equals("ROOT")) {
	            								hilOut.write("\t\t}\n"); // End State, Initial, CompositeState
	            							}
	            						}
	            					}
	            				}	            				
	            			}
	            		}
	            	}
            	}
            	termOut.newLine();
            	hilOut.write("\t}\n"); // Object
            }
            // Extract state machines
            for (int cl_ndx=0; cl_ndx<classNodes.size(); ++cl_ndx) {
            	NodeList opNodes = classNodes.get(cl_ndx).getChildNodes();
            	int numChildren = opNodes.getLength();
            	
            	for (int op_ndx=0; op_ndx<numChildren; ++op_ndx) {
	            	
            	}
            }
        }
        catch (SAXParseException e) {
            // ignore
        }
        catch (Exception e) {
            System.err.println("error: Parse error occurred - "+e.getMessage());
            if (e instanceof SAXException) {
                Exception nested = ((SAXException)e).getException();
                if (nested != null) {
                    e = nested;
                }
            }
            e.printStackTrace(System.err);
            System.exit(-1);
        }
        
        hilOut.write("}"); // Model
        
        termOut.close();
        hilOut.close();
	}

}
