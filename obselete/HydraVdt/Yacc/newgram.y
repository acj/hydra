%{
# Make Yacc.pm like this: byacc -Pv gram.y; mv y.tab.pl Yacc.pm
# setenv YYDEBUG true to see the statemachine parser in action.
# setenv GRAMDEBUG to see the lexer/parser class in action.

package Yacc;

#use AbstractNode;
#use modelNode;
#use modelbodyNode;
#use ClassNode;
#use classbodyNode;
#use DriverfileNode;
#use SignalNode;
#use CCStateNode;
#use ccstatebodyNode;
#use CStateNode;
#use cstatebodyNode;
#use StateNode;
#use statebodyNode;
#use NullNode;
#use InitNode;
#use HistoryNode;
#use JoinNode;
#use TransNode;
#use ActionNode;
#use InstVarNode;
#added
#use transitionbodyNode;
#use eventNode;
#use tranactionsNode;
#use tranactionNode;
#use messagesNode;
#use messageNode;
#added end
%}

/*changed*/
/*before nonterminal: transitionbody*/
%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
%token SUPER, SUB, WHOLE, PART, NEW, SEND
%token EXPRESSION, PRINTEXPRESSION
#added 040703 to handle timing invariants
%token INVARIANT,INVTYPENAME,INVARIANTEXPRESSION
#add end
/*after nonterminal: transitionbody*/
%token WHEN, ASSIGNOP, PRINT
%token AND,NOT,OR,COMPARE_OP,IN
/*changed end*/
%%
spec:       FORMALIZE AS language ';' model
    |   model
    ;
language:   PROMELA
    |   SMV
    |   ALLOY
    |   VHDL
    ;
model:      MODEL ID '{' modelbody '}'          {$final = Node(model, ID,$2, child,[$4]);} 
    |   MODEL '{' modelbody '}'             {$final = Node(model, ID,'Model', child,[$3]);}
    ;
modelbody:  modelstmt                   {$$ = Node(modelbody, child,[$1]);}
    |   modelbody modelstmt             {$$ = AddChild($1,child,$2);}
    ;
modelstmt:  DRIVERFILE ID ';'               {$$ = Node(Driverfile, ID,$2);}
    |   CLASS ID '{' classbody '}'          {$$ = Node(Class, ID,$2, child,[$4]);}
    |   CLASS ID '{' '}'                {$$ = Node(Null);}
        |       ASSOCIATION ID '{' assocbody '}'        {$$ = $1;}
        |       AGGREGATION '{' agbody '}'          {$$ = $1;}
    ;
classbody:  classstmt                   {$$ = Node(classbody, child,[$1]);}
    |   classbody classstmt             {$$ = AddChild($1, child,$2);}
    ;
classstmt:  signal                      {$$ = $1;}
    |   cstate                      {$$ = $1;}
    |   ccstate                     {$$ = $1;}
    |   init                            {$$ = $1;}
    |   join                        {$$ = $1;}
/*  |   history                         {$$ = $1;}  */
    |   state                           {$$ = $1;}
    |   instvar                         {$$ = $1;}
        |       AGSUBCONST ADORNS ID '{' agsubbody '}'      {Nullsub();}
        |       GENERALIZATION '{' genbody '}'          {$$=$1;}
        |       ordconst                                {$$=$1;}
    ;
signal:     SIGNAL ID ';'                   {$$ = Node(Signal,name,$2); Symtab('signal', $2);}
    |   SIGNAL ID '(' ')' ';'               {$$ = Node(Signal,name,$2); Symtab('signal', $2);}
    |   SIGNAL ID '(' ID ')' ';'            {$$ = Node(Signal,name,$2,sigtype,$4); Symtab('signal', $2);}
    ;
cstate:     CSTATE ID '{' cstatebody '}'            {$$ = Node(CState, ID, $2, child,[$4]); Symtab('cstate', $2);}
    |   CSTATE ID '{' '}'                   {$$ = Node(CState, ID, $2);}
    ;
cstatebody: cstatestmt                  {$$ = Node(cstatebody, child,[$1]);}
    |   cstatebody cstatestmt               {$$ = AddChild($1, child,$2);}
    ;
