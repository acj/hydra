package frontend.rhapsodyXmiParser;

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
            
            // Extract data types
            NodeList typeNodes = document.getElementsByTagName("UML:DataType");
            for (int ndx=0; ndx<typeNodes.getLength(); ++ndx) {
            	String xmiId = typeNodes.item(ndx).getAttributes().getNamedItem("xmi.id").getNodeValue();
            	String name = typeNodes.item(ndx).getAttributes().getNamedItem("name").getNodeValue();
            	typeIds.put(xmiId, name);
            	
            	/*
            	// Warn the user about types that are not supported by Hydra/SPIN
            	if (!name.toLowerCase().equals("int") &&
            			!name.toLowerCase().equals("bool") &&
            			!name.toLowerCase().equals("char")) {
            		System.err.println("Type \"" + name + "\" is not supported by Hydra.  Please consider using INT or BOOL.");
            	}
            	*/
            }
            
            // Extract enumerations
            NodeList enumNodes = document.getElementsByTagName("UML:Enumeration");
            for (int ndx=0; ndx<enumNodes.getLength(); ++ndx) {
            	String xmiId = enumNodes.item(ndx).getAttributes().getNamedItem("xmi.id").getNodeValue();
            	String name = enumNodes.item(ndx).getAttributes().getNamedItem("name").getNodeValue();
            	typeIds.put(xmiId, name);
            	EnumeratedType et = new EnumeratedType(name);
            	hilOut.write("\tEnum " + name + " (");
            	NodeList enumChildNodes = enumNodes.item(ndx).getChildNodes();
            	for (int enumc_ndx=0; enumc_ndx<enumChildNodes.getLength(); enumc_ndx++) {
            		if (enumChildNodes.item(enumc_ndx).getNodeName() == "UML:Enumeration.literal") {
            			// Process the set of literals
		            	NodeList literalNodes = enumChildNodes.item(enumc_ndx).getChildNodes();
		            	for (int lit_ndx=0; lit_ndx<literalNodes.getLength(); lit_ndx++) {
		            		if (literalNodes.item(lit_ndx).getNodeName() == "UML:EnumerationLiteral") {
		            			String literalName = literalNodes.item(lit_ndx).getAttributes().getNamedItem("name").getNodeValue();
		            			if (et.literals.size() > 0) {
		            				hilOut.write("," + literalName);
		            			} else {
		            				hilOut.write(literalName);
		            			}
		            			et.addLiteral(literalName);
		            		}
		            	}
            		}
            	}
            	hilOut.write(");\n");
            	enumTypes.put(name, et);
            }
            
            
            // Extract classes from the model
            NodeList allClassNodes = document.getElementsByTagName("UML:Class");
            for (int ndx=0; ndx<allClassNodes.getLength(); ++ndx) {
            	if (allClassNodes.item(ndx).getAttributes().getNamedItem("name") != null) {
            		classNodes.add(allClassNodes.item(ndx));
            		typeIds.put(
            			allClassNodes.item(ndx).getAttributes().getNamedItem("xmi.id").getNodeValue(),
            			allClassNodes.item(ndx).getAttributes().getNamedItem("name").getNodeValue()
            		);
            	}
            }
            
            // Extract generalizations
            NodeList genNodes = document.getElementsByTagName("UML:Generalization");
            for (int ndx=0; ndx<genNodes.getLength(); ++ndx) {
            	String parentId = 
            		genNodes.item(ndx).getAttributes().getNamedItem("parent").getNodeValue();
            	String childId = 
            		genNodes.item(ndx).getAttributes().getNamedItem("child").getNodeValue();
            	String parentName = typeIds.get(parentId);
            	String childName = typeIds.get(childId);
            	classInherits.put(childName, parentName);
            }
            
            // Extract operations and attributes from each class
            for (int cl_ndx=0; cl_ndx<classNodes.size(); ++cl_ndx) {
            	NodeList opNodes = classNodes.get(cl_ndx).getChildNodes();
            	String classId = classNodes.get(cl_ndx).getAttributes().getNamedItem("xmi.id").getNodeValue();
            	String className = classNodes.get(cl_ndx).getAttributes().getNamedItem("name").getNodeValue();
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
	            	if (opNodes.item(op_ndx).getNodeName() == "UML:Classifier.feature") {
	            		NodeList elementNodes = opNodes.item(op_ndx).getChildNodes();
	            		// Now extract operations and attributes
	            		int numElements = elementNodes.getLength();
	            		for (int element_ndx=0; element_ndx<numElements; ++element_ndx) {
	            			if (elementNodes.item(element_ndx).getNodeName() == "UML:Operation") {
	            				String operName = elementNodes.item(element_ndx).getAttributes().getNamedItem("name").getNodeValue();
	            				termOut.write("operation " + operName + "\n");
	            				hilOut.write("\t\tSignal " + operName + "(int);\n");
	            			} else if (elementNodes.item(element_ndx).getNodeName() == "UML:Attribute") {
	            				String attribName = elementNodes.item(element_ndx).getAttributes().getNamedItem("name").getNodeValue();
	            				String attribType = elementNodes.item(element_ndx).getAttributes().getNamedItem("type").getNodeValue();
	            				termOut.write("attribute " + attribName + "\n");
	            				
	            				if (typeIds.containsKey(attribType)) {
	            					hilOut.write("\t\tInstanceVar " + typeIds.get(attribType) +
	            							" " + attribName + " := 0 ;\n");
	            				} else {
	            					System.err.println("Could not find type for attribute " + 
	            							attribName + " (type xmi.id = " + attribType + ")");
	            					hilOut.write("\t\tInstanceVar int " + attribName + " := 0 ;\n");
	            				}
	            			}
	            		}
	            	} else if (opNodes.item(op_ndx).getNodeName() == "UML:Namespace.ownedElement") {
	            		NodeList elementNodes = opNodes.item(op_ndx).getChildNodes();
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
