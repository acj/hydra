$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "newgram.y"
;# Make Yacc.pm like this: byacc -Pv gram.y; mv y.tab.pl Yacc.pm
;# setenv YYDEBUG true to see the statemachine parser in action.
;# setenv GRAMDEBUG to see the lexer/parser class in action.

package Yacc;

;#use AbstractNode;
;#use modelNode;
;#use modelbodyNode;
;#use ClassNode;
;#use classbodyNode;
;#use DriverfileNode;
;#use SignalNode;
;#use CCStateNode;
;#use ccstatebodyNode;
;#use CStateNode;
;#use cstatebodyNode;
;#use StateNode;
;#use statebodyNode;
;#use NullNode;
;#use InitNode;
;#use HistoryNode;
;#use JoinNode;
;#use TransNode;
;#use ActionNode;
;#use InstVarNode;
;#added
;#use transitionbodyNode;
;#use eventNode;
;#use tranactionsNode;
;#use tranactionNode;
;#use messagesNode;
;#use messageNode;
;#added end
#line 39 "y.tab.pl"
$FORMALIZE=257;
$AS=258;
$PROMELA=259;
$SMV=260;
$ALLOY=261;
$VHDL=262;
$MODEL=263;
$ID=264;
$DRIVERFILE=265;
$CLASS=266;
$ASSOCIATION=267;
$AGGREGATION=268;
$AGSUBCONST=269;
$ORDCONST=270;
$ADORNS=271;
$GENERALIZATION=272;
$SIGNAL=273;
$CSTATE=274;
$STATE=275;
$TRANS=276;
$TO=277;
$ACTION=278;
$CCSTATE=279;
$INIT=280;
$JOIN=281;
$FROM=282;
$HISTORY=283;
$INSTVAR=284;
$NUM=285;
$SUPER=286;
$SUB=287;
$WHOLE=288;
$PART=289;
$NEW=290;
$SEND=291;
$EXPRESSION=292;
$PRINTEXPRESSION=293;
$INVARIANT=294;
$INVTYPENAME=295;
$INVARIANTEXPRESSION=296;
$WHEN=297;
$ASSIGNOP=298;
$PRINT=299;
$AND=300;
$NOT=301;
$OR=302;
$COMPARE_OP=303;
$IN=304;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    0,    1,    1,    1,    1,    2,    2,    3,    3,
    4,    4,    4,    4,    4,    5,    5,    8,    8,    8,
    8,    8,    8,    8,    8,    8,    8,    9,    9,    9,
   10,   10,   19,   19,   20,   20,   20,   20,   20,   20,
   20,   20,   14,   14,   24,   24,   25,   25,   22,   22,
   22,   23,   23,   23,   27,   11,   28,   28,   29,   12,
   12,   12,   13,   21,   21,   21,   15,   15,   30,   30,
    6,    6,   16,   17,   18,    7,   26,   26,   26,   26,
   26,   26,   26,   26,   26,   26,   26,   26,   26,   26,
   26,   31,   31,   31,   31,   35,   35,   36,   36,   37,
   37,   37,   32,   33,   33,   39,   39,   39,   39,   39,
   34,   34,   40,   40,   40,   41,   44,   44,   44,   45,
   45,   45,   46,   46,   46,   46,   46,   46,   42,   42,
   43,   47,   48,   48,   49,   49,   49,   38,   38,
);
@yylen = (                                                2,
    5,    1,    1,    1,    1,    1,    5,    4,    1,    2,
    3,    5,    4,    5,    4,    1,    2,    1,    1,    1,
    1,    1,    1,    1,    6,    4,    1,    3,    5,    6,
    5,    4,    1,    2,    1,    1,    1,    1,    1,    1,
    1,    1,    4,    5,    1,    2,    1,    1,    4,    6,
    7,    4,    5,    7,    1,    5,    1,    2,    1,    3,
    5,    6,    7,    3,    5,    6,    4,    6,    1,    1,
    9,    8,    0,    4,    3,   10,    6,    2,    3,    3,
    4,    4,    5,    1,    3,    5,    3,    2,    4,    2,
    1,    1,    4,    4,    4,    1,    3,    1,    3,    1,
    2,    3,    1,    1,    3,    4,    4,    1,    1,    1,
    1,    3,    3,    1,    6,    3,    1,    3,    3,    1,
    3,    3,    1,    1,    2,    2,    3,    1,    4,    6,
    4,    4,    1,    3,    1,    1,    1,    3,    4,
);
@yydefred = (                                             0,
    0,    0,    0,    2,    0,    0,    0,    3,    4,    5,
    6,    0,    0,    0,    0,    0,    0,    0,    9,    0,
    0,    0,    0,    0,    0,    8,   10,    1,    7,   11,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   13,    0,   16,   18,   19,   20,
   21,   22,   23,   24,   27,    0,    0,    0,   15,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   12,   17,    0,   14,    0,    0,   75,    0,    0,   28,
    0,    0,    0,    0,   60,    0,  103,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   73,    0,
   26,    0,    0,    0,    0,    0,    0,   32,   37,   40,
   36,   38,   35,    0,   33,   39,   41,   42,   43,   47,
   48,    0,   45,   59,    0,   57,    0,    0,    0,    0,
    0,    0,    0,    0,  104,  108,  109,  110,    0,    0,
  111,    0,    0,    0,    0,    0,    0,    0,    0,   67,
    0,    0,    0,    0,    0,   29,    0,    0,    0,    0,
    0,    0,   31,   34,   44,   46,   56,   58,    0,    0,
  124,    0,    0,    0,    0,    0,    0,   98,  100,    0,
    0,  120,  128,   61,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   69,   70,    0,    0,    0,   25,   74,   30,    0,
    0,    0,    0,    0,   64,    0,    0,   55,    0,   93,
    0,   95,  101,    0,    0,    0,    0,  126,  125,    0,
   94,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  137,    0,  133,    0,    0,    0,  105,    0,    0,
  112,   62,    0,    0,    0,    0,    0,   68,    0,    0,
   49,    0,    0,   52,    0,    0,    0,    0,    0,    0,
  102,  127,    0,   99,  138,    0,    0,  122,  121,    0,
  131,    0,  106,  107,  129,    0,    0,    0,    0,    0,
   63,    0,    0,    0,    0,   53,   65,    0,    0,  132,
  139,  134,    0,    0,    0,    0,    0,   50,    0,   66,
    0,  130,  115,   71,   76,   51,   54,
);
@yydgoto = (                                              3,
   12,    4,   18,   19,   46,   57,   34,   47,   48,   49,
   50,   51,   52,   53,   54,  153,   79,   55,  114,  115,
  116,  117,  118,  122,  123,   92,  219,  125,  126,  204,
   93,   94,  134,  140,  176,  177,  178,  179,  135,  141,
  136,  137,  138,  180,  181,  182,  183,  243,  244,
);
@yysindex = (                                           -97,
 -137,  -61,    0,    0,  -60,   39,  -59,    0,    0,    0,
    0,   71,  -59, -119,  -96,  -88,   64,  -86,    0,  -80,
   45,  137,   90,   97,  -65,    0,    0,    0,    0,    0,
   67,  -35,  -27,  108,  -30,  -18,  116,  -20,  -17,  -16,
   -9,  -29,   -7,    9,    0,   80,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  173,  145,  180,    0,   10,
   12,   -5,   63,  155,  156,  160,  226,   -4,    5,   26,
    0,    0,   33,    0,   34,  168,    0,   41,  178,    0,
   -8,  -90,  -44,   32,    0,  267,    0,  275,   55, -163,
   61,  282,   -6,   48,   65,  -55,  224,  228,    0,   37,
    0,  281,  269,  -32,  296,  -15,  297,    0,    0,    0,
    0,    0,    0,  -64,    0,    0,    0,    0,    0,    0,
    0,  -40,    0,    0,  -52,    0,   69,  -39,  276,  -23,
  294,  298,  303,   47,    0,    0,    0,    0,  299,  250,
    0,   92, -163,   61,   52, -163,   61,   81, -153,    0,
   98,   68,  238,  101,  307,    0,  103,    2,    3,  309,
    4,   74,    0,    0,    0,    0,    0,    0,  329,  187,
    0,  107,  332,  -24, -150,    6,   75,    0,    0,  -11,
   73,    0,    0,    0,   38,  -22,  109,   61,   83, -163,
   61,  110,   61,  318,   54,  250, -163,   61,   57,  250,
  114,    0,    0,  320,  289,  117,    0,    0,    0,  323,
  106,  350,  326,  352,    0,  123,  354,    0,  342,    0,
  -22,    0,    0,  126,  351,    7,    1,    0,    0,  -24,
    0,  -24, -153,   38,   38,   38,   38,   38,  181,  351,
    0,    0,   93,    0,  353,  355,  120,    0,  250,  357,
    0,    0,   61,   60,  250,   61,  333,    0,  129,  304,
    0,  135,  121,    0,  341,  343,  139,  105,  134,  363,
    0,    0,   75,    0,    0,   73,   73,    0,    0,  124,
    0,  -22,    0,    0,    0,  -22, -153,  250,   61,  250,
    0,  312,  142,  348,  144,    0,    0,  356,  375,    0,
    0,    0,  153,  369,  250,  141,  319,    0,  358,    0,
  359,    0,    0,    0,    0,    0,    0,
);
@yyrindex = (                                             0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   35,    0,    0,    0,    0,
    0,    0,  379,  380,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  382,    0,    0,    0,    0,   53,  385,
    0,    0,    0,    0,  386,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   29,
    0,    0,    0,    0,    0,    0,   16,    0,    0,    0,
  -31,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  387,  388,    0,    0,  389,  390,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -34,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   58,   11,
   23,    0,    0,    0,    0,    0,    0,    0,  391,   59,
    0,    0,    0,  392,  393,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   18,    0,    0,  -19,  -14,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,  394,    0,  395,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  396,  306,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,
);
@yygindex = (                                             0,
    0,  412,  420,  200,    0,    0,    0,  397,    0,   25,
   42,   43,   44,   49,    0,    0,    0,  128,    0,  321,
    0,   21,   27,    0,  314,   13,    0,    0,  313, -149,
    0,  344,  -38,  -58,  265,  210,  209, -109,  252,  -70,
    0,    0,    0,  -83,   17,   22,    0, -142,  162,
);
$YYTABLESIZE=444;
@yytable = (                                            123,
  174,  158,  117,  150,   68,  175,  123,  123,  123,  117,
  123,  117,  123,  117,  118,  174,  186,  238,  161,  119,
  175,  118,  175,  118,  123,  118,  119,  117,  119,   89,
  119,  234,  103,  235,  108,  211,  213,  216,   26,  118,
  143,  272,   90,  234,  119,  235,  231,  271,   90,   90,
   90,  135,  123,  123,  135,  123,   96,  123,   97,  123,
  163,    7,  117,  136,  124,  124,  136,  124,   92,  124,
  123,  123,  167,  123,  118,  123,  242,  238,  269,  119,
  119,   92,  175,  275,  165,  196,  114,  144,  200,   91,
  227,  116,  113,  114,  146,   91,   91,   91,  197,  113,
  130,  239,   81,  120,  195,  190,  109,  199,  124,  121,
  202,  242,  190,  228,  237,  190,  116,  246,  190,  236,
    5,   80,  251,  110,  111,  112,  131,  132,   92,   20,
  113,  203,  249,  281,  229,  133,  282,  304,  109,  255,
  191,  147,  120,  303,   22,  198,  114,  253,  121,  124,
  256,  116,  113,  289,  280,  110,  111,  112,  254,    1,
  285,   13,  113,  286,  272,    2,  234,   23,  235,   29,
  212,  214,  242,  217,  300,   24,  242,  282,   14,   15,
   16,   17,    2,   39,   40,  104,   25,  105,   41,   42,
   43,   45,  106,  312,  288,   30,  282,  290,    8,    9,
   10,   11,    6,  107,   71,   14,   15,   16,   17,   39,
   40,  104,   31,  105,   41,   42,   43,   27,  106,   32,
   27,   39,   33,  234,  170,  235,  221,  222,   56,  107,
  305,  104,   59,  105,   67,  104,   58,  105,   62,  225,
   60,  240,  149,   63,  157,  171,   64,   65,  160,  107,
  276,  277,   61,  107,   66,  102,   69,  278,  279,   86,
  171,  172,  241,   73,  173,   86,   86,   86,  123,   74,
   75,  117,   70,   76,  185,   77,  172,   82,   83,  173,
   78,  173,   84,  118,   85,   87,   95,   87,  119,   96,
   99,  233,   88,   87,   87,   87,   97,   98,   88,   88,
   88,  225,  101,  233,  100,   39,  127,  230,  230,   14,
   15,   16,   17,  123,  128,  142,  151,   96,  129,   97,
  152,  155,  171,  154,  139,  124,   92,  156,  148,  159,
  162,  123,  169,  187,  184,   35,   36,  188,   37,   38,
   39,   40,  189,  193,  192,   41,   42,   43,   35,   36,
   44,   37,   38,   39,   40,  194,  206,  201,   41,   42,
   43,  205,  207,   44,  208,  209,  210,  215,  218,  220,
  223,  224,  245,  250,  232,  247,  252,  257,  258,  259,
  260,  261,  262,  263,  264,  265,  266,  267,  268,  270,
  221,  291,  292,  283,  293,  284,  287,  295,  294,  296,
  299,  297,  298,  301,  306,  307,  308,  309,  311,  313,
   36,  315,   91,   84,  310,   88,  316,  317,   90,   78,
   79,   80,   85,   87,   89,   81,   82,   83,   86,   77,
   72,   28,   21,  314,  164,  166,  145,  168,  226,  273,
  274,  248,   72,  302,
);
@yycheck = (                                             34,
   40,   34,   34,   59,   34,   45,   41,   42,   43,   41,
   45,   43,   47,   45,   34,   40,   40,   40,   34,   34,
   45,   41,   45,   43,   59,   45,   41,   59,   43,   34,
   45,   43,   41,   45,  125,   34,   34,   34,  125,   59,
   47,   41,   47,   43,   59,   45,   41,   41,   47,   47,
   47,   41,   42,   43,   44,   45,   41,   47,   41,   94,
  125,  123,   94,   41,   42,   43,   44,   45,   34,   47,
   42,   43,  125,   45,   94,   47,  186,   40,  221,   94,
  125,   47,   45,  233,  125,  144,   34,   94,  147,   94,
  174,   34,   34,   41,   47,   94,   94,   94,   47,   41,
  264,  185,   40,   83,  143,   59,   82,  146,   84,   83,
  264,  221,   59,  264,   42,   59,   59,  188,   59,   47,
  258,   59,  193,   82,   82,   82,  290,  291,   94,   59,
   82,  285,  191,   41,  285,  299,   44,  287,  114,  198,
   94,   94,  122,  286,  264,   94,   94,   94,  122,  125,
   94,   94,   94,   94,  238,  114,  114,  114,  197,  257,
   41,  123,  114,   44,   41,  263,   43,  264,   45,  125,
  158,  159,  282,  161,   41,  264,  286,   44,  265,  266,
  267,  268,  263,  274,  275,  276,  123,  278,  279,  280,
  281,  125,  283,   41,  253,   59,   44,  256,  259,  260,
  261,  262,  264,  294,  125,  265,  266,  267,  268,  274,
  275,  276,  123,  278,  279,  280,  281,   18,  283,  123,
   21,  274,  288,   43,  264,   45,   40,   41,  264,  294,
  289,  276,  125,  278,  264,  276,  264,  278,  123,  264,
  271,  264,  298,  264,  277,  285,  264,  264,  264,  294,
  234,  235,  271,  294,  264,  264,  264,  236,  237,  264,
  285,  301,  285,   91,  304,  264,  264,  264,  303,  125,
   91,  303,  264,  264,  298,  264,  301,  123,  123,  304,
  286,  304,  123,  303,   59,  292,  282,  292,  303,  264,
  123,  303,  297,  292,  292,  292,  264,  264,  297,  297,
  297,  264,  125,  303,  264,  274,   40,  302,  302,  265,
  266,  267,  268,  303,   40,   34,   93,  302,  264,  302,
   93,   41,  285,  287,  264,  303,  292,   59,  264,   34,
   34,  303,  264,   40,   59,  269,  270,   40,  272,  273,
  274,  275,   40,   94,   46,  279,  280,  281,  269,  270,
  284,  272,  273,  274,  275,  264,  289,  277,  279,  280,
  281,  264,  125,  284,  264,   59,  264,   59,  295,   41,
  264,   40,  264,  264,  300,  293,   59,  264,   59,   91,
  264,   59,  277,   34,   59,   34,  264,   34,   47,  264,
   40,   59,  264,   41,   91,   41,   40,  277,  264,   59,
  296,   59,  264,   41,   93,  264,   59,  264,   34,   41,
  270,   93,   34,   34,   59,   34,   59,   59,   34,   34,
   34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
  125,   20,   13,  306,  114,  122,   93,  125,  174,  230,
  232,  190,   46,  282,
);
$YYFINAL=3;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=304;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
"'\"'",'','','','','',"'('","')'","'*'","'+'","','","'-'","'.'","'/'",'','','','','','','',
'','','','',"';'",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
"'['",'',"']'","'^'",'','','','','','','','','','','','','','','','','','','','','','','','','','','','',
"'{'",'',"'}'",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','',"FORMALIZE","AS","PROMELA","SMV","ALLOY",
"VHDL","MODEL","ID","DRIVERFILE","CLASS","ASSOCIATION","AGGREGATION",
"AGSUBCONST","ORDCONST","ADORNS","GENERALIZATION","SIGNAL","CSTATE","STATE",
"TRANS","TO","ACTION","CCSTATE","INIT","JOIN","FROM","HISTORY","INSTVAR","NUM",
"SUPER","SUB","WHOLE","PART","NEW","SEND","EXPRESSION","PRINTEXPRESSION",
"INVARIANT","INVTYPENAME","INVARIANTEXPRESSION","WHEN","ASSIGNOP","PRINT","AND",
"NOT","OR","COMPARE_OP","IN",
);
@yyrule = (
"\$accept : spec",
"spec : FORMALIZE AS language ';' model",
"spec : model",
"language : PROMELA",
"language : SMV",
"language : ALLOY",
"language : VHDL",
"model : MODEL ID '{' modelbody '}'",
"model : MODEL '{' modelbody '}'",
"modelbody : modelstmt",
"modelbody : modelbody modelstmt",
"modelstmt : DRIVERFILE ID ';'",
"modelstmt : CLASS ID '{' classbody '}'",
"modelstmt : CLASS ID '{' '}'",
"modelstmt : ASSOCIATION ID '{' assocbody '}'",
"modelstmt : AGGREGATION '{' agbody '}'",
"classbody : classstmt",
"classbody : classbody classstmt",
"classstmt : signal",
"classstmt : cstate",
"classstmt : ccstate",
"classstmt : init",
"classstmt : join",
"classstmt : state",
"classstmt : instvar",
"classstmt : AGSUBCONST ADORNS ID '{' agsubbody '}'",
"classstmt : GENERALIZATION '{' genbody '}'",
"classstmt : ordconst",
"signal : SIGNAL ID ';'",
"signal : SIGNAL ID '(' ')' ';'",
"signal : SIGNAL ID '(' ID ')' ';'",
"cstate : CSTATE ID '{' cstatebody '}'",
"cstate : CSTATE ID '{' '}'",
"cstatebody : cstatestmt",
"cstatebody : cstatebody cstatestmt",
"cstatestmt : state",
"cstatestmt : init",
"cstatestmt : cstate",
"cstatestmt : join",
"cstatestmt : history",
"cstatestmt : ccstate",
"cstatestmt : transition",
"cstatestmt : actofstate",
"state : STATE ID '{' '}'",
"state : STATE ID '{' statebody '}'",
"statebody : statestmt",
"statebody : statebody statestmt",
"statestmt : transition",
"statestmt : actofstate",
"transition : TRANS TO ID ';'",
"transition : TRANS '\"' '\"' TO ID ';'",
"transition : TRANS '\"' transitionbody '\"' TO ID ';'",
"actofstate : ACTION '\"' '\"' ';'",
"actofstate : ACTION '\"' transitionbody '\"' ';'",
"actofstate : INVARIANT '\"' invtype '/' INVARIANTEXPRESSION '\"' ';'",
"invtype : INVTYPENAME",
"ccstate : CCSTATE ID '{' ccstatebody '}'",
"ccstatebody : ccstatestmt",
"ccstatebody : ccstatebody ccstatestmt",
"ccstatestmt : cstate",
"init : INIT ID ';'",
"init : INIT '\"' '\"' ID ';'",
"init : INIT '\"' transitionbody '\"' ID ';'",
"join : JOIN ID FROM ID TO ID ';'",
"history : HISTORY ID ';'",
"history : HISTORY '\"' '\"' ID ';'",
"history : HISTORY '\"' transitionbody '\"' ID ';'",
"instvar : INSTVAR ID ID ';'",
"instvar : INSTVAR ID ID ASSIGNOP numid ';'",
"numid : ID",
"numid : NUM",
"assocbody : ID '[' ID ']' ID '[' ID ']' ordconst",
"assocbody : ID '[' ID ']' ID '[' ID ']'",
"agsubbody :",
"genbody : SUPER ID SUB ID",
"ordconst : ORDCONST ADORNS ID",
"agbody : WHOLE ID '[' ID ']' PART ID '[' ID ']'",
"transitionbody : event guard '/' actions '^' messages",
"transitionbody : event guard",
"transitionbody : event '/' actions",
"transitionbody : event '^' messages",
"transitionbody : event guard '/' actions",
"transitionbody : event guard '^' messages",
"transitionbody : event '/' actions '^' messages",
"transitionbody : guard",
"transitionbody : guard '/' actions",
"transitionbody : guard '/' actions '^' messages",
"transitionbody : guard '^' messages",
"transitionbody : '/' actions",
"transitionbody : '/' actions '^' messages",
"transitionbody : '^' messages",
"transitionbody : event",
"event : ID",
"event : ID '(' ID ')'",
"event : WHEN '(' complexguard ')'",
"event : WHEN '(' ID ')'",
"complexguard : expra",
"complexguard : complexguard OR expra",
"expra : gdterm",
"expra : expra AND gdterm",
"gdterm : pred",
"gdterm : NOT ID",
"gdterm : '(' complexguard ')'",
"guard : EXPRESSION",
"actions : action",
"actions : actions ';' action",
"action : NEW '(' ID ')'",
"action : SEND '(' message ')'",
"action : assignstmt",
"action : printstmt",
"action : function",
"messages : message",
"messages : messages '^' message",
"message : ID '.' ID",
"message : ID",
"message : ID '.' ID '(' numid ')'",
"assignstmt : ID ASSIGNOP stmtpm",
"stmtpm : stmtdm",
"stmtpm : stmtpm '+' stmtdm",
"stmtpm : stmtpm '-' stmtdm",
"stmtdm : actterm",
"stmtdm : stmtdm '*' actterm",
"stmtdm : stmtdm '/' actterm",
"actterm : ID",
"actterm : NUM",
"actterm : '-' NUM",
"actterm : '-' ID",
"actterm : '(' stmtpm ')'",
"actterm : functioninassign",
"printstmt : PRINT '(' PRINTEXPRESSION ')'",
"printstmt : PRINT '(' PRINTEXPRESSION ',' parmlist ')'",
"function : ID '(' parmlist ')'",
"functioninassign : ID '(' parmlist ')'",
"parmlist : parm",
"parmlist : parmlist ',' parm",
"parm : ID",
"parm : NUM",
"parm : pred",
"pred : stmtpm COMPARE_OP numid",
"pred : IN '(' ID ')'",
);
#endif
sub yyclearin { $yychar = -1; }
sub yyerrok { $yyerrflag = 0; }
$YYSTACKSIZE = $YYSTACKSIZE || $YYMAXDEPTH || 500;
$YYMAXDEPTH = $YYMAXDEPTH || $YYSTACKSIZE || 500;
$yyss[$YYSTACKSIZE] = 0;
$yyvs[$YYSTACKSIZE] = 0;
sub YYERROR { ++$yynerrs; &yy_err_recover; }
sub yy_err_recover
{
  if ($yyerrflag < 3)
  {
    $yyerrflag = 3;
    while (1)
    {
      if (($yyn = $yysindex[$yyss[$yyssp]]) && 
          ($yyn += $YYERRCODE) >= 0 && 
          $yycheck[$yyn] == $YYERRCODE)
      {
#if YYDEBUG
       print "yydebug: state $yyss[$yyssp], error recovery shifting",
             " to state $yytable[$yyn]\n" if $yydebug;
#endif
        $yyss[++$yyssp] = $yystate = $yytable[$yyn];
        $yyvs[++$yyvsp] = $yylval;
        next yyloop;
      }
      else
      {
#if YYDEBUG
        print "yydebug: error recovery discarding state ",
              $yyss[$yyssp], "\n"  if $yydebug;
#endif
        return(1) if $yyssp <= 0;
        --$yyssp;
        --$yyvsp;
      }
    }
  }
  else
  {
    return (1) if $yychar == 0;
#if YYDEBUG
    if ($yydebug)
    {
      $yys = '';
      if ($yychar <= $YYMAXTOKEN) { $yys = $yyname[$yychar]; }
      if (!$yys) { $yys = 'illegal-symbol'; }
      print "yydebug: state $yystate, error recovery discards ",
            "token $yychar ($yys)\n";
    }
#endif
    $yychar = -1;
    next yyloop;
  }
0;
} # yy_err_recover

