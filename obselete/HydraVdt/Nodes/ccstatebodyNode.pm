#!/usr/bin/perl

package ccstatebodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitccstatebodyNode($self);
}

return 1;
