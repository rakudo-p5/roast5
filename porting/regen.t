#!./perl -w

# Verify that all files generated by perl scripts are up to date.

BEGIN {
    @INC = '..' if -f '../TestInit.pm';
}
use TestInit qw(T A); # T is chdir to the top level, A makes paths absolute
use strict;

require 'regen/regen_lib.pl';
require 't/test.pl';
$::NO_ENDING = $::NO_ENDING = 1;

if ( $^O eq "VMS" ) {
  skip_all( "- regen.pl needs porting." );
}

my $in_regen_pl = 23; # I can't see a clean way to calculate this automatically.
my @files = qw(perly.act perly.h perly.tab keywords.c keywords.h uconfig.h);
my @progs = qw(Porting/makemeta regen/regcharclass.pl regen/mk_PL_charclass.pl);

plan (tests => $in_regen_pl + @files + @progs);

OUTER: foreach my $file (@files) {
    open my $fh, '<', $file or die "Can't open $file: $!";
    1 while defined($_ = <$fh>) and !/Generated from:/;
    if (eof $fh) {
	fail("Can't find 'Generated from' line in $file");
	next;
    }
    my @bad;
    while (<$fh>) {
	last if /ex: set ro:/;
	unless (/^(?: \* | #)([0-9a-f]+) (\S+)$/) {
	    chomp $_;
	    fail("Bad line in $file: '$_'");
	    next OUTER;
	}
	my $digest = digest($2);
	note("$digest $2");
	push @bad, $2 unless $digest eq $1;
    }
    is("@bad", '', "generated $file is up to date");
}

foreach (@progs, 'regen.pl') {
  system "$^X $_ --tap";
}
