#!/usr/bin/perl

package HistoryNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitHistoryNode($self);
}

return 1;
