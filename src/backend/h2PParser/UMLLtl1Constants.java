/* Generated By:JavaCC: Do not edit this line. UMLLtl1Constants.java */
package backend.h2PParser;


/**
 * Token literal values and constants.
 * Generated by org.javacc.parser.OtherFilesGen#start()
 */
public interface UMLLtl1Constants {

  /** End of File. */
  int EOF = 0;
  /** RegularExpression Id. */
  int OR = 6;
  /** RegularExpression Id. */
  int AND = 7;
  /** RegularExpression Id. */
  int NOT = 8;
  /** RegularExpression Id. */
  int IMP = 9;
  /** RegularExpression Id. */
  int COMPARE_OP = 10;
  /** RegularExpression Id. */
  int IN = 11;
  /** RegularExpression Id. */
  int PLUS = 12;
  /** RegularExpression Id. */
  int MINUS = 13;
  /** RegularExpression Id. */
  int TIMES = 14;
  /** RegularExpression Id. */
  int SEMICOLON = 15;
  /** RegularExpression Id. */
  int LPARENS = 16;
  /** RegularExpression Id. */
  int RPARENS = 17;
  /** RegularExpression Id. */
  int PERIOD = 18;
  /** RegularExpression Id. */
  int COMMA = 19;
  /** RegularExpression Id. */
  int SLASH = 20;
  /** RegularExpression Id. */
  int SENT = 21;
  /** RegularExpression Id. */
  int UNOP = 22;
  /** RegularExpression Id. */
  int EQV = 23;
  /** RegularExpression Id. */
  int DIGIT = 24;
  /** RegularExpression Id. */
  int LETTER = 25;
  /** RegularExpression Id. */
  int NUM = 26;
  /** RegularExpression Id. */
  int ID = 27;

  /** Lexical state. */
  int DEFAULT = 0;

  /** Literal token values. */
  String[] tokenImage = {
    "<EOF>",
    "\" \"",
    "\"\\r\"",
    "\"\\t\"",
    "\"\\n\"",
    "\"\\f\"",
    "\"|\"",
    "\"&\"",
    "\"~\"",
    "\"->\"",
    "<COMPARE_OP>",
    "\"in\"",
    "\"+\"",
    "\"-\"",
    "\"*\"",
    "\";\"",
    "\"(\"",
    "\")\"",
    "\".\"",
    "\",\"",
    "\"/\"",
    "\"sent\"",
    "<UNOP>",
    "\"<->\"",
    "<DIGIT>",
    "<LETTER>",
    "<NUM>",
    "<ID>",
  };

}
