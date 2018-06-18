#!perl
package D::oh;

use strict;
use warnings;

use File::Basename;
use File::Spec::Functions qw(catfile tmpdir);

use Carp;
use IO::Handle;
use Time::HiRes 'gettimeofday';

our $VERSION = '1.00';

my $ERRFILE = catfile(($ENV{TMPDIR} || tmpdir), 'D\'oh');
my $OUTFILE;

sub date {
    no strict 'refs';
    my($fh) = ($_[0] && $_[0] =~ /^STDOUT$/i ? 'STDOUT' : 'STDERR');
    my @gt = gettimeofday();
    my @lt = gmtime($gt[0]);
    (my $ss = sprintf('%.03f', '.' . $gt[1])) =~ s/^0\.//;

    printf $fh "\n#===== %s [$$]: %04d-%02d-%02d %02d:%02d:%02d.%sZ =====#\n",
        basename($0), $lt[5]+1900, $lt[4]+1, @lt[3,2,1,0], $ss;
}

sub stdout {
    $OUTFILE = $_[0] if $_[0];
    open(STDOUT, '>>', $OUTFILE) or croak("D'oh can't open $OUTFILE: $!");
    STDOUT->autoflush(1);
}

sub stderr {
    $ERRFILE = $_[0] if $_[0];
    open(STDERR, '>>', $ERRFILE) or croak("D'oh can't open $ERRFILE: $!");
    STDERR->autoflush(1);
}

1;

__END__

=head1 NAME

D'oh - Debug module

=head1 SYNOPSIS

	#!/usr/bin/perl -w
	use D'oh;
	D'oh::stderr();
	D'oh::stderr('/tmp/stderr');

	#print date and script name/pid to STDERR
	D'oh::date();

	#redirect STDOUT	
	D'oh::stdout();
	D'oh::stdout('/tmp/stdout');
	D'oh::date('STDOUT');

	print "hellloooooo\n";
	die "world";

	__END__

	tail /tmp/stdout
	#===== myscript [1743]: Mon Feb  2 11:27:41 1998 =====#
	hellloooooo

	tail /tmp/stderr
	#===== myscript [1743]: Wed Apr  1 11:24:39 1998 =====#
	# world.
	File '/export/home/chrisn/bin/myscript'; Line 15

=head1 DESCRIPTION

The module, when used, prints all C<STDERR> (or C<STDOUT>) to a given file, which is by default C</tmp/D'oh>.

=head1 AUTHOR

Chris Nandor, pudge@pobox.com, http://pudge.net/

Copyright (c) 1998-2018 Chris Nandor.  All rights reserved.  This program is free
software; you can redistribute it and/or modify it under the same terms as
Perl itself.

=head1 VERSION HISTORY

Version 1.00 (2018-06-18)
Version 0.05 (1998-02-02)

=cut
