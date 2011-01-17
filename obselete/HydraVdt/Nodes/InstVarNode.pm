#!/usr/bin/perl

package InstVarNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitInstVarNode($self);
}

return 1;
