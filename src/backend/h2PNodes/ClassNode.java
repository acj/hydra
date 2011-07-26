package backend.h2PNodes;

import java.util.HashMap;
import java.util.HashSet;

import backend.h2PFoundation.AcceptReturnType;
import backend.h2PFoundation.Symbol;
import backend.h2PFoundation.SymbolTable;
import backend.h2PFoundation.Symbol.SymbolType;
import backend.h2PVisitors.aVisitor;


public class ClassNode extends aNode {
	public ClassBodyNode classBodyNode;
	private HashSet<ClassNode> superClassNodes;
	private boolean visitedForInheritance;
    private String className;
    private Symbol symbol;
	protected boolean hasClassBodyNodeBoolean = false;
	
    public ClassNode(String className) {
        super(className, "ClassNode");
        this.className = className;
        superClassNodes = new HashSet<ClassNode>();
        visitedForInheritance = false;
        symbol = SymbolTable.addSymbol(className, SymbolType.CLASS, "", "");
    }
    
	public AcceptReturnType accept(aVisitor v) {
		return v.visitClassNode(this);
	}
	
	/**
	 * Inherit the attributes and operations from all superclasses.
	 * 
	 * @throws Exception
	 */
	public void inheritFromSuperClasses() throws Exception {
	    if (visitedForInheritance) { return; }
	    for (ClassNode superClass : superClassNodes) {
	        superClass.inheritFromSuperClasses();
	        inheritFrom(superClass);
	    }
	    visitedForInheritance = true;
	}
	
	/**
	 * Inherit the attributes and operations from another class, usually a superclass. 
	 * 
	 * @param superClassNode The superclass from which to inherit.
	 * @return A map of attributes that are instances of other classes. (cf. HILParser)
	 * @throws Exception
	 */
	public HashMap<String, String> inheritFrom(ClassNode superClassNode) throws Exception {
	    WorldUtilNode rootNode = (WorldUtilNode)getRootNode();
	    HashMap<String, String> classInstances = new HashMap<String, String>();
        assert(superClassNode.children.size() == 1 &&
            superClassNode.children.get(0).getType().equals("ClassBodyNode"));
        ClassBodyNode cBodyNode = (ClassBodyNode)superClassNode.children.get(0);
        assert(cBodyNode != null);
        
        // Nodes at this level should be instance variables,
        // signals, states, etc.
        for (aNode cbChildNode : cBodyNode.children) {
            String memberName = "";
            if (cbChildNode.getType().equals("InstanceVariableNode")) {
                InstanceVariableNode instNode = (InstanceVariableNode)cbChildNode;
                memberName = instNode.getVar();
                assert(!memberName.equals(""));
                if (SymbolTable.symbolExistsInClass(memberName, className)) {
                    System.err.println("Error: Class " + className +
                            " already has a member ``" + instNode.getVar() +
                            "'' that would be shadowed by the inherited member in " +
                            superClassNode.getName() + ".");
                    throw new Exception();
                } else {
                    InstanceVariableNode newInstNode = new InstanceVariableNode(
                        instNode.getVType(), instNode.getVar(),
                        instNode.getInitValue(), className);

                    // Is this an instance of a class?  If so, then
                    // add a reference to this new instance to the
                    // class's list of instances.
                    if (SymbolTable.symbolExists(newInstNode.getVType(), SymbolType.CLASS)) {
                        classInstances.put(className + "." + newInstNode.getVar(), newInstNode.getVType());
                    }
                    rootNode.addChildToNode(classBodyNode, newInstNode);
                }
            } else if (cbChildNode.getType().equals("SignalNode")) {
                SignalNode sigNode = (SignalNode)cbChildNode;
                memberName = sigNode.getName();
                assert(!memberName.equals(""));
                if (SymbolTable.symbolExistsInClass(memberName, className)) {
                    System.err.println("Error: Class " + className +
                            " already has an operation ``" + sigNode.getName() +
                            "'' that would be shadowed by the inherited operation in " +
                            superClassNode.getName() + ".");
                    throw new Exception();
                } else {
                    SignalNode newSigNode = new SignalNode(
                        sigNode.getName(), sigNode.getSignalType(),
                        className);
                    rootNode.addChildToNode(classBodyNode, newSigNode);
                }
            }
        }
        return classInstances;
	}
	
	public void addSuperClass(ClassNode superClass) {
	    if (!superClassNodes.contains(superClass)) {
	        superClassNodes.add(superClass);
	    }
	}
	    
	public String getName() {
        return className;
    }
	
	public boolean hasClassBodyNode() {
		return hasClassBodyNodeBoolean;
	}
	
	public boolean hasSuperClass() {
	    if (superClassNodes.isEmpty()) {
	        return false;
	    } else {
	        return true;
	    }
	}
	
	public void addChild(aNode newChild){
        super.addChild(newChild);
		if (newChild.getType().equals("ClassBodyNode")) {
			classBodyNode = (ClassBodyNode)newChild;
			hasClassBodyNodeBoolean = true;
		}
	}
	
	public String getNodeName() {
		return super.getNodeName(false, true);
	}
	
	public Symbol getSymbol() {
		return symbol;
	}
}
