#------------------------------------------------------------------------------
#const platform = "TEST"
#const platform = "OLCF"
#const platform = "NERSC"
#const platform = "TACC"
#const platform = "JLab"
const platform = "21g"

when platform == "OLCF":
  import config_OLCF
elif platform == "NERSC":
  import config_NERSC
elif platform == "TACC":
  import config_TACC
elif platform == "JLab":
  import config_JLab
elif platform == "21g":
  import config_21g
elif platform == "TEST":
  import config_TEST
else:
  quit("unknown platform")

# More imports
import os, xmltree, strutils, tables

import colorvec_work, serializetools/serializexml

import irrep_util
import chroma
import genprop_superb as genprop
#import fermbc, fermstate
import propagator
import sequtils
import inverter


#
# Bury these here unfortunately
const chroma_per_node = 8
const node_cnt        = 1

#------------------------------------------------------------------------------
type
  PathFile_t* = object
    name*:               string
    fileDir*:            string

#type Mom_t = array[0..2,cint]    ## shorthand


#
#------------------------------------------------------------------------------
proc genPath*(file: PathFile_t): string =
  ## Convenience to generate a path
  result = file.fileDir & "/" & file.name

proc genPath*(files: seq[PathFile_t]): seq[string] =
  ## Convenience to generate a path
  result = newSeq[string](0)
  for f in items(files):
    result.add(genPath(f))


#------------------------------------------------------------------------------
# Mass params - need to fix this stuff up to have the datasets and their masses
type
  QuarkMass_t* = object
    clov*:         CloverParams_t
    mass_label*:   string

proc quarkMass*(stem: string, quark: string): QuarkMass_t =
  ## Pull out the mass and label
  case quark:
    of "charm":
      let mass_c =  0.092
      result.clov = newAnisoCharmParams(mass_c)
      
    of "strange":
      let mass_s = -0.0743
      result.clov = newAnisoCloverParams(mass_s)
      
    of "light":
      let mass_l = -0.0840
      result.clov = newAnisoCloverParams(mass_l)

    else:
      quit("Unknown quark = " & quark)

  result.mass_label  = "U" & formatFloat(result.clov.Mass, ffDecimal, 4)




#------------------------------------------------------------------------------
# Time ranges
#
type
  TimeRanges_t* = object
    Nt_forward*:       int
    t_start*:          int
    t_snks*:           seq[int]
  
      
proc getTimeRanges*(): TimeRanges_t =
  ## Generate time ranges
  when platform == "TEST":
    result.t_start    = 0
    result.Nt_forward = 6
    let t_snks = @[2,3,4,5,6]
  else:
    result.t_start    = 0
    result.Nt_forward = 32
    let t_snks = @[24]
#    let t_snks = @[22,26,28,31]
#    let t_snks = @[10,12,14,16,18]

  let t_start = result.t_start
  result.t_snks = map(t_snks, proc(t: int): int = t_start + t)


proc wrapLt*(t0, Lt: int): int =
  ## Wrap time around the lattice
  return (t0 + Lt) mod Lt

 


#------------------------------------------------------------------------------
# Paths to all the various files
type
  RunPaths_t* = object    ## Paths used for running
    stem*:               string
    cache*:              string
    scratch*:            string
    dataDir*:            string
    workDir*:            string
    seqName*:            string
    seqDir*:             string
    run_script*:         string
    cfg_file*:           PathFile_t
    colorvec_files*:     seq[PathFile_t]
    quark*:              string
    mm*:                 QuarkMass_t
    time_ranges*:        TimeRanges_t
    chroma_per_node*:    int
    seqno*:              string
    num_vecs*:           int
    prefix*:             string
    genprop_op_tmp*:     PathFile_t
    input_file*:         PathFile_t
    output_file*:        PathFile_t
    out_file*:           PathFile_t
    genprop_op_file*:    PathFile_t
    

