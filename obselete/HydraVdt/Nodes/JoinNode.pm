#!/usr/bin/perl

package JoinNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitJoinNode($self);
}

return 1;
