#!/usr/bin/perl

package transitionbodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visittransitionbodyNode($self);
}

return 1;
