#!/usr/bin/perl

package tranactionsNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visittranactionsNode($self);
}

return 1;