cstatestmt: state                       {$$ = $1;}
    |   init                        {$$ = $1;}
    |   cstate                      {$$ = $1;}
    |   join                        {$$ = $1;}
    |   history                     {$$ = $1;}
    |   ccstate                     {$$ = $1;}
    |   transition                  {$$ = $1;}
    |   actofstate                  {$$ = $1;}
    ;
state:      STATE ID '{' '}'                {$$ = Node(State, ID,$2); Symtab('state', $2);}
    |   STATE ID '{' statebody '}'          {$$ = Node(State, ID,$2, child,[$4]); Symtab('state', $2);}
    ;
statebody:  statestmt                   {$$ = Node(statebody, child,[$1]);}
    |   statebody statestmt             {$$ = AddChild($1, child,$2);}
    ;
statestmt:  transition                  {$$ = $1;}
    |   actofstate                  {$$ = $1;}
    ;
transition: TRANS TO ID ';'                     {$$ = Node(Trans, tran,  '', dest, $3);}
    |   TRANS '"' '"' TO ID ';'             {$$ = Node(Trans, tran,  '', dest, $5);}
    |   TRANS '"' transitionbody '"' TO ID ';'      {$$ = Node(Trans, tran,  $3, dest, $6);}    
    ;
actofstate: ACTION '"' '"' ';'              {$$ = Node(Action, tran,  '');}
    |   ACTION '"' transitionbody '"' ';'       {$$ = Node(Action, tran,  $3);}
#added 040703 to handle timing invariants
    |   INVARIANT '"' invtype '/' INVARIANTEXPRESSION '"' ';'   {$$ = Node(timeinvariant, $3,  $5);}
    ;
invtype: INVTYPENAME            {$$ = $1;}
    ;
#add end

ccstate:    CCSTATE ID '{' ccstatebody '}'          {$$ = Node(CCState,ID,$2, child,[$4]);}
    ;
ccstatebody:    ccstatestmt                 {$$ = Node(ccstatebody, child,[$1]);}
    |   ccstatebody ccstatestmt             {$$ = AddChild($1, child,$2);}
    ;
ccstatestmt:    cstate                      {$$ = $1;}
/*  |   state                       {$$ = $1;} */
/*  |   actofstate                  {$$ = $1;} */
    ;
init:       INIT ID ';'                     {$$ = Node(Init, ID,$2);}
    |   INIT '"' '"' ID ';'             {$$ = Node(Init, ID,$4, tran,  '');}
    |   INIT '"' transitionbody '"' ID ';'          {$$ = Node(Init, ID,$5, tran,  $3);}    
    ;
join:       JOIN ID FROM ID TO ID ';'           {$$ = Node(Join, ID, $2, from, $4, to, $6); Symtab('state', $2);}
    ; 
history:    HISTORY ID ';'                  {$$ = Node(History, ID, $2);}
    |   HISTORY '"' '"' ID ';'              {$$ = Node(History, ID, $4);}
    |   HISTORY '"' transitionbody '"' ID ';'       {$$ = Node(History, ID, $5, tran, $3);}
    ;
instvar:    INSTVAR ID ID ';'               {$$ = Node(InstVar,vtype,$2,var,$3); Symtab('var', $3);}
    |   INSTVAR ID ID ASSIGNOP numid ';'        {$$ = Node(InstVar,vtype,$2,var,$3,initval,$5); Symtab('var', $3);}
    ;
numid:      ID                          {$$ = $1;}
    |   NUM                         {$$ = $1;}
    ;
assocbody:
                ID '[' ID ']' ID '[' ID ']' ordconst        {Nullsub();}
        |       ID '[' ID ']' ID '[' ID ']'                 {Nullsub();}
        ;
agsubbody:
    ;
genbody:        SUPER ID SUB ID                 {Nullsub();}    
    ;
ordconst:       ORDCONST ADORNS ID              {Nullsub();}
        ;
agbody:         WHOLE ID '[' ID ']' PART ID '[' ID ']'      {Nullsub();}
    ;
