#!/usr/bin/perl

die "Usage: $0 <Lt> <traj>" unless scalar(@ARGV) == 2;

my $Lt   = shift(@ARGV);
my $traj = shift(@ARGV);

$traj =~ s/[a-zA-Z]//;
#printf "$traj\n";

srand($traj);

# Call a few to clear out junk
foreach $i (1..20) {
  rand(1.0);
}

# Displace the origin of the time slices
printf STDOUT "%d\n", int(rand($Lt));
  
