#!/usr/bin/perl

package DriverfileNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitDriverfileNode($self);
}

return 1;
