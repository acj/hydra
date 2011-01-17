#!/usr/bin/perl

package modelbodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitmodelbodyNode($self);
}

return 1;
