#!/usr/bin/perl

package UniversalClass;

#It is used to check if in modelbodyNode there is a ClassNode with $classID
sub FindGlobalClassNode
{
	my ($class,$classID,$thisnode)=@_;
	my $search=$thisnode;	
	while ($search->{object} ne 'modelbodyNode')
	{
		$search=$search->{parent};
	}#now $search->{object} eq "modelbodyNode" 
	
	my $children=$search->{child}; #each child is a ClassNode or DriverfileNode
	my $ent;
	my $found=0;	
	foreach $ent (@$children)
	{
		if ($ent->{ID} eq $classID) #the class with name $classID has been found
		{
			$found=1;
			return $ent;
		}
	}
	
	if ($found eq 0) #$classID has not been found in modelbodyNode
	{
		my $parent=$search->{parent}->{ID};
		#warn "Warning: In modelbodyNode, Class $classID is not defined!";
		return '';
	}	
}

#It is used to check if in a Class there is such kind of var
sub FindGlobalDestNode
{
	my ($class,$classID,$thisnode,$nodetype,$nodeID,$entryname)=@_;
	
	my $search=$thisnode;
	while ($search->{object} ne 'modelbodyNode')
	{
		$search=$search->{parent};
	}#now $search->{object} eq "modelbodyNode" 
	
	my $children=$search->{child}; #each child is a ClassNode or DriverfileNode
	my $ent;
	my $found=0;
	foreach $ent (@$children) 
	{
		if ($ent->{ID} eq $classID) #the class with name $classID has been found
		{
			my $classbody=$ent->{child};
			my @classbodyarray=@$classbody;
			my $kids=shift(@classbodyarray);
			my $classbodychild=$kids->{child};
			my $tempent;			
			foreach $tempent (@$classbodychild)
			{
				if ($tempent->{object} eq $nodetype)
				{
					if ($tempent->{$entryname} eq $nodeID)
					{
						$found=1;
						return $tempent;
					}
				}
			}
		}
	}

	if ($found eq 0) #$nodeID with $nodetype has been found in global class
	{
		my $parent=$search->{parent}->{ID};
		#warn "In Class $parent, $nodetype type variables don't include $nodeID!";
		my $returnvalue='';
		return $returnvalue;
	}
}

#search if a signal has been defined
sub FindLocalDestNode 
{
	my ($class,$thisnode,$nodetype,$nodeID,$entryname)=@_;
	
	my $search=$thisnode;
	while ($search->{object} ne 'classbodyNode')
	{
		$search=$search->{parent};
	}#now $search->{object} eq "classbodyNode"
	
	my $children=$search->{child};
	my $ent;
	my $found=0;
	foreach $ent (@$children)
	{
		if ($ent->{object} eq $nodetype)
		{
			if ($ent->{$entryname} eq $nodeID) #$nodeID with $nodetype has been found in Local class
			{
				$found=1;
				return $ent;								
			}
		}
	}
	
	if ($found eq 0) #$nodeID with $nodetype has not been found in Local class
	{
		my $parent=$search->{parent}->{ID};
		#warn "Warning: In Class $parent, $nodetype type variables don't include $nodeID!";
		my $returnvalue='';
		return $returnvalue;
	}
}

sub IfinParent
{
	my ($class,$parentref,$searchobject,$searchname)=@_;

	my $stmt=$parentref->{child};
	my $ent;

	foreach $ent (@$stmt)
	{
		if (($ent->{object} eq $searchobject) and ($ent->{ID} eq $searchname))
		{
			return 1;
		}
	}

	return 0;
}

#Search for the ref of $desttype
#I used it for searching ClassNode or modelNode
sub SearchUpForDest 
{
	my ($class,$thisnode,$desttype)=@_;
	
	my $search=$thisnode;
	while ($search->{object} ne $desttype)
	{
		$search=$search->{parent};
	}
	
	return $search;  #$search->{object} eq $desttype
}

sub ifinarray
{
	my ($class,$thissignal,@mtypelist)=@_;
	my $ent;
	
	my $found=0;
	if (scalar(@mtypelist) gt 0)
	{		
		foreach $ent (@mtypelist)
		{
			if ($ent eq $thissignal)
			{
				$found=1;
				return $found; #1
			}
		}
	}
	return $found; #0
}


#Functionality: copy the content of $array1 to $array2
#How to call: @array2=UniversalClass->jointwoarrays(\@array1,\@array2);
sub jointwoarrays 
{
	my ($class,$array1,$array2)=@_;
	
	my $ent;
	foreach $ent (@$array1)
	{
		push(@$array2,$ent);
	}
	
	return @$array2;
}

#Functionality: add "," between the elments of this array, 
#\and add type, e.g "int" or "mtype" at the very beginning
sub FormatoutputArrayType 
{
	my ($class,$type,@array)=@_;
	
	my $ent;
	my @tempoutput;	
	my $string='';
	my $leng=scalar(@array);
	for ($ent=0; $ent<$leng; ($ent=$ent+1))
	{
		$string=shift(@array);
		if (scalar(@array) ne 0)
		{
			push(@tempoutput,"$string, ");
		}
		else
		{
			push(@tempoutput,"$string;");
		}
	}	
	
	$string='';
	foreach $ent (@tempoutput)
	{
		$string=$string.$ent;
	}
	
	my $temp="$type ".$string;
	push(@array,$temp);
	
	return @array;
}

#Functionality: add $separate, e.g, ',' or '&&' between the elments of this array, 
#\and add type, e.g "int" or "mtype" at the very beginning
sub FormatoutputArraySeparateType 
{
	my ($class,$type,$separate,@array)=@_;
	
	my $ent;
	my @tempoutput;	
	my $string='';
	my $leng=scalar(@array);
	for ($ent=0; $ent<$leng; ($ent=$ent+1))
	{
		$string=shift(@array);
		if (scalar(@array) ne 0)
		{
			push(@tempoutput,"$string $separate");
		}
		else
		{
			push(@tempoutput,"$string;");
		}
	}	
	
	$string='';
	foreach $ent (@tempoutput)
	{
		$string=$string.$ent;
	}
	
	my $temp="$type ".$string;
	push(@array,$temp);
	
	return @array;	
}

sub printMsg
{
	my ($class,$errororwarn,$Classref,$storcsorccsref,$msg)=@_;
	
	my $object;
        
        if ($storcsorccsref eq '')
	{
		warn("$errororwarn: In Class [$Classref->{ID}], $msg.");
	}
 	else
	{
		if ($storcsorccsref->{object} eq 'StateNode')
		{
			$object='State';
		}
		elsif ($storcsorccsref->{object} eq 'CStateNode')
		{
			$object='CState';
		}
		else #($storcsorccsref->{object} eq 'CCStateNode')
		{
			$object='CCState';
		}
		
		warn("$errororwarn: In Class [$Classref->{ID}], $object [$storcsorccsref->{ID}], $msg.");
	}
}

1;
