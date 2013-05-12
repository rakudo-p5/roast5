#!./perl

BEGIN {
    chdir 't' if -d 't';
    @INC = qw(. ../lib);
}

require "test.pl";
plan( tests => 4 );

use strict;
use warnings;

my $start = time;
my $sleep_says = sleep 3;
my $diff = time - $start;

ok( $sleep_says >= 2,  'Sleep says it slept at least 2 seconds' );
ok( $sleep_says <= 10, '... and no more than 10' );

ok( $diff >= 2,  'Actual time diff is at least 2 seconds' );
ok( $diff <= 10, '... and no more than 10' );
