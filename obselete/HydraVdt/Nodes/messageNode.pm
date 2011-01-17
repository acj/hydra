#!/usr/bin/perl

package messageNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitmessageNode($self);
}

return 1;
