#!/usr/bin/perl

package ClassNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitClassNode($self);
}

return 1;
