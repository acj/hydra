#!/usr/bin/perl

package visittranactionNodePak;

use UniversalClass;
use ExprYaccForPromela;
use ExprYaccForPromelaPak;

#unused now
#inner sub
#used by outputNewAction()
sub CheckClassSemantics 
{
	my ($class,$thetranactionnode)=@_;
	
	my $classname=$thetranactionnode->{content};
	my $returnvalue=UniversalClass->FindGlobalClassNode($classname,$thetranactionnode);
	
	return;
}

#used by ASTVisitorForPromela.pm/sub visittranactionNode
sub outputNewAction 
{
	my ($class, $thetranactionnode, @outputtranaction)=@_;

#Semantics check to see if modelbodyNode have this class name or not
	#visittranactionNodePak->CheckClassSemantics($thetranactionnode);
	my $content=$thetranactionnode->{content};
	push(@outputtranaction,"        run $content();");
		
	return @outputtranaction;		
}

#used by ASTVisitorForPromela.pm/sub visittranactionNode
sub outputAssignment
{
	my ($class,$thetranactionnode,@outputtranaction)=@_;

	my $assignment=$thetranactionnode->{assignment};
	ExprYaccForPromelaPak->PassRef($thetranactionnode);	
	my $returnvalue=ExprYaccForPromela->Parse("$assignment");
        push(@outputtranaction,"        $returnvalue");
        
	return @outputtranaction;
}

#inner sub
#used by sub outputPrintstmt()
#delete some unnecessary blanks
sub SQToDQ
{
	my ($class,$sprintcontent)=@_;

	$sprintcontent=~ s/ ;/;/g;
	$sprintcontent=~ s/\' /\'/g;
	$sprintcontent=~ s/ \(/\(/g;  #left
	$sprintcontent=~ s/ \)/\)/g;  #right
	$sprintcontent=~ s/ \[ /\[/g;  #left
	$sprintcontent=~ s/ \] /\]/g;  #right
	$sprintcontent=~ s/ \:= /\:=/g;
	
	my $leng=length($sprintcontent);
	my $subleng=$leng-2;
	
	my $temp=substr($sprintcontent,1,$subleng);
	my $temp1="\"".$temp;
	my $dprintcontent=$temp1."\"";
	
	return $dprintcontent;
}

#inner sub
#used by sub outputPrintstmt()
sub outputPrintstmtWithParmlist
{
	my ($class,$dprintcontent,$returnvalue,@outputtranaction)=@_;
	
	push(@outputtranaction,"        printf($dprintcontent,$returnvalue);");
	
	return @outputtranaction;
}

#inner sub
#used by sub outputPrintstmt()
#delete some unnecessary blanks
sub outputPrintstmtWithoutParmlist
{
	my ($class,$dprintcontent,@outputtranaction)=@_;
	
	push(@outputtranaction,"        printf($dprintcontent);");
	
	return @outputtranaction;
}

#used by ASTVisitorForPromela.pm/sub visittranactionNode()
sub outputPrintstmt
{
	my ($class,$thetranactionnode,@outputtranaction)=@_;
	
	my $sprintcontent=$thetranactionnode->{printcontent};
	my $dprintcontent=visittranactionNodePak->SQToDQ($sprintcontent);  #single quote mark to double quote mark
	if ($thetranactionnode->{printparmlist} ne '')
	{
		my $printparmlist=$thetranactionnode->{printparmlist};
		ExprYaccForPromelaPak->PassRef($thetranactionnode);
		my $returnvalue=ExprYaccForPromela->Parse("$printparmlist");
               	@outputtranaction
		=visittranactionNodePak->outputPrintstmtWithParmlist($dprintcontent,$returnvalue,@outputtranaction);                	
	}
	else
	{
		@outputtranaction
		=visittranactionNodePak->outputPrintstmtWithoutParmlist($dprintcontent,@outputtranaction);
	}

	return @outputtranaction;
}

#used by ASTVisitorForPromela.pm/sub visittranactionNode()
sub outputFunction
{
	my ($class,$thetranactionnode,@outputtranaction)=@_;

	my $funcID=$thetranactionnode->{funcID};
	my $funcparmlist=$thetranactionnode->{funcparmlist};
	ExprYaccForPromelaPak->PassRef($thetranactionnode);
	my $returnvalue=ExprYaccForPromela->Parse("$funcparmlist");
        push(@outputtranaction,"        $funcID($returnvalue)");
        	
	return @outputtranaction;
}

1;
