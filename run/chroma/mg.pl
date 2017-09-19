#!/usr/bin/perl

$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

die "Usage: $0 <perl param file> <arch> <seqno>\n" unless @ARGV == 3;

use File::Basename;
$basedir = dirname($0);

$param_file = shift(@ARGV);
$arch       = shift(@ARGV);
$seqno      = shift(@ARGV);

die "Input parameter file= $param_file  does not exist\n" unless -f $param_file;

require "${basedir}/colorvec_work.pl";
require "$param_file";

&params($arch,$seqno);  # Source the parameters. Perl is not strongly typed, so exploit this malfeature.

print "nrow= ", @HMCParam::nrow;
&setup_rng($seqno);

print "Origin= ", $HMCParam::origin;

# Some initalization
if (($arch eq "BW_CPU") || ($arch eq "JLAB_QOPKNL") || ($arch eq "JLAB_KNL"))
{
  chdir($ENV{'PBS_O_WORKDIR'});
}
elsif ($arch eq "BW_GPU")
{
  chdir($ENV{'PBS_O_WORKDIR'});
}
elsif (($arch eq "JLAB_KEPLER") ||
       ($arch eq "JLAB_690") ||
       ($arch eq "JLAB_FERMI") ||
       ($arch eq "JLAB_285"))
{
  my $tmpp = `pwd`; chomp $tmpp;
  printf "Current directory = $tmpp\n";
}
elsif ($arch eq "TACC")
{
  chdir($ENV{'SLURM_SUBMIT_DIR'});
}
else
{
  die "Unknown in init: arch = $arch\n";
}

$scratch_dir = "$ENV{'SCRATCH'}/${HMCParam::stem}/tmp.allt/${seqno}.${HMCParam::quark_mass}.allt";
system("mkdir -p $scratch_dir");

# Tolerance is prop check
$check_tol = 1.0e-3;

# Diags
printf("Number of nodes= %d\n", $HMCParam::num_np);
printf("Number of tasks per t0= %d\n", $HMCParam::num_tasks_per_t0);
printf("Number of sources= %d\n", scalar(@HMCParam::t_sources));
printf("This process id = %d\n", $$);

# Sanity checks
die "Output mod dir  $HMCParam::sdb_dir   not writable\n" unless -d $HMCParam::sdb_dir;

# Parameters are fixed in the input file
($u_s, $u_t, $u_s_stout, $u_t_stout, $c_s, $c_t) = 
  ($HMCParam::u_s, $HMCParam::u_t, $HMCParam::u_s_stout, $HMCParam::u_t_stout, $HMCParam::c_s, $HMCParam::c_t);

printf "beta= %f  u_s= %6.4f  u_t= %6.4f  u_s_stout= %6.4f  u_t_stout= %6.4f  c_s= %6.4f  c_t= %6.4f\n",
  $HMCParam::beta, $u_s, $u_t, $u_s_stout, $u_t_stout, $c_s, $c_t;

&run_quark_mass_allt_cuda();

# Cleanup
##system("/bin/rm -r $scratch_dir");

# Bolt
exit(0);


