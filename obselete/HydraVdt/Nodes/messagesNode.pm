#!/usr/bin/perl

package messagesNode;

use AbstractNode;
our @ISA=("AbstractNode");

sub Accept 
{
    my $self=shift();
    my $visitor=shift();
    $visitor->visitmessagesNode($self);
}

return 1;
