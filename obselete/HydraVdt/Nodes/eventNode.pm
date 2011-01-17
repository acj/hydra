#!/usr/bin/perl

package eventNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    	my $self=shift();
    	my $visitor=shift();
    	$visitor->visiteventNode($self);
}

1;
