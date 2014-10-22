# NAME

Test::Synopsis - Test your SYNOPSIS code

# SYNOPSIS

    # xt/synopsis.t (with Module::Install::AuthorTests)
    use Test::Synopsis;
    all_synopsis_ok();

    # Or, run safe without Test::Synopsis
    use Test::More;
    eval "use Test::Synopsis";
    plan skip_all => "Test::Synopsis required for testing" if $@;
    all_synopsis_ok();

# DESCRIPTION

Test::Synopsis is an (author) test module to find .pm or .pod files
under your _lib_ directory and then make sure the example snippet
code in your _SYNOPSIS_ section passes the perl compile check.

Note that this module only checks the perl syntax (by wrapping the
code with `sub`) and doesn't actually run the code, __UNLESS__
that code is a `BEGIN {}` block or a `use` statement.

Suppose you have the following POD in your module.

    =head1 NAME

    Awesome::Template - My awesome template

    =head1 SYNOPSIS

    use Awesome::Template;

    my $template = Awesome::Template->new;
    $tempalte->render("template.at");

    =head1 DESCRIPTION

An user of your module would try copy-paste this synopsis code and
find that this code doesn't compile because there's a typo in your
variable name _$tempalte_. Test::Synopsis will catch that error
before you ship it.

# VARIABLE DECLARATIONS

Sometimes you might want to put some undeclared variables in your
synopsis, like:

    =head1 SYNOPSIS

    use Data::Dumper::Names;
    print Dumper($scalar, \@array, \%hash);

This assumes these variables like _$scalar_ are defined elsewhere in
module user's code, but Test::Synopsis, by default, will complain that
these variables are not declared:

    Global symbol "$scalar" requires explicit package name at ...

In this case, you can add the following POD sequence elsewhere in your POD:

    =for test_synopsis
    no strict 'vars'

Or more explicitly,

    =for test_synopsis
    my($scalar, @array, %hash);

Test::Synopsis will find these `=for` blocks and these statements are
prepended before your SYNOPSIS code when being evaluated, so those
variable name errors will go away, without adding unnecessary bits in
SYNOPSIS which might confuse users.

# SKIPPING TEST FROM INSIDE THE POD

You can use a `BEGIN{}` block in the `=for test_synopsis` to check for
specific conditions (e.g. if a module is present), and possibly skip
the test.

If you `die()` inside the `BEGIN{}` block and the die message begins
with sequence `SKIP:` (note the colon at the end), the test
will be skipped for that document.

    =head1 SYNOPSIS

    =for test_synopsis BEGIN { die "SKIP: skip this pod, it's horrible!\n"; }

      $x; # undeclared variable, but we skipped the test!

    =end

# EXPORTED SUBROUTINES

## `all_synopsis_ok`

    all_synopsis_ok();

    all_synopsis_ok( dump_all_code_on_error => 1 );

Checks the SYNOPSIS code in all your modules. Takes __optional__
arguments as key/value pairs. Possible arguments are as follows:

### `dump_all_code_on_error`

    all_synopsis_ok( dump_all_code_on_error => 1 );

Takes true or false values as a value. __Defaults to:__ false. When
set to a true value, if an error is discovered in the SYNOPSIS code,
the test will dump the entire snippet of code it tried to test. Use this
if you want to copy/paste and play around with the code until the error
is fixed.

The dumped code will include any of the `=for` code you specified (see
["VARIABLE DECLARATIONS"](#variable-declarations) section above) as well as a few internal bits
this test module uses to make SYNOPSIS code checking possible.

__Note:__ you will likely have to remove the `#` and a space at the start
of each line (`perl -pi -e 's/^#\s//;' TEMP_FILE_WITH_CODE`)

## `synopsis_ok`

    use Test::More tests => 1;
    use Test::Synopsis;
    synopsis_ok("t/lib/NoPod.pm");

Lets you test a single file. __Note:__ you must setup your own plan if
you use this subroutine (e.g. with `use Test::More tests => 1;`)

# CAVEATS

This module will not check code past the `__END__` token, if one is
present in the SYNOPSIS code.

This module will execute any code you specify in the `BEGIN {}` blocks
in the SYNOPSIS.

If you're using HEREDOCs in your SYNOPSIS, you will need to place
the ending of the HEREDOC at the same indent as the
first line of the code of your SYNOPSIS.

# REPOSITORY

Fork this module on GitHub:
[https://github.com/zoffixznet/Test-Synopsis](https://github.com/zoffixznet/Test-Synopsis)

# BUGS

To report bugs or request features, please use
[https://github.com/zoffixznet/Test-Synopsis/issues](https://github.com/zoffixznet/Test-Synopsis/issues)

If you can't access GitHub, you can email your request
to `bug-Test-Synopsis at rt.cpan.org`

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

Goro Fuji blogged about the original idea at
[http://d.hatena.ne.jp/gfx/20090224/1235449381](http://d.hatena.ne.jp/gfx/20090224/1235449381) based on the testing
code taken from [Test::Weaken](https://metacpan.org/pod/Test::Weaken).

# MAINTAINER

Zoffix Znet <cpan (at) zoffix.com>

# CONTRIBUTORS

- Kevin Ryde ([KRYDE](https://metacpan.org/author/KRYDE))
- Marcel Grünauer ([MARCEL](https://metacpan.org/author/MARCEL))
- Mike Doherty ([DOHERTY](https://metacpan.org/author/DOHERTY))
- Zoffix Znet ([ZOFFIX](https://metacpan.org/author/ZOFFIX))

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# COPYRIGHT

This library is Copyright (c) Tatsuhiko Miyagawa

# SEE ALSO

[Test::Pod](https://metacpan.org/pod/Test::Pod), [Test::UseAllModules](https://metacpan.org/pod/Test::UseAllModules), [Test::Inline](https://metacpan.org/pod/Test::Inline)
