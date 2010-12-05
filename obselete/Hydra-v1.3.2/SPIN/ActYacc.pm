$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "actgram.y"
;# Make Yacc.pm like this: byacc -Pv actgram.y; mv y.tab.pl ActYacc.pm
;#
package ActYacc;
#line 8 "y.tab.pl"
$ID=257;
$NUM=258;
$SEND=259;
$ASSGNOP=260;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    1,    1,    2,    2,    3,    3,    3,    4,    4,
    4,    5,    5,    5,    5,    5,
);
@yylen = (                                                2,
    1,    1,    3,    3,    4,    1,    3,    3,    1,    3,
    3,    1,    1,    2,    2,    3,
);
@yydefred = (                                             0,
    0,    0,    0,    0,    2,    0,    0,    0,   12,   13,
    0,    0,    0,    0,    9,    0,    3,    0,   15,   14,
    0,    0,    0,    0,    5,   16,    0,    0,   10,   11,
);
@yydgoto = (                                              3,
    4,    5,   13,   14,   15,
);
@yysindex = (                                          -246,
 -241,  -18,    0,  -36,    0,  -40, -233, -246,    0,    0,
  -40, -242,  -31,  -38,    0,  -16,    0,  -35,    0,    0,
  -40,  -40,  -40,  -40,    0,    0,  -38,  -38,    0,    0,
);
@yyrindex = (                                             0,
    0,    0,    0,   26,    0,    0,    0,    0,    0,    0,
    0,    0,    3,    1,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    2,    7,    0,    0,
);
@yygindex = (                                             0,
    0,   19,   17,   -4,   -3,
);
$YYTABLESIZE=218;
@yytable = (                                             11,
    6,    7,    4,   23,   12,   26,    8,   21,   24,   22,
    1,   21,    2,   22,   19,   20,   27,   28,    6,   29,
   30,    7,    8,   16,   25,    1,   17,   18,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    6,    7,    6,    7,    6,    7,    8,    0,    8,
    0,    8,    0,    0,    0,    0,    0,    0,    0,    6,
    7,    4,    0,    0,    0,    8,    0,    0,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    9,   10,
);
@yycheck = (                                             40,
    0,    0,    0,   42,   45,   41,    0,   43,   47,   45,
  257,   43,  259,   45,  257,  258,   21,   22,  260,   23,
   24,   40,   59,  257,   41,    0,    8,   11,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   41,   41,   43,   43,   45,   45,   41,   -1,   43,
   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   59,
   59,   59,   -1,   -1,   -1,   59,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,
);
$YYFINAL=3;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=260;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'","'*'","'+'",'',"'-'",'',"'/'",'','','','','','','','','','','',"';'",
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"ID",
"NUM","SEND","ASSGNOP",
);
@yyrule = (
"\$accept : action",
"action : actionseq",
"actionseq : rstmt",
"actionseq : actionseq ';' rstmt",
"rstmt : ID ASSGNOP stmtpm",
"rstmt : SEND '(' ID ')'",
"stmtpm : stmtdm",
"stmtpm : stmtpm '+' stmtdm",
"stmtpm : stmtpm '-' stmtdm",
"stmtdm : term",
"stmtdm : stmtdm '*' term",
"stmtdm : stmtdm '/' term",
"term : ID",
"term : NUM",
"term : '-' NUM",
"term : '-' ID",
"term : '(' stmtpm ')'",
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
#line 9 "actgram.y"
{$final = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 2) {
#line 11 "actgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 3) {
#line 12 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '; ' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 4) {
#line 14 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '=' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 5) {
#line 15 "actgram.y"
{$yyval = 'run event(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 7) {
#line 18 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '+' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 8) {
#line 19 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '-' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 10) {
#line 22 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '*' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 11) {
#line 23 "actgram.y"
{$yyval = $yyvs[$yyvsp-2] . '/' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 12) {
#line 25 "actgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 13) {
#line 26 "actgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 14) {
#line 27 "actgram.y"
{$yyval = '-' . $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 15) {
#line 28 "actgram.y"
{$yyval = '-' . $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 16) {
#line 29 "actgram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
#line 322 "y.tab.pl"
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
#line 32 "actgram.y"

sub yylex 
{
    my $a = yylexa();
    my $what = $a == $IN ? IN :
      $a == $NUM ? NUM :
      $a == $OR ? OR :
      $a == $AND ? AND :
      $a == $NOT ? NOT :
      $a == $ASSGNOP ? ASSGNOP :
      $a == $ID ? ID : $a;
    print "lex returning $what, yylval=$yylval, buf=[$buf]\n";
    return $a;
}

sub yylexa
{

    use English;
    if (!$buf) {return 0;}
    my $ret = $buf =~ /^ *(Send)/ ? $SEND:
    $buf =~ /^ *([A-z][A-z0-9]*)/ ? $ID :
    $buf =~ /^ *([0-9]+)/ ? $NUM:
    $buf =~ /^ *(:=)/ ? $ASSGNOP:
    $buf =~ /^ *(.)/ ? 0 : -1;
    $buf = $POSTMATCH;
    $yylval = $1;
    if ($ret == 0) {$ret = unpack('c1', $yylval)}
    elsif ($ret == -1) {die "failed to match in yylex";}
    return $ret;
}

sub yyerror
{
    $final = '';
    print "Syntax error. Rest of string $buf\n";
}

sub Parse
{
    my $class = shift;
    $buf = shift;
    if (yyparse() == 0) {return $final}
    else {return ''}
}
1;
#line 415 "y.tab.pl"