/*added*/
transitionbody: event guard '/' actions '^' messages        {$$ = Node(transitionbody,event,$1,guard, $2, actions, $4, messages, $6);}
    |   event guard                     {$$ = Node(transitionbody,event,$1,guard, $2, actions, '', messages, '');} 
    |   event '/' actions                   {$$ = Node(transitionbody,event,$1,guard, '', actions, $3, messages, '');}
    |   event '^' messages                  {$$ = Node(transitionbody,event,$1,guard, '', actions, '', messages, $3);}
    |   event guard '/' actions             {$$ = Node(transitionbody,event,$1,guard, $2, actions, $4, messages, '');} 
    |   event guard '^' messages            {$$ = Node(transitionbody,event,$1,guard, $2, actions, '', messages, $4);}
    |   event '/' actions '^' messages          {$$ = Node(transitionbody,event,$1,guard, '', actions, $3, messages, $5);}
    |   guard                       {$$ = Node(transitionbody,event,'',guard, $1, actions, '', messages, '');}
    |   guard '/' actions               {$$ = Node(transitionbody,event,'',guard, $1, actions, $3, messages, '');}
    |   guard '/' actions '^' messages          {$$ = Node(transitionbody,event,'',guard, $1, actions, $3, messages, $5);}
    |   guard '^' messages              {$$ = Node(transitionbody,event,'',guard, $1, actions, '', messages, $3);}
    |   '/' actions                     {$$ = Node(transitionbody,event,'',guard, '', actions, $2, messages, '');}
    |   '/' actions '^' messages            {$$ = Node(transitionbody,event,'',guard, '', actions, $2, messages, $4);}
    |   '^' messages                    {$$ = Node(transitionbody,event,'',guard, '', actions, '', messages, $2);}
    |   event                       {$$ = Node(transitionbody,event,$1,guard, '', actions, '', messages, '');}
    ;
event:      ID                      {$$ = Node(event,eventtype,'normal',eventname,$1,eventvar, '');}
    |   ID '(' ID ')'                   {$$ = Node(event,eventtype,'normal',eventname,$1,eventvar, $3);}
    |   WHEN '(' complexguard ')'           {$$ = Node(event,eventtype,  'when',whenvar, $3);}
    |   WHEN '(' ID ')'                 {$$ = Node(event,eventtype,  'when',whenvar, $3);}
    ;
complexguard:   expra                       {$$ = $1;}
    |   complexguard OR expra               {$$ = $1.$2.$3;}
    ;
expra:      gdterm                      {$$ = $1;}
    |   expra AND gdterm                {$$ = $1.$2.$3;}
    ;
gdterm:     pred                        {$$ = $1;}
    |   NOT ID                      {$$ = $1.$2;}
    |   '(' complexguard ')'                {$$ = '(' . $2 . ')';}
    ;
guard:          EXPRESSION                  {$$ = $1;}
    ;
actions:    action                      {$$ = Node(tranactions,child,[$1]);}
    |   actions ';' action                  {$$ = AddChild($1,child,$3);}
    ;
action:     NEW '(' ID ')'                  {$$ = Node(tranaction,actiontype,'newaction',content,$3);}
    |   SEND '(' message ')'                {$$ = Node(tranaction,actiontype,'sendmsg',message,$3);}
    |   assignstmt                  {$$ = $1;}  /*assignment*/
    |   printstmt                   {$$ = $1;}      /*print stmt*/
    |   function                    {$$ = $1;}  /*foo(x,y,z)*/
    ;
messages:   message                     {$$ = Node(messages,child,[$1]);}
    |   messages '^' message                {$$ = AddChild($1,child,$3);}
    ;
message:    ID '.' ID                   {$$ = Node(message,msgclassname,$1,msgsignalname,$3,msgintvarname,'');}
    |   ID                      {$$ = Node(message,msgclassname,'',msgsignalname,$1,msgintvarname,'');}
    |   ID '.' ID '(' numid ')'             {$$ = Node(message,msgclassname,$1,msgsignalname,$3,msgintvarname,$5);}
    ;
assignstmt: ID ASSIGNOP stmtpm              {$$ = Node(tranaction,actiontype,'assignstmt',assignment,$1.$2.$3);}
        ;
stmtpm:     stmtdm                      {$$ = $1;}
    |   stmtpm '+' stmtdm               {$$ = $1 . '+' . $3;}
    |   stmtpm '-' stmtdm               {$$ = $1 . '-' . $3;}
    ;
stmtdm:     actterm                         {$$ = $1;}
    |   stmtdm '*' actterm                  {$$ = $1 . '*' . $3;}
    |   stmtdm '/' actterm                  {$$ = $1 . '/' . $3;}
    ;
