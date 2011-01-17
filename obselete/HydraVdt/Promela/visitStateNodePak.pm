#!/usr/bin/perl

package visitStateNodePak;

use UniversalClass;

sub EmptyStateOutput 
{
    my ($class,@outputState)=@_;

#    push(@outputState,"        atomic {if :: !t?[free] -> t!free :: else skip fi;}");
    push(@outputState,"        }");
    push(@outputState,"        if");
    push(@outputState,"        :: skip -> false");
    push(@outputState,"        fi;");
    
    return @outputState;    
}

1; 