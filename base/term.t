#!./perl

BEGIN {
    chdir 't' if -d 't';
}

print "1..7\n";

# check "" interpretation

$x = "\n";
# 10 is ASCII/Iso Latin, 13 is Mac OS, 21 is EBCDIC.
if ($x eq chr(10)) { pass 'ASCII/Iso Latin' }
elsif ($x eq chr(13)) { pass 'Mac OS' }
elsif ($x eq chr(21)) { pass 'EBCDIC' }
else { fail }

# check `` processing

#?v5 todo 'rakudo doesnt support -l option'
$x = `$^X -le "print 'hi there'"`;
ok $x eq "hi there\n", "$^X -le \"print 'hi there'\" eq \"hi there\\n\"";

# check $#array

$x[0] = 'foo';
$x[1] = 'foo';
$tmp = $#x;
#?v5 todo 'retrieving highest array index NYI'
ok $#x == '1', ":$tmp: == :1:";

# check numeric literal

$x = 1;
ok $x == '1';

$x = '1E2';
ok(($x | 1) == 101);

# check <> pseudoliteral

#?v5 2 skip 'typeglobs NYI'
{
    open(try, "/dev/null") || open(try,"nla0:") || (die "Can't open /dev/null.");
    if (<try> eq '') {
        pass;
    }
    else {
        fail;
        die "/dev/null IS NOT A CHARACTER SPECIAL FILE!!!!\n" unless -c '/dev/null';
    }

    open(try, "harness") || (die "Can't open harness.");
    ok <try> ne '';
}
