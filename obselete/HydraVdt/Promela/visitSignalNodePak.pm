package visitSignalNodePak;

use UniversalClass;

#parameters: ($class,$thissignalnode,@GlobaloutputSignal)
sub GlobaloutputSignal {
	my ($class,$thissignalnode,@GlobaloutputSignal)=@_;
	
	my $classname=$thissignalnode->{parent}->{parent}->{ID};
	my $signalname=$thissignalnode->{name};
	my $signaltype=$thissignalnode->{sigtype};
	my $temp1=$classname."_";
	my $temp2=$signalname."_p1";
	push(@GlobaloutputSignal,"chan $temp1$temp2=[5] of {$signaltype};");
	
	return @GlobaloutputSignal;
}

1;