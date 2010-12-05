#!/usr/bin/perl
package Context;
use Class;

sub OutFile
{
# Save the name of the output file.
    my ($class, $file) = @_;
    $OUTFILE = $file;
}

sub DriverFile
{
# save the driver file name.
    my ($class, $file) = @_;

    $DRIVERFILE = $file;
}

sub Enum
{
# I think I can ignore Enums. We get this info from transitions
    return;
}

sub AddEnum
{
# save the enums we need globally. This is the defintion of mtype. The
# objname is passed just so we can do error checking.

   my ($classname, $objname, $enum) = @_;

   my ($class,$f,$line) = caller;
   Put Log "enum $enum added. $class($line) called me";
   if (exists($enums{$enum}) && $enums{$enum} ne $objname) {
       return;
   }
   $enums{$enum} = $objname
}

sub AddObj
{
# keep a list of classs in the model
    my ($class, $obj) = @_;
    push(@Classs, $obj);
}

sub GetClassRefByName
{
# Find and return the ref to a class by it's ascii name
    my ($class, $cname) = @_;

    foreach $ent (@Classs) {if ($cname eq $$ent{name}) {return $ent}}
    return '';
}

sub GetClassRefList
{
# Return a list of refs to all the classes in the model.
# Used (at least) by State and Cstate for error checking
    return @Classs;
}

sub Open
{
    my ($class, $file) = @_;
    open(OUT, ">$file");
}

sub SetNever
{
    my ($class, $filename) = @_;
# This routine takes a name containing a 1 one LTL claim in hydra format
# (see ltlgram.y). It grabs the claim, parses it, which gives a spin-able
# claim and a symbol table to match to the spinable claim. Next, it
# calls spin -F to get the never claim into Promela, then fetches the
# symbol tables from LTLYacc and builds a set of #defines to make the
# claim work. Along the way, if it find "Class_V.st_state" variable in a define
# it signals ASTWalker to force a In-State variable for that state.

# Get claim and parse
    open(IN, $filename) || die "Can't open never claim file";
    $l = <IN>;    # get never claim
    chop $l;
    close(IN);
    Put Msg(level=>info, msg=> "Building never claim for LTL: $l");
    $claim = LTLYacc->Parse("$l;");
    if (!$claim) {
	Put Msg(level=>error, msg=> 'Never claim has bad syntax');
	exit(1);
    }
# Spinize the claim
    open(TEMP, ">hydratemp.$$") || die "Can't open claim temp file";
    print TEMP $claim;
    close(TEMP);
    if (!open(SPIN, "spin -F hydratemp.$$|")) {
	Put Msg(level=>error, msg=> "Can't run spin!!");
	exit(1);
    }

    while ($l = <SPIN>) {
	chop $l;
	push(@NEVER, $l);
    }
    close(SPIN);
    unlink("hydratemp.$$");

# Get the symbol table from LTL parse. Force state vars.
    my %symtab = LTLYacc->GetDefn;
    foreach $sym (keys %symtab) {
	push(@DEFINES, "#define $symtab{$sym} ($sym)");
	if ($sym =~ /^[A-z_]+\.st_([A-z0-9]+)/) {
	    my $state = $1;
	    ASTWalker->InStateTarget($state);
	}
    }
    Put Msg(level=>info, msg=> "LTL defines\n");
    Put Msg(level=>info, msg=>join("\n", @DEFINES));
    Put Msg(level=>info, msg=> "Never proc:\n");
    Put Msg(level=>info, msg=>join("\n", @NEVER)); 
}

