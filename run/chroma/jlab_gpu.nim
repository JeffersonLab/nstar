## Generate prop jobs

import os, xmltree, strutils

import colorvec_work, serializetools/serializexml
import config

import chroma
import prop_and_matelem_distillation_harom as matelem
import harom_peram_chroma as peram
import fermbc, fermstate
import inverter
import clover_fermact
import propagator


const basedir = strip(staticExec("pwd"))
echo "basedir= ", basedir

#const platform = "OLCF"
#const platform = "NERSC"
#const platform = "TACC"
const platform = "JLAB_GPU"

type
  PathFile_t* = object
    name*:               string
    fileDir*:            string


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
let mass_s = -0.0743
let mass_l = -0.0856

type
  QuarkMass_t* = object
    mass*:         float
    mass_label*:   string

proc quarkMass*(stem: string, quark: string): QuarkMass_t =
  # Pull out the mass and label
  case quark:
    of "strange":
      result.mass = mass_s
      
    of "light":
      result.mass = mass_l

    else:
      quit("Unknown quark = " & quark)

  result.mass_label  = "U" & formatFloat(result.mass, ffDecimal, 4)




#------------------------------------------------------------------------------
# Paths to all the various files
type
  RunPaths_t* = object    ## Paths used for running
    stem*:             string
    cache*:            string
    scratch*:          string
    dataDir*:          string
    workDir*:          string
    seqName*:          string
    seqDir*:           string
    cfg_file*:         PathFile_t
    colorvec_files*:   seq[PathFile_t]
    quark*:            string
    mm*:               QuarkMass_t
    seqno*:            string
    num_vecs*:         int
    prefix*:           string
    prop_op_tmp*:      PathFile_t
    input_file*:       PathFile_t
    peram_files*:      seq[PathFile_t]
    output_file*:      PathFile_t
    out_file*:         PathFile_t
    check_file*:       PathFile_t
    prop_op_file*:     PathFile_t
    prop_op_file_check*: PathFile_t
    prop_op_file_done*:  PathFile_t
    

#------------------------------------------------------------------------------
proc constructPathNames*(t0: string): RunPaths_t =
  ## Construct the names for all the various paths
  result.stem     = getStem()
  result.cache    = getEnsemblePath()
  result.num_vecs = getNumVecs()
  result.scratch  = getScratchPath()

  # shortcuts
  let stem    = result.stem
  let cache   = result.cache
  let scratch = result.scratch

  result.quark = readFile("quark_mass")
  removeSuffix(result.quark)

  result.seqno = readFile("list")
  removeSuffix(result.seqno)
  let seqno = result.seqno

  # Pull out the mass and label
  result.mm = quarkMass(result.stem, result.quark)

  # Main paths
  result.dataDir    = cache
  result.workDir    = scratch
  result.seqName    = result.seqno & "." & formatFloat(result.mm.mass, ffDecimal, 4) & ".allt"
  result.seqDir     = result.workdir & "/" & result.seqName

  # Files
  result.cfg_file       = PathFile_t(fileDir: result.dataDir & "/cfgs", name: stem & "_cfg_" & seqno & ".lime")
  result.colorvec_files = @[PathFile_t(fileDir: result.dataDir & "/eigs_mod", name: stem & ".3d.eigs.mod" & seqno)]

  result.prefix         = stem & ".prop.n" & $result.num_vecs & "." & result.quark & ".t0_" & t0 
  result.prop_op_tmp    = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".sdb" & seqno)
  result.input_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".ini.xml" & seqno)
  result.output_file    = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out.xml" & seqno)
  result.out_file       = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out" & seqno)
  result.check_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".check" & seqno)

  result.prop_op_file       = PathFile_t(fileDir: result.dataDir & "/prop_db_t0", name: result.prop_op_tmp.name)
  result.prop_op_file_check = PathFile_t(fileDir: result.dataDir & "/prop_db_t0.check", name: result.prop_op_tmp.name)
  result.prop_op_file_done  = PathFile_t(fileDir: result.dataDir & "/prop_db_t0.done", name: result.prop_op_tmp.name)

  result.peram_files = @[]
  for n in 1..24:
    #result.peram_files.add(PathFile_t(fileDir: result.seqDir, name: stem & ".peram" & $n & "." & result.quark & ".t0_" & t0 & ".ini.xml" & seqno))
    result.peram_files.add(PathFile_t(fileDir: result.seqDir, name: "peram" & $n & ".ini.xml"))

  echo "scratch= ", scratch
  echo "dataDir= ", result.dataDir
  echo "workDir= ", result.workDir
  echo "seqDir= ", result.seqDir
  echo "prop_op_file= ", result.prop_op_file
  echo "input_file= ", result.input_file