sub yyparse
{
#ifdef YYDEBUG
  if ($yys = $ENV{'YYDEBUG'})
  {
    $yydebug = int($1) if $yys =~ /^(\d)/;
  }
#endif

  $yynerrs = 0;
  $yyerrflag = 0;
  $yychar = (-1);

  $yyssp = 0;
  $yyvsp = 0;
  $yyss[$yyssp] = $yystate = 0;

yyloop: while(1)
  {
    yyreduce: {
      last yyreduce if ($yyn = $yydefred[$yystate]);
      if ($yychar < 0)
      {
        if (($yychar = &yylex) < 0) { $yychar = 0; }
#if YYDEBUG
        if ($yydebug)
        {
          $yys = '';
          if ($yychar <= $#yyname) { $yys = $yyname[$yychar]; }
          if (!$yys) { $yys = 'illegal-symbol'; };
          print "yydebug: state $yystate, reading $yychar ($yys)\n";
        }
#endif
      }
      if (($yyn = $yysindex[$yystate]) && ($yyn += $yychar) >= 0 &&
              $yycheck[$yyn] == $yychar)
      {
#if YYDEBUG
        print "yydebug: state $yystate, shifting to state ",
              $yytable[$yyn], "\n"  if $yydebug;
#endif
        $yyss[++$yyssp] = $yystate = $yytable[$yyn];
        $yyvs[++$yyvsp] = $yylval;
        $yychar = (-1);
        --$yyerrflag if $yyerrflag > 0;
        next yyloop;
      }
      if (($yyn = $yyrindex[$yystate]) && ($yyn += $yychar) >= 0 &&
            $yycheck[$yyn] == $yychar)
      {
        $yyn = $yytable[$yyn];
        last yyreduce;
      }
      if (! $yyerrflag) {
        &yyerror('syntax error');
        ++$yynerrs;
      }
      return(1) if &yy_err_recover;
    } # yyreduce
#if YYDEBUG
    print "yydebug: state $yystate, reducing by rule ",
          "$yyn ($yyrule[$yyn])\n"  if $yydebug;
#endif
    $yym = $yylen[$yyn];
    $yyval = $yyvs[$yyvsp+1-$yym];
    switch:
    {
if ($yyn == 7) {
#line 61 "newgram.y"
{$final = Node(model, ID,$yyvs[$yyvsp-3], child,[$yyvs[$yyvsp-1]]);
last switch;
} }
if ($yyn == 8) {
#line 62 "newgram.y"
{$final = Node(model, ID,'Model', child,[$yyvs[$yyvsp-1]]);
last switch;
} }
if ($yyn == 9) {
#line 64 "newgram.y"
{$yyval = Node(modelbody, child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 10) {
#line 65 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-1],child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 11) {
#line 67 "newgram.y"
{$yyval = Node(Driverfile, ID,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 12) {
#line 68 "newgram.y"
{$yyval = Node(Class, ID,$yyvs[$yyvsp-3], child,[$yyvs[$yyvsp-1]]);
last switch;
} }
if ($yyn == 13) {
#line 69 "newgram.y"
{$yyval = Node(Null);
last switch;
} }
if ($yyn == 14) {
#line 70 "newgram.y"
{$yyval = $yyvs[$yyvsp-4];
last switch;
} }
if ($yyn == 15) {
#line 71 "newgram.y"
{$yyval = $yyvs[$yyvsp-3];
last switch;
} }
if ($yyn == 16) {
#line 73 "newgram.y"
{$yyval = Node(classbody, child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 17) {
#line 74 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-1], child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 18) {
#line 76 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 19) {
#line 77 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 20) {
#line 78 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 21) {
#line 79 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 22) {
#line 80 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 23) {
#line 82 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 24) {
#line 83 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 25) {
#line 84 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 26) {
#line 85 "newgram.y"
{$yyval=$yyvs[$yyvsp-3];
last switch;
} }
if ($yyn == 27) {
#line 86 "newgram.y"
{$yyval=$yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 28) {
#line 88 "newgram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-1]); Symtab('signal', $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 29) {
#line 89 "newgram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-3]); Symtab('signal', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 30) {
#line 90 "newgram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-4],sigtype,$yyvs[$yyvsp-2]); Symtab('signal', $yyvs[$yyvsp-4]);
last switch;
} }
if ($yyn == 31) {
#line 92 "newgram.y"
{$yyval = Node(CState, ID, $yyvs[$yyvsp-3], child,[$yyvs[$yyvsp-1]]); Symtab('cstate', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 32) {
#line 93 "newgram.y"
{$yyval = Node(CState, ID, $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 33) {
#line 95 "newgram.y"
{$yyval = Node(cstatebody, child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 34) {
#line 96 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-1], child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 35) {
#line 98 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 36) {
#line 99 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 37) {
#line 100 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 38) {
#line 101 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 39) {
#line 102 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 40) {
#line 103 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 41) {
#line 104 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 42) {
#line 105 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 43) {
#line 107 "newgram.y"
{$yyval = Node(State, ID,$yyvs[$yyvsp-2]); Symtab('state', $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 44) {
#line 108 "newgram.y"
{$yyval = Node(State, ID,$yyvs[$yyvsp-3], child,[$yyvs[$yyvsp-1]]); Symtab('state', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 45) {
#line 110 "newgram.y"
{$yyval = Node(statebody, child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 46) {
#line 111 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-1], child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 47) {
#line 113 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 48) {
#line 114 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 49) {
#line 116 "newgram.y"
{$yyval = Node(Trans, tran,  '', dest, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 50) {
#line 117 "newgram.y"
{$yyval = Node(Trans, tran,  '', dest, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 51) {
#line 118 "newgram.y"
{$yyval = Node(Trans, tran,  $yyvs[$yyvsp-4], dest, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 52) {
#line 120 "newgram.y"
{$yyval = Node(Action, tran,  '');
last switch;
} }
if ($yyn == 53) {
#line 121 "newgram.y"
{$yyval = Node(Action, tran,  $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 54) {
#line 123 "newgram.y"
{$yyval = Node(timeinvariant, $yyvs[$yyvsp-4],  $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 55) {
#line 125 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 56) {
#line 129 "newgram.y"
{$yyval = Node(CCState,ID,$yyvs[$yyvsp-3], child,[$yyvs[$yyvsp-1]]);
last switch;
} }
if ($yyn == 57) {
#line 131 "newgram.y"
{$yyval = Node(ccstatebody, child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 58) {
#line 132 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-1], child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 59) {
#line 134 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 60) {
#line 138 "newgram.y"
{$yyval = Node(Init, ID,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 61) {
#line 139 "newgram.y"
{$yyval = Node(Init, ID,$yyvs[$yyvsp-1], tran,  '');
last switch;
} }
if ($yyn == 62) {
#line 140 "newgram.y"
{$yyval = Node(Init, ID,$yyvs[$yyvsp-1], tran,  $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 63) {
#line 142 "newgram.y"
{$yyval = Node(Join, ID, $yyvs[$yyvsp-5], from, $yyvs[$yyvsp-3], to, $yyvs[$yyvsp-1]); Symtab('state', $yyvs[$yyvsp-5]);
last switch;
} }
if ($yyn == 64) {
#line 144 "newgram.y"
{$yyval = Node(History, ID, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 65) {
#line 145 "newgram.y"
{$yyval = Node(History, ID, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 66) {
#line 146 "newgram.y"
{$yyval = Node(History, ID, $yyvs[$yyvsp-1], tran, $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 67) {
#line 148 "newgram.y"
{$yyval = Node(InstVar,vtype,$yyvs[$yyvsp-2],var,$yyvs[$yyvsp-1]); Symtab('var', $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 68) {
#line 149 "newgram.y"
{$yyval = Node(InstVar,vtype,$yyvs[$yyvsp-4],var,$yyvs[$yyvsp-3],initval,$yyvs[$yyvsp-1]); Symtab('var', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 69) {
#line 151 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 70) {
#line 152 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 71) {
#line 155 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 72) {
#line 156 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 74) {
#line 160 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 75) {
#line 162 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 76) {
#line 164 "newgram.y"
{Nullsub();
last switch;
} }
if ($yyn == 77) {
#line 167 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-5],guard, $yyvs[$yyvsp-4], actions, $yyvs[$yyvsp-2], messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 78) {
#line 168 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-1],guard, $yyvs[$yyvsp-0], actions, '', messages, '');
last switch;
} }
if ($yyn == 79) {
#line 169 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-2],guard, '', actions, $yyvs[$yyvsp-0], messages, '');
last switch;
} }
if ($yyn == 80) {
#line 170 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-2],guard, '', actions, '', messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 81) {
#line 171 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-3],guard, $yyvs[$yyvsp-2], actions, $yyvs[$yyvsp-0], messages, '');
last switch;
} }
if ($yyn == 82) {
#line 172 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-3],guard, $yyvs[$yyvsp-2], actions, '', messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 83) {
#line 173 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-4],guard, '', actions, $yyvs[$yyvsp-2], messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 84) {
#line 174 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, $yyvs[$yyvsp-0], actions, '', messages, '');
last switch;
} }
if ($yyn == 85) {
#line 175 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, $yyvs[$yyvsp-2], actions, $yyvs[$yyvsp-0], messages, '');
last switch;
} }
if ($yyn == 86) {
#line 176 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, $yyvs[$yyvsp-4], actions, $yyvs[$yyvsp-2], messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 87) {
#line 177 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, $yyvs[$yyvsp-2], actions, '', messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 88) {
#line 178 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, '', actions, $yyvs[$yyvsp-0], messages, '');
last switch;
} }
if ($yyn == 89) {
#line 179 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, '', actions, $yyvs[$yyvsp-2], messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 90) {
#line 180 "newgram.y"
{$yyval = Node(transitionbody,event,'',guard, '', actions, '', messages, $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 91) {
#line 181 "newgram.y"
{$yyval = Node(transitionbody,event,$yyvs[$yyvsp-0],guard, '', actions, '', messages, '');
last switch;
} }
if ($yyn == 92) {
#line 183 "newgram.y"
{$yyval = Node(event,eventtype,'normal',eventname,$yyvs[$yyvsp-0],eventvar, '');
last switch;
} }
if ($yyn == 93) {
#line 184 "newgram.y"
{$yyval = Node(event,eventtype,'normal',eventname,$yyvs[$yyvsp-3],eventvar, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 94) {
#line 185 "newgram.y"
{$yyval = Node(event,eventtype,  'when',whenvar, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 95) {
#line 186 "newgram.y"
{$yyval = Node(event,eventtype,  'when',whenvar, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 96) {
#line 188 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 97) {
#line 189 "newgram.y"
{$yyval = $yyvs[$yyvsp-2].$yyvs[$yyvsp-1].$yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 98) {
#line 191 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 99) {
#line 192 "newgram.y"
{$yyval = $yyvs[$yyvsp-2].$yyvs[$yyvsp-1].$yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 100) {
#line 194 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 101) {
#line 195 "newgram.y"
{$yyval = $yyvs[$yyvsp-1].$yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 102) {
#line 196 "newgram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 103) {
#line 198 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 104) {
#line 200 "newgram.y"
{$yyval = Node(tranactions,child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 105) {
#line 201 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-2],child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 106) {
#line 203 "newgram.y"
{$yyval = Node(tranaction,actiontype,'newaction',content,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 107) {
#line 204 "newgram.y"
{$yyval = Node(tranaction,actiontype,'sendmsg',message,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 108) {
#line 205 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 109) {
#line 206 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 110) {
#line 207 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 111) {
#line 209 "newgram.y"
{$yyval = Node(messages,child,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 112) {
#line 210 "newgram.y"
{$yyval = AddChild($yyvs[$yyvsp-2],child,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 113) {
#line 212 "newgram.y"
{$yyval = Node(message,msgclassname,$yyvs[$yyvsp-2],msgsignalname,$yyvs[$yyvsp-0],msgintvarname,'');
last switch;
} }
if ($yyn == 114) {
#line 213 "newgram.y"
{$yyval = Node(message,msgclassname,'',msgsignalname,$yyvs[$yyvsp-0],msgintvarname,'');
last switch;
} }
if ($yyn == 115) {
#line 214 "newgram.y"
{$yyval = Node(message,msgclassname,$yyvs[$yyvsp-5],msgsignalname,$yyvs[$yyvsp-3],msgintvarname,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 116) {
#line 216 "newgram.y"
{$yyval = Node(tranaction,actiontype,'assignstmt',assignment,$yyvs[$yyvsp-2].$yyvs[$yyvsp-1].$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 117) {
#line 218 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 118) {
#line 219 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . '+' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 119) {
#line 220 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . '-' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 120) {
#line 222 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 121) {
#line 223 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . '*' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 122) {
#line 224 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . '/' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 123) {
#line 226 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 124) {
#line 227 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 125) {
#line 228 "newgram.y"
{$yyval = '-' . $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 126) {
#line 229 "newgram.y"
{$yyval = '-' . $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 127) {
#line 230 "newgram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 128) {
#line 231 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 129) {
#line 233 "newgram.y"
{$yyval = Node(tranaction,actiontype,'printstmt',printcontent,$yyvs[$yyvsp-1],printparmlist,'');
last switch;
} }
if ($yyn == 130) {
#line 234 "newgram.y"
{$yyval = Node(tranaction,actiontype,'printstmt',printcontent,$yyvs[$yyvsp-3],printparmlist,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 131) {
#line 236 "newgram.y"
{$yyval = Node(tranaction,actiontype,'function',funcID,$yyvs[$yyvsp-3],funcparmlist,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 132) {
#line 239 "newgram.y"
{$yyval = $yyvs[$yyvsp-3] . $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 133) {
#line 241 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 134) {
#line 242 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 135) {
#line 244 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 136) {
#line 245 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 137) {
#line 246 "newgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 138) {
#line 248 "newgram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 139) {
#line 249 "newgram.y"
{$yyval = $yyvs[$yyvsp-3] . '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
#line 1281 "y.tab.pl"
    } # switch
    $yyssp -= $yym;
    $yystate = $yyss[$yyssp];
    $yyvsp -= $yym;
    $yym = $yylhs[$yyn];
    if ($yystate == 0 && $yym == 0)
    {
#if YYDEBUG
      print "yydebug: after reduction, shifting from state 0 ",
            "to state $YYFINAL\n" if $yydebug;
#endif
      $yystate = $YYFINAL;
      $yyss[++$yyssp] = $YYFINAL;
      $yyvs[++$yyvsp] = $yyval;
      if ($yychar < 0)
      {
        if (($yychar = &yylex) < 0) { $yychar = 0; }
#if YYDEBUG
        if ($yydebug)
        {
          $yys = '';
          if ($yychar <= $#yyname) { $yys = $yyname[$yychar]; }
          if (!$yys) { $yys = 'illegal-symbol'; }
          print "yydebug: state $YYFINAL, reading $yychar ($yys)\n";
        }
#endif
      }
      return(0) if $yychar == 0;
      next yyloop;
    }
    if (($yyn = $yygindex[$yym]) && ($yyn += $yystate) >= 0 &&
        $yyn <= $#yycheck && $yycheck[$yyn] == $yystate)
    {
        $yystate = $yytable[$yyn];
    } else {
        $yystate = $yydgoto[$yym];
    }
#if YYDEBUG
    print "yydebug: after reduction, shifting from state ",
        "$yyss[$yyssp] to state $yystate\n" if $yydebug;
#endif
    $yyss[++$yyssp] = $yystate;
    $yyvs[++$yyvsp] = $yyval;
  } # yyloop
} # yyparse
#line 252 "newgram.y"

my $YYDEBUG=1;

#sub Node
#{
#    my ($type, @arg) = @_;
#
#    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
#    my $node = {};
#    $$node{type} = $type;
#    while (@arg) {
#   my $key = shift(@arg);
#   my $val = shift(@arg);
#   $$node{$key} = $val;
#    }
#    $$node{linenum} = $lineno;
#    return $node;
#}

#added by min
sub Node
{
    my ($type, @arg) = @_;

    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
    my @list;
    push(@list,$type);push(@list,"Node");
    my $classname = join("",@list);
    my $node = new $classname($lineno, @arg);   
    bless($node, $classname);
    return $node;
}

#sub Nullsub
#{
#  my $node = {};
#  $dtype = 'Dummy';
#  $$node{type} = $dtype;
#  $$node{linenum} = $lineno;
#  return $node;
#}

#added
sub Nullsub
{
    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
    my @list;
    push(@list,"Null");
    push(@list,"Node");
    my $classname = join("",@list);
    my $node = new $classname($lineno, @arg);   
    bless($node, $classname);
    return $node;
}

#added
sub AddChild
{
    my ($node, $key, $val) = @_;
    
    #print "adding $val to $key\n"; #if $DEBUG;
    push(@{$$node{$key}}, $val);
    $val->{parent}=$node;   #add a parent key to this node
    #print("\n***###\nval->{parent}  $val->{parent}\n");
    return $node;
}

sub yylex 
{
    my $a = yylexa();
    print "lex returning $TokenLkup[$a] yylval=$yylval\n" if $DEBUG;
    print "buf=\ [$buf\]\n" if $DEBUG;
    return $a;
}

sub yylexa
{

    use English;

    if (!$buf || $buf =~ /^ *\#/ || $buf =~ /^ *\/\*/) {
    $buf = <IN>;
    $buf =~ s/[\n]//g;
    $buf =~ s/\t/ /g;
    $buf =~ s/\x00//g;
    $lineno++;
    while ($buf =~ /^\#/ || $buf =~ /^ *$/ || $buf =~ /^ *\/\*/) {
        $buf = <IN>;
        $buf =~ s/[\n]//g;
        $buf =~ s/\t/ /g;
        $buf =~ s/\x00//g;
        $lineno++;
        if (!$buf) {last}
    }
    if (!$buf) {return 0}
    $buf =~ s/;/ ;/g;
    $buf =~ s/\'/\' /g;
    $buf =~ s/\)/ \)/g;  #right
    $buf =~ s/\(/ \(/g;  #left
    $buf =~ s/\[/ \[ /g;
    $buf =~ s/\]/ \] /g;
    $buf =~ s/\:=/ \:= /g;
    $bufcopy = $buf;
    print "read($lineno):$buf\n" if $DEBUG;
    }

#old tokens
#%token MODEL,ID,NUM,QSTR,CLASS,ASSOC,TYPE,CCSTATE,CSTATE,TO,ENUM
#%token DRIVERFILE,STATE,TRANS,INIT,FORMAL,JOIN,HISTORY,FROM,INSTVAR
#%token SIGNAL

#new tokens
#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token SINGLEQUOTE,DOUBLEQUOTE,TWODOUBLEQUOTE, EXPRESSION, PRINTEXPRESSION
#%token WHEN, ASSIGNOP, PRINT, NEW, SEND, AND, OR, IN, NOT, COMPARE_OP

    my $ret = $buf =~ /^ *(Model)/ ? $MODEL :
    $buf =~ /^ *(Class) / ? $CLASS :
    $buf =~ /^ *(Formalize) / ? $FORMALIZE :
    $buf =~ /^ *(as) / ? $AS :
    $buf =~ /^ *(promela) / ? $PROMELA :
    $buf =~ /^ *(smv) / ? $SMV :
    $buf =~ /^ *(alloy) / ? $ALLOY :
    $buf =~ /^ *(vhdl) / ? $VHDL :   
    $buf =~ /^ *(new) /i ? $NEW :
    $buf =~ /^ *(is) /i ? $COMPARE_OP : #this is for type enum, e.g. 'mode is heat'
    $buf =~ /^ *(send) /i ? $SEND :
    $buf =~ /^ *(when) /i ? $WHEN :
    #added 040703 to handle timing invariants
    $buf =~ /^ *(timeinvar) / ? $INVTYPENAME :
    # add end
    $buf =~ /^ *(DriverFile) / ? $DRIVERFILE :
    $buf =~ /^ *(Association) /? $ASSOCIATION :
    $buf =~ /^ *(Aggregation) / ? $AGGREGATION :
    $buf =~ /^ *(Aggregation-Subclass-Constraint) /? $AGSUBCONST :
    $buf =~ /^ *(Ordered-Constraint) /? $ORDCONST :
    $buf =~ /^ *(adorns) /? $ADORNS :
    $buf =~ /^ *(in) /i ? $IN :
    $buf =~ /^ *(\|) / ? $OR :
    $buf =~ /^ *(\&) / ? $AND :
    $buf =~ /^ *(\~) / ? $NOT :
    $buf =~ /^ *(Generalization) /? $GENERALIZATION :
    $buf =~ /^ *(Signal) / ? $SIGNAL :
    $buf =~ /^ *(Action) / ? $ACTION :
    $buf =~ /^ *(Time) / ? $TIME :
    $buf =~ /^ *(print) /i ? $PRINT :
    $buf =~ /^ *(CompositeState) / ? $CSTATE :
    $buf =~ /^ *(State) / ? $STATE :
    $buf =~ /^ *(Transition) / ? $TRANS :
    $buf =~ /^ *(to) / ? $TO :
    $buf =~ /^ *(ConcurrentState) / ? $CCSTATE :
    $buf =~ /^ *(Initial) / ? $INIT :
    $buf =~ /^ *(Join) / ? $JOIN :
    $buf =~ /^ *(from) / ? $FROM :    
    $buf =~ /^ *(History) / ? $HISTORY :
    $buf =~ /^ *(InstanceVar) / ? $INSTVAR :
    # SK: added 052403 '-?' to handle negative numbers
    $buf =~ /^ *(-?[0-9]+)/ ? $NUM:
    # SK end add
    $buf =~ /^ *(super) / ? $SUPER :
    $buf =~ /^ *(sub) / ? $SUB :
    $buf =~ /^ *(Whole) / ? $WHOLE :
    $buf =~ /^ *(Part) / ? $PART :
    $buf =~ /^ *(\'[^\"\']+\') / ? $PRINTEXPRESSION :
    $buf =~ /^ *(:=) / ? $ASSIGNOP :
    $buf =~ /^ *(=|!=|>=|<=|>|<)/ ? $COMPARE_OP :
    #added 040703 to handle timing invariants
    $buf =~ /^ *(Invariant) / ? $INVARIANT :
    $buf =~ /^ *(\{[^\"]+\}) / ? $INVARIANTEXPRESSION :   
    #add end
    $buf =~ /^ *(\[[^\"]+\]) / ? $EXPRESSION :
    $buf =~ /^ *([A-Za-z\_][A-Za-z0-9\_]*)/ ? $ID :
    $buf =~ /^ *(.)/ ? -2 : -1;
    $buf = $POSTMATCH;
    $yylval = $1;
    $lasttoken = $1;
    if ($ret == -2) {$ret = unpack('c1', $yylval)}
    elsif ($ret == -1) {die "failed to match in yylex";}

    if ($ret == $ID && $saveclassid) {
      $LastClass = $yylval;
      $saveclassid = 0;
    }
    elsif ($ret == $ID && $savestateid) {
      $LastState = $yylval;
      $savestateid = 0;
    }
    elsif ($ret == $CLASS) {$saveclassid = 1}
    elsif ($ret == $STATE) {$savestateid = 1}

    return $ret;
}

sub yyerror
{
    print("\n***class=>$LastClass, state=>$LastState***\n");
    print("\nSyntax error near '$lasttoken' in '$bufcopy', line $lineno\n");
    #exit;
}

sub Init
{
  if ($ENV{GRAMDEBUG}) 
  {$DEBUG = 1}
  else 
  {$DEBUG = 0}

#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token WHEN, PRINT, NEW, SEND,IN

# This is the official token lookup table.
  %TokenTab = ('Formalize'=>$FORMALIZE, 'as'=>$AS, 'promela'=>$PROMELA, 'smv'=>$SMV, 'alloy'=>$ALLOY, 'vhdl'=>$VHDL,
           'Model'=>$MODEL, 'ID'=>$ID,
           'DriverFile'=>$DRIVERFILE, 'Class'=>$CLASS, 'Association'=>$ASSOCIATION, 'Aggregation'=>$AGGREGATION,
           'Aggregation-Subclass-Constraint'=>$AGSUBCONST, 'Ordered-Constraint'=>$ORDCONST, 'adorns'=>$ADORNS,
           'Generalization'=>$GENERALIZATION,
           'Signal'=>$SIGNAL, 'CompositeState'=>$CSTATE, 'State'=>$STATE, 'Transition'=>$TRANS, 'to'=>$TO,
           'Action'=>$ACTION, 'ConcurrentState'=>$CCSTATE, 'Initial'=>$INIT, 'Join'=>$JOIN, 'from'=>$FROM, 
           'History'=>$HISTORY, 'InstanceVar'=>$INSTVAR, 'NUM'=>$NUM,
           'super'=>$SUPER, 'sub'=>$SUB, 'Whole'=>$WHOLE, 'Part'=>$PART,
           'when'=>$WHEN, 
           'print'=>$PRINT,
           'new'=>$NEW, 'send'=>$SEND,'in'=>$IN
           );
            
#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token WHEN, PRINT, NEW, SEND,IN
   
# This is only used to print out the token name above.

   $TokenLkup[$FORMALIZE] = 'Formalize';    $TokenLkup[$AS] = 'as';
   $TokenLkup[$PROMELA] = 'promela';        $TokenLkup[$SMV] = 'smv';
   $TokenLkup[$ALLOY] = 'alloy';        $TokenLkup[$VHDL] = 'vhdl';   
   $TokenLkup[$MODEL] = 'Model';        $TokenLkup[$ID] = 'ID';
   
   $TokenLkup[$DRIVERFILE] = 'DriverFile';  $TokenLkup[$CLASS] = 'Class';    
   $TokenLkup[$ASSOCIATION] = 'Association';    $TokenLkup[$AGGREGATION] = 'Aggregation';
   $TokenLkup[$AGSUBCONST] = 'Aggregation-Subclass-Constraint';
   $TokenLkup[$ORDCONST] = 'Ordered-Constraint';
   $TokenLkup[$ADORNS]='adorns';        $TokenLkup[$GENERALIZATION] = 'Generalization';
   
   $TokenLkup[$SIGNAL]='Signal';        $TokenLkup[$CSTATE]='CompositeState'; 
   $TokenLkup[$STATE] = 'State';        $TokenLkup[$TRANS] = 'Transition'; 
   $TokenLkup[$TO] = 'To';          $TokenLkup[$ACTION]='Action';
   $TokenLkup[$CCSTATE] = 'CCState';        $TokenLkup[$INIT] = 'Initial'; 
   $TokenLkup[$JOIN] = 'Join';          $TokenLkup[$FROM] = 'from'; 
   $TokenLkup[$HISTORY] = 'History';        $TokenLkup[$INSTVAR] = 'InstanceVar'; #no NUM
   
   $TokenLkup[$SUPER]='super';          $TokenLkup[$SUB]='sub'; 
   $TokenLkup[$WHOLE] = 'Whole';        $TokenLkup[$PART] = 'Part';
   
   $TokenLkup[$WHEN]='when';            
   $TokenLkup[$PRINT]='print';
   $TokenLkup[$NEW]='new';  
   $TokenLkup[$SEND]='send';
   $TokenLkup[$IN]='in';
}

sub Symtab
{
# This is NOT a class routine. The parser calls it directly
  my ($type, $sym) = @_;

  $symtab{$sym} = $type;
}

sub LkupSym
{
# This IS a class routine. Return type of symbol, or nul if none
  my ($class,$sym) = @_;

  if ($sym =~ /^\d+$/) {return 'const'}
  if (exists($symtab{$sym})) {return $symtab{$sym}}
  else {return ''}
}

sub Parse
{
    my ($class, $file) = @_;

    Yacc->Init;
    if (!open(IN, $file)) {
    print "Can't open file $file\n";
    exit(1);
    }
    if (yyparse() == 0) {return $final}
    else {return ''}
}
1;
#line 1627 "y.tab.pl"
