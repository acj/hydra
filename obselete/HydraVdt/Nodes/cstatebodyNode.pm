#!/usr/bin/perl

package cstatebodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitcstatebodyNode($self);
}

return 1;
