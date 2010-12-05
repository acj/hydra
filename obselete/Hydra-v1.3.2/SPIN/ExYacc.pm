$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "exprgram.y"
;# Make Yacc.pm like this: byacc -Pv exprgram.y; mv y.tab.pl ExYacc.pm
;#
package ExYacc;
#line 8 "y.tab.pl"
$OR=257;
$AND=258;
$NOT=259;
$COMPARE_OP=260;
$ID=261;
$IN=262;
$NUM=263;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    1,    1,    2,    2,    3,    3,    3,    3,    4,
    4,    5,    5,
);
@yylen = (                                                2,
    2,    1,    3,    1,    3,    1,    1,    2,    3,    3,
    6,    1,    1,
);
@yydefred = (                                             0,
    0,    0,    0,   13,    0,    0,    0,    0,    4,    6,
    0,    8,    0,    0,    0,    1,    0,    0,    0,    9,
    0,    5,   12,   10,    0,    0,   11,
);
@yydgoto = (                                              6,
    7,    8,    9,   10,   11,
);
@yysindex = (                                           -40,
 -255,    0,  -29,    0,  -40,    0,  -58, -251,    0,    0,
 -248,    0, -252,  -31,  -40,    0,  -40, -258,  -32,    0,
 -251,    0,    0,    0, -246,  -28,    0,
);
@yyrindex = (                                             0,
    0,  -33,    0,    0,    0,    0,    0,  -39,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  -37,    0,    0,    0,    0,    0,    0,
);
@yygindex = (                                             0,
   11,    2,    1,    0,    3,
);
$YYTABLESIZE=227;
@yytable = (                                              5,
   16,    2,   23,    3,    4,   12,   17,    7,   19,   20,
   13,   18,   27,   25,   26,   14,   21,   22,    0,    2,
   24,    3,    0,    0,    0,    7,    0,    0,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   15,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    2,    1,    3,
    2,    3,    4,    7,    7,   15,   12,
);
@yycheck = (                                             40,
   59,   41,  261,   41,  263,  261,  258,   41,  261,   41,
   40,  260,   41,   46,  261,    5,   15,   17,   -1,   59,
   18,   59,   -1,   -1,   -1,   59,   -1,   -1,   -1,   -1,
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
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  259,  257,
  261,  262,  263,  257,  258,  257,  260,
);
$YYFINAL=6;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=263;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'",'','','','',"'.'",'','','','','','','','','','','','',"';'",'','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"OR","AND","NOT",
"COMPARE_OP","ID","IN","NUM",
);
@yyrule = (
"\$accept : expr",
"expr : exprao ';'",
"exprao : expra",
"exprao : exprao OR expra",
"expra : term",
"expra : expra AND term",
"term : pred",
"term : ID",
"term : NOT ID",
"term : '(' exprao ')'",
"pred : numid COMPARE_OP numid",
"pred : IN '(' ID '.' ID ')'",
"numid : ID",
"numid : NUM",
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
#line 9 "exprgram.y"
{$final = $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 3) {
#line 12 "exprgram.y"
{$yyval = $yyvs[$yyvsp-2] . ' || ' . $yyvs[$yyvsp-0]  ;
last switch;
} }
if ($yyn == 5) {
#line 15 "exprgram.y"
{$yyval =  $yyvs[$yyvsp-2] . ' && ' . $yyvs[$yyvsp-0] ;
last switch;
} }
if ($yyn == 7) {
#line 18 "exprgram.y"
{$yyval =  $yyvs[$yyvsp-0] ;
last switch;
} }
if ($yyn == 8) {
#line 19 "exprgram.y"
{$yyval = '!' . $yyvs[$yyvsp-0] ;
last switch;
} }
if ($yyn == 9) {
#line 20 "exprgram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 10) {
#line 22 "exprgram.y"
{$yyval =  Compare($yyvs[$yyvsp-2], $yyvs[$yyvsp-1], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 11) {
#line 23 "exprgram.y"
{$yyval = '(in_' . $yyvs[$yyvsp-3] . '==st_' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 12) {
#line 25 "exprgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 13) {
#line 26 "exprgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
#line 304 "y.tab.pl"
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
#line 29 "exprgram.y"

sub Compare
{
    my ($arg1, $op, $arg2) = @_;

    if ($op eq '=') {return "$arg1==$arg2"}
    else {return "$arg1$op$arg2"}
}

sub yylex 
{
    my $a = yylexa();
    my $what = $a == $IN ? IN :
      $a == $NUM ? NUM :
      $a == $OR ? OR :
      $a == $AND ? AND :
      $a == $NOT ? NOT :
      $a == $COMPARE_OP ? COMPARE_OP :
      $a == $ID ? ID : $a;
    print "lex returning $what, yylval=$yylval, buf=[$buf]\n";
    return $a;
}

sub yylexa
{

    use English;
    if (!$buf) {return 0;}
    my $ret = $buf =~ /^ *(IN)/ ? $IN :
    $buf =~ /^ *([A-z][A-z0-9]*)/ ? $ID :
    $buf =~ /^ *([0-9]+)/ ? $NUM:
    $buf =~ /^ *(\|)/ ? $OR  :
    $buf =~ /^ *(\~)/ ? $NOT :
    $buf =~ /^ *(\&)/ ? $AND  :
    $buf =~ /^ *(!=|>=|<=|>|<|=)/ ? $COMPARE_OP :
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
    $buf .= ' ;';
    if (yyparse() == 0) {return $final}
    else {return ''}
}
1;
#line 409 "y.tab.pl"
