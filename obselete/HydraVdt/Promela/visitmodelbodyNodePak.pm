#!/usr/bin/perl

package visitmodelbodyNodePak;

use UniversalClass;

#Reused
sub MakeOut
{
    my ($lvl, $txt) = @_;
 
    my ($out,$margin);
    my ($label, $rest);
    ($label,$rest) = $txt =~ /^([A-z0-9]+:)(.*)/s;
    $margin = length($label) > $LEFTMARGIN ? length($label)+1 : $LEFTMARGIN;
    if ($label) {$out = $label . ' ' x ($margin-length($label)) . $rest}
    else {$out = ' ' x $tab[$lvl] . $txt}
    return $out;
}

#Reused
sub cut
{
    my ($str, $len) = @_;

    
    my ($i,$p,$lasti,$ret,$rest,$inq);
    for ($i=0; $i<length($str); $i++) {
    $inq = substr($str,$i,1) eq '"' ? ++$inq%2 : $inq;
    if ($inq) {next}
    if (substr($str,$i,1) eq ' ') {
        if ($i+1 > $len) {
        $p = $lasti ? $lasti : $i;
        $ret = substr($str,0,$p);
        $rest = substr($str,$p+1);
        return ($ret, $rest);
        }
        else {$lasti = $i}
    }
    }
    if ($lasti) {return (substr($str,0,$lasti), substr($str,$lasti+1))}
    else {return ($str, '')}
}

#Reused
sub Put
{
# Put (lvl, @list) write a string out indented according to level. If the
# string has a label, it is placed at the left. If the string is over
# 72 chars, it is split to a next line indented at lvl+1. 

# If Put, lvl=0 follows a PutNR, the string is placed on the right
# end of the previous PutNR and if folded, folded at the PutNR lvl+1

# If multiple Puts are req'd, do this: PutNR lvl,text for the first with
# lvl set to what is req'd. The do PutNR 0,text as many times as needed,
# then Put 0,text.
    my ($class, $lvl, @list) = @_;
    
    my $textMargin = 99999;
    
    my $out = MakeOut($lvl, join('', @list));
    $out = $STR ? $STR . $out : $out;
    $lvl = !$lvl && $LASTLVL ? $LASTLVL : $lvl;
    my $lvl2 = $lvl;
    my $x;
    if (length($out) > $textMargin) {
    if ($out =~ /^ +(.+)/) {$out = $1}
    while (length($out) > $textMargin-$tab[$lvl2]) {
        ($x,$out) = cut($out, $textMargin-$tab[$lvl2]);
        print OUT ' ' x $tab[$lvl2], "$x\n";
        $lvl2 = $lvl+1;
    }
    if ($out) {print OUT ' ' x $tab[$lvl2], "$out\n"}
    }
    else {print OUT "$out\n"}
    $STR = '';
    $LASTLVL = 0;
}

#Reused
sub PutNR
{
    my ($class, $lvl, @list) = @_;

    if (!$STR) {
    $LASTLVL = $lvl;
    $STR = MakeOut($lvl, join('', @list));
    }
    else {$STR .= MakeOut(0, join('', @list))}
    return;
}

