%{
# Make Yacc.pm like this: byacc -Pv trangram.y; mv y.tab.pl TranYacc.pm
#
package TranYacc;
%}
%token OR,AND,NOT,COMPARE_OP,ID,IN,NUM,ASSGNOP,SEND,WHEN
%token PRINT,QSTR,SQSTR,NULL,NEW

%%
/* The transition expression is parsed to the form: event#event-var#guard#action#msgs where any
 * component can be omitted (a split(/#/, $tran) statement is used). 
 */
transition: event guard '/' actions '^' msgs {$final = $1 . '#G#' . $2 . '#A#' . $4 . '#M#' . $6 ;}
	    | event {$final = $1;}
	    | event  guard   {$final = $1 . '#G#' . $2;} 
	    | event '/' actions    {$final = $1 . '#A#' . $3;}
	    | event '^' msgs       {$final = $1 . '#M#' . $3;}
	    | event  guard  '/' actions {$final = $1 . '#G# ' . $2 . '#A# ' . $4;} 
	    | event  guard  '^' msgs  {$final = $1 . '#G#' . $2 . '#M#' . $4;}
	    | event '/' actions '^' msgs {$final = $1 . '#A# ' . $3 . '#M#' . $5;}
	    |  guard  {$final = 'G# ' . $1;}
	    |  guard  '/' actions  {$final = 'G# ' . $1 . '#A#' . $3;}
	    |  guard  '/' actions '^' msgs {$final = 'G# ' . $1 . '#A# ' . $3 . '#M# ' . $5;}
	    |  guard  '^' msgs {$final = 'G#' . $1 . '#M#' . $3;}
	    | '/' actions   {$final = 'A#' . $2;}
	    | '/' actions '^' msgs {$final = 'A# ' . $2 . '#M#' . $4;}
	    | '^' msgs     {$final = 'M#' . $2;}
	    ;
event:	    ID				{$$ = 'E#' . $1;}
/*	    | ID '(' ID ')'		{$$ = 'E#' . $1 . '#V#' . $VOBJ . $3;}  */
	    | ID '(' ID ')'		{$$ = 'E#' . $1 . '#V#' . TranYaccPak->InstVar($3);}
	    | WHEN '(' complexguard ')'	{$$ = 'E#' . '**when' . $3 ;}
	    | WHEN '(' ID ')'		{$$ = 'E#' . '**when' . $3 ;}
	    ;
actions:    action	{$$ = $1;}
	    | actions ';' action    {$$ = $1 . $3;}
	    ;
action:  rstmt			{$$ = $1;}
	| printstmt		{$$ = $1;}  
	| NEW '(' ID ')'	{$$ = TranYaccPak->New($3);}
	| SEND '(' msg ')'	{$$ = $3;}
	| function		{$$ = $1;}
	;
printstmt:	PRINT '(' SQSTR ')'			{$$ = 'printf('. Sq($3) . ');';}
	 |	PRINT '(' SQSTR ',' parmlist ')'	{$$ = 'printf(' . Sq($3) . ',' . $5 . ');';}
	 ;
rstmt:	ID ASSGNOP stmtpm    {$$ = TranYaccPak->Assign($1, $3); CheckVar($1);}
	;
stmtpm:	stmtdm
	| stmtpm '+' stmtdm  {$$ = $1 . '+' . $3;}
	| stmtpm '-' stmtdm  {$$ = $1 . '-' . $3;}
	;
stmtdm:	actterm       {$$ = $1;}
	| stmtdm '*' actterm    {$$ = $1 . '*' . $3;}
	| stmtdm '/' actterm    {$$ = $1 . '/' . $3;}
	;
actterm:  ID			{$$ = TranYaccPak->InstVar($1);}
        |  NUM			{$$ = $1;}
	| '-' NUM		{$$ = '-' . $1;}
	| '-' ID		{$$ = '-' . TranYaccPak->InstVar($1);}
	| '(' stmtpm ')'	{$$ = '(' . $2 . ')';}
	| function		{$$ = $1;}
	;

guard:    '[' complexguard ']'			{$$ = $2;}
        | '[' ID ']'				{$$ = TranYaccPak->InstVar($1);}
	;
complexguard:  expra				{$$ = $1;}
             | complexguard OR expra		{$$ = TranYaccPak->Logic('or', $1, $3);}
             ;
expra:	gdterm                  {$$ = $1;}
	| expra AND gdterm	{$$ =  TranYaccPak->Logic('and', $1, $3);}
	;
gdterm:	pred			{$$ = $1;}
	| NOT ID		{$$ = TranYaccPak->Logic('not', $2);}
	| '(' complexguard ')'	{$$ = '(' . $2 . ')';}
	;
/*pred:	numid COMPARE_OP numid  {$$ =  TranYaccPak->Compare($1, $2, $3);}  */
pred:	stmtpm COMPARE_OP numid  {$$ =  TranYaccPak->Compare($1, $2, $3);}
	| IN '(' ID ')'		 {$$ = TranYaccPak->INPredicate($3);}
	;
function: ID '(' parmlist ')' {$$ = $1 . $2 . $3 . $4;}
	;
parmlist: parm			{$$ = $1;}
	  | parmlist ',' parm	{$$ = $1 . $2 . $3;}
	  ;
parm: ID		{$$ = TranYaccPak->InstVar($1);}
	  | NUM		{$$ = $1;}
	  | pred	{$$ = $1;}
	  ;
numid:	ID			{$$ = TranYaccPak->InstVar($1);}
	| NUM			{$$ = $1;}
	;

msgs:	msg   {$$ = $1;}
	|     msgs '^' msg   {$$ = $1 . $3;}
	;
/* Queued semantics between classes  */
msg:	ID '.' ID	{$$ = TranYaccPak->ClassSend($1, $3);}
	| ID		{$$ = TranYaccPak->StateSend($1);}
/* The next rule is for queued semantics with a temp var for parms */
/*	| ID '.' ID '(' numid ')' {$$ = 'atomic{' . $3 . 'v = ' . $5 . '; ' . $1 . '_q!' . $3 . '};';} */
	| ID '.' ID '(' numid ')' {$$ = TranYaccPak->ClassSend($1, $3, $5);}
	;
/*  non-queued semantics  
msg:	ID '.' ID	{$$ = 'run event(' . $3 . '); ';}
	| ID		{$$ = 'run event(' . $1 . '); ';}
	| ID '.' ID '(' numid ')' {$$ = 'atomic{' . $3 . 'v = ' . $5 . '; run event(' . $3 . ')} ';}
	;
*/
%%


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
