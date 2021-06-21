#!/usr/bin/env perl

use strict;
use warnings;

use IPC::Run qw( run );

my $cmd = qq(dcfldd if=/dev/urandom of=/dev/null bs=2M count=2000);
my @ipc_cmd = qw(dcfldd if=/dev/urandom of=/dev/null bs=2M count=2000);

print "Running as System\n";
system( $cmd );


print "Running as IPC::Run\n";
run \@ipc_cmd or die "Couldn't run command: $?";

