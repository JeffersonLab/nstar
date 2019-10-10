## Generate prop jobs

import os, xmltree, strutils

import colorvec_work, serializetools/serializexml
import config

import chroma
import prop_and_matelem_distillation as matelem
#import prop_and_matelem_distillation
import fermbc, fermstate
import inverter
import clover_fermact
import propagator


const basedir = strip(staticExec("pwd"))
echo "basedir= ", basedir

#const platform = "OLCF"
#const platform = "NERSC"
const platform = "TACC"

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


#------------------------------------------------------------------------------
proc generateChromaXML*(t0: int, run_paths: RunPaths_t) =
  ## Generate input file and return the path to the expected output file
  let mass        = run_paths.mm.mass

  # Main paths
  createDir(run_paths.workDir)
  createDir(run_paths.seqDir)

  # Common stuff
  #let Rsd         = 1.0e-8
  let Rsd         = 5.0e-7
  let MaxIter     = 8

  let lattSize = extractLattSize(run_paths.stem)
  let Lt = lattSize[3]
  let t_origin = getTimeOrigin(Lt, run_paths.seqno)

  var (Nt_forward, Nt_backward) = if t0 mod 16 == 0: (48, 0) else: (1, 0)

  # Used by distillation input
  let contract = matelem.Contractions_t(mass_label: run_paths.mm.mass_label,
                                        num_vecs: run_paths.num_vecs,
                                        t_sources: @[(t0 + t_origin + Lt) mod Lt],
                                        Nt_forward: Nt_forward,
                                        Nt_backward: Nt_backward,
                                        decay_dir: 3,
                                        num_tries: 1)
 
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
  else:
    quit("not allowed")


  # Inline measurement
  let mat_named_obj = matelem.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: genPath(run_paths.colorvec_files),
                                            prop_op_file: genPath(run_paths.prop_op_tmp))
  let mat_prop      = newPropagator(fermact, inv)
  let mat_param     = matelem.DistParams_t(Contractions: contract, Propagator: mat_prop)
  let inline_dist   = matelem.newPropAndMatelemDistillation(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(run_paths.cfg_file), reunit: true, parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(genPath(run_paths.input_file), input)


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
proc generateTACCRunScript*(t0s: seq[int]): string =
  ## Generate input file
  # Common stuff
  let propCheck = "/home1/00314/tg455881/qcd/git/nim-play/nstar/prop_check"
  let nodes    = 4
  let mpi      = 64 
  let queue    = "normal"
  let wallTime = "6:00:00"

  let total_nodes = nodes * t0s.len()
  let total_mpi   = mpi * t0s.len()

  # This particular job
  let job_paths = constructPathNames("t0")
  let seqDir    = job_paths.seqDir

  if t0s.len() < 1: quit("Need more than 0 t0s")

  var exe = """
#!/bin/bash
#SBATCH -N """ & $total_nodes & "\n" & """
#SBATCH -p """ & queue & "\n" & """
#SBATCH -t """ & wallTime & "\n" & """
#SBATCH -n """ & $total_mpi & "\n" & """
#SBATCH -A TG-PHY190005

cd """ & seqDir & "\n" & """

export OMP_NUM_THREADS=8
export OMP_PLACES=threads
export OMP_PROC_BIND=spread
exe="/home1/00314/tg455881/bin/exe/tacc/chroma.knl.double.parscalar.sep_29_2019"
"""

  exe = exe & "source " & basedir & "/env_stampede2.sh\n"
  var cnt = 0

  for t0 in items(t0s):
    let run_paths = constructPathNames($t0)
    exe = exe & "/bin/rm -f " & genPath(run_paths.prop_op_tmp) & "\n"
  
  exe = exe & "\ndate\n"

  for t0 in items(t0s):
    let run_paths = constructPathNames($t0)
    exe = exe & "ibrun -n " & $mpi & " -o " & $cnt & " task_affinity $exe -i " & genPath(run_paths.input_file) & " -o " & genPath(run_paths.output_file) & " -geom 1 1 4 16 --qmp-alloc-map 3 2 1 0 --qmp-logic-map 3 2 1 0 -by 4 -bz 4 -c 4 -sy 1 -sz 2  > " & genPath(run_paths.out_file) & " 2>&1 &\n"
    cnt += mpi

  exe = exe & "wait\ndate\n\n\n"

  for t0 in items(t0s):
    let run_paths = constructPathNames($t0)
    exe = exe & propCheck & " 0.5 " & genPath(run_paths.prop_op_tmp) & " > " & genPath(run_paths.check_file) & "\n"
    exe = exe & """
stat=$?
if [ $stat -eq 0 ]
then
  /bin/mv """ & genPath(run_paths.prop_op_tmp) & " " & genPath(run_paths.prop_op_file) & "\n" & """
fi
"""
  exe = exe & "\nexit 0\n"

  # Will hopefully remove writing any specific file
  let run_script = seqDir & "/tacc.t_" & $t0s[0] & "-" & $t0s[t0s.high()] & ".sh"
  writeFile(run_script, exe)
  var perm = getFilePermissions(run_script) + {fpUserExec}
  setFilePermissions(run_script, perm)
  return run_script

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
      #if (t0 mod 16) != 0: continue
      if (t0 mod 16) == 0: continue
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
      echo "Generate job for prop= ", outputFile
      generateChromaXML(t0, run_paths)
      array_t0s.add(t0)

    # Build the script
    if array_t0s.len == 0: 
      setCurrentDir(cwd)
      continue

    # Must construct
    let max_t0 = 64

    for to_do in items(splitSeq(array_t0s, max_t0)):
      let f = generateTACCRunScript(to_do)
      echo "Submitting " & f
      if execShellCmd("sbatch " & f) != 0:
        quit("Some error submitting " & f)

    # popd
    setCurrentDir(cwd)
    
