#!/usr/bin/perl

package CCStateNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitCCStateNode($self);
}

return 1;
