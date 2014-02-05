use Test::Builder::Tester tests => 1;
use Test::More;
use Test::Synopsis;

# Test whether we indeed can detect errors in SYNOPSIS codes

test_out('not ok 1 - t/lib/BrokenSYNOPSIS01.pm');
test_diag(q{  Failed test 't/lib/BrokenSYNOPSIS01.pm'},
    q{  at t/01-fail-if-SYNOPSIS-has-errors.t line } . line_num(+4) . q{.},
    q{syntax error at t/lib/BrokenSYNOPSIS01.pm line 18, near "** ZOMG"},
);
synopsis_ok("t/lib/BrokenSYNOPSIS01.pm");
test_test("synopsis fail works");
