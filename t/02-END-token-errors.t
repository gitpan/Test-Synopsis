use Test::Builder::Tester tests => 1;
use Test::More;
use Test::Synopsis;

# Test whether we indeed can detect errors in SYNOPSIS codes

test_out('not ok 1 - t/lib/ENDInPodWithError.pm');
test_diag(q{  Failed test 't/lib/ENDInPodWithError.pm'},
    q{  at t/02-END-token-errors.t line } . line_num(+4) . q{.},
    q{Global symbol "$x" requires explicit package name at t/lib/ENDInPodWithError.pm line 30.},
);
synopsis_ok("t/lib/ENDInPodWithError.pm");
test_test("synopsis fail works");
