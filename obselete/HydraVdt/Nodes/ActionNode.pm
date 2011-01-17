#!/usr/bin/perl

package ActionNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitActionNode($self);
}

1;
