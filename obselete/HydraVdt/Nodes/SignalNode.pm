#!/usr/bin/perl

package SignalNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitSignalNode($self);
}

return 1;
