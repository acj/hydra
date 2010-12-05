$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "gram.y"
;# Make Yacc.pm like this: byacc -Pv gram.y; mv y.tab.pl Yacc.pm
;# setenv YYDEBUG true to see the parser in action.
;#
package Yacc;
#line 9 "y.tab.pl"
$MODEL=257;
$ID=258;
$NUM=259;
$QSTR=260;
$CLASS=261;
$ASSOC=262;
$TYPE=263;
$CCSTATE=264;
$CSTATE=265;
$TO=266;
$ENUM=267;
$DRIVERFILE=268;
$STATE=269;
$TRANS=270;
$INIT=271;
$FORMAL=272;
$JOIN=273;
$HISTORY=274;
$FROM=275;
$INSTVAR=276;
$SIGNAL=277;
$ACTION=278;
$FORMALIZE=279;
$AS=280;
$PROMELA=281;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    0,    2,    2,    3,    3,    4,    4,    4,    1,
    5,    5,    6,    6,    6,    6,    6,    6,    6,    6,
    7,    7,    7,   15,   15,   16,   16,   16,   18,   18,
    8,    8,   19,   19,   19,   19,   19,   19,   19,   19,
   13,   13,   21,   21,   22,   22,   10,   10,   12,   12,
   11,   20,   20,   17,    9,   14,   14,   14,   25,   25,
   24,   24,   23,   23,
);
@yylen = (                                                2,
    5,    1,    5,    4,    1,    2,    3,    5,    4,    1,
    1,    2,    1,    1,    1,    1,    1,    1,    1,    1,
    3,    5,    6,    1,    2,    1,    1,    1,    1,    2,
    5,    4,    1,    1,    1,    1,    1,    1,    1,    1,
    5,    4,    1,    2,    1,    1,    3,    4,    3,    4,
    7,    5,    4,    3,    5,    4,    7,    6,    1,    3,
    1,    1,    1,    3,
);
@yydefred = (                                             0,
    0,    0,    0,    2,    0,    0,    0,    0,    0,    0,
    0,    5,   10,    0,    0,    0,    0,    4,    6,    0,
    3,    0,    7,    1,    0,    0,    0,    0,    0,    0,
    0,    0,    9,    0,   11,   13,   14,   15,   16,   17,
   18,   19,   20,    0,    0,    0,    0,   63,    0,    0,
    0,    0,    0,    0,    8,   12,    0,    0,    0,   47,
    0,    0,    0,   49,    0,    0,   21,    0,    0,   27,
   26,    0,   24,   28,    0,   32,   35,   38,   34,   36,
   37,   33,   40,    0,   29,   39,   42,   46,   45,    0,
   43,   48,   64,    0,   50,   56,    0,    0,    0,    0,
   55,   25,    0,    0,   31,   30,   41,   44,    0,    0,
    0,   22,   54,    0,    0,    0,    0,   62,    0,    0,
   23,   53,    0,   51,   57,    0,   52,   60,
);
@yydgoto = (                                              3,
   14,    4,   11,   12,   34,   35,   36,   37,   38,   39,
   40,   41,   42,   43,   72,   73,   74,   84,   85,   86,
   90,   91,   49,  119,  120,
);
@yysindex = (                                          -243,
 -117, -250,    0,    0,  -75, -205, -248, -205, -201, -199,
  -90,    0,    0,    3,  -81,  -53,   12,    0,    0, -185,
    0,  -88,    0,    0, -184, -183, -182, -240, -181, -213,
 -180, -179,    0,  -74,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  -38,  -37,  -36,   14,    0,  -41, -195,
   23,  -40, -175,    2,    0,    0, -211, -120, -104,    0,
   25, -172, -169,    0,   31,    7,    0,  -39, -168,    0,
    0, -106,    0,    0, -235,    0,    0,    0,    0,    0,
    0,    0,    0, -109,    0,    0,    0,    0,    0, -103,
    0,    0,    0, -173,    0,    0,   30,   53,   37,  -27,
    0,    0, -161,  -43,    0,    0,    0,    0, -160, -190,
   40,    0,    0,   41, -157,   43,    0,    0,   44,   60,
    0,    0,   46,    0,    0, -152,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  -44,    0,    0,  -30,
    0,    0,    0,    0,    0,    0,    0,    0,
);
@yygindex = (                                             0,
    0,   87,  100,   49,    0,   75,    0,  -46,  -45,  -35,
  -34,  -31,  -29,    0,    0,   38,  -50,    0,   27,  -49,
    0,   22,  -23,    0,    0,
);
$YYTABLESIZE=247;
@yytable = (                                             59,
   62,   99,   62,   62,   76,    6,   52,   83,   88,   89,
   70,   77,   78,    1,   61,  105,   62,   47,  101,   48,
   87,  107,   79,   80,   48,   70,   81,   71,   82,    7,
  103,  113,   13,   83,   18,    2,   33,   77,   78,   88,
   89,   68,   71,   21,   51,  100,   48,    8,   79,   80,
   55,  104,   81,   26,   82,    9,   16,   27,   17,   19,
   67,   20,   10,   19,   97,   96,   69,  117,  118,   22,
   23,    1,   60,   44,   45,   46,   50,   53,   54,   63,
   59,   64,   66,   92,   57,   58,   59,   93,   94,   95,
  110,   48,  109,  111,   58,  112,  114,  116,  121,  122,
  123,  124,  125,  126,  127,  128,   24,   15,   56,  102,
  106,  108,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    5,    0,    0,   25,   26,    0,    0,    0,   27,   75,
   28,    0,   29,   30,   25,   26,    0,   69,   26,   27,
   75,   28,   27,   29,   30,   75,   75,    0,   69,    0,
    9,   69,    0,   69,   69,   25,   26,   10,    0,    9,
   27,    0,   28,    0,   29,   30,   10,   31,   32,   25,
   26,    0,    0,    0,   27,    0,   28,    0,   29,   30,
    0,   31,   32,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   61,   65,   98,   59,
   59,    0,  115,    0,   59,    0,   59,    0,   59,   59,
    0,   59,   59,   58,   58,    0,    0,    0,   58,    0,
   58,    0,   58,   58,    0,   58,   58,
);
@yycheck = (                                             44,
   44,   41,   44,   44,  125,  123,   30,   58,   59,   59,
   57,   58,   58,  257,   59,  125,   44,  258,  125,  260,
  125,  125,   58,   58,  260,   72,   58,   57,   58,  280,
  266,   59,  281,   84,  125,  279,  125,   84,   84,   90,
   90,   40,   72,  125,  258,   69,  260,  123,   84,   84,
  125,   75,   84,  265,   84,  261,  258,  269,  258,   11,
   59,   59,  268,   15,   58,   59,  278,  258,  259,  123,
   59,  257,   59,  258,  258,  258,  258,  258,  258,  275,
  125,   59,  258,   59,  123,  123,  123,  260,  258,   59,
   61,  260,  266,   41,  125,   59,  258,  258,   59,   59,
  258,   59,   59,   44,   59,  258,   20,    8,   34,   72,
   84,   90,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  258,   -1,   -1,  264,  265,   -1,   -1,   -1,  269,  270,
  271,   -1,  273,  274,  264,  265,   -1,  278,  265,  269,
  270,  271,  269,  273,  274,  270,  270,   -1,  278,   -1,
  261,  278,   -1,  278,  278,  264,  265,  268,   -1,  261,
  269,   -1,  271,   -1,  273,  274,  268,  276,  277,  264,
  265,   -1,   -1,   -1,  269,   -1,  271,   -1,  273,  274,
   -1,  276,  277,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  258,  258,  258,  264,
  265,   -1,  266,   -1,  269,   -1,  271,   -1,  273,  274,
   -1,  276,  277,  264,  265,   -1,   -1,   -1,  269,   -1,
  271,   -1,  273,  274,   -1,  276,  277,
);
$YYFINAL=3;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=281;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'",'','',"','",'','','','','','','','','','','','','',"':'","';'",'',"'='",
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','',"'{'",'',"'}'",'','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
"MODEL","ID","NUM","QSTR","CLASS","ASSOC","TYPE","CCSTATE","CSTATE","TO","ENUM",
"DRIVERFILE","STATE","TRANS","INIT","FORMAL","JOIN","HISTORY","FROM","INSTVAR",
"SIGNAL","ACTION","FORMALIZE","AS","PROMELA",
);
@yyrule = (
"\$accept : spec",
"spec : FORMALIZE AS language ';' model",
"spec : model",
"model : MODEL ID '{' modelbody '}'",
"model : MODEL '{' modelbody '}'",
"modelbody : modelstmt",
"modelbody : modelbody modelstmt",
"modelstmt : DRIVERFILE ID ';'",
"modelstmt : CLASS ID '{' classbody '}'",
"modelstmt : CLASS ID '{' '}'",
"language : PROMELA",
"classbody : classstmt",
"classbody : classbody classstmt",
"classstmt : signal",
"classstmt : cstate",
"classstmt : ccstate",
"classstmt : init",
"classstmt : join",
"classstmt : history",
"classstmt : state",
"classstmt : instvar",
"signal : SIGNAL ID ';'",
"signal : SIGNAL ID '(' ')' ';'",
"signal : SIGNAL ID '(' ID ')' ';'",
"ccstatebody : ccstatestmt",
"ccstatebody : ccstatebody ccstatestmt",
"ccstatestmt : state",
"ccstatestmt : cstate",
"ccstatestmt : action",
"cstatebody : cstatestmt",
"cstatebody : cstatebody cstatestmt",
"cstate : CSTATE ID '{' cstatebody '}'",
"cstate : CSTATE ID '{' '}'",
"cstatestmt : state",
"cstatestmt : init",
"cstatestmt : cstate",
"cstatestmt : join",
"cstatestmt : history",
"cstatestmt : ccstate",
"cstatestmt : transition",
"cstatestmt : action",
"state : STATE ID '{' statebody '}'",
"state : STATE ID '{' '}'",
"statebody : statestmt",
"statebody : statebody statestmt",
"statestmt : transition",
"statestmt : action",
"init : INIT ID ';'",
"init : INIT qstrlist ID ';'",
"history : HISTORY ID ';'",
"history : HISTORY qstrlist ID ';'",
"join : JOIN ID FROM ID TO ID ';'",
"transition : TRANS qstrlist TO ID ';'",
"transition : TRANS TO ID ';'",
"action : ACTION qstrlist ';'",
"ccstate : CCSTATE ID '{' ccstatebody '}'",
"instvar : INSTVAR ID ID ';'",
"instvar : INSTVAR ID ID ':' '=' numid ';'",
"instvar : INSTVAR ID ID ':' '=' alist",
"alist : ID",
"alist : alist ',' ID",
"numid : ID",
"numid : NUM",
"qstrlist : QSTR",
"qstrlist : qstrlist ',' QSTR",
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
if ($yyn == 3) {
#line 16 "gram.y"
{$final = Node(model, ID,$yyvs[$yyvsp-3], modelbody,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 4) {
#line 17 "gram.y"
{$final = Node(model, ID,'Model', modelbody,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 5) {
#line 19 "gram.y"
{$yyval = Node(modelbody, modelstmtlist,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 6) {
#line 20 "gram.y"
{$yyval = Add($yyvs[$yyvsp-1], modelstmtlist,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 7) {
#line 23 "gram.y"
{$yyval = Node(Driverfile, ID,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 8) {
#line 24 "gram.y"
{$yyval = Node(Class, ID,$yyvs[$yyvsp-3], classbody,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 9) {
#line 25 "gram.y"
{$yyval = Node(Null);
last switch;
} }
if ($yyn == 11) {
#line 29 "gram.y"
{$yyval = Node(classbody, classstmtlist,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 12) {
#line 30 "gram.y"
{$yyval = Add($yyvs[$yyvsp-1], classstmtlist,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 13) {
#line 32 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 14) {
#line 33 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 15) {
#line 34 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 16) {
#line 35 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 17) {
#line 36 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 18) {
#line 37 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 19) {
#line 38 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 20) {
#line 39 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 21) {
#line 41 "gram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-1]); Symtab('signal', $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 22) {
#line 42 "gram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-3]); Symtab('signal', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 23) {
#line 43 "gram.y"
{$yyval = Node(Signal,name,$yyvs[$yyvsp-4],sigtype,$yyvs[$yyvsp-2]); Symtab('signal', $yyvs[$yyvsp-4]);
last switch;
} }
if ($yyn == 24) {
#line 45 "gram.y"
{$yyval = Node(ccstatebody, ccstatestmtlist,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 25) {
#line 46 "gram.y"
{$yyval = Add($yyvs[$yyvsp-1], ccstatestmtlist,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 26) {
#line 48 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 27) {
#line 49 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 28) {
#line 50 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 29) {
#line 52 "gram.y"
{$yyval = Node(cstatebody, cstatestmtlist,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 30) {
#line 53 "gram.y"
{$yyval = Add($yyvs[$yyvsp-1], cstatestmtlist,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 31) {
#line 55 "gram.y"
{$yyval = Node(CState, ID,$yyvs[$yyvsp-3], body,$yyvs[$yyvsp-1]); Symtab('cstate', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 32) {
#line 56 "gram.y"
{$yyval = Node(CState, ID);
last switch;
} }
if ($yyn == 33) {
#line 58 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 34) {
#line 59 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 35) {
#line 60 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 36) {
#line 61 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 37) {
#line 62 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 38) {
#line 63 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 39) {
#line 64 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 40) {
#line 65 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 41) {
#line 67 "gram.y"
{$yyval = Node(State, ID,$yyvs[$yyvsp-3], statebody,$yyvs[$yyvsp-1]); Symtab('state', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 42) {
#line 68 "gram.y"
{$yyval = Node(State, ID,$yyvs[$yyvsp-2], statebody,''); Symtab('state', $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 43) {
#line 70 "gram.y"
{$yyval = Node(statebody, statestmtlist,[$yyvs[$yyvsp-0]]);
last switch;
} }
if ($yyn == 44) {
#line 71 "gram.y"
{$yyval = Add($yyvs[$yyvsp-1], statestmtlist,$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 45) {
#line 73 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 46) {
#line 74 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 47) {
#line 76 "gram.y"
{$yyval = Node(Init, ID,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 48) {
#line 77 "gram.y"
{$yyval = Node(Init, ID,$yyvs[$yyvsp-1], tran, $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 49) {
#line 79 "gram.y"
{$yyval = Node(History, ID, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 50) {
#line 80 "gram.y"
{$yyval = Node(History, ID, $yyvs[$yyvsp-1], tran, $yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 51) {
#line 82 "gram.y"
{$yyval = Node(Join, ID, $yyvs[$yyvsp-5], from, $yyvs[$yyvsp-3], to, $yyvs[$yyvsp-1]); Symtab('state', $yyvs[$yyvsp-5]);
last switch;
} }
if ($yyn == 52) {
#line 84 "gram.y"
{$yyval = Node(Trans, tran,$yyvs[$yyvsp-3], dest,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 53) {
#line 85 "gram.y"
{$yyval = Node(Trans, tran, '', dest, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 54) {
#line 87 "gram.y"
{$yyval = Node(Action, action, $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 55) {
#line 89 "gram.y"
{$yyval = Node(CCState,ID,$yyvs[$yyvsp-3], body,$yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 56) {
#line 91 "gram.y"
{$yyval = Node(InstVar,vtype,$yyvs[$yyvsp-2],var,$yyvs[$yyvsp-1]); Symtab('var', $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 57) {
#line 92 "gram.y"
{$yyval = Node(InstVar,vtype,$yyvs[$yyvsp-5],var,$yyvs[$yyvsp-4],initval,$yyvs[$yyvsp-1]); Symtab('var', $yyvs[$yyvsp-4]);
last switch;
} }
if ($yyn == 58) {
#line 93 "gram.y"
{$yyval = Node(InstVar,vtype,$yyvs[$yyvsp-4],var,$yyvs[$yyvsp-3],Initlist,$yyvs[$yyvsp-0]); Symtab('var', $yyvs[$yyvsp-3]);
last switch;
} }
if ($yyn == 59) {
#line 95 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 60) {
#line 96 "gram.y"
{$yyval = $yyvs[$yyvsp-2] . ',' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 61) {
#line 98 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 62) {
#line 99 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 63) {
#line 101 "gram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 64) {
#line 102 "gram.y"
{$yyval = substr($yyvs[$yyvsp-2],0,-1) . substr($yyvs[$yyvsp-0],1);
last switch;
} }
#line 679 "y.tab.pl"
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
#line 105 "gram.y"

sub Node
{
    my ($type, @arg) = @_;

    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
    my $node = {};
    $$node{type} = $type;
    while (@arg) {
	my $key = shift(@arg);
	my $val = shift(@arg);
	$$node{$key} = $val;
    }
    $$node{linenum} = $lineno;
    return $node;
}

sub Add
{
    my ($node, $key, $val) = @_;
    
    print "adding $val to $key\n" if $DEBUG;
    push(@{$$node{$key}}, $val);
    return $node;
}

sub yylex 
{
    my $a = yylexa();
    print "lex returning $TokenLkup[$a] yylval=$yylval\n" if $DEBUG;
#    print "buf=\[$buf\]\n" if $DEBUG;
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
	$bufcopy = $buf;
	print "read($lineno):$buf\n" if $DEBUG;
    }

#%token MODEL,ID,NUM,QSTR,CLASS,ASSOC,TYPE,CCSTATE,CSTATE,TO,ENUM
#%token DRIVERFILE,STATE,TRANS,INIT,FORMAL,JOIN,HISTORY,FROM,INSTVAR
#%token SIGNAL
    my $ret = $buf =~ /^ *(Model)/ ? $MODEL :
    $buf =~ /^ *(\"[^\"]*\")/ ? $QSTR :
    $buf =~ /^ *(Class) / ? $CLASS :
    $buf =~ /^ *(Formalize) / ? $FORMALIZE :
    $buf =~ /^ *(as) / ? $AS :
    $buf =~ /^ *(promela) / ? $PROMELA :
    $buf =~ /^ *(Type) / ? $TYPE :
    $buf =~ /^ *(ConcurrentState) / ? $CCSTATE :
    $buf =~ /^ *(CompositeState) / ? $CSTATE :
    $buf =~ /^ *(to) / ? $TO :
    $buf =~ /^ *(Enum) / ? $ENUM :
    $buf =~ /^ *(DriverFile) / ? $DRIVERFILE :
    $buf =~ /^ *(State) / ? $STATE :
    $buf =~ /^ *(Transition) / ? $TRANS :
    $buf =~ /^ *(Action) / ? $ACTION :
    $buf =~ /^ *(Initial) / ? $INIT :
    $buf =~ /^ *(Join) / ? $JOIN :
    $buf =~ /^ *(History) / ? $HISTORY :
    $buf =~ /^ *(from) / ? $FROM :
    $buf =~ /^ *(InstanceVar) / ? $INSTVAR :
    $buf =~ /^ *(Signal) / ? $SIGNAL :
    $buf =~ /^ *([A-Za-z\_][A-Za-z0-9\_]*)/ ? $ID :
    $buf =~ /^ *([0-9]+)/ ? $NUM:
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
  Put Msg(level=>error, class=>$LastClass, state=>$LastState,
	  msg=> "Syntax error near '$lasttoken' in '$bufcopy'");
    exit;
}



sub Init
{
  if ($ENV{GRAMDEBUG}) {$DEBUG = 1}
  else {$DEBUG = 0}
# This is the official token lookup table.
  %TokenTab = ('Model'=>$MODEL, 'Class'=>$CLASS, 'Association'=>$ASSOC,
	       'type'=>$TYPE, 'ConcurrentState'=>$CCSTATE,
	       'CompositeState'=>$CSTATE, 'to'=>$TO, 'from'=>$FROM, 
	       'Enum'=>$ENUM,
	       'DriverFile'=>$DRIVERFILE, 'State'=>$STATE, 
	       'Transition'=>$TRANS, 'Initial'=>$INIT, 'Join'=>$JOIN,
	       'History'=>$HISTORY,
		'FormalLanguage'=>$FORMAL,
		'InstanceVar'=>$INSTVAR,
		'Signal'=>$SIGNAL);

#%token MODEL,ID,QSTR,CLASS,ASSOC,TYPE,CCSTATE,CSTATE,TO,ENUM
#%token DRIVERFILE,STATE,TRANS,INIT,FORMAL
   
# This is only used to print out the token name above.
   $TokenLkup[$MODEL] = 'Model';
   $TokenLkup[$ID] = 'ID';
   $TokenLkup[$QSTR] = 'QSTR';
   $TokenLkup[$CLASS] = 'Class';
   $TokenLkup[$FORMALIZE] = 'Formalize';
   $TokenLkup[$AS] = 'as';
   $TokenLkup[$PROMELA] = 'promela';
   $TokenLkup[$TYPE] = 'Type';
   $TokenLkup[$CCSTATE] = 'CCState';
   $TokenLkup[$COMPOSITE] = 'Composite';
   $TokenLkup[$TO] = 'To';
   $TokenLkup[$ENUM] = 'Enum';
   $TokenLkup[$DRIVERFILE] = 'DriverFile';
   $TokenLkup[$STATE] = 'State';
   $TokenLkup[$TRANS] = 'Transition';
   $TokenLkup[$INIT] = 'Initial';
   $TokenLkup[$FORMAL] = 'Formal';
   $TokenLkup[$INIT] = 'Initial';
   $TokenLkup[$JOIN] = 'Join';
   $TokenLkup[$HISTORY] = 'History';
   $TokenLkup[$FROM] = 'from';
   $TokenLkup[$INSTVAR] = 'InstanceVar';
   
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
#line 917 "y.tab.pl"
