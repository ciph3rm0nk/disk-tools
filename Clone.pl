#!/usr/env perl

use strict;
use warnings;
use Term::Choose qw( choose );

# Need to be Root to run DCFLDD
die "Must run as sudo or root\n" if $> != 0;

# Need to have DCFLDD
my $command = qx( which dcfldd ) || qx( which dx3dd );
if (!$command) {
	die "This program needs dxfldd or dx3dd installed.\n You can install it via apt: \n\t \$ sudo apt install dcfldd|dc3dd \n";
}

# Get all of the disks by id (i think its easier to identify than by the classic numberation which can also be inconsistent)

my $disks_ref = [ qx(ls /dev/disk/by-id) ];

my $disk_path = '/dev/disk/by-id/';

