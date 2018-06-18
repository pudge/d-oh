#!perl
package D::oh;

use strict;
use warnings;

use File::Basename;
use File::Temp;
use File::Spec::Functions 'catfile';

use IO::Handle;
use Carp;

our $VERSION = '1.00';

#-----------------------------------------------------------------
my $ERRFILE = catfile(($ENV{TMPDIR} || File::Temp->tmpdir), 'D\'oh');
my $OUTFILE;

#-----------------------------------------------------------------
sub date {
    my($fh)   = ($_[0] =~ /^STDOUT$/i ? 'STDOUT' : 'STDERR');
    printf $fh "\n#===== %s [$$]: %s =====#\n",
    	($0 =~ /([^$Sep]+)$/), scalar localtime;
	1;
}

#-----------------------------------------------------------------
sub stdout {
	$Out = $_[0] ? $_[0] : ($Out ? $Out : $Err);
	open(STDOUT,">>$Out") || croak("D'oh can't open $Err: $!");
	STDOUT->autoflush(1);
	1;
}
#-----------------------------------------------------------------
sub stderr {
	$Err = $_[0] ? $_[0] : $Err;
	open(STDERR,">>$Err") || croak("D'oh can't open $Err: $!");
	STDERR->autoflush(1);
	1;
}
#-----------------------------------------------------------------
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
