#!/usr/bin/perl

package classbodyNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitclassbodyNode($self);
}

return 1;
