#!/usr/bin/perl

package AbstractVisitor;

sub new 
{
	my $type=shift();
	my $class = ref($type) || $type;
	my $self = {};
	bless($self, $class);
	return $self;
}

sub visitmodelNode {
}

sub visitmodelbodyNode {
}

sub visitClassNode {
}

sub visitclassbodyNode {
}

sub visitDriverfileNode {
}

sub visitSignalNode {
}

sub visitCCStateNode {
}

sub visitccstatebodyNode {
}

sub visitCStateNode {
}

sub visitcstatebodyNode {
}

sub visitStateNode {
}

sub visitstatebodyNode {
}

sub visitInitNode {
}

sub visitHistoryNode {
}

sub visitJoinNode {
}

sub visitTransNode {
}

sub visitActionNode {
}

sub visitInstVarNode {
}

sub visitNullNode {
}

sub visittransitionbodyNode {
}

sub visiteventNode {
}

sub visittranactionsNode {
}

sub visittranactionNode {
}

sub visitmessagesNode {
}

sub visitmessageNode {
}

return 1;