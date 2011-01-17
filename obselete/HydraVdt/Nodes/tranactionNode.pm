#!/usr/bin/perl

package tranactionNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visittranactionNode($self);
}

return 1;