actterm:    ID                      {$$ = $1;}
        |   NUM                     {$$ = $1;}
    |   '-' NUM                     {$$ = '-' . $1;}
    |   '-' ID                      {$$ = '-' . $1;}
    |   '(' stmtpm ')'                  {$$ = '(' . $2 . ')';}
    |   functioninassign                {$$ = $1;}
    ;        
printstmt:      PRINT '(' PRINTEXPRESSION ')'           {$$ = Node(tranaction,actiontype,'printstmt',printcontent,$3,printparmlist,'');}
    |   PRINT '(' PRINTEXPRESSION ',' parmlist ')'  {$$ = Node(tranaction,actiontype,'printstmt',printcontent,$3,printparmlist,$5);}
    ;
function:       ID '(' parmlist ')'             {$$ = Node(tranaction,actiontype,'function',funcID,$1,funcparmlist,$3);}
    ;
functioninassign:
        ID '(' parmlist ')'             {$$ = $1 . $2 . $3 . $4;}
    ;
parmlist:       parm                        {$$ = $1;}
    |   parmlist ',' parm               {$$ = $1 . $2 . $3;}
    ;
parm:           ID                      {$$ = $1;}
    |   NUM                     {$$ = $1;}
    |   pred                        {$$ = $1;}
    ;
pred:       stmtpm COMPARE_OP numid             {$$ = $1 . $2 . $3;}
    |   IN '(' ID ')'                   {$$ = $1 . '(' . $3 . ')';}
    ;
%%

my $YYDEBUG=1;

#sub Node
#{
#    my ($type, @arg) = @_;
#
#    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
#    my $node = {};
#    $$node{type} = $type;
#    while (@arg) {
#   my $key = shift(@arg);
#   my $val = shift(@arg);
#   $$node{$key} = $val;
#    }
#    $$node{linenum} = $lineno;
#    return $node;
#}

#added by min
sub Node
{
    my ($type, @arg) = @_;

    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
    my @list;
    push(@list,$type);push(@list,"Node");
    my $classname = join("",@list);
    my $node = new $classname($lineno, @arg);   
    bless($node, $classname);
    return $node;
}

#sub Nullsub
#{
#  my $node = {};
#  $dtype = 'Dummy';
#  $$node{type} = $dtype;
#  $$node{linenum} = $lineno;
#  return $node;
#}

#added
sub Nullsub
{
    print "building a $type=(", join(',', @arg), ")\n" if $DEBUG;
    my @list;
    push(@list,"Null");
    push(@list,"Node");
    my $classname = join("",@list);
    my $node = new $classname($lineno, @arg);   
    bless($node, $classname);
    return $node;
}

#added
sub AddChild
{
    my ($node, $key, $val) = @_;
    
    #print "adding $val to $key\n"; #if $DEBUG;
    push(@{$$node{$key}}, $val);
    $val->{parent}=$node;   #add a parent key to this node
    #print("\n***###\nval->{parent}  $val->{parent}\n");
    return $node;
}

