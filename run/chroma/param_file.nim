## Parameters

import "config"

type
  HMCParam* = object
    stem*:         string
    lattSize*:     array[0..3,int]
    t_source*:     int
    num_vecs*:     int
    Nt_forward*:   int
    Nt_backward*:  int
    quark_mass*:   string
    gauge_type*:   string
    gauge_file*:   string
    


proc getParams*(arch, seqno: string; t0: int): HMCParam = 
{
  echo "arch= ", arch, "  seqno= ", seqno, "  t0= ", t0
  let stem = getStem()

  # List file containing t0-s
  var list = stem & ".list"
  if not fileExists(list):
    quit("t0 list file= " & $list & "  does not exist")

  # Extract file params
  result.lattSize = extractLattSize(stem)

  let mass_l = "-0.0850"
  let mass_s = "-0.0743"
  let mass_c = "0.092"

  # Find the quark mass
  block:
    let q_file = "quark_mass"
    if not fileExists(q_file):
      quit("quark mass file " & q_file & "  does not exist")
    var tmp = readFile(q_file)
    removeSuffix(tmp)

    if tmp eq "light":
      result.quark_mass = mass_l
    elsif tmp eq "strange":
      result.quark_mass = mass_s
    elsif tmp eq "charm":
      result.quark_mass = mass_c
    else:
      quit("Unknown quark type = " & tmp)

  printf "ARCH = ", arch

  #----------------------------------------
  # Pull off t_sources.
  result.t_source = t0

  #----------------------------------------
  # Vsriables for this run
  result.num_vecs = 162

  result.Nt_backward = 0

  if result.t_source mod 16 == 0:
    result.Nt_forward = 48
  else:
    result.Nt_forward = 1

## HACKS
  if false:
    result.num_vecs = 1
## END OF HACKS

  #----------------------------------------
  # Inputs
  result.gauge_type = "SCIDAC"
  ##result.gauge_type = "WEAK_FIELD"

  let remote_gauge = "${stem}_cfg_${seqno}.lime"
  let remote_eig   = "${stem}.3d.eigs.mod${seqno}"

  let bw_dir = getScratchPath()

  result.gauge_file = "${bw_dir}/$stem/cfgs/${remote_gauge}"
  result.eig_file = "<elem>${bw_dir}/$stem/eigs_mod/${remote_eig}</elem>"
##  result.eig_file = "<elem>${bw_dir}/$stem/tmp_eigs/${seqno}/eigs.t_%d.mod${seqno}</elem>\n"

  #----------------------------------------
  # Outputs
  result.sdb_dir = "${bw_dir}/$stem/prop_db_t0"

  # Quark mass string
  if mass_l == result.quark_mass:
    echo "Run light: t0= ", t_source
    result.quark_string = "light"
  elsif mass_s == result.quark_mass:
    echo "Run strange: t0= ", t_source
    result.quark_string = "strange"
  elsif mass_c == result.quark_mass:
    echo "Run charm: t0= ", t_source
    result.quark_string = "charm"
  else:
    quit("Unknown quark mass = ", result.quark_mass)

  # More files
  result.soln_file = "${stem}.prop.n${num_vecs}.${quark_string}.t0_${t0}.sdb${seqno}"


  #----------------------------------------
  # Run params
  result.beta = 1.5
  result.xi = 3.5
  result.xi_0 = 4.3
  result.nu = 1.265

  result.anisoP = "true"
  result.t_dir = 3
  result.u_s = 0.733566
  result.u_t = 1
  result.u_s_stout = 0.926742
  result.u_t_stout = 1
  result.c_s = 1.589327
  result.c_t = 0.902784

  if mass_l == result.quark_mass:
    echo "Using light parameters"
  elsif mass_s == result.quark_mass:
    echo "Using strange parameters"
  elsif mass_c == result.quark_mass:
    # Charm params override the default params
    echo "Using charm parameters"

    result.nu  = "1.078"
    result.c_s = "1.3545694350"
    result.c_t = "0.7939900651"
    # end of charm params
  else:
    quit("Unknown quark mass = " & result.quark_mass)
  
  result.rho = 0.14
  result.n_smear = 2
  result.orthog_dir = 3

  result.link_smear_type = "STOUT_SMEAR"
  result.link_smear_num = 10
  result.link_smear_fact = 0.1

##  result.SolverType = "BICGSTAB_INVERTER"
  result.RsdCG = 1.0e-8
  result.MaxCG = 10000

  #----------------------------------------
  # Executables
  my $basedir = $main::basedir
  my $builddir = "$ENV{'HOME'}/bin/exe/cuda"

  printf "Builddir = %s\n", $builddir
  printf "Basedir = %s\n", $basedir

  # The system
  if ($arch eq "BW_CPU")
  {
    $nnmpi = `cat $ENV{'PBS_NODEFILE'} | wc -l | awk '{print \$1}'` chomp $nnmpi
    printf "On arch BW_CPU: nnmpi= $nnmpi\n"

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-1.8"
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $ENV{'PBS_NODEFILE'}"

    $numa_script = ""
    print "numa_script = $numa_script\n"

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017"
    $harom_env_vars = ""

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.parscalar.jan_14_2017"
    $chroma_env_vars = ""
  }
  elsif ($arch eq "JLAB_QOPKNL")
  {
    my $hostf = $ENV{'PWD'} . "/hostfile.$$"
    system("cat $ENV{'PBS_NODEFILE'} | awk '{for(i=0i<64++i){print \$1}}' > $hostf")
    system("cat $hostf")

    $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'` chomp $nnmpi

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-2.1"
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $hostf"

    $numa_script = ""
    print "numa_script = $numa_script\n"

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017"
    $harom_env_vars = ""

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.parscalar.jan_14_2017"
    $chroma_env_vars = ""
  }
  elsif ($arch eq "JLAB_KNL")
  {
    $SolverType = "BICGSTAB"
    $Delta = 0.1
    $RsdTarget = $RsdCG = 1.0e-8
    $RsdToleranceFactor = 10
    $MaxIter = $MaxCG = 10000

    $numa_script = ""
    print "numa_script = $numa_script\n"

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017"
    $harom_env_vars = ""

    $chroma_exe = "/home/edwards/bin/exe/ib9q/chroma.scalar.qphix.aug_25_2017"
    $chroma_env_vars = ""
  }
  elsif ($arch eq "NERSC_QPHIX")
  {
    $SolverType = "BICGSTAB"
    $Delta = 0.1
    $RsdTarget = $RsdCG = 1.0e-8
    $RsdToleranceFactor = 10
    $MaxIter = $MaxCG = 10000

    $numa_script = ""
    print "numa_script = $numa_script\n"

    $harom_exe = "$builddir/harom_parscalar.jan_14_2017"
    $harom_env_vars = ""

    $chroma_exe = "/global/homes/r/redwards/bin/exe/ib9q/chroma.cori2.scalar.qphix.aug_28_2017"
    $chroma_env_vars = ""
  }
  elsif ($arch eq "BW_GPU")
  {
    ##$SolverType = "CG"
    $SolverType = "BICGSTAB"
    $CudaSloppyPrecision = "SINGLE"
    $Delta = 0.001
    #$CudaSloppyPrecision = "HALF"
    #$Delta = 0.1

    #$RsdTarget = $RsdCG = 2.5e-8
    ####$RsdTarget = $RsdCG = 5.0e-7
    $RsdTarget = $RsdCG = 1.0e-8
    #$RsdToleranceFactor = 50
    #$RsdToleranceFactor = 100
    $RsdToleranceFactor = 150
    $MaxIter = $MaxCG = 10000

    # BW on cpus
    $run = "env APRUN_BALANCED_INJECTION=64 aprun"

    $numa_script = "./numa_script.sh"
    print "numa_script = $numa_script\n"

    $harom_exe = "$builddir/harom_parscalar.aug_17_2013"
    $harom_env_vars = ""

    my $CUDA_INSTALL_PATH = "/usr/local/cuda-5.0"
    $chroma_env_vars = "-e LD_LIBRARY_PATH=/opt/cray/libsci/12.1.01/GNU/48/interlagos/lib"

##    $chroma_exe = "$builddir/chroma_double_quda_gpu35.sep_12_2013"
    $chroma_exe = "$builddir/chroma_single_quda_qpu35.nov_30_2013"
  }
  elsif ($jlab_gpu eq "JLAB_GPU")
  {
    ##$SolverType = "CG"
    $SolverType = "BICGSTAB"
    $CudaSloppyPrecision = "SINGLE"
    $Delta = 0.001
    #$CudaSloppyPrecision = "HALF"
    #$Delta = 0.1

    #$RsdTarget = $RsdCG = 2.5e-8
    ####$RsdTarget = $RsdCG = 2.5e-7
    $RsdTarget = $RsdCG = 1.0e-8
    $RsdToleranceFactor = 50
    $MaxIter = $MaxCG = 10000

    my $hostf = $ENV{'PWD'} . "/hostfile.$$"
    system("cat $ENV{'PBS_NODEFILE'} | $basedir/trim_hostfile.csh > $hostf")
    system("cat $hostf")

    $nnmpi = `cat $hostf | wc -l | awk '{print \$1}'` chomp $nnmpi

    my $MPIHOME = "/usr/mpi/gcc/mvapich2-1.8"
    $run = "${MPIHOME}/bin/mpirun_rsh -rsh -np $nnmpi -hostfile $hostf"

    $numa_script = ""
    print "numa_script = $numa_script\n"

##    $harom_exe = "$builddir/harom_centos62_dist_parscalar.jul_16_2013"
##    $harom_env_vars = "MV2_ENABLE_AFFINITY=0 OMP_NUM_THREADS=2"

    $harom_exe = "$builddir/harom_centos62_scalar.feb_6_2014"
    $harom_env_vars = ""

#    my $CUDA_INSTALL_PATH = "/usr/local/cuda-5.0"
    my $CUDA_INSTALL_PATH = "/usr/local/cuda-7.0"
    $chroma_env_vars = "MV2_ENABLE_AFFINITY=0 OMP_NUM_THREADS=2 LD_LIBRARY_PATH=/dist/gcc-4.8.2/lib64:/dist/gcc-4.8.2/lib:${CUDA_INSTALL_PATH}/lib64:${CUDA_INSTALL_PATH}/lib"

    if ($sm eq "sm13")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu13_mvapich2.jul_17_2013"
      die "sm13 no longer supported\n"
    }
    elsif ($sm eq "sm20")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu20_mvapich2.jun_16_2014"
##      $chroma_exe = "chroma_double_centos62_gpu20_mvapich2.aug_15_2013"
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016"
      $chroma_exe = "$builddir/chroma_centos65_gpu20_mvapich2.dec_18_2015"
    }
    elsif ($sm eq "sm30")
    {
##      $chroma_exe = "$builddir/chroma_centos62_gpu30_mvapich2.jun_16_2014"
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu30_mvapich2.jun_16_2014"
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016"
      $chroma_exe = "$builddir/chroma_centos65_gpu30_mvapich2.dec_18_2015"
    }
    elsif ($sm eq "sm35")
    {
##    $chroma_exe = "$builddir/chroma_centos62_gpu35_mvapich2.jun_16_2014"
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu30_mvapich2.oct_7_2013"
##      $chroma_exe = "$builddir/chroma_double_centos62_gpu35_mvapich2.jun_16_2014"
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.feb_10_2016"
##      $chroma_exe = "$builddir/chroma_centos65_gpu35_mvapich2.apr_6_2016"
      $chroma_exe = "$builddir/chroma_double_centos65_gpu35_mvapich2.jul_11_2016"
##      $chroma_exe = "$builddir/chroma_double_centos65_gpu35_mvapich2.sep_14_2016"
    }
    else
    {
      die "Unknown SM type = $sm\n"
    }
  }
  else
  {
    die "Unknown in exe: arch = $arch\n"
  }
}
