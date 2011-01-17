#!/usr/bin/perl

package CStateNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitCStateNode($self);
}

return 1;
