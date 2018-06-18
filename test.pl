#!perl
use strict;
use warnings;

use Test::More;

use_ok("D'oh");

# we use "#'#" to fix syntax highlighting for stupid parsers that do not understand ' as a package separator

my($out, $err);
prep();

sub prep {
    my($outf, $errf) = ('./stdout_temp', './stderr_temp');
    open(SAVEOUT, '>&STDOUT');
    open(SAVEERR, '>&STDERR');

    D'oh::stdout($outf); #'#
    D'oh::date('STDOUT'); #'#
    print "bee!\n"; #'#

    D'oh::stderr($errf); #'#
    D'oh::date(); #'#
    warn "boo!";

    close(STDOUT);
    close(STDERR);

    open(STDOUT, '>&SAVEOUT');
    open(STDERR, '>&SAVEERR');

    open(OLDOUT, $outf) or die $!;
    open(OLDERR, $errf) or die $!;

    while(<OLDOUT>) {$out .= $_}
    while(<OLDERR>) {$err .= $_}

    close(OLDOUT);
    close(OLDERR);

    unlink $outf or die $!;
    unlink $errf or die $!;

    print $out, "\n", $err, "\n";
}

{
	ok(($out =~ /#===/ && $out =~ /==#/), 'output looks right for STDOUT');
    ok(($err =~ /#===/ && $err =~ /==#/), 'output looks right for STDERR');

    ok(($out =~ /$$/), 'PID in STDOUT');
    ok(($err =~ /$$/), 'PID in STDERR');

    ok(($out =~ /bee!/), 'text in STDOUT');
    ok(($err =~ /boo!/), 'text in STDERR');
}

done_testing();

