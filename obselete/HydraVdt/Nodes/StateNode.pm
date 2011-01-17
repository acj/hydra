#!/usr/bin/perl

package StateNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitStateNode($self);
}

return 1;