#SK 041303 added Timer process output
#Called by ASTVisitorForPromela.pm/sub visitmodelbodyNode()
#Functionality: to output the whole Promela file (.pr).
#To call: $modelnum1outputfile=visitmodelbodyNodePak->OutputmodelbodyNode($modelnum1outputfile,\@DEFINES,
#                             \@mtypelist,\@GlobalInstVarSignal,$driverfileID,\@outputWholeClass,\@NEVER);
sub OutputmodelbodyNode
{
    my ($class,$modelnum1outputfile,$DEFINES,$mtypelist,
        $GlobalInstVarSignal,$driverfileID,$outputWholeClass,$NEVER,$GlobalTimerList,$GlobalProcessList)=@_;
    
    
#******************
#The output file is $modelnum1outputfile
#1 output two Global Macros
#2 output definitions of never claim
#3 output Global Channel definitions
#4 output @mtypelist
#5 @GlobalInstVarSignal
#6 Token
#7 Driverfile
#8 @outputWholeClass
#9 Universal Dispatcher
#10 never claim
#******************

#output two global macros       
    visitmodelbodyNodePak->MacroGlobalOutput($modelnum1outputfile);
       
#Output definitions of never claim
    visitmodelbodyNodePak->NeverDefinitionOutput($modelnum1outputfile,@$DEFINES);

#output global channel definitions  
    visitmodelbodyNodePak->ChanGlobalOutput($modelnum1outputfile);

#output @mtypelist, add format
    visitmodelbodyNodePak->mtypelistOutput($modelnum1outputfile,@$mtypelist);
    
#output @GlobalInstVarSignal
    visitmodelbodyNodePak->InstVarSignalOutput($modelnum1outputfile,@$GlobalInstVarSignal);
    
#output global token
    visitmodelbodyNodePak->TokenGlobalOutput($modelnum1outputfile);
    
#KS: output dijkstra process
#KS: removed in version 7
#    visitmodelbodyNodePak->DijkstraOutput($modelnum1outputfile);

#output Driverfile to $driverfileID
    visitmodelbodyNodePak->Driverfile("$driverfileID.pr");
    
#output @outputWholeClass
    visitmodelbodyNodePak->WholeClassOutput($modelnum1outputfile,@$outputWholeClass);
    
#output global dispatcher
    visitmodelbodyNodePak->DispatcherOutput($modelnum1outputfile);  

#output timer process
    visitmodelbodyNodePak->TimerProcessOutput($modelnum1outputfile,$GlobalTimerList,$GlobalProcessList);  
  
#write out never claim
    visitmodelbodyNodePak->NeverClaim($modelnum1outputfile,@$NEVER);
    
    return $modelnum1outputfile;
}
#041303 end change

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub MacroGlobalOutput 
{
    my ($self,$outputfile)=@_;  
    open(OUT,">$outputfile");
    
    Put visitmodelbodyNodePak 0,'#define min(x,y) (x<y->x:y)';
    Put visitmodelbodyNodePak 0,'#define max(x,y) (x>y->x:y)';  
    #KS Removed dijkstra definitions ver 7
#    Put visitmodelbodyNodePak 0,'#define up 0';
#    Put visitmodelbodyNodePak 0,'#define down 1';      
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub NeverDefinitionOutput
{
    my ($self,$outputfile,@DEFINES)=@_;
    open(OUT,">>$outputfile");
    
    my $ent;
    foreach $ent (@DEFINES)
    {
        Put visitmodelbodyNodePak 0,$ent;
    }
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub ChanGlobalOutput 
{
    my ($self,$outputfile)=@_;
    open(OUT,">>$outputfile");
    
    Put visitmodelbodyNodePak 0,"chan evq=[10] of {mtype,int};";
    Put visitmodelbodyNodePak 0,"chan evt=[10] of {mtype,int};";
    Put visitmodelbodyNodePak 0,"chan wait=[10] of {int,mtype};";       
    Put visitmodelbodyNodePak 0,""; 
    
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub mtypelistOutput 
{
    my ($self,$outputfile,@mtypelist)=@_;
        
#to form every line has three mtype variables       
    my $ent;
    my @tempoutput; 
    my $string='';
    my $leng=scalar(@mtypelist);
    for ($ent=0; $ent<$leng; ($ent=$ent+1))
    {
        $string=shift(@mtypelist);
        if (scalar(@mtypelist) ne 0)
        {
            push(@tempoutput,"$string, ");
        }
        else
        {
            push(@tempoutput,"$string");
        }
    }
        
    #output the main part
    my @tempoutput1;
    my $divisor=2;
    $mod=scalar(@tempoutput) % $divisor;
    $leng=(scalar(@tempoutput)-$mod)/$divisor;
    my $wholeleng=$leng * $divisor;
    $string=''; my $tempstring='';
    for ($ent=1; $ent<=$wholeleng; $ent=$ent+1)
    {
        $tempstring=shift(@tempoutput);
        $string=$string.$tempstring;
        if (($ent % $divisor) eq 0)
        {
            push(@tempoutput1,$string);
            $string='';
        }
    }
    #output the remaining
    $string='';
    foreach $ent (@tempoutput)
    {
        $string=$string.$ent;
    }
    push(@tempoutput1,$string);
  
#to output @tempoutput to $outputfile
    open(OUT,">>$outputfile");
    Put visitmodelbodyNodePak 0,"mtype={";  
    
    foreach $ent (@tempoutput1)
    {
        Put visitmodelbodyNodePak 0,"        $ent";
    }
    
    Put visitmodelbodyNodePak 0,"};";
        
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub InstVarSignalOutput 
{
    my ($self,$outputfile,@GlobalInstVarSignal)=@_;
    
    open(OUT,">>$outputfile");
    my $ent;
    foreach $ent (@GlobalInstVarSignal)
    {
        Put visitmodelbodyNodePak 0,$ent;
    }
    
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub TokenGlobalOutput 
{
    my ($self,$outputfile)=@_;
    open(OUT,">>$outputfile");
    
#    Put visitmodelbodyNodePak 0,"chan t=[1] of {mtype};";
#    Put visitmodelbodyNodePak 0,"mtype={free};";
#   Put visitmodelbodyNodePak 0;
#   Put visitmodelbodyNodePak 0;
#   Put visitmodelbodyNodePak 0;
#   Put visitmodelbodyNodePak 0;
    
    close (OUT);
}

#reused from SPIN/Context.pm
#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub Driverfile
{
    my ($self,$driverfile)=@_;
    if (open(DRV,"$driverfile"))
    {
        Put visitmodelbodyNodePak 0;
        Put visitmodelbodyNodePak 0,"/* User specified driver file */";
        while ($l = <DRV>)
        {
            chop $l;
            Put visitmodelbodyNodePak 0,$l;
        }
        Put visitmodelbodyNodePak 0;
        close(DRV);
    }   
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub WholeClassOutput 
{
    my ($self,$outputfile,@outputWholeClass)=@_;
    open(OUT,">>$outputfile");
    
    my $ent;
    foreach $ent (@outputWholeClass)
    {
        Put visitmodelbodyNodePak 0,$ent;
    }
    
    close (OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub DispatcherOutput {
    my ($self,$outputfile)=@_;
#SK 10/23/05 Temporarily removed the event dispatcher because ti gives me headaches and has no use
# For Karli: I think you need to figure out what this dispatcher is actually good for. My guess if for some type of internal events
#    open(OUT,">>$outputfile");
#    Put visitmodelbodyNodePak 0;
#    Put visitmodelbodyNodePak 0;
#    Put visitmodelbodyNodePak 0,'/* This is the universal event dispatcher routine */';
#    Put visitmodelbodyNodePak 0,"proctype event(mtype msg)";
#    Put visitmodelbodyNodePak 0,"{";
#    Put visitmodelbodyNodePak 0,"   mtype type;";
#    Put visitmodelbodyNodePak 0,"   int process_id;";
#    Put visitmodelbodyNodePak 0;
#    Put visitmodelbodyNodePak 0,"   atomic {";
#    Put visitmodelbodyNodePak 0,"   do";
#    Put visitmodelbodyNodePak 0,"   :: evq??[eval(msg),process_id] ->";
#    Put visitmodelbodyNodePak 0,"      evq??eval(msg),process_id; ";
#    Put visitmodelbodyNodePak 0,"      evt!msg,process_id;";
#    Put visitmodelbodyNodePak 0,"      do";
#    Put visitmodelbodyNodePak 0,"      :: if";
#    Put visitmodelbodyNodePak 0,"         :: evq??[type,eval(process_id)] -> evq??type,eval(process_id)";
#    Put visitmodelbodyNodePak 0,"         :: else break;";
#    Put visitmodelbodyNodePak 0,"         fi";
#    Put visitmodelbodyNodePak 0,"      od";
#    Put visitmodelbodyNodePak 0,"   :: else -> break";  
#    Put visitmodelbodyNodePak 0,"   od}";
#    Put visitmodelbodyNodePak 0,"exit:skip";
#    Put visitmodelbodyNodePak 0,"}";
#
#    close(OUT);
}

#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
#KS: Added dijkstra process (active!)
sub DijkstraOutput {
    my ($self,$outputfile)=@_;
    open(OUT,">>$outputfile");
    
    Put visitmodelbodyNodePak 0;
    Put visitmodelbodyNodePak 0;
    Put visitmodelbodyNodePak 0,'/* This is the semaphore process */';
    Put visitmodelbodyNodePak 0,"chan sema=[0] of {bit};";
    Put visitmodelbodyNodePak 0;
    Put visitmodelbodyNodePak 0,"typedef dijkstra_T";
    Put visitmodelbodyNodePak 0,"   {";
    Put visitmodelbodyNodePak 0,"       bit free;";
    Put visitmodelbodyNodePak 0,"   }";
    Put visitmodelbodyNodePak 0;
    Put visitmodelbodyNodePak 0,"dijkstra_T dijkstra_V;";
    Put visitmodelbodyNodePak 0;
    #KS: dijkstra process is active from the beginning
    Put visitmodelbodyNodePak 0,"active proctype dijkstra()";
    Put visitmodelbodyNodePak 0,"{";
    Put visitmodelbodyNodePak 0,"        atomic";
    Put visitmodelbodyNodePak 0,"        {";
    Put visitmodelbodyNodePak 0,"            dijkstra_V.free=1;";
    Put visitmodelbodyNodePak 0,"            do";
    Put visitmodelbodyNodePak 0,"            :: (dijkstra_V.free==1) ->";
    Put visitmodelbodyNodePak 0,"                sema!up;";  
    Put visitmodelbodyNodePak 0,"            :: (dijkstra_V.free==0) ->";
    Put visitmodelbodyNodePak 0,"                sema?down; dijkstra_V.free = 1;";
    Put visitmodelbodyNodePak 0,"            od";  
    Put visitmodelbodyNodePak 0,"        }";
    Put visitmodelbodyNodePak 0,"}";
    Put visitmodelbodyNodePak 0;
    close(OUT);
}

#KS 041304 Added timer process
#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
#KS: Timer process is outputted as an active process
sub TimerProcessOutput {
#    my ($self,$outputfile,$GlobalTimerList,$GlobalProcessList)=@_;
#    open(OUT,">>$outputfile");
#    
#    Put visitmodelbodyNodePak 0;
#    Put visitmodelbodyNodePak 0,"/* This is the timer process */";
#    Put visitmodelbodyNodePak 0,"/* It increments timers and unlocks waiting processes */";
#    Put visitmodelbodyNodePak 0,"active proctype Timer()";
#    Put visitmodelbodyNodePak 0,"{";
#    Put visitmodelbodyNodePak 0,"        do";
#    Put visitmodelbodyNodePak 0,"        :: atomic{timeout ->";
#    foreach $ent (@$GlobalTimerList)
#    {   
#        Put visitmodelbodyNodePak 0,"                             if";    
#        Put visitmodelbodyNodePak 0,"                             :: Timer_V.$ent>=0";   
#        Put visitmodelbodyNodePak 0,"                                -> Timer_V.$ent++;";  
#        Put visitmodelbodyNodePak 0,"                             :: else -> skip;";  
#        Put visitmodelbodyNodePak 0,"                             fi;";    
#    }
#    foreach $ent (@$GlobalProcessList)
#    {
#    if($ent ne '_SYSTEMCLASS_')
#        {
#            Put visitmodelbodyNodePak 0,"                             ",$ent,"_V.timerwait=0;";    
#        }
#    }
#    Put visitmodelbodyNodePak 0,"                      }";
#    Put visitmodelbodyNodePak 0,"         od";
#    Put visitmodelbodyNodePak 0,"}";
#    Put visitmodelbodyNodePak 0;
#    close(OUT);
}
#KS 041304 end add
    
#used by visitmodelbodyNodePak.pm/sub OutputmodelbodyNode()
sub NeverClaim
{
    my ($self,$outputfile,@NEVER)=@_;
    open(OUT,">>$outputfile");
    
    my $ent;
    foreach $ent (@NEVER)
    {
        Put visitmodelbodyNodePak 0,$ent;
    }

    close(OUT);
}

1;
