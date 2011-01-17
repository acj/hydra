package visitHistoryNodePak;

use UniversalClass;

#called ASTVisitorForPromela.pm/sub visitHistoryNodePak()
sub ResolveDest
{
	my ($class,$thishistorynode,@GlobalHistoryMtype)=@_;

	my $cstatebodyref=UniversalClass->SearchUpForDest($thishistorynode,"cstatebodyNode");
	my $cstateID=$cstatebodyref->{parent}->{ID};
	
	my $stmt=$cstatebodyref->{child};
	my $ent;
	foreach $ent (@$stmt)
	{
		if ($ent->{ID} eq $thishistorynode->{ID})
		{
			if ( ($ent->{object} eq 'StateNode') or ($ent->{object} eq 'CStateNode') or 
			     ($ent->{object} eq 'CCStateNode') )
			{
				my $entID=$ent->{ID};
				if ($ent->{object} eq 'StateNode')
				{
					push(@GlobalHistoryMtype,"mtype H_$cstateID=st_$entID;");
				}
				else
				{
					push(@GlobalHistoryMtype,"mtype H_$cstateID=to_$entID;");	
				}
			}
			
		}
	}
	
	return @GlobalHistoryMtype;	
}

1;