/*
 * Created on Jul 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PFoundation.NodeUtilityClass;
import h2PVisitors.aVisitor;

import java.util.Vector;

/**
 * @author karli
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class aNode extends NodeUtilityClass {
    // all nodes have the capacity to have children and 
    // for their children to accept themselves!
    protected String ID, classType;
    protected aNode parent;
    // list of all former parent, most recent at end of list
    protected Vector formerParent;
    protected boolean parentLives;
    protected String uniqueID = "";
    protected boolean usesParentID = false;
    
	public Vector children = new Vector(); // generic children nodes
	//TODO make these children *protected* and wrap them around functions!
	/**
	 * 
	 */
	public aNode(String theID, String theClassType) {
		super();
        ID = theID;
        classType = theClassType;
        parent = null;
        parentLives = false;
        formerParent = new Vector();
	}

	// Used to initialize nodes with no ID.
	public static String noID() {
		return "";
	}
	
	public AcceptReturnType accept(aVisitor v) {
	  return AcceptReturnType.retString("");
	}
	
	// calls accept on all of this node's generic children
	public AcceptReturnType acceptChildren(aVisitor v) {
		return acceptChildren(v, children);
	}
	
	// calls accept on all members of a vector of children nodes
	protected AcceptReturnType acceptChildren(aVisitor v, Vector otherChildren) {
		// String tmpStr = "";
		AcceptReturnType tmpART = new AcceptReturnType();
		for (int i = 0; i < otherChildren.size(); i++) {
			aNode childNode = (aNode)(otherChildren.get(i));
			tmpART.merge(childNode.accept(v)); // This will call the appropriate accept function based on the object's VMT
		}
		return tmpART;
	}
	
	public AcceptReturnType acceptChildrenOfType(aVisitor v, String childType) {
		return acceptChildrenOfType (v, childType, children);
	}
	
	protected AcceptReturnType acceptChildrenOfType(aVisitor v, String childType, Vector otherChildren) {
		// String tmpStr = "";
		AcceptReturnType tmpART = new AcceptReturnType();
		for (int i = 0; i < otherChildren.size(); i++) {
			aNode childNode = (aNode)(otherChildren.get(i));
			if (childNode.getType().equals(childType)) {
			  tmpART.merge(childNode.accept(v)); // This will call the appropriate accept function based on the object's VMT
			}
		}
		return tmpART;
	}
	
	public void addChild(aNode newChild){
        if (newChild != null) {
          newChild.setParent(this);
		  children.addElement(newChild);
        }
	}
    
	// hacked out function to add children.
	// likely won't be needed.
	public void addChildKeepParent (aNode newChild) {
		aNode oldParent = newChild.getParent();
		addChild(newChild);
		newChild.parent = oldParent;
	}
	
    public String getID() {
      if ((usesParentID) && (hasParent())) {
        return parent.getID();
      } else {
        return ID;
      }
    }
    
    public String getUniqueID() {
      return uniqueID;
    }
    
    public boolean hasParent() {
        return (parentLives) && (parent != null);   
      }
      
    /*
     * Returns a node's parent, if the parentLives
     * variable is FALSE, then it always returns
     * NULL, forcing a NullPointerError exception to be 
     * thrown in the case that the parent is deferenced.
     * This ensures parents are set up in the proper manner. 
     */
    public aNode getParent(){
      if (parentLives) { 
        return parent;
      } else {
        return null; // sort of a failsafe. 
      }
    }
    
    // returns the most recent formerParent
    public aNode getFormerParent () {
    	if (formerParent.size() > 0) {
    	  return (aNode) formerParent.get(formerParent.size()-1);
    	} else {
    		return null;
    	}
    }
    
    public aNode getFormerParent(int itemnum) {
    	if ((itemnum < formerParent.size()) &&
    		(itemnum >= 0)) {
      	  return (aNode) formerParent.get(itemnum-1);
      	} else {
      		return null;
      	}
    }

    public Vector getFormerParentVec () {
    	return formerParent;
    }
    
    public String getType() {
      return classType;   
    }
    
    // returns an object's description (based on it's original
    // UML model code.
    public String getDescription() {
      return "";   
    }
    
    protected void setParent(aNode theParent){
      if (parent != null) {
        formerParent.addElement(parent);
      }
      parent = theParent;
      parentLives = true;
    }
    
    // oh my goodness! not another perl-ism that needs to be handled!
    public String getNodeVal (String valName) {
    	if (valName.equals("ID")) {
    		return getID();
    	}
    	return "";
    }
    
    public aNode getRootNode() {
    	return searchUpForDest (this, "WorldUtilNode");
    }

    //assume i have added a parent && rootnode exists!
    public void addToRootNode() {
    	WorldUtilNode rootNode = (WorldUtilNode)getRootNode();
    	if (rootNode != null) {
    		rootNode.addNode(this);
    	}
    }
    
    public aNode searchUpForDest(String destType) {
      return searchUpForDest(this, destType);   
    }
}
