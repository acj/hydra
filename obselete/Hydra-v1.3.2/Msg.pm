#!/usr/bin/perl
package Msg;

# This class issues informative (we hope), error and warning messages.
# There are only class methods

sub BEGIN
{
    $ERRS = 0;
}

sub Put
{
    my ($class, %p) = @_;

    my $e = '';
    if ($p{level} eq 'error') {
	$e = 'ERROR';
	$ERRS++;
    }
    elsif ($p{level} eq 'warn') {$e = 'Warning'}
    $p{class} = $p{class} ? "Class: [$p{class}]" : '';
    $p{state} = $p{state} ? "State: [$p{state}]" : '';
    $p{cstate} = $p{cstate} ? "CState: [$p{cstate}]" : '';
    $p{ccstate} = $p{ccstate} ? "CState wrapper: [$p{ccstate}]" : '';
    print "**** $e $p{class} $p{state}$p{cstate}$p{ccstate} $p{msg}\n";
}
	
sub Errors
{
    return $ERRS;
}
1;
