%{
#Make ExprYaccForPromela.pm like this: byacc -Pv expressiongram.y; mv y.tab.pl ExprYaccForPromela.pm
#EXPRGRAMDEBUG

package ExprYaccForPromela;
use ExprYaccForPromelaPak;

%}

%token ID AND OR NOT IN NUM COMPARE_OP ASSGNOP WHEN
%%

stmt:       assignment          {$final = $1;}
    |   guard               {$final = $1;}
    |   parmlist            {$final = $1;}
    |   whenclause          {$final = $1;}
    ;   
assignment: ID ASSGNOP stmtpm           {$$ = ExprYaccForPromelaPak->Assignment($1,$3);}
    ;
stmtpm:     stmtdm
    |   stmtpm '+' stmtdm       {$$ = $1 . '+' . $3;}
    |   stmtpm '-' stmtdm       {$$ = $1 . '-' . $3;}
    ;
stmtdm:     actterm             {$$ = $1;}
    |   stmtdm '*' actterm          {$$ = $1 . '*' . $3;}
    |   stmtdm '/' actterm          {$$ = $1 . '/' . $3;}
    ;
actterm:    ID              {$$ = ExprYaccForPromelaPak->InstVar($1);}
        |   NUM             {$$ = $1;}
    |   '-' NUM             {$$ = '-' . $2;}
    |   '-' ID              {$$ = '-' . ExprYaccForPromelaPak->InstVar($2);}
    |   '(' stmtpm ')'          {$$ = '(' . $2 . ')';}
    |   function            {$$ = $1;}
    ;
function:   ID '(' parmlist ')'     {$$ = $1 . $2 . $3 . $4;}
    |   IN '(' ID ')'           {$$ = ExprYaccForPromelaPak->INPredicate($3);}
    ;
parmlist:   parm                {$$ = $1;}
        |   parmlist ',' parm       {$$ = $1 . $2 . $3;}
    ;
parm:       ID              {$$ = ExprYaccForPromelaPak->InstVar($1);}
    |   NUM             {$$ = $1;}
    |   pred                {$$ = $1;}
    ;
guard:      '[' guardbody ']'       {$$ = $2;}
guardbody:  expra               {$$ = $1;}
    |   guardbody OR expra      {$$ = ExprYaccForPromelaPak->Logic('or', $1, $3);}
    ;
expra:      gdterm                      {$$ = $1;}
    |   expra AND gdterm        {$$ = ExprYaccForPromelaPak->Logic('and', $1, $3);}
    ;
gdterm:     pred                {$$ = $1;}
    |   ID              {$$ = ExprYaccForPromelaPak->InstVar($1);}
    |   NOT ID              {$$ = ExprYaccForPromelaPak->Logic('not', $2);}
    |   '(' guardbody ')'       {$$ = '(' . $2 . ')';}
    ;
pred:       numid COMPARE_OP numid      {$$ = ExprYaccForPromelaPak->Compare($1, $2, $3);}
    |   function            {$$ = $1;}  
    ;
numid:      ID              {$$ = ExprYaccForPromelaPak->InstVar($1);}
    |   NUM             {$$ = $1;}
    ;
/*for event when*/
whenclause: WHEN '(' guardbody ')'      {$$ = $3;}
    ;
%%

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
