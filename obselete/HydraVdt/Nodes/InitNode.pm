#!/usr/bin/perl

package InitNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitInitNode($self);
}

return 1;
