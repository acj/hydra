#!/usr/bin/perl

package AbstractNode;

sub new 
{
    my ($object, $linenum, @arg)=@_;
    my $class = ref($object) || $object;
    
    my $node={object=>undef,linenum=>undef,parent=>undef};

    $node->{object}=$class;
    $node->{linenum}=$linenum;
    while (@arg) {
	my $key = shift(@arg);
	my $val = shift(@arg);
	$$node{$key} = $val;
    }
        
    bless($node, $class);
    if (exists($node->{child}))
    {
    	if ($node->{child} ne '')
    	{
    		my $ent;
    		my $child=$node->{child};
    		foreach $ent (@$child)
    		{	
    			$ent->{parent}=$node;	#assign a parent key to child node
    		}
    	}
    }	
   
    if (exists($node->{event}) && ($node->{event} ne ''))
    {
    	my $event=$node->{event};
    	$event->{parent}=$node;
    }
    if (exists($node->{guard}) && ($node->{guard} ne ''))
    {
    	my $guard=$node->{guard};
    	$guard->{parent}=$node;
    }
    if (exists($node->{actions}) && ($node->{actions} ne ''))
    {
    	my $actions=$node->{actions};
    	$actions->{parent}=$node;
    }
    if (exists($node->{messages}) && ($node->{messages} ne ''))
    {
    	my $messages=$node->{messages};
    	$messages->{parent}=$node;
    }
    if (exists($node->{message}) && ($node->{message} ne ''))
    {    	
    	my $message=$node->{message};
    	$message->{parent}=$node;    	
    }
    if (exists($node->{tran}) && ($node->{tran} ne ''))
    {
    	my $transitionbody=$node->{tran};
    	$transitionbody->{parent}=$node;    	
    }
    
    return $node;
}

sub Accept
{
}

1;
