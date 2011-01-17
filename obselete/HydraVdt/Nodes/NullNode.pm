#!/usr/bin/perl

package NullNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitNullNode($self);
}

return 1;
