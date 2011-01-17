#!/usr/bin/perl

package modelNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitmodelNode($self);
}

return 1;
