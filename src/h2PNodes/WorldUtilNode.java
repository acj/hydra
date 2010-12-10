package h2PNodes;

import h2PFoundation.AcceptReturnType;
import h2PVisitors.aVisitor;

import java.util.Hashtable;
import java.util.Vector;


/* 
 *  Global container "Node" Class that holds all
 *  other nodes within it.  Used for "stuff".
 *  This is considered a master node implementation.
 *  It sorts its elements by class, ID as well.
 *  It also holds the main "node" for the entire model
 *  to be used in primary acceptance. 
 */

public class WorldUtilNode extends aNode {

	public Vector<aNode> allNodes;
	protected Hashtable<String, Vector<aNode>> categorizedNodes;
	protected Hashtable<String, aNode> hashOfAllNodes;
    protected Hashtable<String, Vector<aNode>> hashOfAllIDs;
	protected aNode headNode = null;
    protected int latestUniqueID = 0;
	
	public WorldUtilNode() {
		super("0", "WorldUtilNode");
		allNodes = new Vector<aNode>();
		categorizedNodes = new Hashtable<String, Vector<aNode>>();
        hashOfAllNodes = new Hashtable<String, aNode>();
        hashOfAllIDs = new Hashtable<String, Vector<aNode>>();
        uniqueID = "0";
	}
	
	public void addNode(aNode theN) {
        if (theN == null) return;
		allNodes.addElement(theN);
		
		Vector<aNode> tmpV = getCategoryVector(theN.classType);
		tmpV.addElement(theN);
		if (tmpV.size() == 1) { // this is a new vector not in the hash
			categorizedNodes.remove(theN.classType); // a precaution
			categorizedNodes.put(theN.classType, tmpV);
		}
        
        tmpV = getIDVector(theN.ID);
        tmpV.addElement(theN);
        if (tmpV.size() == 1) { // this is a new vector not in the hash
            hashOfAllIDs.remove(theN.ID); // a precaution
            hashOfAllIDs.put(theN.ID, tmpV);
        }
        
        theN.uniqueID = generateUniqueID();
        hashOfAllNodes.put(theN.uniqueID, theN);
	}
	
	public Vector<aNode> getCategoryVector(String theCategory) {
		Vector<aNode> retV = (Vector<aNode>)categorizedNodes.get(theCategory);
		
		if (retV == null) {
			retV = new Vector<aNode>();
		}
		return retV;
	}
	
    public Vector<aNode> getIDVector(String theID) {
        Vector<aNode> retV = (Vector<aNode>)hashOfAllIDs.get(theID);
        
        if (retV == null) {
            retV = new Vector<aNode>();
        }
        return retV;
    }
    
	public aNode getByUniqueID (String theUniqueID) {
		return (aNode)hashOfAllNodes.get(theUniqueID);
	}
	
	public void setHeadNode (aNode newHeadNode) {
        if (newHeadNode != null) {
		  headNode = newHeadNode;
        }
	}
	
	public aNode getHeadNode () {
		return headNode;
	}

	public AcceptReturnType accept(aVisitor v) {
		// TODO Auto-generated method stub
        if (headNode != null) {
            return headNode.accept(v);
        } else {
            return acceptChildren(v);
        }
	}
    
    protected String generateUniqueID() {
      latestUniqueID++; // increment, this gives the next UniqueID
      return Integer.toString(latestUniqueID);   
    }

	public void addChild(aNode newChild){
        super.addChild(newChild);
        addNode(newChild);
        if (newChild != null) {
          setHeadNode (newChild); // this function is expected to be called only once.
        }
	}
    
	// this function is meant to act as an aid in the parsing process
	// it allows a node to be created inline and then passed on to the parent
	// AND also added to the rootNode.  This function returns the parent for
	// further use if necessary. 
	public aNode addChildToNode (aNode theParentNode, aNode theChildNode) {
        if (theChildNode != null) {
		  theParentNode.addChild(theChildNode);
		  addNode(theChildNode);
        }
		return theParentNode;
	}

	// I don't need to add the rootnode to myself!
	public void addToRootNode() {
		// T ODO Auto-generated method stub
		return;
	}

	/* (non-Javadoc)
	 * @see h2PNodes.aNode#getNodeName(boolean, boolean, boolean)
	 */
	public String getNodeName(boolean withClassName, boolean withModelName, boolean withID) {
		return this.getID();
	}

}
