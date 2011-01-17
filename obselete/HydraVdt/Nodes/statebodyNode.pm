#!/usr/bin/perl

package statebodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitstatebodyNode($self);
}

return 1;
