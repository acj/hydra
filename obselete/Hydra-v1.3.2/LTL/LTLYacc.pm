$yysccsid = "@(#)yaccpar 1.8 (Berkeley) 01/20/91 (Perl 2.0 12/31/92)";
#define YYBYACC 1
#line 2 "ltlgram.y"
;# Make LTLYacc.pm like this: byacc -Pv ltlgram.y; mv y.tab.pl LTLYacc.pm
;#
package LTLYacc;
#line 8 "y.tab.pl"
$OR=257;
$AND=258;
$NOT=259;
$IMP=260;
$COMPARE_OP=261;
$ID=262;
$IN=263;
$NUM=264;
$SENT=265;
$UNOP=266;
$EQV=267;
$YYERRCODE=256;
@yylhs = (                                               -1,
    0,    1,    1,    1,    2,    2,    3,    3,    4,    4,
    4,    4,    6,    6,    6,    6,    7,    8,    8,    9,
    9,    9,    5,
);
@yylen = (                                                2,
    2,    1,    3,    3,    1,    3,    1,    3,    1,    1,
    2,    3,    3,    4,    6,    1,    4,    1,    3,    1,
    1,    1,    3,
);
@yydefred = (                                             0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    7,
    0,   10,   16,    0,    0,    0,    0,   11,    0,    0,
    0,    1,    0,    0,    0,   21,    0,   22,    0,   18,
   23,    0,    0,    0,   12,    0,    0,    0,    8,   13,
   17,    0,   14,    0,   19,    0,   15,
);
@yydgoto = (                                              6,
    7,    8,    9,   10,   11,   12,   13,   29,   30,
);
@yysindex = (                                           -38,
  -35,  -21,  -19,  -38,  -38,    0,  -58, -229, -221,    0,
 -232,    0,    0, -238, -224, -222, -220,    0,  -25,  -38,
  -38,    0,  -38,  -38, -223,    0, -232,    0,  -24,    0,
    0,   -3,    3,    1,    0, -229, -229, -221,    0,    0,
    0, -238,    0, -217,    0,    5,    0,
);
@yyrindex = (                                             0,
    0,    0,    0,    0,    0,    0,    0,  -29,  -37,    0,
  -41,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   -5,    0,    0,    0,
    0,    0,    0,    0,    0,  -27,  -26,  -28,    0,    0,
    0,    0,    0,    0,    0,    0,    0,
);
@yygindex = (                                             0,
   43,  -11,   26,   -1,   -8,   -7,    0,    0,    8,
);
$YYTABLESIZE=242;
@yytable = (                                              9,
   22,    5,   18,    5,   14,   27,   28,   33,   36,   37,
   15,    2,    6,    3,    4,   35,   41,    9,   16,   42,
   17,    5,   39,    1,    2,   26,    3,   23,   25,    2,
    6,    3,    4,   27,   28,   20,   24,   31,   20,   32,
   40,   34,   15,   43,   46,   47,   44,   19,   38,   45,
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
    0,   20,    0,    0,    0,    0,    0,    0,   21,    0,
    0,    0,    0,    0,    0,    9,    9,    0,    9,    5,
    0,    0,    5,    1,    2,    9,    3,    4,    6,    5,
    2,    6,    3,    4,   20,    0,    0,    2,    6,    3,
    4,   21,
);
@yycheck = (                                             41,
   59,   40,    4,   41,   40,   14,   14,   16,   20,   21,
   46,   41,   41,   41,   41,   41,   41,   59,   40,   44,
   40,   59,   24,  262,  263,  264,  265,  257,  261,   59,
   59,   59,   59,   42,   42,   41,  258,  262,   44,  262,
  264,  262,   46,   41,  262,   41,   46,    5,   23,   42,
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
   -1,  260,   -1,   -1,   -1,   -1,   -1,   -1,  267,   -1,
   -1,   -1,   -1,   -1,   -1,  257,  258,   -1,  260,  257,
   -1,   -1,  260,  262,  263,  267,  265,  266,  257,  267,
  260,  260,  260,  260,  260,   -1,   -1,  267,  267,  267,
  267,  267,
);
$YYFINAL=6;
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
$YYMAXTOKEN=267;
#if YYDEBUG
@yyname = (
"end-of-file",'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','',"'('","')'",'','',"','",'',"'.'",'','','','','','','','','','','','',"';'",'','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',"OR","AND",
"NOT","IMP","COMPARE_OP","ID","IN","NUM","SENT","UNOP","EQV",
);
@yyrule = (
"\$accept : ltlform",
"ltlform : imp ';'",
"imp : disjunct",
"imp : imp IMP disjunct",
"imp : imp EQV disjunct",
"disjunct : conjunct",
"disjunct : disjunct OR conjunct",
"conjunct : term",
"conjunct : conjunct AND term",
"term : var",
"term : pred",
"term : UNOP term",
"term : '(' imp ')'",
"pred : var COMPARE_OP NUM",
"pred : IN '(' var ')'",
"pred : SENT '(' ID '.' ID ')'",
"pred : function",
"function : ID '(' parmlist ')'",
"parmlist : parm",
"parmlist : parmlist ',' parm",
"parm : var",
"parm : NUM",
"parm : pred",
"var : ID '.' ID",
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
#line 10 "ltlgram.y"
{$final = $yyvs[$yyvsp-1];
last switch;
} }
if ($yyn == 2) {
#line 11 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 3) {
#line 12 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-2] . '->' . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 4) {
#line 13 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 5) {
#line 15 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 6) {
#line 16 "ltlgram.y"
{$yyval = '(' . $yyvs[$yyvsp-2] . '||' . $yyvs[$yyvsp-0] . ')';
last switch;
} }
if ($yyn == 7) {
#line 18 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 8) {
#line 19 "ltlgram.y"
{$yyval = '(' . $yyvs[$yyvsp-2] . '&&' . $yyvs[$yyvsp-0] . ')';
last switch;
} }
if ($yyn == 9) {
#line 21 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 10) {
#line 22 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 11) {
#line 23 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 12) {
#line 24 "ltlgram.y"
{$yyval = '(' . $yyvs[$yyvsp-1] . ')';
last switch;
} }
if ($yyn == 13) {
#line 26 "ltlgram.y"
{$yyval =  LTLYacc->Compare($yyvs[$yyvsp-2], $yyvs[$yyvsp-1], $yyvs[$yyvsp-0]);
last switch;
} }
if ($yyn == 14) {
#line 27 "ltlgram.y"
{$yyval = LTLYacc->InPredicate($yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 15) {
#line 28 "ltlgram.y"
{$yyval = LTLYacc->Sent($yyvs[$yyvsp-3], $yyvs[$yyvsp-1]);
last switch;
} }
if ($yyn == 16) {
#line 29 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 17) {
#line 31 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-3] . $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 18) {
#line 33 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 19) {
#line 34 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-2] . $yyvs[$yyvsp-1] . $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 20) {
#line 36 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 21) {
#line 37 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 22) {
#line 38 "ltlgram.y"
{$yyval = $yyvs[$yyvsp-0];
last switch;
} }
if ($yyn == 23) {
#line 40 "ltlgram.y"
{$yyval = LTLYacc->GetVar($yyvs[$yyvsp-2], $yyvs[$yyvsp-0]);
last switch;
} }
#line 395 "y.tab.pl"
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
#line 42 "ltlgram.y"

sub yylex 
{
    my $a = yylexa();
    my $what = $a == $IN ? IN :
      $a == 0 ? EOF :
      $a == $QSTR ? QSTR :
      $a == $EVEN ? EVEN :
      $a == $ALWAYS ? ALWAYS :
      $a == $NUM ? NUM :
      $a == $OR ? OR :
      $a == $IN ? IN :
      $a == $ASSGNOP ? ASSGNOP :
      $a == $SEND ? SEND :
      $a == $WHEN ? WHEN :
      $a == $AND ? AND :
      $a == $NOT ? NOT :
      $a == $IMP ? IMP :
      $a == $COMPARE_OP ? COMPARE_OP :
      $a == $ID ? ID : $a;
    print "lex returning $what, yylval=$yylval, buf=[$buf]\n" if $DEBUG;
    return $a;
}

sub yylexa
{

    use English;
    if ($buf eq '') {return 0;}
    my $ret = $buf =~ /^ *(in)/i ? $IN :
    $buf =~ /^ *(sent)/i ? $SENT :
    $buf =~ /^ *(is)/i ? $IS : # this is for type enum, e.g. 'mode is heat'
    $buf =~ /^ *([A-Za-z\_][A-Za-z0-9\_]*)/ ? $ID :
    $buf =~ /^ *([0-9]+)/ ? $NUM:
    $buf =~ /^ *(\<\-\>)/ ? $EQV :
    $buf =~ /^ *(\-\>)/ ? $IMP :
    $buf =~ /^ *(\|)/ ? $OR  :
    $buf =~ /^ *(\&)/ ? $AND  :
    $buf =~ /^ *(\~)/ ? $UNOP :
    $buf =~ /^ *(\<\>)/ ? $UNOP :
    $buf =~ /^ *(\[\])/ ? $UNOP :
    $buf =~ /^ *(=|!=|>=|<=|>|<)/ ? $COMPARE_OP :
    $buf =~ /^ *(.)/ ? -3 : -4;
    $buf = $POSTMATCH;
    $lasttoken = $1;
    $yylval = $1;
    if ($yylval eq '~') {$yylval = '!'}
    if ($ret == -3) {$ret = unpack('c1', $yylval)}
    elsif ($ret == -4) {
      print "failed to find token:\{$buf\}\n";
      exit;
    }
    return $ret;
}

sub yyerror
{
    $final = '';
    print "**** Syntax error in transition $bufcopy near $lasttoken\n";
}

sub GetVar
{
    my ($classname, $class, $var) = @_;

    my $key = "${class}_V.$var";
    if (exists($SYMTAB{$key})) {return $SYMTAB{$key}}
    $SYMTAB{$key} = "p$INDEX";
    $REVERSE{$SYMTAB{$key}} = $key;       # reverse lookup
    print "******* put $SYMTAB{$key} in tab for $key\n";
    $INDEX++;
    return $SYMTAB{$key};
}

sub InPredicate
{
    my ($classname, $var) = @_;
# By the time we get the variable, GetVar has made it a simple letter.
# We have to look it up and change it.
    
    print "***** InPredicate arg=<$var>\n";
    my ($class,$state) = split(/\./, $REVERSE{$var}); 
# Make new variable... Class_V.st_statename
    my $newvar = "${class}.st_${state}";
# copy old variable to new spot
    $SYMTAB{$newvar} = $SYMTAB{$REVERSE{$var}};
# delete old one
    delete $SYMTAB{$REVERSE{$var}};
# Change reverse map to new symbol
    $REVERSE{$var} = $newvar;
    return $SYMTAB{$newvar};
}

sub Sent
{
    my ($classname, $class, $sig) = @_;

    my $key = "${class}_q??\[$sig\]";
    if (exists($SYMTAB{$key})) {return $SYMTAB{$key}}
    $SYMTAB{$key} = "p$INDEX";
    $INDEX++;
    return $SYMTAB{$key};
}

sub Compare
{
    my ($class, $arg1, $op, $arg2) = @_;

    if ($op eq 'is') {return "$argv1==$argv2"}
    elsif ($op eq '=') {return "$arg1==$arg2"}
    else {return "$arg1$op$arg2"}
}

sub Parse
{
    my $class = shift;
    $buf = shift;
    $bufcopy = $buf;
    $buf =~ s/\A *(.+?) *\Z/$1/;     # Trim blanks from both ends
    $DEBUG = $ENV{'LTLGRAMDEBUG'} ? 1 : 0;
    if (yyparse() == 0) {return $final}
    else {return ''}
}

sub GetDefn
{
# Return the symtab, which gives the defn of vars
  return %SYMTAB;
}

sub BEGIN{
    $INDEX = 0;
}

# Syntax of LTL expressions:

#        ltl ::= opd | ( ltl ) | ltl binop ltl | unop ltl
#Unary Operators (unop):
#        []   (the temporal operator always),
#        <>   (the temporal operator eventually),
#        ~   (the boolean operator for negation)
#Binary Operators (binop):
#        U   (the temporal operator strong until)  Not implemented
#        V   (the dual of U): (p V q) == ~(~p U ~q) Not implemented
#        &   (the boolean operator for logical and)
#        |   (the boolean operator for logical or)
#        ->   (the boolean operator for logical implication)
#        <->  (the boolena operator for logical equivalence)
#Operands (opd):
#        variables: Class.varname
#        'in' predicate: in(Class.state)
#	'sent' predicate (to test if signal was sent): sent(Class.signalname)
1;



#line 598 "y.tab.pl"
