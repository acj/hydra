#!/usr/bin/perl
# added 040603 to support timing invariants
package timeinvariantNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visittimeinvariantNode($self);
}

1;
