#/usr/bin/perl
#/usr/bin/perl
#!c:\perl\bin
#HydraVdt version 2.6 using discrete time extensions to Promela based on HydraV 08/01/02 by Min
use FindBin qw($RealBin);
use File::Basename;
{
	use lib ( $RealBin, "$RealBin/Universal", "$RealBin/Yacc", "$RealBin/Nodes", "$RealBin/Visitors",
			  "$RealBin/Promela" );    
	use Yacc;
	use AbstractVisitor;
	use TraverseVisitor;
	use ASTErrorCheckerVisitor;
	use AbstractNode;
	use ActionNode;
	use ccstatebodyNode;
	use CCStateNode;
	use classbodyNode;
	use ClassNode;
	use cstatebodyNode;
	use CStateNode;
	use DriverfileNode;
	use eventNode;
	use HistoryNode;
	use InitNode;
	use InstVarNode;
	use JoinNode;
	use messageNode;
	use messagesNode;

	# added 040603 to support timing invariants
	use timeinvariantNode;

	# 040603 end
	use modelbodyNode;
	use modelNode;
	use NullNode;
	use SignalNode;
	use statebodyNode;
	use StateNode;
	use tranactionNode;
	use tranactionsNode;
	use transitionbodyNode;
	use TransNode;
	use ASTINPredVisitorForPromela;
	use ASTStateVisitorForPromela;
	use ASTVisitorForPromela;
	use ExprYaccForPromela;
	use LTLYacc;
	use LTLYaccPak;
	use visitclassbodyNodePak;
	use visitcstatebodyNodePak;
	use visiteventNodePak;
	use visitInitNodePak;
	use visitInstVarNodePak;
	use visitmessageNodePak;
	use visitmodelbodyNodePak;
	use visitSignalNodePak;
	use visitstatebodyNodePak;
	use visitStateNodePak;
	use visittranactionNodePak;

	#print the information
	print("***** Starting HydraVdt v2.94 (10/18/2005)*******\n");
	print("***** Warning: Contains Hack around Process Termination Bug! *******\n");
	print("***** Warning: All processes active! *******\n");

	#analyze the commandline
	if ( @ARGV == 0 ) { ShowOptions() }
	while ( substr( $ARGV[0], 0, 1 ) eq '-' )
	{
		my $switch = shift(@ARGV);
		if ( @ARGV == 0 ) { ShowOptions }
		if ( $switch eq '-N' )
		{
			$NEVERFILE = shift(@ARGV);
		} elsif ( $switch eq '-E' )
		{
			$RUNSPIN = 1;
		} elsif ( $switch eq '-V' )
		{
			$VERIFY = 1;
		} else
		{
			print("Unknown option $ARGV[0]\n");
			ShowOptions();
		}
	}
	if ( $RUNSPIN && $VERIFY )
	{
		print("Error: Specify either -V or -E but not both\n");
		exit(1);
	}

	# All the filename processing... take an extension if given, else look
	# for .hil, then .xyz. Check to make sure file exists before parse.
	$FILENAME = $ARGV[0];
	( $base, $path, $type ) = fileparse( $FILENAME, ( '\.hil', '\.xyz' ) );
	if ( !$type )
	{
		if ( -e $path . $base . '.hil' ) { $type = '.hil' }
		elsif ( -e $path . $base . '.xyz' )
		{
			$type = '.xyz';
			print("The .xyz is deprecated in favor of .hil.\n");
			print(".xyz will go away in future versions.\n");
		} else
		{
			print("$path$base not found with .hil or .xyz extension\n");
			exit(1);
		}
	}
	if ( !( -e $path . $base . $type ) )
	{
		print("Can't find the input file $path$base$type\n");
		exit(1);
	}

	#added 08/01/2002
	print("***** Converting dos format to unix format *****\n");

	#open(OUT,">tempoutfile");
	#my $output = `dos2unix $path$base$type $path$base$type`;   # >& tempoutfile`;
	#`dos2unix $path$base$type $path$base$type`;
	system("dos2unix $path$base$type $path$base$type 1>temp1 2>temp2");
	unlink("temp1");
	unlink("temp2");

	#parse the input file and get the pointer to the root of AST
	my $rootnode = Yacc->Parse( $path . $base . $type );
	if ( $rootnode eq '' )
	{
		exit(1);
	}
	warn("***** Parsing successfully complete! *****\n");

	#Error checking
	my $errorvisitor = new ASTErrorCheckerVisitor;
	$rootnode->Accept($errorvisitor);
	my $anyerror = ASTErrorCheckerVisitor->PassErrorNum;
	if ( $anyerror gt 0 )
	{
		warn("There are some errors in source file \n");
		exit(1);
	}
	warn("***** Checking successfully complete! *****\n");
	ASTVisitorForPromela->PassOutputFileName("$path$base.pr");
	if ($NEVERFILE)
	{
		ASTVisitorForPromela->SetNever($NEVERFILE);
		print("\n Temporal assertion processed");
	}
	my $visitor = new ASTVisitorForPromela;
	$rootnode->Accept($visitor);
	if ($RUNSPIN)
	{
		system("spin $path$base.pr");
	} elsif ($VERIFY)
	{
		system("spin -a $path$base.pr");
		if ($?)
		{
			print("\n Error: spin failed");
			exit(1);
		}
		system("gcc pan.c -o pan");
		if ($?)
		{
			print("\n Error: Compile failed (this is not good).");
			exit(1);
		}
		if ($NEVERFILE) { system("pan -a") }
		else { system("pan") }
	}
}

sub ShowOptions
{
	print <<"EOF";
Usage: perl HydraV [-N neverclaim_file] [-E] inputfile
Where inputfile ends in .xyz extension.
-E runs SPIN in simulation mode
-V runs SPIN in neverclaim verify mode (does compile, etc)
Neverclaim is written using syntax:
[] = always
<> = eventually
Variables: Class.instancevar
IN predicate: in(Class.state)
message sent predicate: sent(Class.msg)
EOF
	exit;
}
