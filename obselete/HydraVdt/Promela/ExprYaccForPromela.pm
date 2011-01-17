$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "expressiongram.y"
;#Make ExprYaccForPromela.pm like this: byacc -Pv expressiongram.y; mv y.tab.pl ExprYaccForPromela.pm
;#EXPRGRAMDEBUG

package ExprYaccForPromela;
use ExprYaccForPromelaPak;

#line 11 "y.tab.pl"
$ID=257;
$AND=258;
$OR=259;
$NOT=260;
$IN=261;
$NUM=262;
$COMPARE_OP=263;
$ASSGNOP=264;
$WHEN=265;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    0,    0,    0,    1,    5,    5,    5,    6,    6,
    6,    7,    7,    7,    7,    7,    7,    8,    8,    3,
    3,    9,    9,    9,    2,   11,   11,   12,   12,   13,
   13,   13,   13,   10,   10,   14,   14,    4,
);
@yylen = (                                                2,
    1,    1,    1,    1,    3,    1,    3,    3,    1,    3,
    3,    1,    1,    2,    2,    3,    1,    4,    4,    1,
    3,    1,    1,    1,    3,    1,    3,    1,    3,    1,
    1,    2,    3,    3,    1,    1,    1,    4,
);
@yydefred = (                                             0,
    0,    0,    0,    0,    0,    0,    1,    2,    0,    4,
   35,   20,   24,    0,    0,    0,    0,    0,    0,    0,
   37,    0,   30,    0,    0,   28,    0,    0,    0,   13,
    0,    0,    0,    0,    9,   17,    0,    0,    0,    0,
   32,    0,    0,   25,    0,   21,   36,   34,   15,   14,
    0,    0,    0,    0,    0,   18,   19,   38,   33,    0,
   29,   16,    0,    0,   10,   11,
);
@yydgoto = (                                              6,
    7,    8,    9,   10,   33,   34,   35,   11,   12,   23,
   24,   25,   26,   14,
);
@yysindex = (                                           -87,
  -40,  -30,    0,    4,  -35,    0,    0,    0,   -7,    0,
    0,    0,    0, -215,  -29, -233, -198,  -35,   27, -194,
    0,  -35,    0,  -86, -189,    0, -233, -248,   27,    0,
 -245,  -29,    9,  -17,    0,    0,   27,   -3,   32,  -21,
    0,  -20,  -35,    0,  -35,    0,    0,    0,    0,    0,
   -9,  -29,  -29,  -29,  -29,    0,    0,    0,    0, -189,
    0,    0,  -17,  -17,    0,    0,
);
@yyrindex = (                                             0,
    3,    0,    1,    0,    0,    0,    0,    0,   75,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  -28,    0,
    0,    0,    0,    0,  -23,    0,    0,    0,    8,    0,
    0,    0,   81,   15,    0,    0,    2,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  -22,
    0,    0,   23,   31,    0,    0,
);
@yygindex = (                                             0,
    0,    0,   66,    0,   51,  -26,    7,   25,   57,    6,
   17,   42,   41,   59,
);
$YYTABLESIZE=266;
@yytable = (                                             16,
   23,   22,   22,    5,   22,   13,   44,   12,   47,   17,
   32,   49,   31,   21,    6,   31,   50,   26,   27,   58,
   59,   13,    7,   37,   54,   63,   64,    2,    3,   55,
    8,   62,   13,   52,   40,   53,   27,   56,   42,   36,
   27,   23,   22,   18,   23,   22,   22,   28,   12,   12,
   12,   52,   12,   53,   12,    6,   36,    6,   39,    6,
   65,   66,   41,    7,   31,    7,   16,    7,   45,   26,
   27,    8,   57,    8,    3,    8,   36,   36,   36,   36,
    5,   38,   51,   46,   60,   61,   48,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,
    0,    0,   43,    2,    3,    0,    0,    4,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   19,    0,   15,   20,    2,   21,   29,    0,   31,
   31,    2,   30,    0,   36,   26,   27,   43,   43,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   37,   36,   36,
);
@yycheck = (                                             40,
    0,    0,    0,   91,   40,    0,   93,    0,  257,   40,
   40,  257,   41,  262,    0,   45,  262,   41,   41,   41,
   41,   16,    0,  257,   42,   52,   53,  261,  262,   47,
    0,   41,   27,   43,   18,   45,   44,   41,   22,   15,
   44,   41,   41,   40,   44,   44,   44,  263,   41,   42,
   43,   43,   45,   45,   47,   41,   32,   43,  257,   45,
   54,   55,  257,   41,   93,   43,   40,   45,  258,   93,
   93,   41,   41,   43,    0,   45,   52,   53,   54,   55,
    0,   16,   32,   27,   43,   45,   28,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,
   -1,   -1,  259,  261,  262,   -1,   -1,  265,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  257,   -1,  264,  260,  261,  262,  257,   -1,  258,
  259,  261,  262,   -1,  263,  259,  259,  259,  259,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  263,  263,  263,
);
$YYFINAL=6;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=265;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'","'*'","'+'","','","'-'",'',"'/'",'','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"'['",'',"']'",'','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'',"ID","AND","OR","NOT","IN","NUM","COMPARE_OP","ASSGNOP","WHEN",
);
@yyrule = (
"\$accept : stmt",
"stmt : assignment",
"stmt : guard",
"stmt : parmlist",
"stmt : whenclause",
"assignment : ID ASSGNOP stmtpm",
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
"function : ID '(' parmlist ')'",
"function : IN '(' ID ')'",
"parmlist : parm",
"parmlist : parmlist ',' parm",
"parm : ID",
"parm : NUM",
"parm : pred",
"guard : '[' guardbody ']'",
"guardbody : expra",
"guardbody : guardbody OR expra",
"expra : gdterm",
"expra : expra AND gdterm",
"gdterm : pred",
"gdterm : ID",
"gdterm : NOT ID",
"gdterm : '(' guardbody ')'",
"pred : numid COMPARE_OP numid",
"pred : function",
"numid : ID",
"numid : NUM",
"whenclause : WHEN '(' guardbody ')'",
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
#line 13 "expressiongram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 2) {
#line 14 "expressiongram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 3) {
#line 15 "expressiongram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 4) {
#line 16 "expressiongram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 5) {
#line 18 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->Assignment($yyvs[$yyvsp-2],$yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 7) {
#line 21 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-2] . '+' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 8) {
#line 22 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-2] . '-' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 9) {
#line 24 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 10) {
#line 25 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-2] . '*' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 11) {
#line 26 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-2] . '/' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 12) {
#line 28 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 13) {
#line 29 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 14) {
#line 30 "expressiongram.y"
{$yyval = '-' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 15) {
#line 31 "expressiongram.y"
{$yyval = '-' . ExprYaccForPromelaPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 16) {
#line 32 "expressiongram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 17) {
#line 33 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 18) {
#line 35 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-3] . $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 19) {
#line 36 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->INPredicate($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 20) {
#line 38 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 21) {
#line 39 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 22) {
#line 41 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 23) {
#line 42 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 24) {
#line 43 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 25) {
#line 45 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 26) {
#line 46 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 27) {
#line 47 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->Logic('or', $yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 28) {
#line 49 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 29) {
#line 50 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->Logic('and', $yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 30) {
#line 52 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 31) {
#line 53 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 32) {
#line 54 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->Logic('not', $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 33) {
#line 55 "expressiongram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 34) {
#line 57 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->Compare($yyvs[$yyvsp-2], $yyvs[$yyvsp-1], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 35) {
#line 58 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 36) {
#line 60 "expressiongram.y"
{$yyval = ExprYaccForPromelaPak->InstVar($yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 37) {
#line 61 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 38) {
#line 64 "expressiongram.y"
{$yyval = $yyvs[$yyvsp-1];
last switch;
} }
#line 495 "y.tab.pl"
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
#line 67 "expressiongram.y"

sub yylex 
{
    my $a = yylexa();
    my $what = $a == $IN ? IN :
      $a == 0 ? EOF :
      $a == $NUM ? NUM :
      $a == $OR ? OR :
      $a == $IN ? IN :
      $a == $WHEN ? WHEN :
      $a == $ASSGNOP ? ASSGNOP :
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
    $buf =~ /^ *(when)/i ? $WHEN  :
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

sub Parse
{
    my $class = shift;
    $buf = shift;
    $DEBUG = $ENV{'EXPRGRAMDEBUG'} ? 1 : 0;
    $bufcopy = $buf;
    $buf =~ s/([\(\)&\~|])/ $1 /g;
    $buf =~ s/\A *(.+?) *\Z/$1/;     # Trim blanks from both ends
    print "buffer before parse:<$buf>\n" if $DEBUG;
    if (yyparse() == 0) {return $final}
    else {return ''}
}

1;
#line 609 "y.tab.pl"
