$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "trangram.y"
;# Make Yacc.pm like this: byacc -Pv trangram.y; mv y.tab.pl TranYacc.pm
;#
package TranYacc;
#line 8 "y.tab.pl"
$OR=257;
$AND=258;
$NOT=259;
$COMPARE_OP=260;
$ID=261;
$IN=262;
$NUM=263;
$ASSGNOP=264;
$SEND=265;
$WHEN=266;
$PRINT=267;
$QSTR=268;
$SQSTR=269;
$NULL=270;
$NEW=271;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    1,    1,    1,    1,    3,
    3,    6,    6,    6,    6,    6,    8,    8,    7,   12,
   12,   12,   13,   13,   13,   14,   14,   14,   14,   14,
   14,    2,    2,    5,    5,   15,   15,   16,   16,   16,
   17,   17,   10,   11,   11,   19,   19,   19,   18,   18,
    4,    4,    9,    9,    9,
);
@yylen = (                                                2,
    6,    1,    2,    3,    3,    4,    4,    5,    1,    3,
    5,    3,    2,    4,    2,    1,    4,    4,    4,    1,
    3,    1,    1,    4,    4,    1,    4,    6,    3,    1,
    3,    3,    1,    3,    3,    1,    1,    2,    2,    3,
    1,    3,    3,    1,    3,    1,    3,    1,    2,    3,
    3,    4,    4,    1,    3,    1,    1,    1,    1,    1,
    1,    3,    3,    1,    6,
);
@yydefred = (                                             0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   20,   22,   23,   26,    0,
    0,   61,    0,    0,    0,   37,    0,    0,    0,   41,
    0,    0,   33,    0,   46,   48,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   49,   43,    0,    0,    0,    0,   39,
   38,    0,   42,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   17,   19,   18,    0,    0,
    0,    0,    0,   58,   54,    0,    0,    0,    0,   21,
    0,   62,    0,   50,   40,    0,   59,   60,   51,    0,
    0,   35,   34,   47,    0,    0,    0,    0,    0,   53,
    0,   25,   27,    0,   24,    0,   52,    0,    0,    0,
   55,    0,    0,    0,   28,   65,
);
@yydgoto = (                                              6,
    7,    8,   15,   21,   29,   16,   17,   18,   22,   30,
   83,   31,   32,   33,   34,   35,   36,   99,   85,
);
@yysindex = (                                            -6,
  -21,  -18, -129, -185,  -34,    0,   26,   35, -174,  -28,
  -40,   84,   88,   95,   27,    0,    0,    0,    0,   94,
   45,    0, -111,  -16,  115,    0,  -22, -116,  -85,    0,
   19,   59,    0,  -99,    0,    0, -129, -185,   36, -129,
 -185,  121,   72,  -39,  -25,  -19, -185, -106,  -97, -185,
 -129,  -96, -185,    0,    0,  -95,  127,   24,  -38,    0,
    0,  -22,    0, -110,  -25,  -25,  -25,  -25,  -22,   32,
   45, -129, -185,   33,   45,    0,    0,    0,  -25,  111,
  127,    0,   74,    0,    0,  128,  100,  129,   45,    0,
  131,    0,  132,    0,    0,  -99,    0,    0,    0,   59,
   59,    0,    0,    0, -185,   37,   45, -185,   64,    0,
  -19,    0,    0,  -19,    0, -110,    0,   45, -185,   45,
    0,  105,  133,   45,    0,    0,
);
@yyrindex = (                                             0,
   25,    0,    0,    0,    0,    0,  168,  175,    0,    0,
    0,    0,    0,    0,  176,    0,    0,    0,    0,   39,
  177,    0,    0,   14,    0,    0,    0,    0,    0,    0,
    0,    4,    0,  -27,    0,    0,    0,    0,  178,    0,
    0,    0,   14,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  179,
  180,    0,    0,  181,  182,    0,    0,    0,    0,   16,
  -14,   -7,    0,    0,    0,    0,    0,    0,  183,    0,
   58,    0,    0,    0,    0,   -9,    0,    0,    0,    9,
   10,    0,    0,    0,    0,  184,  185,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,  186,    0,  187,
    0,    0,    0,  188,    0,    0,
);
@yygindex = (                                             0,
    0,  189,   53,   29,   87,  138,    0,    0,   47,   71,
   76,   44,   92,   93,  130,  122,  -33,   77,   83,
);
$YYTABLESIZE=281;
@yytable = (                                             46,
   36,   78,   95,   30,   65,   27,   66,   63,   31,   32,
   28,   27,   84,   44,   79,   29,   28,   27,    9,   28,
   79,   10,   28,   46,   16,   28,   56,   36,   36,   56,
   36,   45,   36,   57,   37,   37,   57,   37,   64,   37,
    3,   36,   36,   36,   30,   36,   30,   36,   30,   31,
   32,   31,   32,   31,   32,   36,   36,   63,   36,   36,
   36,   65,   30,   66,   94,   44,   71,   31,   32,   75,
   59,   16,   37,   19,   29,   20,   55,   84,   89,   64,
   84,   40,   72,   45,    5,   51,   42,    4,   80,   70,
   51,   51,   74,   86,   36,   51,   44,   30,   63,   92,
   68,  107,   31,   32,   95,   67,   65,   19,   66,   29,
   19,   46,   77,   58,  110,   16,    5,  111,   16,   38,
   50,   19,  109,   47,  106,  105,  108,   48,   41,   73,
  119,   11,   64,  118,   49,   12,  120,   13,   53,   52,
  113,   14,   19,  114,   60,  125,   61,  124,  111,   54,
   97,   63,   98,   65,   56,   66,  100,  101,   69,  102,
  103,   76,   87,   88,   91,   93,   46,    2,  112,  115,
  116,   62,  117,  126,    9,   13,   15,    3,    4,    5,
   10,   12,   14,    6,    7,    8,   11,    1,   90,  122,
  104,   96,  123,  121,    0,   39,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   62,    0,    0,
    0,   64,    0,   45,   23,    0,   24,   25,   26,   44,
   23,    0,   43,   25,   26,   57,   23,   26,   57,   25,
   26,   81,   25,   82,    0,   36,    0,   45,    0,    0,
    0,    0,   37,    0,    1,    0,    0,    0,    0,    2,
   36,    0,    0,   30,    0,    0,    0,    0,   31,   32,
    0,    0,    0,   36,    0,    0,    0,    0,   64,    0,
   62,
);
@yycheck = (                                             40,
    0,   41,   41,    0,   43,   40,   45,   93,    0,    0,
   45,   40,   46,   41,   40,    0,   45,   40,   40,   45,
   40,   40,   45,   40,    0,   45,   41,   42,   43,   44,
   45,   41,   47,   41,   42,   43,   44,   45,    0,   47,
   47,   41,   42,   43,   41,   45,   43,   47,   45,   41,
   41,   43,   43,   45,   45,   42,   43,    0,   45,   59,
   47,   43,   59,   45,   41,   93,   38,   59,   59,   41,
   27,   47,   47,    3,   59,  261,   93,  111,   50,   41,
  114,   47,   47,   93,   91,   59,  261,   94,   45,   37,
   59,   59,   40,   47,   94,   59,   10,   94,   41,   53,
   42,   73,   94,   94,   41,   47,   43,   37,   45,   94,
   40,   40,   41,   27,   41,   91,   91,   44,   94,   94,
   94,   51,   79,   40,   72,   94,   94,   40,   94,   94,
   94,  261,   94,  105,   40,  265,  108,  267,   94,   46,
   41,  271,   72,   44,  261,   41,  263,  119,   44,  261,
  261,   94,  263,   43,   40,   45,   65,   66,  258,   67,
   68,   41,  269,  261,  261,  261,   40,    0,   41,   41,
   40,  257,   41,   41,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   51,  114,
   69,   62,  116,  111,   -1,    7,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,   -1,
   -1,  260,   -1,  264,  259,   -1,  261,  262,  263,  257,
  259,   -1,  261,  262,  263,  261,  259,  263,  261,  262,
  263,  261,  262,  263,   -1,  260,   -1,  257,   -1,   -1,
   -1,   -1,  260,   -1,  261,   -1,   -1,   -1,   -1,  266,
  260,   -1,   -1,  260,   -1,   -1,   -1,   -1,  260,  260,
   -1,   -1,   -1,  260,   -1,   -1,   -1,   -1,  260,   -1,
  257,
);
$YYFINAL=6;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=271;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'","'*'","'+'","','","'-'","'.'","'/'",'','','','','','','','','','',
'',"';'",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"'['",'',
"']'","'^'",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','',"OR","AND","NOT","COMPARE_OP","ID","IN","NUM","ASSGNOP","SEND",
"WHEN","PRINT","QSTR","SQSTR","NULL","NEW",
);
@yyrule = (
"\$accept : transition",
"transition : event guard '/' actions '^' msgs",
"transition : event",
"transition : event guard",
"transition : event '/' actions",
"transition : event '^' msgs",
"transition : event guard '/' actions",
"transition : event guard '^' msgs",
"transition : event '/' actions '^' msgs",
"transition : guard",
"transition : guard '/' actions",
"transition : guard '/' actions '^' msgs",
"transition : guard '^' msgs",
"transition : '/' actions",
"transition : '/' actions '^' msgs",
"transition : '^' msgs",
"event : ID",
"event : ID '(' ID ')'",
"event : WHEN '(' complexguard ')'",
"event : WHEN '(' ID ')'",
"actions : action",
"actions : actions ';' action",
"action : rstmt",
"action : printstmt",
"action : NEW '(' ID ')'",
"action : SEND '(' msg ')'",
"action : function",
"printstmt : PRINT '(' SQSTR ')'",
"printstmt : PRINT '(' SQSTR ',' parmlist ')'",
"rstmt : ID ASSGNOP stmtpm",
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
"actterm : function",
"guard : '[' complexguard ']'",
"guard : '[' ID ']'",
"complexguard : expra",
"complexguard : complexguard OR expra",
"expra : gdterm",
"expra : expra AND gdterm",
"gdterm : pred",
"gdterm : NOT ID",
"gdterm : '(' complexguard ')'",
"pred : stmtpm COMPARE_OP numid",
"pred : IN '(' ID ')'",
"function : ID '(' parmlist ')'",
"parmlist : parm",
"parmlist : parmlist ',' parm",
"parm : ID",
"parm : NUM",
"parm : pred",
"numid : ID",
"numid : NUM",
"msgs : msg",
"msgs : msgs '^' msg",
"msg : ID '.' ID",
"msg : ID",
"msg : ID '.' ID '(' numid ')'",
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
if ($yyn == 1) {
#line 13 "trangram.y"
{$final = $yyvs[$yyvsp-5] . '#G#' . $yyvs[$yyvsp-4] . '#A#' . $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0] ;
last switch;
} }
if ($yyn == 2) {
#line 14 "trangram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 3) {
#line 15 "trangram.y"
{$final = $yyvs[$yyvsp-1] . '#G#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 4) {
#line 16 "trangram.y"
{$final = $yyvs[$yyvsp-2] . '#A#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 5) {
#line 17 "trangram.y"
{$final = $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 6) {
#line 18 "trangram.y"
{$final = $yyvs[$yyvsp-3] . '#G# ' . $yyvs[$yyvsp-2] . '#A# ' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 7) {
#line 19 "trangram.y"
{$final = $yyvs[$yyvsp-3] . '#G#' . $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 8) {
#line 20 "trangram.y"
{$final = $yyvs[$yyvsp-4] . '#A# ' . $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 9) {
#line 21 "trangram.y"
{$final = 'G# ' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 10) {
#line 22 "trangram.y"
{$final = 'G# ' . $yyvs[$yyvsp-2] . '#A#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 11) {
#line 23 "trangram.y"
{$final = 'G# ' . $yyvs[$yyvsp-4] . '#A# ' . $yyvs[$yyvsp-2] . '#M# ' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 12) {
#line 24 "trangram.y"
{$final = 'G#' . $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 13) {
#line 25 "trangram.y"
{$final = 'A#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 14) {
#line 26 "trangram.y"
{$final = 'A# ' . $yyvs[$yyvsp-2] . '#M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 15) {
#line 27 "trangram.y"
{$final = 'M#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 16) {
#line 29 "trangram.y"
{$yyval = 'E#' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 17) {
#line 31 "trangram.y"
{$yyval = 'E#' . $yyvs[$yyvsp-3] . '#V#' . TranYaccPak->InstVar($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 18) {
#line 32 "trangram.y"
{$yyval = 'E#' . '**when' . $yyvs[$yyvsp-1] ;
last switch;
} }
if ($yyn == 19) {
#line 33 "trangram.y"
{$yyval = 'E#' . '**when' . $yyvs[$yyvsp-1] ;
last switch;
} }
if ($yyn == 20) {
#line 35 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 21) {
#line 36 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 22) {
#line 38 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 23) {
#line 39 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 24) {
#line 40 "trangram.y"
{$yyval = TranYaccPak->New($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 25) {
#line 41 "trangram.y"
{$yyval = $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 26) {
#line 42 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 27) {
#line 44 "trangram.y"
{$yyval = 'printf('. Sq($yyvs[$yyvsp-1]) . ');';
last switch;
} }
if ($yyn == 28) {
#line 45 "trangram.y"
{$yyval = 'printf(' . Sq($yyvs[$yyvsp-3]) . ',' . $yyvs[$yyvsp-1] . ');';
last switch;
} }
if ($yyn == 29) {
#line 47 "trangram.y"
{$yyval = TranYaccPak->Assign($yyvs[$yyvsp-2], $yyvs[$yyvsp-0]); CheckVar($yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 31) {
#line 50 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . '+' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 32) {
#line 51 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . '-' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 33) {
#line 53 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 34) {
#line 54 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . '*' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 35) {
#line 55 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . '/' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 36) {
#line 57 "trangram.y"
{$yyval = TranYaccPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 37) {
#line 58 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 38) {
#line 59 "trangram.y"
{$yyval = '-' . $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 39) {
#line 60 "trangram.y"
{$yyval = '-' . TranYaccPak->InstVar($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 40) {
#line 61 "trangram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 41) {
#line 62 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 42) {
#line 65 "trangram.y"
{$yyval = $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 43) {
#line 66 "trangram.y"
{$yyval = TranYaccPak->InstVar($yyvs[$yyvsp-2]);
last switch;
} }
if ($yyn == 44) {
#line 68 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 45) {
#line 69 "trangram.y"
{$yyval = TranYaccPak->Logic('or', $yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 46) {
#line 71 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 47) {
#line 72 "trangram.y"
{$yyval =  TranYaccPak->Logic('and', $yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 48) {
#line 74 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 49) {
#line 75 "trangram.y"
{$yyval = TranYaccPak->Logic('not', $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 50) {
#line 76 "trangram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 51) {
#line 79 "trangram.y"
{$yyval =  TranYaccPak->Compare($yyvs[$yyvsp-2], $yyvs[$yyvsp-1], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 52) {
#line 80 "trangram.y"
{$yyval = TranYaccPak->INPredicate($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 53) {
#line 82 "trangram.y"
{$yyval = $yyvs[$yyvsp-3] . $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 54) {
#line 84 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 55) {
#line 85 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 56) {
#line 87 "trangram.y"
{$yyval = TranYaccPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 57) {
#line 88 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 58) {
#line 89 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 59) {
#line 91 "trangram.y"
{$yyval = TranYaccPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 60) {
#line 92 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 61) {
#line 95 "trangram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 62) {
#line 96 "trangram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 63) {
#line 99 "trangram.y"
{$yyval = TranYaccPak->ClassSend($yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 64) {
#line 100 "trangram.y"
{$yyval = TranYaccPak->StateSend($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 65) {
#line 103 "trangram.y"
{$yyval = TranYaccPak->ClassSend($yyvs[$yyvsp-5], $yyvs[$yyvsp-3], $yyvs[$yyvsp-1]);
last switch;
} }
#line 689 "y.tab.pl"
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
#line 112 "trangram.y"


sub Sq
{
# Convert single quotes to double quotes
  my ($arg) = @_;

  $arg =~ s/'/"/g;
  return $arg;
}


sub yylex 
{
    my $a = yylexa();
    my $what = $a == $IN ? IN :
      $a == 0 ? EOF :
      $a == $QSTR ? QSTR :
      $a == $SQSTR ? SQSTR :
      $a == $PRINT ? PRINT :
      $a == $NUM ? NUM :
      $a == $OR ? OR :
      $a == $IN ? IN :
      $a == $ASSGNOP ? ASSGNOP :
      $a == $SEND ? SEND :
      $a == $WHEN ? WHEN :
      $a == $AND ? AND :
      $a == $NOT ? NOT :
      $a == $COMPARE_OP ? COMPARE_OP :
      $a == $ID ? ID : $a;
    print "lex returning $what, yylval=$yylval, buf=[$buf]\n" if $DEBUG;
    return $a;
}

sub yylexa
{

    use English;
    if ($buf eq '') {return 0;}
    my $ret = $buf =~ /^ *(IN )/i ? $IN :
    $buf =~ /^ *(\"[^\"]+\")/ ? $QSTR :
    $buf =~ /^ *(\'[^\']+\')/ ? $SQSTR :
    $buf =~ /^ *(print )/i ? $PRINT :
    $buf =~ /^ *(send )/i ? $SEND :
    $buf =~ /^ *(when )/i ? $WHEN :
    $buf =~ /^ *(new )/i ? $NEW :
    $buf =~ /^ *(is )/i ? $COMPARE_OP : # this is for type enum, e.g. 'mode is heat'
    $buf =~ /^ *([A-Za-z\_][A-Za-z0-9\_]*)/ ? $ID :
    $buf =~ /^ *([0-9]+)/ ? $NUM:
    $buf =~ /^ *(\|)/ ? $OR  :
    $buf =~ /^ *(\~)/ ? $NOT :
    $buf =~ /^ *(\&)/ ? $AND  :
    $buf =~ /^ *(:=)/ ? $ASSGNOP:
    $buf =~ /^ *(=|!=|>=|<=|>|<)/ ? $COMPARE_OP :
    $buf =~ /^ *(.)/ ? -3 : -4;
    $buf = $POSTMATCH;
    $lasttoken = $1;
    $yylval = $1;
    if ($ret == -3) {$ret = unpack('c1', $yylval)}
    elsif ($ret == -4) {die "failed to match in yylex";}
    return $ret;
}

sub yyerror
{
    $final = '';
}

sub LastToken
{
  return $lasttoken;
}

sub CheckVar
{
    my ($var) = @_;

    if (Yacc->LkupSym($var)) {return}
    
    print "**** Error: variable $var undefined in transition $bufcopy\n";
}

sub Parse
{
    my $class = shift;
    $buf = shift;
    $DEBUG = $ENV{'TRANGRAMDEBUG'} ? 1 : 0;
    $bufcopy = $buf;
    $buf =~ s/([\(\)&\~|])/ $1 /g;
    $buf =~ s/\A *(.+?) *\Z/$1/;     # Trim blanks from both ends
#    $buf =~ s/(=|!=|>=|<=|>|<|\)|\(|:=|\&|\~|\||)/ $1 /g;
    print "buffer before parse:<$buf>\n" if $DEBUG;
    if (yyparse() == 0) {return $final}
    else {return ''}
}
1;
#line 832 "y.tab.pl"
