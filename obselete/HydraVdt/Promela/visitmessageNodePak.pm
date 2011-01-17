#!/usr/bin/perl

package visitmessageNodePak;

use UniversalClass;

sub outputThreePartmessage 
{
    my ($class, $msgclassname,$msgsignalname,$msgintvarname,$classref,@outputmessage)=@_;
    
    my $temp1="atomic"."{";
    my $temp2=$msgclassname."_";
    my $temp3=$msgsignalname."_p1!";
    my $ClassParent=$classref->{ID};
    my $temp4=$ClassParent."_V.";
    my $temp5=$msgclassname."_q!";

#test if $msgintvarname is an ID (the first character is [A-Z][a-z]) or a NUM (all characters are [0-9]+)
    my $testtemp=substr($msgintvarname,0,1);    #get the first character in $msgintvarname to test if it a NUM
                            #of course this test is not very complete   
    my $ent;
    my $ifnum=0;
    foreach ($ent=0;$ent<10;$ent++)
    {
        if ($ent eq $testtemp)
        {
            $ifnum=1;
        }
    }
    
    #SK Added  052403 to support negative numbers
    if($testtemp eq '-')
    {
        $ifnum=1;
    }
    #052403 end add
    
    if ($ifnum eq 0)  #$msgintvarname is an ID
    {
#        push(@outputmessage,"        $temp1$temp2$temp3$temp4$msgintvarname; $temp5$msgsignalname};");
# SK 04-04-03
        push(@outputmessage,"        $temp2$temp3$temp4$msgintvarname; $temp5$msgsignalname;");
    }
    else  #$msgintvarname is a NUM
    {
#       push(@outputmessage,"        $temp1$temp2$temp3$msgintvarname; $temp5$msgsignalname};");
#SK 04-04-03
        push(@outputmessage,"        $temp2$temp3$msgintvarname; $temp5$msgsignalname;");
    }
    
    return @outputmessage;
}

sub outputTwoPartmessage 
{
    my ($class, $msgclassname,$msgsignalname,@outputmessage)=@_;
    
    my $temp1=$msgclassname."_q!";
    
    push(@outputmessage,"        $temp1$msgsignalname;");
    
    return @outputmessage;  
}

sub outputOnePartmessage 
{
    my ($class, $msgsignalname,@outputmessage)=@_;
    
    push(@outputmessage,"        run event($msgsignalname);");
    
    return @outputmessage;
}

sub addTomtypelist 
{
    my ($class,$msgsignalname,@mtypelist)=@_;
    
    my $found=0;
    if (scalar(@mtypelist) eq 0)
    {
        push(@mtypelist,$msgsignalname);
        return @mtypelist;
    }
    else
    {
        $found=UniversalClass->ifinarray($msgsignalname,@mtypelist);
    }
    
    if ($found eq 0)
    {
        push(@mtypelist,$msgsignalname);
    }
    
    return @mtypelist;
}

1; 