#------------------------------------------------------------------------------
proc generateChromaXML*(t0: int, run_paths: RunPaths_t) =
  ## Generate input file and return the path to the expected output file
  let mass        = run_paths.mm.mass

  # Main paths
  echo "workDir= ", run_paths.workDir
  #createDir(run_paths.workDir)
  echo "seqDir= ", run_paths.seqDir
  discard existsOrCreateDir(run_paths.seqDir)

  # Common stuff
  let Rsd         = 1.0e-8
  let MaxIter     = 8

  let lattSize = extractLattSize(run_paths.stem)
  let Lt = lattSize[3]
  let t_origin = getTimeOrigin(Lt, run_paths.seqno)

  var (Nt_forward, Nt_backward) = if t0 mod 16 == 0: (48, 0) else: (1, 0)

  let nodes_per_cn = 8
  var fifo: seq[string]
  for n in 1..24:
     fifo.add("/tmp/harom-cmd" & $n)

  # Used by distillation input
  let contract = matelem.Contractions_t(mass_label: run_paths.mm.mass_label,
                                        num_vecs: run_paths.num_vecs,
                                        t_sources: @[(t0 + t_origin + Lt) mod Lt],
                                        Nt_forward: Nt_forward,
                                        Nt_backward: Nt_backward,
                                        decay_dir: 3,
                                        num_tries: -1,
                                        nodes_per_cn: nodes_per_cn,
                                        do_inversions: true,
                                        check_results: false,
                                        cache_eigs: true,
                                        fifo: fifo)

 
  # Fermion action and inverters
  when platform == "OLCF":
    let mg  = newQUDAMGParams24x256()
    let inv = newQUDAMGInv(mass, Rsd, MaxIter, mg)
    let fermact = newAnisoPrecCloverFermAct(mass)
  elif platform == "NERSC":
    let inv = newQPhiXMGParams24x256(mass, Rsd, MaxIter)
    let fermact = newAnisoCloverFermAct(mass)
  elif platform == "TACC":
    let inv = newQPhiXMGParams24x256(mass, Rsd, MaxIter)
    let fermact = newAnisoCloverFermAct(mass)
  elif platform == "JLAB_GPU":
    let mg  = newQUDAMGParams24x256()
    let inv = newQUDAMGInv(mass, Rsd, MaxIter, mg)
    let fermact = newAnisoSEOPrecCloverFermAct(mass)
  else:
    quit("not allowed")


  # Inline measurement
  let mat_named_obj = matelem.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: genPath(run_paths.colorvec_files),
                                            prop_op_file: genPath(run_paths.prop_op_tmp))
  let mat_prop      = newPropagator(fermact, inv)
  let mat_param     = matelem.DistParams_t(Contractions: contract, Propagator: mat_prop)
  let inline_dist   = matelem.newPropAndMatelemDistillationHarom(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(run_paths.cfg_file), reunit: true, parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  writeFile(genPath(run_paths.input_file), xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma")))

  # Harom peram inline measurement
  for n in 1..24:
    let peram_named_obj = peram.NamedObject_t(fifo: fifo[n-1])
    let inline_peram = peram.newHaromPeramChroma(peram_named_obj)
    var harom_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_peram])
    let harom_xml = chroma.Harom_t(Param: harom_param)
    writeFile(genPath(run_paths.peram_files[n-1]), xmlHeader & xmlToStr(serializeXML(harom_xml, "harom")))


#-----------------------------------------------------------------------------
# Types need for submitter
type
  PandaJob_t* = object
    nodes*:            int
    walltime*:         string
    queuename*:        string
    outputFile*:       string
    command*:          string

  PandaSubmitter_t* = object
    campaign*:         string
    jobs*:             seq[PandaJob_t]