sub yylex 
{
    my $a = yylexa();
    print "lex returning $TokenLkup[$a] yylval=$yylval\n" if $DEBUG;
    print "buf=\ [$buf\]\n" if $DEBUG;
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
    $buf =~ s/\'/\' /g;
    $buf =~ s/\)/ \)/g;  #right
    $buf =~ s/\(/ \(/g;  #left
    $buf =~ s/\[/ \[ /g;
    $buf =~ s/\]/ \] /g;
    $buf =~ s/\:=/ \:= /g;
    $bufcopy = $buf;
    print "read($lineno):$buf\n" if $DEBUG;
    }

#old tokens
#%token MODEL,ID,NUM,QSTR,CLASS,ASSOC,TYPE,CCSTATE,CSTATE,TO,ENUM
#%token DRIVERFILE,STATE,TRANS,INIT,FORMAL,JOIN,HISTORY,FROM,INSTVAR
#%token SIGNAL

#new tokens
#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token SINGLEQUOTE,DOUBLEQUOTE,TWODOUBLEQUOTE, EXPRESSION, PRINTEXPRESSION
#%token WHEN, ASSIGNOP, PRINT, NEW, SEND, AND, OR, IN, NOT, COMPARE_OP

    my $ret = $buf =~ /^ *(Model)/ ? $MODEL :
    $buf =~ /^ *(Class) / ? $CLASS :
    $buf =~ /^ *(Formalize) / ? $FORMALIZE :
    $buf =~ /^ *(as) / ? $AS :
    $buf =~ /^ *(promela) / ? $PROMELA :
    $buf =~ /^ *(smv) / ? $SMV :
    $buf =~ /^ *(alloy) / ? $ALLOY :
    $buf =~ /^ *(vhdl) / ? $VHDL :   
    $buf =~ /^ *(new) /i ? $NEW :
    $buf =~ /^ *(is) /i ? $COMPARE_OP : #this is for type enum, e.g. 'mode is heat'
    $buf =~ /^ *(send) /i ? $SEND :
    $buf =~ /^ *(when) /i ? $WHEN :
    #added 040703 to handle timing invariants
    $buf =~ /^ *(timeinvar) / ? $INVTYPENAME :
    # add end
    $buf =~ /^ *(DriverFile) / ? $DRIVERFILE :
    $buf =~ /^ *(Association) /? $ASSOCIATION :
    $buf =~ /^ *(Aggregation) / ? $AGGREGATION :
    $buf =~ /^ *(Aggregation-Subclass-Constraint) /? $AGSUBCONST :
    $buf =~ /^ *(Ordered-Constraint) /? $ORDCONST :
    $buf =~ /^ *(adorns) /? $ADORNS :
    $buf =~ /^ *(in) /i ? $IN :
    $buf =~ /^ *(\|) / ? $OR :
    $buf =~ /^ *(\&) / ? $AND :
    $buf =~ /^ *(\~) / ? $NOT :
    $buf =~ /^ *(Generalization) /? $GENERALIZATION :
    $buf =~ /^ *(Signal) / ? $SIGNAL :
    $buf =~ /^ *(Action) / ? $ACTION :
    $buf =~ /^ *(Time) / ? $TIME :
    $buf =~ /^ *(print) /i ? $PRINT :
    $buf =~ /^ *(CompositeState) / ? $CSTATE :
    $buf =~ /^ *(State) / ? $STATE :
    $buf =~ /^ *(Transition) / ? $TRANS :
    $buf =~ /^ *(to) / ? $TO :
    $buf =~ /^ *(ConcurrentState) / ? $CCSTATE :
    $buf =~ /^ *(Initial) / ? $INIT :
    $buf =~ /^ *(Join) / ? $JOIN :
    $buf =~ /^ *(from) / ? $FROM :    
    $buf =~ /^ *(History) / ? $HISTORY :
    $buf =~ /^ *(InstanceVar) / ? $INSTVAR :
    # SK: added 052403 '-?' to handle negative numbers
    $buf =~ /^ *(-?[0-9]+)/ ? $NUM:
    # SK end add
    $buf =~ /^ *(super) / ? $SUPER :
    $buf =~ /^ *(sub) / ? $SUB :
    $buf =~ /^ *(Whole) / ? $WHOLE :
    $buf =~ /^ *(Part) / ? $PART :
    $buf =~ /^ *(\'[^\"\']+\') / ? $PRINTEXPRESSION :
    $buf =~ /^ *(:=) / ? $ASSIGNOP :
    $buf =~ /^ *(=|!=|>=|<=|>|<)/ ? $COMPARE_OP :
    #added 040703 to handle timing invariants
    $buf =~ /^ *(Invariant) / ? $INVARIANT :
    $buf =~ /^ *(\{[^\"]+\}) / ? $INVARIANTEXPRESSION :   
    #add end
    $buf =~ /^ *(\[[^\"]+\]) / ? $EXPRESSION :
    $buf =~ /^ *([A-Za-z\_][A-Za-z0-9\_]*)/ ? $ID :
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
    print("\n***class=>$LastClass, state=>$LastState***\n");
    print("\nSyntax error near '$lasttoken' in '$bufcopy', line $lineno\n");
    #exit;
}

sub Init
{
  if ($ENV{GRAMDEBUG}) 
  {$DEBUG = 1}
  else 
  {$DEBUG = 0}

#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token WHEN, PRINT, NEW, SEND,IN

# This is the official token lookup table.
  %TokenTab = ('Formalize'=>$FORMALIZE, 'as'=>$AS, 'promela'=>$PROMELA, 'smv'=>$SMV, 'alloy'=>$ALLOY, 'vhdl'=>$VHDL,
           'Model'=>$MODEL, 'ID'=>$ID,
           'DriverFile'=>$DRIVERFILE, 'Class'=>$CLASS, 'Association'=>$ASSOCIATION, 'Aggregation'=>$AGGREGATION,
           'Aggregation-Subclass-Constraint'=>$AGSUBCONST, 'Ordered-Constraint'=>$ORDCONST, 'adorns'=>$ADORNS,
           'Generalization'=>$GENERALIZATION,
           'Signal'=>$SIGNAL, 'CompositeState'=>$CSTATE, 'State'=>$STATE, 'Transition'=>$TRANS, 'to'=>$TO,
           'Action'=>$ACTION, 'ConcurrentState'=>$CCSTATE, 'Initial'=>$INIT, 'Join'=>$JOIN, 'from'=>$FROM, 
           'History'=>$HISTORY, 'InstanceVar'=>$INSTVAR, 'NUM'=>$NUM,
           'super'=>$SUPER, 'sub'=>$SUB, 'Whole'=>$WHOLE, 'Part'=>$PART,
           'when'=>$WHEN, 
           'print'=>$PRINT,
           'new'=>$NEW, 'send'=>$SEND,'in'=>$IN
           );
            
#%token FORMALIZE, AS, PROMELA, SMV, ALLOY, VHDL, MODEL, ID
#%token MODEL, ID
#%token DRIVERFILE, CLASS, ASSOCIATION, AGGREGATION, AGSUBCONST, ORDCONST, ADORNS, GENERALIZATION
#%token SIGNAL, CSTATE, STATE, TRANS, TO, ACTION, CCSTATE, INIT, JOIN, FROM, HISTORY, INSTVAR, NUM
#%token SUPER, SUB, WHOLE, PART
#%token WHEN, PRINT, NEW, SEND,IN
   
# This is only used to print out the token name above.

   $TokenLkup[$FORMALIZE] = 'Formalize';    $TokenLkup[$AS] = 'as';
   $TokenLkup[$PROMELA] = 'promela';        $TokenLkup[$SMV] = 'smv';
   $TokenLkup[$ALLOY] = 'alloy';        $TokenLkup[$VHDL] = 'vhdl';   
   $TokenLkup[$MODEL] = 'Model';        $TokenLkup[$ID] = 'ID';
   
   $TokenLkup[$DRIVERFILE] = 'DriverFile';  $TokenLkup[$CLASS] = 'Class';    
   $TokenLkup[$ASSOCIATION] = 'Association';    $TokenLkup[$AGGREGATION] = 'Aggregation';
   $TokenLkup[$AGSUBCONST] = 'Aggregation-Subclass-Constraint';
   $TokenLkup[$ORDCONST] = 'Ordered-Constraint';
   $TokenLkup[$ADORNS]='adorns';        $TokenLkup[$GENERALIZATION] = 'Generalization';
   
   $TokenLkup[$SIGNAL]='Signal';        $TokenLkup[$CSTATE]='CompositeState'; 
   $TokenLkup[$STATE] = 'State';        $TokenLkup[$TRANS] = 'Transition'; 
   $TokenLkup[$TO] = 'To';          $TokenLkup[$ACTION]='Action';
   $TokenLkup[$CCSTATE] = 'CCState';        $TokenLkup[$INIT] = 'Initial'; 
   $TokenLkup[$JOIN] = 'Join';          $TokenLkup[$FROM] = 'from'; 
   $TokenLkup[$HISTORY] = 'History';        $TokenLkup[$INSTVAR] = 'InstanceVar'; #no NUM
   
   $TokenLkup[$SUPER]='super';          $TokenLkup[$SUB]='sub'; 
   $TokenLkup[$WHOLE] = 'Whole';        $TokenLkup[$PART] = 'Part';
   
   $TokenLkup[$WHEN]='when';            
   $TokenLkup[$PRINT]='print';
   $TokenLkup[$NEW]='new';  
   $TokenLkup[$SEND]='send';
   $TokenLkup[$IN]='in';
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
