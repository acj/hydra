%{
# Make LTLYacc.pm like this: byacc -Pv ltlgram.y; mv y.tab.pl LTLYacc.pm
#
package LTLYacc;
%}
%token OR,AND,NOT,IMP,COMPARE_OP,ID,IN,NUM
%token SENT,UNOP,EQV

%%
ltlform:	imp ';'		{$final = $1;}
imp:		disjunct	{$$ = $1;}
		| imp IMP disjunct  {$$ = $1 . '->' . $3;}
		| imp EQV disjunct  {$$ = $1 . $2 . $3;}
		;
disjunct:	conjunct	{$$ = $1;}
		| disjunct OR conjunct   {$$ = '(' . $1 . '||' . $3 . ')';}
		;
conjunct:	term		{$$ = $1;}
		| conjunct AND term	{$$ = '(' . $1 . '&&' . $3 . ')';}
		;
term:		var		{$$ = $1;}
		| pred		{$$ = $1;}
		| UNOP term     {$$ = $1 . $2;}
		| '(' imp ')'	{$$ = '(' . $2 . ')';}
		;
pred:		var COMPARE_OP NUM		{$$ =  LTLYacc->Compare($1, $2, $3);}
		| IN '(' var ')'		{$$ = LTLYacc->InPredicate($3);}
		| SENT '(' ID '.' ID ')'	{$$ = LTLYacc->Sent($3, $5);}
		| function			{$$ = $1;}
		;
function:	ID '(' parmlist ')'		{$$ = $1 . $2 . $3 . $4;}
		;
parmlist:	parm			{$$ = $1;}
		| parmlist ',' parm	{$$ = $1 . $2 . $3;}
		;
parm:		var		{$$ = $1;}
		| NUM		{$$ = $1;}
		| pred		{$$ = $1;}
		;
var:		ID '.' ID	{$$ = LTLYacc->GetVar($1, $3);}
%%

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
    Put Msg(level=>error, msg=> "Syntax error in transition "
	    . "$bufcopy near $lasttoken");
}

sub GetVar
{
    my ($classname, $class, $var) = @_;

    my $key = "${class}_V.$var";
    if (exists($SYMTAB{$key})) {return $SYMTAB{$key}}
    $SYMTAB{$key} = "p$INDEX";
    $REVERSE{$SYMTAB{$key}} = $key;       # reverse lookup
    $INDEX++;
    return $SYMTAB{$key};
}

sub InPredicate
{
    my ($classname, $var) = @_;
# By the time we get the variable, GetVar has made it a simple letter.
# We have to look it up and change it.
    
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