sub Output
{
# This is where the good stuff starts. We need to do the following things:
# 1. write out global mtypes enums
# 2. write out global mtypes for associations
# 3. grab the driverfile and put if out.
# 4. cycle thru the classs in the model calling each's Output
    Put Log "Starting output to $OUTFILE";

    open(OUT, ">$OUTFILE");

    my $ent;

    Put Context 0, '#define min(x,y) (x<y->x:y)';
    Put Context 0, '#define max(x,y) (x>y->x:y)';
    
# Defines for never clauses, if any. See below for the never claim    
    foreach $ent (@DEFINES) {Put Context 0, $ent}

    Put Context 0,"chan evq=[10] of {mtype,int};";
    Put Context 0,"chan evt=[10] of {mtype,int};";
    Put Context 0,"chan wait=[10] of {int,mtype};";
    
    foreach $ent (@Classs) {
	$ent->PreProcess;
    }

# Enums
    my $list = join(', ', keys(%enums));
    Put Context 0, "mtype=\{$list\};";

    foreach $ent (@Classs) {
	$ent->GlobalOutput;
    }
    Put Context 0,"chan t=[1] of {mtype};";
    Put Context 0,"mtype={free};";

# Driverfile:
    if (open(DRV, "$DRIVERFILE.pr")) {
	Put Context 0;
	Put Context 0, "/* User specified driver file  */";
	while ($l = <DRV>) {
	    chop $l;
	    Put Context 0,$l}
	Put Context 0;
	close(DRV);
    }
# Cycle thru classs and get output

    foreach $ent (@Classs) {
	$ent->Output;
    }
    print OUT <<"EOF";

/* This is the universal event dispatcher routine */
proctype event(mtype msg)
{
	mtype type;
	int pid;

	atomic {
	do
	:: evq??[eval(msg),pid] ->
	   evq??eval(msg),pid; 
	   evt!msg,pid;
	   do
	   :: if 
	      :: evq??[type,eval(pid)] -> evq??type,eval(pid)
	      :: else break;
	      fi
	   od
	:: else -> break
	od}
exit:	skip
}	      
EOF

# Write out never claim    
    foreach $ent (@NEVER) {Put Context 0,$ent}

    close(OUT);
}

sub MakeOut
{
    my ($lvl, $txt) = @_;
 
    my ($out,$margin);
    my ($label, $rest);
    ($label,$rest) = $txt =~ /^([A-z0-9]+:)(.*)/s;
    $margin = length($label) > $LEFTMARGIN ? length($label)+1 : $LEFTMARGIN;
    if ($label) {$out =	$label . ' ' x ($margin-length($label)) . $rest}
    else {$out = ' ' x $tab[$lvl] . $txt}
    return $out;
}

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

sub Put
{
# Put (lvl, @list) write a string out indented according to level. If the
# string has a label, is is placed at the left. If the string is over
# 72 chars, it is split to a next line indented at lvl+1. 

# If Put, lvl=0 follows a PutNR, the string is placed on the right
# end of the previous PutNR and if folded, folded at the PutNR lvl+1

# If multiple Puts are req'd, do this: PutNR lvl,text for the first with
# lvl set to what is req'd. The do PutNR 0,text as many times as needed,
# then Put 0,text.
    my ($class, $lvl, @list) = @_;
    
    my $out = MakeOut($lvl, join('', @list));
    $out = $STR ? $STR . $out : $out;
    $lvl = !$lvl && $LASTLVL ? $LASTLVL : $lvl;
    my $lvl2 = $lvl;
    my $x;
    if (length($out) > 72) {
	if ($out =~ /^ +(.+)/) {$out = $1}
	while (length($out) > 72-$tab[$lvl2]) {
	    ($x,$out) = cut($out, 72-$tab[$lvl2]);
	    print OUT ' ' x $tab[$lvl2], "$x\n";
	    $lvl2 = $lvl+1;
	}
	if ($out) {print OUT ' ' x $tab[$lvl2], "$out\n"}
    }
    else {print OUT "$out\n"}
    $STR = '';
    $LASTLVL = 0;
}

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

sub Seq{return $SEQ++}

sub BEGIN
{
    $LEFTMARGIN = 10;
    $INC = 3;
    $tab[0] = 0;
    $tab[1] = $LEFTMARGIN;
    my $i = $LEFTMARGIN + $INC;
    my $j = 2;
    while ($i < 72) {
	$tab[$j++] = $i;
	$i += $INC;
    }
    $SEQ = 1;
}
1;