#------------------------------------------------------------------------------
# Set global values
#
sub run_quark_mass_allt_cuda
{
  # Local
  my $stem = $HMCParam::stem;

  my $tt = "t0_" . $HMCParam::t_sources[0];

  my $input_src  = "${stem}.${tt}.src.ini.xml${seqno}";
  my $output_src = "${stem}.${tt}.src.out.xml${seqno}";
  
  my $eig_db   = "$HMCParam::eig_file";

  # Sanity check
##  die "Eig file $eig_db does not exist\n" unless -f $eig_db;

  #
  # Build chroma input
  #
  my @input_chromas = ();
  my @output_chromas = ();
  my @stdout_chromas = ();
  my @stdout_checks = ();

  my $cnt = 0;
  foreach my $tt (@HMCParam::t_sources)
  {
    my $pref = "${stem}.t0_${tt}";
    my $input_chroma  = "${pref}.prop.ini.xml${seqno}";
    my $output_chroma = "${pref}.prop.out.xml${seqno}";
    my $stdout_chroma = "${pref}.prop.out${seqno}";
    my $stdout_check  = "${pref}.check_prop.out${seqno}";

    my $soln_db  = $scratch_dir . "/" . $HMCParam::soln_files[$cnt];
    unlink($soln_db);

    &print_header_xml($input_chroma);

    if (($arch eq "BW_CPU") || ($arch eq "JLAB_QOPKNL"))
    {
      $stdout_chroma = "$scratch_dir/$stdout_chroma";
      &print_prop_distillation_cpu_mg($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
    }
    elsif ($arch eq "JLAB_KNL")
    {
      $stdout_chroma = "$scratch_dir/$stdout_chroma";
      &print_prop_distillation_qphix($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
    }
    elsif ($arch eq "BW_GPU")
    {
      &print_prop_distillation_gpu($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
    }
    elsif (($arch eq "JLAB_KEPLER") ||
           ($arch eq "JLAB_690") ||
           ($arch eq "JLAB_FERMI") ||
           ($arch eq "JLAB_285"))
    {
      $stdout_chroma = "$scratch_dir/$stdout_chroma";
##      &print_prop_distillation_gpu($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
      &print_prop_distillation_gpu_mg($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
    }
    elsif ($arch eq "TACC")
    {
      if (($cnt % 2) == 0)
      {
        &print_prop_distillation_avx($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
        $stdout_chroma = "${pref}.prop.avx.out${seqno}";
      }
      elsif (($cnt % 2) == 1)
      {
        &print_prop_distillation_mic($eig_db, $soln_db, $HMCParam::quark_mass, $tt, $input_chroma);
        $stdout_chroma = "${pref}.prop.mic.out${seqno}";
      }
    }
    else
    {
      die "Unknown in gen: arch = $arch\n";
    }

    &print_trailer_xml($HMCParam::gauge_type, $HMCParam::gauge_file, $input_chroma);

    $input_chromas[$cnt] = $input_chroma;
    $output_chromas[$cnt] = $output_chroma;
    $stdout_chromas[$cnt] = $stdout_chroma;
    $stdout_checks[$cnt]  = $stdout_check;
    ++$cnt;
  }

  #
  # Run the chroma program
  #
  system("echo 'Here is $scratch_dir'; /bin/ls -lt $scratch_dir");
  if ($arch eq "BW_CPU")
  {
    &run_program_bw_cpu(\@input_chromas, \@output_chromas, \@stdout_chromas);
    &run_check_prop_allt_jlab(\@stdout_checks);
  }  
  elsif ($arch eq "JLAB_QOPKNL")
  {
    &run_program_qop_knl(\@input_chromas, \@output_chromas, \@stdout_chromas);
    &run_check_prop_allt_jlab(\@stdout_checks);
  }
  elsif ($arch eq "JLAB_KNL")
  {
    &run_program_qphix_knl_jlab(\@input_chromas, \@output_chromas, \@stdout_chromas);
    &run_check_prop_allt_jlab(\@stdout_checks);
  }  
  elsif ($arch eq "BW_GPU")
  {
    &run_program_bw_gpu(\@input_chromas, \@output_chromas, \@stdout_chromas);
  }  
  elsif ($arch eq "JLAB_KEPLER")
  {
    &run_program_jlab_gpu_mg(\@input_chromas, \@output_chromas, \@stdout_chromas);
    &run_check_prop_allt_jlab(\@stdout_checks);
  }  
  elsif (($arch eq "JLAB_690") ||
         ($arch eq "JLAB_FERMI") ||
         ($arch eq "JLAB_285"))
  {
    &run_program_jlab_gpu(\@input_chromas, \@output_chromas, \@stdout_chromas);
    &run_check_prop_allt_jlab(\@stdout_checks);
  }  
  elsif ($arch eq "TACC")
  {
    &run_program_tacc_cpu(\@input_chromas, \@output_chromas, \@stdout_chromas);
  }
  else
  {
    die "Unknown in run: arch = $arch\n";
  }


  #
  # Check for files
  #
  for(my $cnt = 0; $cnt < scalar(@HMCParam::t_sources); ++$cnt)
  {
    my $soln_db  = $scratch_dir . "/" . $HMCParam::soln_files[$cnt];

    # First check the xml file
    # If an error, then skip this file
    my $err = &flag_xml($output_chromas[$cnt]);
    if ($err != 0) {next;}

    # Check the xml output
    &test_xml(&gzip($output_chromas[$cnt]));

    # Check the sdb files - this test is superceded by the more string check_prop() test
#    &test_sdb($soln_db);

    # Check the prop
##    my $check_err = &check_prop("U${HMCParam::quark_mass}", ${HMCParam::num_vecs}, $check_tol, $soln_db);
##    $check_err >>= 8;
##
##    if ($check_err >= 2)
##    {
##      die "CHECK_PROP: this prop is failing sum or worse: err= $check_err\n";
##    }
##    elsif ($check_err == 1)
##    {
##      printf "CHECK_PROP: this prop has matelem errors\n";
##    }
##    else
##    {
##      printf "CHECK_PROP: okay\n";
##    }

    # Check for the sdb file
    if (! -f $soln_db) {next;}

    # Check for result of DB test. If okay, then copy back
    my $checks = `grep 'CHECK_PROP:' $stdout_checks[$cnt] | head -1`; chomp($checks);

    if ($checks eq "CHECK_PROP: okay")
    {
	# Copy back solution files
	printf "Copy solution files back to $HMCParam::sdb_dir\n";
	&copy_back_lustre($HMCParam::sdb_dir, $soln_db);
    }
    else
    {
	# Copy back solution files
	printf "Problem with peram for t0= %d\n", $HMCParam::t_sources[$cnt];
    }
  }
}


#------------------------------------------------------------------------
# Run the program
sub run_program_bw_cpu
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  # Build script
  my $tmp_script = "run.chroma.$$.sh";

##  my $nmpi = 8;
##  die "Number of tasks=$nmpi not the expected number\n" unless ($nmpi == $HMCParam::num_tasks_per_t0);

  my $nmpi = $HMCParam::num_tasks_per_t0;

  my $GEOM = "-geom 2 2 2 8";
  my $IOGEOM = "-iogeom 1 2 2 4";
  my $QMPGEOM = "-qmp-geom 2 2 2 8";
  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  print "Run = $run";
  print "MPI options = $mpi_options";
  print "Chroma options = $chroma_options";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;

  my $cnt = 0;
  print "Before ${exe}: ", `date`;
  my $exe_str = "$run ${HMCParam::chroma_env_vars}  ${exe}  -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${GEOM} ${IOGEOM} > $stdout_chromas[$cnt] 2>&1";
  print $exe_str,"\n";
  my $err = 0xffff & system("$exe_str < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

##  die "Output file missing = $output\n" unless -f "$output";
}


#------------------------------------------------------------------------
# Run the program
sub run_program_bw_gpu
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  my $gpu_sm = "sm35";
  my $quda_path = "./resource_${gpu_sm}";
  if (! -d $quda_path) {mkdir($quda_path);}

  # Build script
  my $tmp_script = "run.chroma.$$.sh";

  my $nmpi = $HMCParam::num_tasks_per_t0;
  die "Number of tasks=$nmpi not divisible by 16\n" unless (($nmpi % 16) == 0);
  my $my_nmpi = $nmpi / 16;

  my $GEOM = "-geom 1 1 1 $my_nmpi";
  my $IOGEOM = "-iogeom 1 1 1 $my_nmpi";
  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  open(SCRIPT, "> $tmp_script");
  print SCRIPT<<EOF;
#!/bin/bash

source /opt/modules/default/init/bash
module unload PrgEnv-cray
module unload cray-mpich2
module unload cray-libsci
module unload gcc

module load PrgEnv-gnu
module load cray-libsci/12.1.3
module load cray-mpich/6.2.0
module load gcc/4.8.2

module unload cudatoolkit
module load cudatoolkit

export MPICH_RANK_REORDER_METHOD=1 
export OMP_NUM_THREADS=2
export QUDA_RESOURCE_PATH="${quda_path}"

EOF

  close(SCRIPT);

  for(my $cnt = 0; $cnt < scalar(@HMCParam::t_sources); ++$cnt)
  {
    open(SCRIPT, ">> $tmp_script");
    printf SCRIPT "aprun -n ${my_nmpi} -d 16 ${HMCParam::chroma_env_vars} ${exe}  -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${GEOM} ${IOGEOM} > $stdout_chromas[$cnt] 2>&1 &\n";
    close(SCRIPT);
  }

  open(SCRIPT, ">> $tmp_script");
  printf SCRIPT "\nwait\n";
  close(SCRIPT);

  ### Finished with script
  print "Run = $run";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  print "Before ${exe}: ", `date`;
  my $err = 0xffff & system("chmod +x $tmp_script; sh $tmp_script < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

##  die "Output file missing = $output\n" unless -f "$output";
}


#------------------------------------------------------------------------
# Run the program
sub run_program_tacc_cpu
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  die "Chroma avx exe= $HMCParam::chroma_avx_exe does not exist\n" unless -x $HMCParam::chroma_avx_exe;
  die "Chroma mic exe= $HMCParam::chroma_mic_exe does not exist\n" unless -x $HMCParam::chroma_mic_exe;

  # Build script
  my $tmp_script = "run.chroma.$$.sh";

  my $GEOM = "-geom 1 1 1 32";
  my $IOGEOM = "";
  my $num_proc = scalar(@HMCParam::t_sources);
  die "Number of processes not 2\n" unless ($num_proc == 2);

  open(SCRIPT, "> $tmp_script");
  print SCRIPT<<EOF;
#!/bin/bash

#source environment
. /opt/apps/lmod/lmod/init/bash
module unload mvapich2
module load intel/13.1.1.163
module load impi/4.1.1.036
module list

# Start the proxy
export PPN=1
echo Starting Proxy
export OMP_NUM_THREADS=1
export KMP_AFFINITY=proclist=[15],explicit
ibrun ${HMCParam::proxy_exe} > output_proxy 2>&1 &
sleep 1

echo Starting CPU Job
export OMP_NUM_THREADS=15
export KMP_AFFINITY=compact
export I_MPI_EAGER_THRESHOLD=8192
ibrun "${HMCParam::chroma_avx_exe} -i $input_chromas[0]  -o $output_chromas[0] ${GEOM}" > $stdout_chromas[0] 2>&1 & 
sleep 4

echo Starting MIC Job
export MIC_I_MPI_EAGER_THRESHOLD=8192
export MIC_OMP_NUM_THREADS=240
export MIC_PPN=1
export MIC_KMP_AFFINITY=compact,granularity=thread
export MIC_LD_PRELOAD=$ENV{'HOME'}/bin/exe/cuda/proxy/libcml.so
ibrun.symm -m "${HMCParam::chroma_mic_exe} -i $input_chromas[1] -o $output_chromas[1] ${GEOM}" > $stdout_chromas[1] 2>&1 &

wait
EOF

  close(SCRIPT);
  system("chmod +x $tmp_script");

  ### Finished with script
  print "Run = $run";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  print "Before ${exe}: ", `date`;
  my $err = 0xffff & system("$tmp_script < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

##  die "Output file missing = $output\n" unless -f "$output";
}


#------------------------------------------------------------------------
# Run the program
sub run_check_prop_allt_bw
{
  my $tmpp;
  $tmpp = shift(@_);
  my @stdout_checks = @{$tmpp};

  # Build script
  my $tmp_script = "run.check_prop.$$.sh";

  open(SCRIPT, "> $tmp_script");
  print SCRIPT<<EOF;
#!/bin/bash

export OMP_NUM_THREADS=1
export MPICH_RANK_REORDER_METHOD=1 
EOF

  close(SCRIPT);

  my $exe = "$basedir/check_prop.pl";

  # Tolerance is prop check
# my $check_tol = 1.0e-3;

  for(my $cnt = 0; $cnt < scalar(@HMCParam::t_sources); ++$cnt)
  {
    my $pref = $HMCParam::stem . ".t0_" . $HMCParam::t_sources[$cnt];

    my $soln_db  = $scratch_dir . "/" . $HMCParam::soln_files[$cnt];
    my $quark_mass = "U${HMCParam::quark_mass}";

    open(SCRIPT, ">> $tmp_script");
    printf SCRIPT "aprun -n 1  ${exe} $quark_mass ${HMCParam::num_vecs} $check_tol $soln_db > $stdout_checks[$cnt] 2>&1 &\n";
    close(SCRIPT);
  }

  open(SCRIPT, ">> $tmp_script");
  printf SCRIPT "\nwait\n";
  close(SCRIPT);

  ### Finished with script
  print "Run = $run";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  print "Before ${exe}: ", `date`;
  my $err = 0xffff & system("chmod +x $tmp_script; sh $tmp_script < /dev/null");
  print "After ${exe}: ", `date`;
}


#------------------------------------------------------------------------
# Run the jlab program
sub run_program_jlab_gpu
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  my $numa_script = "$HMCParam::numa_script";

  my $quda_path = "${pwd}/resource_${gpu_sm}";
  if (! -d $quda_path) {mkdir($quda_path);}


  my $nmpi = $HMCParam::num_tasks_per_t0;
  die "Number of tasks=$nmpi not divisible by 4\n" unless (($nmpi % 4) == 0);
  my $my_nmpi = $nmpi / 4;

#  my $hostf = $ENV{'PWD'} . "/hostfile.$$";
#  system("cat $ENV{'PBS_NODEFILE'} | $basedir/trim_hostfile.csh > $hostf");
#  system("cat $hostf");

#  my $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'`; chomp $nnmpi;

  my $GEOM = "-geom 1 1 1 $HMCParam::nnmpi";
  my $IOGEOM = "-iogeom 1 1 1 $HMCParam::nnmpi";
  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  print "SM = $gpu_sm";
  print "Run = $run";
  print "MPI options = $mpi_options";
  print "Chroma options = $chroma_options";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  my $cnt = 0;
  print "Before ${exe}: ", `date`;
  my $exe_str = "$run ${HMCParam::chroma_env_vars}  ${exe}  -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${GEOM} ${IOGEOM} > $stdout_chromas[$cnt] 2>&1";
  print $exe_str,"\n";
  my $err = 0xffff & system("$exe_str < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

  die "Output file missing = $output\n" unless -f $stdout_chromas[$cnt];
}

#------------------------------------------------------------------------
# Run the jlab program
sub run_program_jlab_gpu_mg
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  my $numa_script = "$HMCParam::numa_script";

  my $quda_path = "${pwd}/resource_${gpu_sm}";
  if (! -d $quda_path) {mkdir($quda_path);}


  my $nmpi = $HMCParam::num_tasks_per_t0;
  die "Number of tasks=$nmpi not divisible by 4\n" unless (($nmpi % 4) == 0);
  my $my_nmpi = $nmpi / 4;

#  my $hostf = $ENV{'PWD'} . "/hostfile.$$";
#  system("cat $ENV{'PBS_NODEFILE'} | $basedir/trim_hostfile.csh > $hostf");
#  system("cat $hostf");

#  my $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'`; chomp $nnmpi;

  my $GEOM = "-geom 1 1 2 8";
  my $IOGEOM = "-iogeom 1 1 1 8";
  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  print "SM = $gpu_sm";
  print "Run = $run";
  print "MPI options = $mpi_options";
  print "Chroma options = $chroma_options";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  my $cnt = 0;
  print "Before ${exe}: ", `date`;
  my $exe_str = "$run ${HMCParam::chroma_env_vars}  ${exe}  -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${GEOM} ${IOGEOM} > $stdout_chromas[$cnt] 2>&1";
  print $exe_str,"\n";
  my $err = 0xffff & system("$exe_str < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

  die "Output file missing = $output\n" unless -f $stdout_chromas[$cnt];
}

#------------------------------------------------------------------------
# Run the program
sub run_check_prop_allt_jlab
{
  my $tmpp;
  $tmpp = shift(@_);
  my @stdout_checks = @{$tmpp};

  my $exe = "$basedir/check_prop.pl";

  # Tolerance is prop check
# my $check_tol = 1.0e-3;

  for(my $cnt = 0; $cnt < scalar(@HMCParam::t_sources); ++$cnt)
  {
    my $soln_db  = $scratch_dir . "/" . $HMCParam::soln_files[$cnt];
    my $quark_mass = "U${HMCParam::quark_mass}";

    print "Before ${exe}: ", `date`;
    my $err = 0xffff & system("${exe} $quark_mass ${HMCParam::num_vecs} $check_tol $soln_db > $stdout_checks[$cnt] 2>&1");
    print "After ${exe}: ", `date`;
  }
}





#------------------------------------------------------------------------
# Run the qop knl program
sub run_program_qop_knl
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  my $nnmpi = `cat $ENV{'PBS_NODEFILE'} | wc -l | awk '{print \$1}'`; chomp $nnmpi;

  my $GEOM = "-geom 2 2 2 8";
  my $IOGEOM = "-iogeom 1 2 2 4";
  my $QMPGEOM = "-qmp-geom 2 2 2 8";
  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  print "Run = $run";
  print "MPI options = $mpi_options";
  print "Chroma options = $chroma_options";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  my $cnt = 0;
  print "Before ${exe}: ", `date`;
  my $exe_str = "$run ${HMCParam::chroma_env_vars}  ${exe}  -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${GEOM} ${IOGEOM} > $stdout_chromas[$cnt] 2>&1";
  print $exe_str,"\n";
  my $err = 0xffff & system("$exe_str < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

  die "Output file missing = $output\n" unless -f $stdout_chromas[$cnt];
}


#------------------------------------------------------------------------
# Run the qphix knl program
sub run_program_qphix_knl_jlab
{
  ##local($input, $output) = @_;
  my $tmpp;
  $tmpp = shift(@_);
  my @input_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @output_chromas = @{$tmpp};
  $tmpp = shift(@_);
  my @stdout_chromas = @{$tmpp};

  my $run = $HMCParam::run;
  my $exe = $HMCParam::chroma_exe;
  die "Chroma exe= $exe does not exist\n" unless -x $exe;

  my $QPHIXVARS = "-by 4 -bz 4 -pxy 0 -pxyz 0 -c 64 -sy 1 -sz 2 -minct 1 -poolsize 64";
  my $nnmpi = `cat $ENV{'PBS_NODEFILE'} | wc -l | awk '{print \$1}'`; chomp $nnmpi;

  my $num_proc = scalar(@HMCParam::t_sources);

  die "Number of processes not divisible into number of cores\n" unless (($num_np % $num_proc) == 0);

  print "Run = $run";
  print "MPI options = $mpi_options";
  print "Chroma options = $chroma_options";
  print "Host = ", `hostname`;
  print "Chroma exe = ", $exe;
  
  my $cnt = 0;
  print "Before ${exe}: ", `date`;
  my $exe_str = "source ${basedir}/env_qphix.sh; export KMP_AFFINITY=compact,granularity=thread ;export KMP_PLACE_THREADS=1s,64c,2t ; $run ${HMCParam::chroma_env_vars} ${exe} -i $input_chromas[$cnt] -o $output_chromas[$cnt] ${QPHIXVARS} > $stdout_chromas[$cnt] 2>&1";
  print $exe_str,"\n";
  my $err = 0xffff & system("$exe_str < /dev/null");
  print "After ${exe}: ", `date`;

#  if ($err > 0x00)
#  {
#    print "Some error running $exe";
#    exit(1);
#  }

  die "Output file missing = $output\n" unless -f $stdout_chromas[$cnt];
}