#------------------------------------------------------------------------------
proc constructPathNames*(quark: string, seqno: string, time_ranges: TimeRanges_t): RunPaths_t =
  ## Construct the names for all the various paths
  result.stem        = getStem()
  result.cache       = getEnsemblePath()
  result.num_vecs    = getNumVecs()
  result.scratch     = getScratchPath()
  result.time_ranges = time_ranges
  result.seqno       = seqno

  # Pull out the mass and label
  result.quark      = quark
  result.mm         = quarkMass(result.stem, result.quark)

  # Main paths
  result.dataDir    = result.cache
  result.workDir    = result.scratch
  result.seqName    = result.seqno & "." & formatFloat(result.mm.clov.Mass, ffDecimal, 4) & ".allt"
  result.seqDir     = result.workdir & "/" & result.seqName

  # Files
  result.cfg_file       = PathFile_t(fileDir: result.dataDir & "/cfgs", name: result.stem & "_cfg_" & seqno & ".lime")
  result.colorvec_files = @[PathFile_t(fileDir: result.dataDir & "/eigs_mod", name: result.stem & ".3d.eigs.mod" & seqno)]

  result.prefix          = result.stem & ".genprop.n" & $result.num_vecs & "." & result.quark & ".t_" & $time_ranges.t_start
  for t in items(time_ranges.t_snks):
    result.prefix &= "_" & $t

  result.genprop_op_tmp  = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".sdb" & seqno)
  result.input_file      = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".ini.xml" & seqno)
  result.output_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out.xml" & seqno)
  result.out_file        = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out" & seqno)
  result.genprop_op_file = PathFile_t(fileDir: result.dataDir & "/genprop_db3", name: result.genprop_op_tmp.name)

  result.run_script      = result.seqDir & "/jlab.all.sh"


#------------------------------------------------------------------------------
proc generateChromaXML*(run_paths: RunPaths_t) =
  ## Generate input file and return the path to the expected output file
  # Main paths
  echo "workDir= ", run_paths.workDir
  #createDir(run_paths.workDir)
  if execShellCmd("mkdir -p " & run_paths.workDir) != 0:
    quit("Some error creating " & run_paths.workDir)

  echo "seqDir= ", run_paths.seqDir
  #createDir(run_paths.seqDir)
  if execShellCmd("mkdir -p " & run_paths.seqDir) != 0:
    quit("Some error creating " & run_paths.seqDir)

  # Help with testing
  when platform == "TEST":
    let MaxIter     = 100
    let Rsd         = 1.0e-5
  else:
    let MaxIter     = 10
    let Rsd         = 1.0e-8

  # Common stuff
  let lattSize = extractLattSize(run_paths.stem)
  let tr       = getTimeRanges()
  let Lt       = lattSize[3]
  echo "lattSize= ", lattSize, " ",tr, " ",Lt, " seqno=", run_paths.seqno
    
  let t_origin = getTimeOrigin(Lt, run_paths.seqno)
  let t_start  = wrapLt(tr.t_start+t_origin, Lt)
  let t_snks   = map(tr.t_snks, proc(t: int): int = wrapLt(t+t_origin, Lt))
  let clov     = run_paths.mm.clov

  echo "t_origin = ", t_origin

  var sink_sources = newSeq[SinkSource_t]()

#  # Find the longest plateau
#  var Nt_forward: int
#  for t in items(t_snks):
#    Nt_forward = max(wrapLt(t-t_start,Lt), Nt_forward)

  # Source-source annih
  sink_sources.add(SinkSource_t(t_sink: t_start,
                                t_source: t_start,
                                Nt_backward: 0,
                                Nt_forward: tr.Nt_forward))

  # Sink-* annihilation
  for t in items(t_snks):
    let t_plat = wrapLt(t-t_start,Lt)+1

    # Sink-sink annihilation
    sink_sources.add(SinkSource_t(t_sink: t,
                                  t_source: t,
                                  Nt_backward: t_plat,
                                  Nt_forward: 0))

    # Sink-source annihilation
    sink_sources.add(SinkSource_t(t_sink: t,
                                  t_source: t_start,
                                  Nt_backward: 0,
                                  Nt_forward: t_plat))

  # Smearing
  let link_smearing = colorvec_work.newStandardStoutLinkSmear()

  var displacements: seq[seq[int]] = @[]
  displacements.add(@[])
