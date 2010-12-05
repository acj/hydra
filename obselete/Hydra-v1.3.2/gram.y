%{
# Make Yacc.pm like this: byacc -Pv gram.y; mv y.tab.pl Yacc.pm
# setenv YYDEBUG true to see the statemachine parser in action.
# setenv GRAMDEBUG to see the lexer/parser class in action.
#
package Yacc;
%}
%token MODEL,ID,NUM,QSTR,CLASS,ASSOC,TYPE,CCSTATE,CSTATE,TO,ENUM
%token DRIVERFILE,STATE,TRANS,INIT,FORMAL,JOIN,HISTORY,FROM,INSTVAR
%token SIGNAL,ACTION,FORMALIZE,AS
%token PROMELA

%%
spec:		FORMALIZE AS language ';' model
	|	model
	;
model:		MODEL ID '{' modelbody '}' {$final = Node(model, ID,$2, modelbody,$4);} 
	|	MODEL '{' modelbody '}' {$final = Node(model, ID,'Model', modelbody,$3);}
	;
modelbody:	modelstmt		{$$ = Node(modelbody, modelstmtlist,[$1]);}
	|	modelbody modelstmt	{$$ = Add($1, modelstmtlist,$2);}
	;

modelstmt:	DRIVERFILE ID ';'	{$$ = Node(Driverfile, ID,$2);}
	|	CLASS ID '{' classbody '}' {$$ = Node(Class, ID,$2, classbody,$4);}
	|	CLASS ID '{' '}'	   {$$ = Node(Null);}
	;
language:	PROMELA
	;
classbody:	classstmt		{$$ = Node(classbody, classstmtlist,[$1]);}
	|	classbody classstmt	{$$ = Add($1, classstmtlist,$2);}
	;
classstmt:	signal		{$$ = $1;}
	|	cstate			{$$ = $1;}
	|	ccstate			{$$ = $1;}
	|	init			       {$$ = $1;}
	|	join			       {$$ = $1;}
	|	history			       {$$ = $1;}
	|	state			       {$$ = $1;}
	|	instvar			       {$$ = $1;}
	;
signal:		SIGNAL ID ';'			{$$ = Node(Signal,name,$2); Symtab('signal', $2);}
	|	SIGNAL ID '(' ')' ';'		{$$ = Node(Signal,name,$2); Symtab('signal', $2);}
	|	SIGNAL ID '(' ID ')' ';'	{$$ = Node(Signal,name,$2,sigtype,$4); Symtab('signal', $2);}
	;
ccstatebody:	ccstatestmt		{$$ = Node(ccstatebody, ccstatestmtlist,[$1]);}
	|	ccstatebody ccstatestmt	{$$ = Add($1, ccstatestmtlist,$2);}
	;
ccstatestmt:	state		{$$ = $1;}
	|	cstate		{$$ = $1;}
	|	action		{$$ = $1;}
	;
cstatebody:	cstatestmt		{$$ = Node(cstatebody, cstatestmtlist,[$1]);}
	|	cstatebody cstatestmt	{$$ = Add($1, cstatestmtlist,$2);}
	;
cstate:		CSTATE ID '{' cstatebody '}' {$$ = Node(CState, ID,$2, body,$4); Symtab('cstate', $2);}
	|	CSTATE ID '{' '}'	     {$$ = Node(CState, ID);}
	;
cstatestmt:	state			{$$ = $1;}
	|	init			{$$ = $1;}
	|	cstate			{$$ = $1;}
	|	join			{$$ = $1;}
	|	history			{$$ = $1;}
	|	ccstate			{$$ = $1;}
	|	transition		{$$ = $1;}
	|	action			{$$ = $1;}
	;
state:		  STATE ID '{' statebody '}' {$$ = Node(State, ID,$2, statebody,$4); Symtab('state', $2);}
		| STATE ID '{' '}' {$$ = Node(State, ID,$2, statebody,''); Symtab('state', $2);}
		;
statebody:	statestmt		{$$ = Node(statebody, statestmtlist,[$1]);}
	|	statebody statestmt	{$$ = Add($1, statestmtlist,$2);}
	;
statestmt:	transition		{$$ = $1;}
	|	action			{$$ = $1;}
	;
init:		INIT ID ';'	       {$$ = Node(Init, ID,$2);}
	|	INIT qstrlist ID ';'       {$$ = Node(Init, ID,$3, tran, $2);}	
	;
history:	HISTORY ID ';'		{$$ = Node(History, ID, $2);}
	|	HISTORY qstrlist ID ';'	{$$ = Node(History, ID, $3, tran, $2);}
		;
join:		JOIN ID FROM ID TO ID ';' {$$ = Node(Join, ID, $2, from, $4, to, $6); Symtab('state', $2);}
		; 
transition:	TRANS qstrlist TO ID ';'      {$$ = Node(Trans, tran,$2, dest,$4);}
		| TRANS TO ID ';'	      {$$ = Node(Trans, tran, '', dest, $3);}
		;
action:		ACTION qstrlist ';'	      {$$ = Node(Action, action, $2);}
		;
ccstate:	CCSTATE ID '{' ccstatebody '}' {$$ = Node(CCState,ID,$2, body,$4);}
;
instvar:    INSTVAR ID ID ';'			{$$ = Node(InstVar,vtype,$2,var,$3); Symtab('var', $3);}
	  | INSTVAR ID ID ':' '=' numid ';'	{$$ = Node(InstVar,vtype,$2,var,$3,initval,$6); Symtab('var', $3);}
	  | INSTVAR ID ID ':' '=' alist		{$$ = Node(InstVar,vtype,$2,var,$3,Initlist,$6); Symtab('var', $3);}
		;
alist:	ID			{$$ = $1;}
	|	alist ',' ID	{$$ = $1 . ',' . $3;}
	;
numid:	ID  {$$ = $1;}
	| NUM {$$ = $1;}
	;
qstrlist:	QSTR                  {$$ = $1;}
		| qstrlist ',' QSTR   {$$ = substr($1,0,-1) . substr($3,1);}
		;
%%

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
