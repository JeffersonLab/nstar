#
# Take output from extract*svd.pl and flip signs of the opposite charge conjugation entries
#

while(my $line = <STDIN>)
{
  chomp $line;
  my @F = split(/ /, "${line}");
  my $opname = $F[0];
  my $subopname = $F[1];
  my $val = $F[2];

  my $C = +1;

  # Gamma matrices
  if ($subopname =~ /_a0x/ || $subopname =~ /_a1x/ || $subopname =~ /_pionx/ || $subopname =~ /_pion_2x/)
  {
    $C *= +1;
  }
  elsif ($subopname =~ /_b0x/ || $subopname =~ /_b1x/ || $subopname =~ /_rhox/ || $subopname =~ /_rho_2x/)
  {
    $C *= -1;
  }
  else
  {
    die "Unknown gamma matrix structure for op = $subopname\n";
  }

  # Derivatives
  if ($subopname =~ /xD0_/ || $subopname =~ /xD2_J0/ || $subopname =~ /xD2_J2/ || 
      $subopname =~ /xD3_J131/)
  {
    $C *= +1;
  }
  elsif ($subopname =~ /xD1/ || $subopname =~ /xD2_J1/ || 
	 $subopname =~ /xD3_J130/ || $subopname =~ /xD3_J132/)
  {
    $C *= -1;
  }
  else
  {
    die "Unknown gamma matrix structure for op = $subopname\n";
  }

#  printf "%s %s %g   orig= %g\n", ${opname}, ${subopname}, $C*${val}, ${val};
  printf "%s %s %g\n", ${opname}, ${subopname}, $C*${val};
}