#------------------------------------------------------------------------------
proc generateJLabGPURunScript*(t0: int): string =
  ## Generate input file
  # Common stuff
  let propCheck = "/home/edwards/bin/x86_64-redhat-linux-gnu/prop_check"
  let shm_script = "/home/edwards/qcd/git/bw.3/scripts_rge/run/chroma/run.shm.sh"

  let queue    = "normal"
  let wallTime = "6:00:00"

  # This particular job
  let run_paths = constructPathNames($t0)
  let seqDir    = run_paths.seqDir

  var exe = """
#!/bin/bash
#SBATCH -n 16
#SBATCH -N 2
#SBATCH -p gpu
#SBATCH -A Spectrumg
#SBATCH -t 10:00:00

source /usr/share/Modules/init/bash
module load gcc-6.3.0
module load mvapich2-2.3
module load cuda-10.0

module list

cd $SLURM_SUBMIT_DIR

CHROMA=/home/fwinter/bin/exe/chroma.shm.19g
HAROM=/home/fwinter/bin/exe/harom.shm.19g
REMOVE=/home/fwinter/bin/exe/remove_fifo.sh

export OMP_NUM_THREADS=2
export CUDA_DEVICE_MAX_CONNECTIONS=1
export QUDA_RESOURCE_PATH=$SLURM_SUBMIT_DIR
export MV2_ENABLE_AFFINITY=0
export QUDA_ENABLE_DEVICE_MEMORY_POOL=0

hostfile=$(mktemp "hostfile.XXXXX")
/usr/bin/scontrol show hostnames $SLURM_JOB_NODELIST > ${hostfile}

date

npid=0

mpiexec -launcher=rsh -genvall -n 2 -ppn 1 -hostfile ${hostfile} ${REMOVE}

sleep 2

"""
  exe = exe & "t0=" & $t0 & "\n"
  exe = exe & "CFG=" & run_paths.seqno & "\n\n"
  exe = exe & "/bin/rm -f " & genPath(run_paths.prop_op_tmp) & "\n"
  
  exe = exe & "mpiexec -launcher=rsh -genvall -np 16 -ppn 8 -hostfile ${hostfile} ${CHROMA} -i " & genPath(run_paths.input_file) & " -geom 1 1 1 16 -iogeom 1 1 1 4 -qmp-alloc-map 3 2 1 0 -qmp-logic-map 3 2 1 0 > " & genPath(run_paths.out_file) & " 2>&1 &\n"
  exe = exe & "pids[${npid}]=$! ; npid=$((npid+1))\n\n"

  for n in 1..24:
    exe = exe & "mpiexec -launcher=rsh -genvall -n 2 -ppn 1 -hostfile ${hostfile} ${HAROM} -i " & genPath(run_paths.peram_files[n-1]) & " 1> out.harom" & $n & ".t0_${t0}.${CFG} &\n"
    exe = exe & "pids[${npid}]=$! ; npid=$((npid+1))\n\n"

  exe = exe & """
for pid in ${pids[*]}; do 
    wait $pid
done
"""

  exe = exe & "\ndate\n\n"

  exe = exe & propCheck & " 0.5 " & genPath(run_paths.prop_op_tmp) & " > " & genPath(run_paths.check_file) & "\n"
  exe = exe & """
stat=$?
if [ $stat -eq 0 ]
then
  /bin/mv """ & genPath(run_paths.prop_op_tmp) & " " & genPath(run_paths.prop_op_file) & "\n" & """
fi
"""
  exe = exe & "\n/bin/rm ${hostfile}\n\nexit 0\n"

  # Will hopefully remove writing any specific file
  result = seqDir & "/jlab_gpu.t_" & $t0 & ".sh"
  echo "run_script= ", result

  writeFile(result, exe)
  var perm = getFilePermissions(result) + {fpUserExec}
  setFilePermissions(result, perm)

#------------------------------------------------------------------------------
proc splitSeq(t0s: seq[int], max_t0: int): seq[seq[int]] =
  ## Split array of seqs into chunks of seqs
  result = @[]

  var cnt = 0
  while cnt < t0s.len():
    var to_do: seq[int] = @[]

    for cc in 1 .. max_t0:
      if cnt == t0s.len(): continue
      to_do.add(t0s[cnt])
      cnt += 1

    if to_do.len() > 0:
      result.add(to_do)


#------------------------------------------------------------------------------
when isMainModule:
  import marshal
  echo "paramCount()= ", paramCount()

  # The t0 list filename is always the same for each config
  let stem = getStem()
  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]

  # This vesion assumes the arguments are the pre-existing directories
  for dir in commandLineParams():
    # All the jobs to accumulate
    var Data: PandaSubmitter_t
    Data.campaign = dir
    Data.jobs = @[]

    # build input for each directory
    echo dir
    let cwd = getCurrentDir()
    setCurrentDir(dir)
    var array_t0s: seq[int]
    array_t0s = @[]    

    for t0 in 0 .. Lt-1:
      if (t0 mod 16) != 0: continue
      #if (t0 mod 16) == 0: continue
      echo "Check t0= ", t0
      let run_paths = constructPathNames($t0)
      let outputFile = genPath(run_paths.prop_op_file)
      let outputFile_check = genPath(run_paths.prop_op_file_check)
      let outputFile_done  = genPath(run_paths.prop_op_file_done)

      # Empty files are bad
      if existsFile(outputFile):
        if getFileSize(outputFile) == 0:
          discard tryRemoveFile(outputFile)

      # If the outputFile does not exist, do the thang!
      if fileExists(outputFile): continue
      if fileExists(outputFile_check): continue
      if fileExists(outputFile_done): continue
      echo "Generate job for prop= ", run_paths.prop_op_file.name
      generateChromaXML(t0, run_paths)
      array_t0s.add(t0)

    # Build the script
    if array_t0s.len == 0: 
      setCurrentDir(cwd)
      continue

    # Must construct
    for to_do in items(array_t0s):
      let f = generateJLabGPURunScript(to_do)
      echo "Submitting " & f
#      if execShellCmd("sbatch " & f) != 0:
#        quit("Some error submitting " & f)

    # popd
    setCurrentDir(cwd)
    
