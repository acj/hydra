/* Generated By:JavaCC: Do not edit this line. UMLExpr1.java */
package h2PVisitors.Parser;

import h2PNodes.*;
import h2PVisitors.*;
import java.io.*;
import h2PFoundation.*;

public class UMLExpr1 extends NodeUtilityClass implements UMLExpr1Constants {
  public String finalStr = "";
  protected aNode classRef;
  protected AcceptReturnType globalOutputs;
  protected PromelaInPredicateVisitor pinpv;
  protected Reader dataStream;
/*  
  public UMLExpr1(AcceptReturnType theGlobalOutputs) {
  	globalOutputs = theGlobalOutputs;
  }
*/

  public UMLExpr1(AcceptReturnType theGlobalOutputs, PromelaInPredicateVisitor THEpinpv) {
        this(new StringReader("This is a test string"));
        globalOutputs = theGlobalOutputs;
        pinpv = THEpinpv;
  }

  // TODO work it! work it good...
  public String Parse_Me (aNode theClassRef, String expresssion) /*throws ParseException*/ {
         classRef = theClassRef;
         String retStr;
         dataStream = new StringReader (expresssion);
         ReInit(dataStream);
         /* for debug only
  	 println ("---------------------------------------------------------------------------------");
  	 println ("  parsing \"" + expresssion + "\"");
  	 println ("---------------------------------------------------------------------------------");
  	 */
         try {
                retStr = stmt();
         }  catch (ParseException pe) {
                retStr = "*ERROR*";
         }
         /* for debug only
  	 println ("---------------------------------------------------------------------------------");
  	 println ("");
  	 */
         return retStr;
  }

  public String Compare(String arg1, String op, String arg2) {
        if (op.equals("=")) {
                return arg1 + "==" + arg2;
        }

        return arg1 + op + arg2;
  }

  public String InstVar (String varname) {
        ClassNode thisClassRef = (ClassNode) searchUpForDest (classRef, "ClassNode");
        aNode returnValue = FindLocalDestNode (classRef, "InstanceVariableNode", "var", varname);

        String temp = thisClassRef.getID() + "_V.";

        String entities [] = globalOutputs.getStrSplit("TimerList");
        for (int i = 0; i < entities.length; i++) {
                if (entities[i].equals(varname)) {
                        temp = "Timer_V.";
                }
        }
        if (returnValue != null) {
                return temp + varname;
        }
        return varname;
  }

  public String Logic(String op, String arg1) {
        return Logic (op, arg1, "");
  }

  public String Logic(String op, String arg1, String arg2) {
        if ((op.equals ("not")) && (arg2.length() == 0)) {
                return "!" + InstVar (arg1);
        }
        if (op.equals ("or")) {
                return arg1 + " || " + arg2;
        }
        if (op.equals ("and")) {
                return arg1 + " && " + arg2;
        }

        //T O D O  $ret || die "Logic was passed a bad operator: <$op>";
        println ("Logic was passed a bad operator: <" + op + ">");
        exit();
        return "";
  }

  public String INPredicate(String predtarg) {
        ClassNode thisClassRef = (ClassNode) searchUpForDest (classRef, "ClassNode");
        String className = thisClassRef.getID();
        aNode myParent = classRef.getParent().getParent().getParent();
        String parentName = myParent.getID();

        /* TODO implement:
   	if (!Yacc->LkupSym($target)) 
        {
            die "In class $classname, $myparent->{object} $parentname, state $target undefined in IN predicate."
    }
   	*/
        ClassBodyNode thisClassBodyRef = (ClassBodyNode) searchUpForDest (classRef, "ClassBodyNode");
        pinpv.INTarget(thisClassBodyRef, predtarg);

        return className + "INPredicate_V.st_" + predtarg;
  }

  public String Assignment(String assignto, String assignfrom) {
        String newleft = InstVar(assignto);
        return newleft + "=" + assignfrom + ";";
  }

