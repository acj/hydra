#!/usr/bin/perl

package TransNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitTransNode($self);
}

return 1;