#  displacements.add(@[3])
#  displacements.add(@[-3])
#  displacements.add(@[3,3])
#  displacements.add(@[-3,-3])
  
  # Generate the pos/neg pairs of canonical mom
  let mom2_min = 0
  let mom2_max = 4
  let canon_moms = irrep_util.generateCanonMoms(cint(mom2_min), cint(mom2_max))
  var moms = newSeq[array[3,int]]()

  for p in items(canon_moms):
    echo "p= ", p
    let pp = [int(p[2]),int(p[1]),int(p[0])]
    moms.add(pp)
    if norm2(p) > 0:
      moms.add([-pp[0],-pp[1],-pp[2]])

  echo "moms= ", moms

  # Only interesting gammas
  var gammas = @[1,2,4,8,9,10,12,0]

  # Build DispGammaMomList
  var disp_gamma_moms = newSeq[DispGammaMom_t]()

  for g in items(gammas):
    for p in items(moms):
      for d in items(displacements):
        disp_gamma_moms.add(DispGammaMom_t(gamma: g, displacement: d, mom: p))


  # That should be enough
  let contract = genprop.Contractions_t(mass_label: run_paths.mm.mass_label,
                                        num_vecs: run_paths.num_vecs,
                                        t_start: t_start,
                                        max_moms_in_contraction: 1,
                                        max_tslices_in_contraction: run_paths.time_ranges.Nt_forward,
                                        use_genprop4_format: true,
                                        use_device_for_contractions: false,
                                        displacement_length: 1,
                                        max_rhs: 8,
                                        decay_dir: 3,
                                        num_tries: 1)
 
  # Fermion action and inverters
  when platform == "OLCF":
    let mg   = newQUDAMGParams24x256()
    let inv  = newQUDAMGInv(Rsd, MaxIter, clov, mg)
    let fermact = newAnisoPrecCloverFermAct(clov)
  elif platform == "NERSC":
    let inv  = newQPhiXMGParams24x256(Rsd, MaxIter, clov)
    let fermact = newAnisoCloverFermAct(clov)
  elif platform == "TACC":
    let inv = newQPhiXMGParams24x256(Rsd, MaxIter, clov)
    let fermact = newAnisoCloverFermAct(clov)
  elif platform == "JLab":
    let inv = newQPhiXMGParams24x256(Rsd, MaxIter, clov)
    let fermact = newAnisoCloverFermAct(clov)
  elif platform == "21g":
    let mg   = newQUDAMGParams24x256()
    let inv  = newQUDAMGInv(Rsd, MaxIter, clov, mg)
    let fermact = newAnisoCloverFermAct(clov)
  elif platform == "TEST":
    let inv = serializeXML(CGInverter_t(invType: "CG_INVERTER", RsdCG: Rsd, MaxCG: MaxIter))
    let fermact = newAnisoCloverFermAct(clov)
  else:
    quit("not allowed")


  # Inline measurement
  let mat_prop      = propagator.newPropagator(fermact, inv)
  let mat_param     = genprop.GenPropParam_t(LinkSmearing: link_smearing,
                                             SinkSourcePairs: sink_sources,
                                             DispGammaMomList: disp_gamma_moms,
                                             Contractions: contract,
                                             Propagator: mat_prop)
  let mat_named_obj = genprop.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: genPath(run_paths.colorvec_files),
                                            dist_op_file: genPath(run_paths.genprop_op_tmp))
  let inline_dist   = genprop.newGenPropSuperbDistillation(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(run_paths.cfg_file), reunit: true, parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(genPath(run_paths.input_file), input)


#------------------------------------------------------------------------------
proc generate21gRunScript*(run_paths: RunPaths_t) =
  ## Generate input file
  # Common stuff
  #let propCheck = "/home/edwards/bin/x86_64-linux/prop_check"

  #SBATCH -o light.o%j
  #SBATCH -t 10:00:00
  #SBATCH --nodes=2
  #SBATCH --ntasks-per-node=8
  #SBATCH -A spectrum21g
  #SBATCH -p 21g
  #SBATCH -J light
  #SBATCH -c 8

  #cd $SLURM_SUBMIT_DIR

  #source /work/JLabLQCD/eromero/chromaform-roc/env.sh

  let queue    = "21g"
  let wallTime = "5:00:00"

  # This particular job
  let mpi_cnt           = node_cnt * chroma_per_node
  let nodes             = node_cnt


  # SBATCH --time-min 4:00:00

  let command = """
#!/bin/tcsh -x
#SBATCH -o light.o%j
#SBATCH -t """ & wallTime & "\n" & """
#SBATCH --nodes=""" & $nodes & "\n" & """
#SBATCH --ntasks-per-node=""" & $chroma_per_node & "\n" & """
#SBATCH -A spectrum21g
#SBATCH -p """ & queue & "\n" & """
#SBATCH -J light
#SBATCH -c 8

cd $SLURM_SUBMIT_DIR

source /work/JLabLQCD/eromero/chromaform-roc/env.sh

rehash

setenv NODEFILE `mktemp`
scontrol show hostnames "${SLURM_JOB_NODELIST}" > ${NODEFILE}
set mpi_cnt="""" & $mpi_cnt & """"

echo nodes
cat ${NODEFILE}

setenv SB_ASYNC_ALLTOALL 0 # avoid bug on openmp
setenv OMP_NUM_THREADS 16
setenv QUDA_ENABLE_P2P 0    # P2P can still have issues so disable
setenv QUDA_ENABLE_GDR 0    # You need a GDR capable MPI for this to work, so disable
setenv SB_LOG 1
setenv SB_TRACK_MEM 1
setenv SB_TRACK_TIME 1
setenv HIP_VISIBLE_DEVICES 0,1,2,3,4,5,6,7
setenv ROCR_VISIBLE_DEVICES 0,1,2,3,4,5,6,7
setenv GPU_DEVICE_ORDINAL 0,1,2,3,4,5,6,7
setenv CUDA_VISIBLE_DEVICES 0,1,2,3,4,5,6,7

rm -f module_* prop* gprop*

echo "host= " `hostname`
echo "procid= $SLURM_JOB_ID"

set input="""" & genPath(run_paths.input_file) & """"
set output="""" & genPath(run_paths.output_file) & """"
set out="""" & genPath(run_paths.out_file) & """"
set genprop_tmp="""" & genPath(run_paths.genprop_op_tmp) & """"
set genprop_op="""" & genPath(run_paths.genprop_op_file) & """"
/bin/rm -f $genprop_tmp

set exe="/work/JLabLQCD/eromero/chromaform-roc/install/chroma-quda-qdp-jit-double-nd4-cmake-superbblas-hip/bin/chroma"

echo "host= " `hostname` > ${out}
echo "procid= " $SLURM_JOB_ID >> ${out}

if (-e $genprop_op) then
  exit 0
endif

# Horrible hack to support bad variable names
set hack="`mktemp`"
cat $input | sed 's/PreSmo/Pre-Smo/g' | sed 's/PostSmo/Post-Smo/g' > $hack

echo "Starting Chroma"
date
mpirun -np ${mpi_cnt} --hostfile ${NODEFILE}  -mca pml ucx -mca btl '^vader,tcp,uct,openib,rocm' -x UCX_NET_DEVICES=mlx5_0:1 $exe -i ${hack} -geom 1 1 2 4 -pool-max-alloc 0 -pool-max-alignment 512 -poolsize 0k >> ${out}
date
echo "End Chroma"

echo "Check output"
xmllint XMLDAT >& /dev/null
set stat=$status

if ($stat != 0) then
  echo "Exiting after some error in ${out}"
  exit 1
endif

if (! -f $genprop_tmp) then 
  echo "Missing genprop= $genprop_tmp"
  exit 1
endif

echo "Check db"
$HOME/bin/x86_64-redhat-linux-gnu/dbkeys $genprop_tmp keys >& /dev/null
set stat=$status

if ($stat != 0) then 
  echo "Moving $genprop_tmp to $genprop_op"
  /bin/mv $genprop_tmp $genprop_op
endif

exit 0

"""

  # Will hopefully remove writing any specific file
  let f = run_paths.run_script
  writeFile(f, command)
  var perm = getFilePermissions(f) + {fpUserExec}
  setFilePermissions(f, perm)



#------------------------------------------------------------------------------
when isMainModule:
  echo "paramCount()= ", paramCount()

  # This vesion assumes the arguments are the pre-existing directories
  echo "paramCount = ", paramCount()
  if paramCount() < 2:
    quit("Usage: exe <quark> [seqno1 .. seqnoN")
    
  let quark = paramStr(1)
  echo "quark= ", quark

#  let stem   = getStem()
  let time_ranges = getTimeRanges()

  # Loop over the sdbs within a dir
  for n in 2..paramCount():
    # Has to be a sensible filename
    let seqno = paramStr(n)
    echo "seqno= ", seqno

    # All the jobs to accumulate
    let run_paths = constructPathNames(quark, seqno, time_ranges)
    echo run_paths
    let outputFile = genPath(run_paths.genprop_op_file)

    # Empty files are bad
    if fileExists(outputFile):
      if getFileSize(outputFile) == 0:
       discard tryRemoveFile(outputFile)

    # Short cut - gauge has to exist
    echo "Cfg= ", genPath(run_paths.cfg_file)
    if not fileExists(genPath(run_paths.cfg_file)): continue

    # If the outputFile does not exist, do the thang!
    echo "outputFile= ", outputFile
    if fileExists(outputFile): continue

    # build input for each directory
    echo "Generate job for prop= ", outputFile
    generateChromaXML(run_paths)

    # Must construct
    generate21gRunScript(run_paths)

    # Either is not or empty, so submit
    let cwd = getCurrentDir()
    setCurrentDir(run_paths.seqDir)

    let f = run_paths.run_script
    echo "Submitting " & f
    if execShellCmd("sbatch " & f) != 0:
      quit("Some error submitting " & f)

    # popd
    setCurrentDir(cwd)
