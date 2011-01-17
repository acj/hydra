#!/usr/bin/perl

package visitInitNodePak;

#Called by ASTVisitorForPromela.pm/sub visitInitNode()
#$found means how many Initial stmts this classbodyNode has. 
#More than a warning will be generated.
sub ResolveDest 
{
    my ($class,$thisinitnode,$myparenttype,@outputInit)=@_;

    my $thisparent=$thisinitnode->{parent};
    while ($thisparent->{object} ne $myparenttype)
    {
        $thisparent=$thisparent->{parent};
    }
    my $thechild=$thisparent->{child};
    
    my $found=0;
    my $ent;    
    foreach $ent (@$thechild) 
    {
        if ($ent->{ID} eq $thisinitnode->{ID}) 
        {
            if ($ent->{object} eq 'CStateNode')
            {
                $found=$found+1;
                push(@outputInit,"        goto (exit1) to_$thisinitnode->{ID}; skip;};");
                goto LABLE;
            }
            elsif ($ent->{object} eq 'CCStateNode')
            {
                $found=$found+1;
                push(@outputInit,"        goto  (exit2) to_$thisinitnode->{ID}; skip;};");
                goto LABLE;             
            }
            #special treatment for cstates
            elsif ($ent->{object} eq 'StateNode' && $thisinitnode->{parent}->{object} eq 'cstatebodyNode')
            {
                $found=$found+1;
				#push(@outputInit,"        startCState: ");
                push(@outputInit,"        goto  $thisinitnode->{ID}; skip;};");
                goto LABLE;
            }       
            elsif ($ent->{object} eq 'StateNode' && $thisinitnode->{parent}->{object} ne 'cstatebodyNode')
            {
                $found=$found+1;
                push(@outputInit,"        goto  $thisinitnode->{ID}; skip;};");
                goto LABLE;
            }     
        }
    }

LABLE:  return @outputInit;
}

1; 