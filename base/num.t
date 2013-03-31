#!./perl

print "1..53\n";

# First test whether the number stringification works okay.
# (Testing with == would exercise the IV/NV part, not the PV.)

ok 1       eq "1",  '1 eq "1"';
ok -1      eq "-1", '-1 eq "-1"';

ok 1.      eq "1";
ok -1.     eq "-1";

ok 0.1     eq "0.1";
ok -0.1    eq "-0.1";
ok .1      eq "0.1";
ok -.1     eq "-0.1";
ok 10.01   eq "10.01";

ok 1e3     eq "1000",  '1e3     eq "1000"';
ok 10.01e3 eq "10010", '10.01e3 eq "10010"';

ok 0b100   eq "4";
ok 0100    eq "64";
ok 0x100   eq "256";
ok 1000    eq "1000";

# more hex and binary tests below starting at 51

# Okay, now test the numerics.
# We may be assuming too much, given the painfully well-known floating
# point sloppiness, but the following are still quite reasonable
# assumptions which if not working would confuse people quite badly.

# Keep the stringification as a potential troublemaker.
ok "1" + 1 == 2;
# Don't know how useful printing the stringification of $a + 1 really is.
ok "-1" + 1 == 0;

#?v5 2 skip 'trailing dot within strings NYI'
ok "1." + 1 == 2;
ok "-1." + 1 == 0;

sub _ok { # Can't assume too much of floating point numbers.
    my ($a, $b, $c) = @_;
    abs($a - $b) <= $c;
}

ok _ok("0.1" + 1,  1.1,  0.05);
ok _ok("-0.1" + 1,  0.9,  0.05);
ok _ok(".1" + 1,  1.1,  0.005);
ok _ok("-.1" + 1,  0.9,  0.05);
ok _ok("10.01" + 1, 11.01, 0.005);

ok "1e3" + 1 == 1001;
ok "10.01e3" + 1 == 10011;

ok "0b100" + 1 == 0b101;
#?v5 todo 'octal number in string not treaded as such'
ok "0100" + 1 == 0101;
ok "0x100" + 1 == 0x101;
ok "1000" + 1 == 1001;

# back to some basic stringify tests
# we expect NV stringification to work according to C sprintf %.*g rules

if ($^O eq 'os2') { # In the long run, fix this.  For 5.8.0, deal.
    ok 0.01 eq "0.01"   || 0.01 eq '1e-02';
    ok 0.001 eq "0.001"  || 0.001 eq '1e-03';
    ok 0.0001 eq "0.0001" || 0.0001 eq '1e-04';
} else {
    ok 0.01 eq "0.01";
    ok 0.001 eq "0.001";
    ok 0.0001 eq "0.0001";
}

#?v5 1 todo 'NYI'
ok 0.00009 eq "9e-05" || 0.00009 eq "9e-005";
ok 1.1 eq "1.1";
ok 1.01 eq "1.01";
ok 1.001 eq "1.001";
ok 1.0001 eq "1.0001";
ok 1.00001 eq "1.00001";
ok 1.000001 eq "1.000001";
ok 0. eq "0";
ok 100000. eq "100000";
ok -100000. eq "-100000";
ok 123.456 eq "123.456";

unless ($^O eq 'posix-bc') {
    ok 1e34 eq "1e+34" || 1e34 eq "1e+034";
}
else {
    skip "skipped on $^O";
}

# see bug #15073

ok 0.00049999999999999999999999999999999999999 <= 0.0005000000000000000104;

if ($^O eq 'ultrix' || $^O eq 'VMS') {
  # Ultrix enters looong nirvana over this. VMS blows up when configured with
  # D_FLOAT (but with G_FLOAT or IEEE works fine).  The test should probably
  # make the number of 0's a function of NV_DIG, but that's not in Config and 
  # we probably don't want to suck Config into a base test anyway.
  skip "skipped on $^O";
} else {
  ok 0.00000000000000000000000000000000000000000000000000000000000000000001 > 0;
}

ok 80000.0000000000000000000000000 == 80000.0;

ok 1.0000000000000000000000000000000000000000000000000000000000000000000e1 == 10.0;

# From Math/Trig - number has to be long enough to exceed at least DBL_DIG

ok _ok(57.295779513082320876798154814169*10,572.95779513082320876798154814169,1e-10);

# Allow uppercase base markers (#76296)

ok 0Xabcdef eq "11259375";
ok 0XFEDCBA eq "16702650";
ok 0B1101   eq "13";
