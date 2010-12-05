#!/usr/bin/perl
package Log;

sub Put
{
    my($class, @m) = @_;
    
    ($class, $f, $line) = caller;
    if ($track{$class}) {
	print "$class($line) ". join(' ', @m) . "\n";
    }
}

# Track Log(pkg, pkg, ...)
# This routine accepts package names for log output.
# If Register is not called with the package name, it is not logged

sub Register
{
    my($class, @names) = @_;

    my $name;
    foreach $name (@names) {
	$track{$name} = 1;
    }
}

1;








