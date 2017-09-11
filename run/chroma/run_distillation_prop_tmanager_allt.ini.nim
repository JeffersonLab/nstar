#!/usr/bin/perl
#
# Params for run_dist_prop
#
sub params
{
  package HMCParam;

#  local($arch,$seqno) = @_;
  my $arch  = shift(@_);
  my $seqno = shift(@_);
  my $t0    = shift(@_);
 
  printf "arch= $arch  seqno= $seqno  t0= $t0\n";
  $stem = "szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265";

  # List file containing t0-s
  my $list = $stem . ".list";
  die "t0 list file= $list  does not exist\n" unless -f $list;

  # Extract file params
  @nrow = &main::extract_params($stem);

  $mass_l = "-0.0850";
  $mass_s = "-0.0743";
  $mass_c = "0.092";

  # Find the quark mass
##  $quark_mass = $mass_l;
##  $quark_mass = $mass_s;

  if (1)
  {
    my $q_file = "quark_mass";
    die "quark mass file $q_file  does not exist\n" unless -f $q_file;
    my $tmp = `cat $q_file`; chomp $tmp;
    if ($tmp eq "light")
    {
      $quark_mass = $mass_l;
    }
    elsif ($tmp eq "strange")
    {
      $quark_mass = $mass_s;
    }
    elsif ($tmp eq "charm")
    {
      $quark_mass = $mass_c;
    }
    else
    {
      die "Unknown quark type = $tmp\n";
    }
  }

  printf "ARCH = $arch\n";

  #----------------------------------------
  # Pull off t_sources.
  @t_sources = ();
  push(@t_sources, $t0);

  #----------------------------------------
  # Vsriables for this run
  $num_vecs = 162;
  $num_tries = 0;

  $Nt_forward = 1;
  $Nt_backward = 0;

  if (($t_sources[0] % 16) == 0)
  {
   $Nt_forward = 48;
  }

## HACKS
  if (0)
  {
    $num_vecs = 1;
  }
## END OF HACKS

  #----------------------------------------
  # Inputs
  $gauge_type = "SCIDAC";
  ##$gauge_type = "WEAK_FIELD";

  my $remote_gauge = "${stem}_cfg_${seqno}.lime";
  my $remote_eig   = "${stem}.3d.eigs.mod${seqno}";

  my $bw_dir = $ENV{'SCRATCH'};
  #my $bw_dir = "$ENV{'HOME'}/scratch";
  #my $bw_dir = "/scratch";

  $gauge_file = "${bw_dir}/$stem/cfgs/${remote_gauge}";
  $eig_file = "<elem>${bw_dir}/$stem/eigs_mod/${remote_eig}</elem>";
##  $eig_file = "<elem>${bw_dir}/$stem/tmp_eigs/${seqno}/eigs.t_%d.mod${seqno}</elem>\n";

  #----------------------------------------
  # Outputs
  $sdb_dir = "${bw_dir}/$stem/prop_db_t0";
  $save_solnP = "true";

  # Quark mass string
  if ($mass_l == $quark_mass)
  {
    printf "Run light: t0= @t_sources\n";
    $quark_string = "light";
  }
  elsif ($mass_s == $quark_mass)
  {
    printf "Run strange: t0= @t_sources\n";
    $quark_string = "strange";
  }
  elsif ($mass_c == $quark_mass)
  {
    printf "Run charm: t0= @t_sources\n";
    $quark_string = "charm";
  }
  else
  {
    die "Unknown quark mass = $this_mass\n";
  }

  # More files
  $soln_file = "${stem}.prop.n${num_vecs}.${quark_string}.t0_${t0}.sdb${seqno}";


  #----------------------------------------
  # Run params
  $beta = 1.5;
  $xi = 3.5;
  $xi_0 = 4.3;
  $nu = 1.265;

  $anisoP = "true";
  $t_dir = 3;
  $u_s = 0.733566;
  $u_t = 1;
  $u_s_stout = 0.926742;
  $u_t_stout = 1;
  $c_s = 1.589327;
  $c_t = 0.902784;

  if ($mass_l == $quark_mass)
  {
    printf "Using light parameters\n";
  }
  elsif ($mass_s == $quark_mass)
  {
    printf "Using strange parameters\n";
  }
  elsif ($mass_c == $quark_mass)
  {
    # Charm params override the default params
    printf "Using charm parameters\n";

    $nu  = "1.078";
    $c_s = "1.3545694350";
    $c_t = "0.7939900651";
    # end of charm params
  }
  else
  {
    die "Unknown quark mass = $this_mass\n";
  }
  
  $rho = 0.14;
  $n_smear = 2;
  $orthog_dir = 3;

  $link_smear_type = "STOUT_SMEAR";
  $link_smear_num = 10;
  $link_smear_fact = 0.1;

##  $SolverType = "BICGSTAB_INVERTER";
  $RsdCG = 1.0e-8;
  $MaxCG = 10000;

  $plaq_freq = $wilslp_freq = $sf_freq = $eig_freq = 1;

  #----------------------------------------
  # Executables
  my $basedir = $main::basedir;
  my $builddir = "$ENV{'HOME'}/bin/exe/cuda";

  printf "Builddir = %s\n", $builddir;
  printf "Basedir = %s\n", $basedir;

  # The system
  if ($arch eq "BW_CPU")
  {
    $nnmpi = `cat $ENV{'PBS_NODEFILE'} | wc -l | awk '{print \$1}'`; chomp $nnmpi;
    printf "On arch BW_CPU: nnmpi= $nnmpi\n";

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-1.8";
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $ENV{'PBS_NODEFILE'}";

    $numa_script = "";
    print "numa_script = $numa_script\n";

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017";
    $harom_env_vars = "";

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.parscalar.jan_14_2017";
    $chroma_env_vars = "";
  }
  elsif ($arch eq "JLAB_QOPKNL")
  {
    my $hostf = $ENV{'PWD'} . "/hostfile.$$";
    system("cat $ENV{'PBS_NODEFILE'} | awk '{for(i=0;i<64;++i){print \$1;}}' > $hostf");
    system("cat $hostf");

    $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'`; chomp $nnmpi;

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-2.1";
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $hostf";

    $numa_script = "";
    print "numa_script = $numa_script\n";

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017";
    $harom_env_vars = "";

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.parscalar.jan_14_2017";
    $chroma_env_vars = "";
  }
  elsif ($arch eq "JLAB_KNL")
  {
    $SolverType = "BICGSTAB";
    $Delta = 0.1;
    $RsdTarget = $RsdCG = 1.0e-8;
    $RsdToleranceFactor = 10;
    $MaxIter = $MaxCG = 10000;

    $numa_script = "";
    print "numa_script = $numa_script\n";

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017";
    $harom_env_vars = "";

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.scalar.qphix.aug_25_2017";
    $chroma_env_vars = "";
  }
  elsif ($arch eq "NERSC_QPHIX")
  {
    $SolverType = "BICGSTAB";
    $Delta = 0.1;
    $RsdTarget = $RsdCG = 1.0e-8;
    $RsdToleranceFactor = 10;
    $MaxIter = $MaxCG = 10000;

    $numa_script = "";
    print "numa_script = $numa_script\n";

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017";
    $harom_env_vars = "";

    $chroma_exe = "/global/homes/r/redwards/bin/exe/ib9q/chroma.cori2.scalar.qphix.aug_28_2017";
    $chroma_env_vars = "";
  }
  elsif ($arch eq "BW_GPU")
  {
    ##$SolverType = "CG";
    $SolverType = "BICGSTAB";
    $CudaSloppyPrecision = "SINGLE";
    $Delta = 0.001;
    #$CudaSloppyPrecision = "HALF";
    #$Delta = 0.1;

    #$RsdTarget = $RsdCG = 2.5e-8;
    ####$RsdTarget = $RsdCG = 5.0e-7;
    $RsdTarget = $RsdCG = 1.0e-8;
    #$RsdToleranceFactor = 50;
    #$RsdToleranceFactor = 100;
    $RsdToleranceFactor = 150;
    $MaxIter = $MaxCG = 10000;

    # BW on cpus
    $run = "env APRUN_BALANCED_INJECTION=64 aprun";

    $numa_script = "./numa_script.sh";
    print "numa_script = $numa_script\n";

    $harom_exe = "$builddir/harom_parscalar.aug_17_2013";
    $harom_env_vars = "";

    my $CUDA_INSTALL_PATH = "/usr/local/cuda-5.0";
    $chroma_env_vars = "-e LD_LIBRARY_PATH=/opt/cray/libsci/12.1.01/GNU/48/interlagos/lib";

##    $chroma_exe = "$builddir/chroma_double_quda_gpu35.sep_12_2013";
    $chroma_exe = "$builddir/chroma_single_quda_qpu35.nov_30_2013";
  }
  elsif ($jlab_gpu eq "JLAB_GPU")
  {
    ##$SolverType = "CG";
    $SolverType = "BICGSTAB";
    $CudaSloppyPrecision = "SINGLE";
    $Delta = 0.001;
    #$CudaSloppyPrecision = "HALF";
    #$Delta = 0.1;

    #$RsdTarget = $RsdCG = 2.5e-8;
    ####$RsdTarget = $RsdCG = 2.5e-7;
    $RsdTarget = $RsdCG = 1.0e-8;
    $RsdToleranceFactor = 50;
    $MaxIter = $MaxCG = 10000;

    my $hostf = $ENV{'PWD'} . "/hostfile.$$";
    system("cat $ENV{'PBS_NODEFILE'} | $basedir/trim_hostfile.csh > $hostf");
    system("cat $hostf");

    $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'`; chomp $nnmpi;

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-1.8";
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $hostf";

    $numa_script = "";
    print "numa_script = $numa_script\n";

##    $harom_exe = "$builddir/harom_centos62_dist_parscalar.jul_16_2013";
##    $harom_env_vars = "MV2_ENABLE_AFFINITY=0 OMP_NUM_THREADS=2";

    $harom_exe = "$builddir/harom_centos62_scalar.feb_6_2014";
    $harom_env_vars = "";

#    my $CUDA_INSTALL_PATH = "/usr/local/cuda-5.0";
    my $CUDA_INSTALL_PATH = "/usr/local/cuda-7.0";
    $chroma_env_vars = "MV2_ENABLE_AFFINITY=0 OMP_NUM_THREADS=2 LD_LIBRARY_PATH=/dist/gcc-4.8.2/lib64:/dist/gcc-4.8.2/lib:${CUDA_INSTALL_PATH}/lib64:${CUDA_INSTALL_PATH}/lib";

    if ($sm eq "sm13")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu13_mvapich2.jul_17_2013";
      die "sm13 no longer supported\n";
    }
    elsif ($sm eq "sm20")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu20_mvapich2.jun_16_2014";
##      $chroma_exe = "chroma_double_centos62_gpu20_mvapich2.aug_15_2013";
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016";
      $chroma_exe = "$builddir/chroma_centos65_gpu20_mvapich2.dec_18_2015";
    }
    elsif ($sm eq "sm30")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu30_mvapich2.jun_16_2014";
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu30_mvapich2.jun_16_2014";
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016";
      $chroma_exe = "$builddir/chroma_centos65_gpu30_mvapich2.dec_18_2015";
    }
    elsif ($sm eq "sm35")
    {
##    $chroma_exe = "$builddir/chroma_centos62_gpu35_mvapich2.jun_16_2014";
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu30_mvapich2.oct_7_2013";
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu35_mvapich2.jun_16_2014";
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016";
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.apr_6_2016";
      $chroma_exe = "$builddir/chroma_double_centos65_gpu35_mvapich2.jul_11_2016";
##      $chroma_exe = "$builddir/chroma_double_centos65_gpu35_mvapich2.sep_14_2016";
    }
    else
    {
      die "Unknown SM type = $sm\n";
    }
  }
  elsif ($arch eq "TACC")
  {
    # TACC
    $run = "ibrun";
    $proxy_exe = "$builddir/proxy/cml-proxy";
    $harom_exe = "$builddir/harom.parscalar.nov_16_2013";

    $numa_script = "";
    $harom_env_vars = "";
    $chroma_env_vars = "";

    $chroma_avx_exe = "$builddir/chroma.parscalar.s8_avx.nov_13_2013";
    $chroma_mic_exe = "$builddir/chroma.parscalar.s8_mic.nov_13_2013";
  }
  else
  {
    die "Unknown in exe: arch = $arch\n";
  }
}

# Needed by require
1;
