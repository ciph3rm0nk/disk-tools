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

print "This is a 3-pass disk wiping program. \n
\n
WARNING THIS DESTROYS DATA. \n";

my @choices = choose( $disks_ref, { alignment => 1, prompt => 'Select your disk (/dev/disk/by-id/) :' } );
print "Disks Selected :\n\t @choices\n";

my $disk_path = '/dev/disk/by-id/';
my @disks;
for (@choices) {
	chomp $_;
	push @disks, $disk_path.$_;
}

if (scalar @disks > 0 ) {
	my $confirm_choices_ref = [ 'Yes', 'No' ];
	my $confirmation = choose( $confirm_choices_ref, { prompt => "Are you sure you want to do this ? This will destroy data on the following Disks: \n\t @choices \n" } );
	
	if ($confirmation eq 'Yes') {
		my @ofs;
		my $of_prefix = 'of=';

		for (@disks) {
			chomp $_;
			push @ofs, $of_prefix.$_;
		}

		my $dcfldd_disks = join(' ', @ofs);
		
		system( qq( echo if=/dev/zero $dcfldd_disks conv=notrunc,noerror bs=2M ) );
		system( qq( echo pattern=FF $dcfldd_disks conv=notrunc,noerror bs=2M ) );
		system( qq( echo if=/dev/zero $dcfldd_disks conv=notrunc,noerror bs=2M ) );


	} else {

		die "Disk wipe cancelled by user choice \n";

	}

} else {

	die "No selection made. Exiting...\n";

}