  final public String stmt() throws ParseException, ParseException {
    if (jj_2_1(2)) {
      finalStr = assignment();
    } else if (jj_2_2(2)) {
      finalStr = guard();
    } else if (jj_2_3(2)) {
      finalStr = parmlist();
    } else if (jj_2_4(2)) {
      finalStr = whenclause();
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    {if (true) return finalStr;}
    throw new Error("Missing return statement in function");
  }

  final public String assignment() throws ParseException, ParseException {
        Token t;
        String temp1, temp2;
    t = jj_consume_token(ID);
                   temp1 = t.image;
    jj_consume_token(ASSGNOP);
    temp2 = stmtpm();
          {if (true) return Assignment(temp1, temp2);}
    throw new Error("Missing return statement in function");
  }

  final public String stmtpm() throws ParseException, ParseException {
        Token t;
        String retVal = "";
        String temp;
    temp = stmtdm();
                            retVal += temp;
    label_1:
    while (true) {
      if (jj_2_5(2)) {
        ;
      } else {
        break label_1;
      }
      if (jj_2_6(2)) {
        t = jj_consume_token(PLUS);
      } else if (jj_2_7(2)) {
        t = jj_consume_token(MINUS);
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                retVal += t.image;
      temp = stmtdm();
                             retVal += temp;
    }
            {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String stmtdm() throws ParseException, ParseException {
        Token t;
        String retVal = "";
        String temp;
    temp = actterm();
                             retVal += temp;
    label_2:
    while (true) {
      if (jj_2_8(2)) {
        ;
      } else {
        break label_2;
      }
      if (jj_2_9(2)) {
        t = jj_consume_token(TIMES);
      } else if (jj_2_10(2)) {
        t = jj_consume_token(SLASH);
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                retVal += t.image;
      temp = actterm();
                              retVal += temp;
    }
            {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String actterm() throws ParseException, ParseException {
        Token t;
        String retVal = "";
        String temp;
        boolean isID = false;
    if (jj_2_14(2)) {
      retVal = function();
                              {if (true) return retVal;}
    } else if (jj_2_15(2)) {
      if (jj_2_11(2)) {
        jj_consume_token(MINUS);
                            retVal += "-";
      } else {
        ;
      }
      if (jj_2_12(2)) {
        t = jj_consume_token(ID);
                             isID = true;
      } else if (jj_2_13(2)) {
        t = jj_consume_token(NUM);
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                    temp = t.image;
                if (isID) {
                  temp = InstVar(temp);
                }
                {if (true) return (retVal + temp);}
    } else if (jj_2_16(2)) {
      jj_consume_token(LPARENS);
      retVal = stmtpm();
      jj_consume_token(RPARENS);
            {if (true) return ("(" + retVal + ")");}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String function() throws ParseException, ParseException {
        Token t;
        String funcID = "";
        String parmlistStr = "";
    if (jj_2_17(2)) {
      t = jj_consume_token(ID);
                           funcID = t.image;
      jj_consume_token(LPARENS);
      parmlistStr = parmlist();
      jj_consume_token(RPARENS);
          {if (true) return (funcID + "(" + parmlistStr + ")");}
    } else if (jj_2_18(2)) {
      jj_consume_token(IN);
      jj_consume_token(LPARENS);
      t = jj_consume_token(ID);
                           funcID = t.image;
      jj_consume_token(RPARENS);
          {if (true) return INPredicate(funcID);}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String parmlist() throws ParseException, ParseException {
        String retVal = "";
        String temp = "";
    temp = parm();
                        retVal += temp;
    label_3:
    while (true) {
      if (jj_2_19(2)) {
        ;
      } else {
        break label_3;
      }
      jj_consume_token(COMMA);
      temp = parm();
                                retVal += temp;
    }
          {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String parm() throws ParseException, ParseException {
        Token t;
        String temp;
    if (jj_2_20(2)) {
      t = jj_consume_token(ID);
                   {if (true) return InstVar(t.image);}
    } else if (jj_2_21(2)) {
      t = jj_consume_token(NUM);
                    {if (true) return t.image;}
    } else if (jj_2_22(2)) {
      temp = pred();
                        {if (true) return temp;}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String guard() throws ParseException, ParseException {
  String retVal = "";
    jj_consume_token(LBRACKET);
    retVal = guardbody();
    jj_consume_token(RBRACKET);
    {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String guardbody() throws ParseException, ParseException {
        String retVal = "";
        String temp = "";
    retVal = expra();
    label_4:
    while (true) {
      if (jj_2_23(2)) {
        ;
      } else {
        break label_4;
      }
      jj_consume_token(OR);
      temp = expra();
                           retVal = Logic("or", retVal, temp);
    }
          {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String expra() throws ParseException, ParseException {
        String retVal = "";
        String temp = "";
    retVal = gdterm();
    label_5:
    while (true) {
      if (jj_2_24(2)) {
        ;
      } else {
        break label_5;
      }
      jj_consume_token(AND);
      temp = gdterm();
                            retVal = Logic("and", retVal, temp);
    }
          {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final public String gdterm() throws ParseException, ParseException {
        Token t;
        String retVal = "";
        String temp;
        boolean isnot = false;
    if (jj_2_26(2)) {
      retVal = pred();
          {if (true) return retVal;}
    } else if (jj_2_27(2)) {
      if (jj_2_25(2)) {
        jj_consume_token(NOT);
                    isnot = true;
      } else {
        ;
      }
      t = jj_consume_token(ID);
                      temp = t.image;
                if (isnot) {
                        {if (true) return Logic("not", temp);}
                } else {
                        {if (true) return  InstVar(temp);}
                }
    } else if (jj_2_28(2)) {
      jj_consume_token(LPARENS);
      retVal = guardbody();
      jj_consume_token(RPARENS);
           {if (true) return ("(" + retVal + ")");}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String pred() throws ParseException, ParseException {
        Token t;
        String retVal = "";
        String temp1, temp2, temp3;
    if (jj_2_29(2)) {
      temp1 = numid();
      t = jj_consume_token(COMPARE_OP);
                                   temp2 = t.image;
      temp3 = numid();
             {if (true) return Compare(temp1, temp2, temp3);}
    } else if (jj_2_30(2)) {
      retVal = function();
                              {if (true) return retVal;}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String numid() throws ParseException, ParseException {
        Token t;
    if (jj_2_31(2)) {
      t = jj_consume_token(ID);
                   {if (true) return InstVar (t.image);}
    } else if (jj_2_32(2)) {
      t = jj_consume_token(NUM);
                    {if (true) return t.image;}
    } else {
      jj_consume_token(-1);
      throw new ParseException();
    }
    throw new Error("Missing return statement in function");
  }

  final public String whenclause() throws ParseException, ParseException {
        String retVal = "";
    jj_consume_token(WHEN);
    jj_consume_token(LPARENS);
    retVal = guardbody();
    jj_consume_token(RPARENS);
          {if (true) return retVal;}
    throw new Error("Missing return statement in function");
  }

  final private boolean jj_2_1(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_1(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(0, xla); }
  }

  final private boolean jj_2_2(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_2(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(1, xla); }
  }

  final private boolean jj_2_3(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_3(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(2, xla); }
  }

  final private boolean jj_2_4(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_4(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(3, xla); }
  }

  final private boolean jj_2_5(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_5(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(4, xla); }
  }

  final private boolean jj_2_6(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_6(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(5, xla); }
  }

  final private boolean jj_2_7(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_7(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(6, xla); }
  }

  final private boolean jj_2_8(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_8(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(7, xla); }
  }

  final private boolean jj_2_9(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_9(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(8, xla); }
  }

  final private boolean jj_2_10(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_10(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(9, xla); }
  }

  final private boolean jj_2_11(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_11(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(10, xla); }
  }

  final private boolean jj_2_12(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_12(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(11, xla); }
  }

  final private boolean jj_2_13(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_13(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(12, xla); }
  }

  final private boolean jj_2_14(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_14(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(13, xla); }
  }

  final private boolean jj_2_15(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_15(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(14, xla); }
  }

  final private boolean jj_2_16(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_16(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(15, xla); }
  }

  final private boolean jj_2_17(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_17(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(16, xla); }
  }

  final private boolean jj_2_18(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_18(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(17, xla); }
  }

  final private boolean jj_2_19(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_19(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(18, xla); }
  }

  final private boolean jj_2_20(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_20(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(19, xla); }
  }

  final private boolean jj_2_21(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_21(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(20, xla); }
  }

  final private boolean jj_2_22(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_22(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(21, xla); }
  }

  final private boolean jj_2_23(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_23(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(22, xla); }
  }

  final private boolean jj_2_24(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_24(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(23, xla); }
  }

  final private boolean jj_2_25(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_25(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(24, xla); }
  }

  final private boolean jj_2_26(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_26(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(25, xla); }
  }

  final private boolean jj_2_27(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_27(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(26, xla); }
  }

  final private boolean jj_2_28(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_28(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(27, xla); }
  }

  final private boolean jj_2_29(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_29(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(28, xla); }
  }

  final private boolean jj_2_30(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_30(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(29, xla); }
  }

  final private boolean jj_2_31(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_31(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(30, xla); }
  }

  final private boolean jj_2_32(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_32(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(31, xla); }
  }

  final private boolean jj_3_11() {
    if (jj_scan_token(MINUS)) return true;
    return false;
  }

  final private boolean jj_3_24() {
    if (jj_scan_token(AND)) return true;
    if (jj_3R_17()) return true;
    return false;
  }

  final private boolean jj_3R_16() {
    if (jj_3R_17()) return true;
    return false;
  }

  final private boolean jj_3_15() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_11()) jj_scanpos = xsp;
    xsp = jj_scanpos;
    if (jj_3_12()) {
    jj_scanpos = xsp;
    if (jj_3_13()) return true;
    }
    return false;
  }

  final private boolean jj_3R_11() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_14()) {
    jj_scanpos = xsp;
    if (jj_3_15()) {
    jj_scanpos = xsp;
    if (jj_3_16()) return true;
    }
    }
    return false;
  }

  final private boolean jj_3_14() {
    if (jj_3R_12()) return true;
    return false;
  }

  final private boolean jj_3_10() {
    if (jj_scan_token(SLASH)) return true;
    return false;
  }

  final private boolean jj_3_23() {
    if (jj_scan_token(OR)) return true;
    if (jj_3R_16()) return true;
    return false;
  }

  final private boolean jj_3_9() {
    if (jj_scan_token(TIMES)) return true;
    return false;
  }

  final private boolean jj_3R_18() {
    if (jj_3R_16()) return true;
    return false;
  }

  final private boolean jj_3_8() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_9()) {
    jj_scanpos = xsp;
    if (jj_3_10()) return true;
    }
    if (jj_3R_11()) return true;
    return false;
  }

  final private boolean jj_3R_10() {
    if (jj_3R_11()) return true;
    return false;
  }

  final private boolean jj_3R_9() {
    if (jj_scan_token(WHEN)) return true;
    if (jj_scan_token(LPARENS)) return true;
    return false;
  }

  final private boolean jj_3_7() {
    if (jj_scan_token(MINUS)) return true;
    return false;
  }

  final private boolean jj_3_6() {
    if (jj_scan_token(PLUS)) return true;
    return false;
  }

  final private boolean jj_3R_7() {
    if (jj_scan_token(LBRACKET)) return true;
    if (jj_3R_18()) return true;
    return false;
  }

  final private boolean jj_3_22() {
    if (jj_3R_15()) return true;
    return false;
  }

  final private boolean jj_3_21() {
    if (jj_scan_token(NUM)) return true;
    return false;
  }

  final private boolean jj_3_32() {
    if (jj_scan_token(NUM)) return true;
    return false;
  }

  final private boolean jj_3R_19() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_31()) {
    jj_scanpos = xsp;
    if (jj_3_32()) return true;
    }
    return false;
  }

  final private boolean jj_3R_14() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_20()) {
    jj_scanpos = xsp;
    if (jj_3_21()) {
    jj_scanpos = xsp;
    if (jj_3_22()) return true;
    }
    }
    return false;
  }

  final private boolean jj_3_20() {
    if (jj_scan_token(ID)) return true;
    return false;
  }

  final private boolean jj_3_31() {
    if (jj_scan_token(ID)) return true;
    return false;
  }

  final private boolean jj_3_5() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_6()) {
    jj_scanpos = xsp;
    if (jj_3_7()) return true;
    }
    if (jj_3R_10()) return true;
    return false;
  }

  final private boolean jj_3_19() {
    if (jj_scan_token(COMMA)) return true;
    if (jj_3R_14()) return true;
    return false;
  }

  final private boolean jj_3R_13() {
    if (jj_3R_10()) return true;
    return false;
  }

  final private boolean jj_3_30() {
    if (jj_3R_12()) return true;
    return false;
  }

  final private boolean jj_3R_15() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_29()) {
    jj_scanpos = xsp;
    if (jj_3_30()) return true;
    }
    return false;
  }

  final private boolean jj_3_29() {
    if (jj_3R_19()) return true;
    if (jj_scan_token(COMPARE_OP)) return true;
    return false;
  }

  final private boolean jj_3R_8() {
    if (jj_3R_14()) return true;
    Token xsp;
    while (true) {
      xsp = jj_scanpos;
      if (jj_3_19()) { jj_scanpos = xsp; break; }
    }
    return false;
  }

  final private boolean jj_3R_6() {
    if (jj_scan_token(ID)) return true;
    if (jj_scan_token(ASSGNOP)) return true;
    return false;
  }

  final private boolean jj_3_28() {
    if (jj_scan_token(LPARENS)) return true;
    if (jj_3R_18()) return true;
    return false;
  }

  final private boolean jj_3_18() {
    if (jj_scan_token(IN)) return true;
    if (jj_scan_token(LPARENS)) return true;
    return false;
  }

  final private boolean jj_3_25() {
    if (jj_scan_token(NOT)) return true;
    return false;
  }

  final private boolean jj_3_4() {
    if (jj_3R_9()) return true;
    return false;
  }

  final private boolean jj_3R_12() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_17()) {
    jj_scanpos = xsp;
    if (jj_3_18()) return true;
    }
    return false;
  }

  final private boolean jj_3_3() {
    if (jj_3R_8()) return true;
    return false;
  }

  final private boolean jj_3_17() {
    if (jj_scan_token(ID)) return true;
    if (jj_scan_token(LPARENS)) return true;
    return false;
  }

  final private boolean jj_3_2() {
    if (jj_3R_7()) return true;
    return false;
  }

  final private boolean jj_3_1() {
    if (jj_3R_6()) return true;
    return false;
  }

  final private boolean jj_3_27() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_25()) jj_scanpos = xsp;
    if (jj_scan_token(ID)) return true;
    return false;
  }

  final private boolean jj_3R_17() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_26()) {
    jj_scanpos = xsp;
    if (jj_3_27()) {
    jj_scanpos = xsp;
    if (jj_3_28()) return true;
    }
    }
    return false;
  }

  final private boolean jj_3_26() {
    if (jj_3R_15()) return true;
    return false;
  }

  final private boolean jj_3_13() {
    if (jj_scan_token(NUM)) return true;
    return false;
  }

  final private boolean jj_3_12() {
    if (jj_scan_token(ID)) return true;
    return false;
  }

  final private boolean jj_3_16() {
    if (jj_scan_token(LPARENS)) return true;
    if (jj_3R_13()) return true;
    return false;
  }

  public UMLExpr1TokenManager token_source;
  SimpleCharStream jj_input_stream;
  public Token token, jj_nt;
  private int jj_ntk;
  private Token jj_scanpos, jj_lastpos;
  private int jj_la;
  public boolean lookingAhead = false;
  private boolean jj_semLA;
  private int jj_gen;
  final private int[] jj_la1 = new int[0];
  static private int[] jj_la1_0;
  static private int[] jj_la1_1;
  static {
      jj_la1_0();
      jj_la1_1();
   }
   private static void jj_la1_0() {
      jj_la1_0 = new int[] {};
   }
   private static void jj_la1_1() {
      jj_la1_1 = new int[] {};
   }
  final private JJCalls[] jj_2_rtns = new JJCalls[32];
  private boolean jj_rescan = false;
  private int jj_gc = 0;

  public UMLExpr1(java.io.InputStream stream) {
     this(stream, null);
  }
  public UMLExpr1(java.io.InputStream stream, String encoding) {
    try { jj_input_stream = new SimpleCharStream(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source = new UMLExpr1TokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(java.io.InputStream stream) {
     ReInit(stream);
  }
  public void ReInit(java.io.InputStream stream, String encoding) {
    try { jj_input_stream.ReInit(stream, encoding, 1, 1); } catch(java.io.UnsupportedEncodingException e) { throw new RuntimeException(e); }
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public UMLExpr1(java.io.Reader stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new UMLExpr1TokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(java.io.Reader stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public UMLExpr1(UMLExpr1TokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(UMLExpr1TokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  final private Token jj_consume_token(int kind) throws ParseException {
    Token oldToken;
    if ((oldToken = token).next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    if (token.kind == kind) {
      jj_gen++;
      if (++jj_gc > 100) {
        jj_gc = 0;
        for (int i = 0; i < jj_2_rtns.length; i++) {
          JJCalls c = jj_2_rtns[i];
          while (c != null) {
            if (c.gen < jj_gen) c.first = null;
            c = c.next;
          }
        }
      }
      return token;
    }
    token = oldToken;
    jj_kind = kind;
    throw generateParseException();
  }

  static private final class LookaheadSuccess extends java.lang.Error { }
  final private LookaheadSuccess jj_ls = new LookaheadSuccess();
  final private boolean jj_scan_token(int kind) {
    if (jj_scanpos == jj_lastpos) {
      jj_la--;
      if (jj_scanpos.next == null) {
        jj_lastpos = jj_scanpos = jj_scanpos.next = token_source.getNextToken();
      } else {
        jj_lastpos = jj_scanpos = jj_scanpos.next;
      }
    } else {
      jj_scanpos = jj_scanpos.next;
    }
    if (jj_rescan) {
      int i = 0; Token tok = token;
      while (tok != null && tok != jj_scanpos) { i++; tok = tok.next; }
      if (tok != null) jj_add_error_token(kind, i);
    }
    if (jj_scanpos.kind != kind) return true;
    if (jj_la == 0 && jj_scanpos == jj_lastpos) throw jj_ls;
    return false;
  }

  final public Token getNextToken() {
    if (token.next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    jj_gen++;
    return token;
  }

  final public Token getToken(int index) {
    Token t = lookingAhead ? jj_scanpos : token;
    for (int i = 0; i < index; i++) {
      if (t.next != null) t = t.next;
      else t = t.next = token_source.getNextToken();
    }
    return t;
  }

  final private int jj_ntk() {
    if ((jj_nt=token.next) == null)
      return (jj_ntk = (token.next=token_source.getNextToken()).kind);
    else
      return (jj_ntk = jj_nt.kind);
  }

  private java.util.Vector jj_expentries = new java.util.Vector();
  private int[] jj_expentry;
  private int jj_kind = -1;
  private int[] jj_lasttokens = new int[100];
  private int jj_endpos;

  private void jj_add_error_token(int kind, int pos) {
    if (pos >= 100) return;
    if (pos == jj_endpos + 1) {
      jj_lasttokens[jj_endpos++] = kind;
    } else if (jj_endpos != 0) {
      jj_expentry = new int[jj_endpos];
      for (int i = 0; i < jj_endpos; i++) {
        jj_expentry[i] = jj_lasttokens[i];
      }
      boolean exists = false;
      for (java.util.Enumeration e = jj_expentries.elements(); e.hasMoreElements();) {
        int[] oldentry = (int[])(e.nextElement());
        if (oldentry.length == jj_expentry.length) {
          exists = true;
          for (int i = 0; i < jj_expentry.length; i++) {
            if (oldentry[i] != jj_expentry[i]) {
              exists = false;
              break;
            }
          }
          if (exists) break;
        }
      }
      if (!exists) jj_expentries.addElement(jj_expentry);
      if (pos != 0) jj_lasttokens[(jj_endpos = pos) - 1] = kind;
    }
  }

  public ParseException generateParseException() {
    jj_expentries.removeAllElements();
    boolean[] la1tokens = new boolean[33];
    for (int i = 0; i < 33; i++) {
      la1tokens[i] = false;
    }
    if (jj_kind >= 0) {
      la1tokens[jj_kind] = true;
      jj_kind = -1;
    }
    for (int i = 0; i < 0; i++) {
      if (jj_la1[i] == jj_gen) {
        for (int j = 0; j < 32; j++) {
          if ((jj_la1_0[i] & (1<<j)) != 0) {
            la1tokens[j] = true;
          }
          if ((jj_la1_1[i] & (1<<j)) != 0) {
            la1tokens[32+j] = true;
          }
        }
      }
    }
    for (int i = 0; i < 33; i++) {
      if (la1tokens[i]) {
        jj_expentry = new int[1];
        jj_expentry[0] = i;
        jj_expentries.addElement(jj_expentry);
      }
    }
    jj_endpos = 0;
    jj_rescan_token();
    jj_add_error_token(0, 0);
    int[][] exptokseq = new int[jj_expentries.size()][];
    for (int i = 0; i < jj_expentries.size(); i++) {
      exptokseq[i] = (int[])jj_expentries.elementAt(i);
    }
    return new ParseException(token, exptokseq, tokenImage);
  }

  final public void enable_tracing() {
  }

  final public void disable_tracing() {
  }

  final private void jj_rescan_token() {
    jj_rescan = true;
    for (int i = 0; i < 32; i++) {
    try {
      JJCalls p = jj_2_rtns[i];
      do {
        if (p.gen > jj_gen) {
          jj_la = p.arg; jj_lastpos = jj_scanpos = p.first;
          switch (i) {
            case 0: jj_3_1(); break;
            case 1: jj_3_2(); break;
            case 2: jj_3_3(); break;
            case 3: jj_3_4(); break;
            case 4: jj_3_5(); break;
            case 5: jj_3_6(); break;
            case 6: jj_3_7(); break;
            case 7: jj_3_8(); break;
            case 8: jj_3_9(); break;
            case 9: jj_3_10(); break;
            case 10: jj_3_11(); break;
            case 11: jj_3_12(); break;
            case 12: jj_3_13(); break;
            case 13: jj_3_14(); break;
            case 14: jj_3_15(); break;
            case 15: jj_3_16(); break;
            case 16: jj_3_17(); break;
            case 17: jj_3_18(); break;
            case 18: jj_3_19(); break;
            case 19: jj_3_20(); break;
            case 20: jj_3_21(); break;
            case 21: jj_3_22(); break;
            case 22: jj_3_23(); break;
            case 23: jj_3_24(); break;
            case 24: jj_3_25(); break;
            case 25: jj_3_26(); break;
            case 26: jj_3_27(); break;
            case 27: jj_3_28(); break;
            case 28: jj_3_29(); break;
            case 29: jj_3_30(); break;
            case 30: jj_3_31(); break;
            case 31: jj_3_32(); break;
          }
        }
        p = p.next;
      } while (p != null);
      } catch(LookaheadSuccess ls) { }
    }
    jj_rescan = false;
  }

  final private void jj_save(int index, int xla) {
    JJCalls p = jj_2_rtns[index];
    while (p.gen > jj_gen) {
      if (p.next == null) { p = p.next = new JJCalls(); break; }
      p = p.next;
    }
    p.gen = jj_gen + xla - jj_la; p.first = token; p.arg = xla;
  }

  static final class JJCalls {
    int gen;
    Token first;
    int arg;
    JJCalls next;
  }

}
