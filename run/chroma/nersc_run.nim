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
const platform = "NERSC"


type
  PathFile_t* = object
    name*:               string
    fileDir*:            string


#------------------------------------------------------------------------------
proc genPath(file: PathFile_t): string =
  ## Convenience to generate a path
  result = file.fileDir & "/" & file.name

proc genPath(files: seq[PathFile_t]): seq[string] =
  ## Convenience to generate a path
  result = newSeq[string](0)
  for f in items(files):
    result.add(genPath(f))


#------------------------------------------------------------------------------
# Mass params - need to fix this stuff up to have the datasets and their masses
let mass_s = -0.0743
let mass_l = -0.0856

type
  QuarkMass_t = object
    mass:         float
    mass_label:   string

proc quarkMass(stem: string, quark: string): QuarkMass_t =
  # Pull out the mass and label
  case quark:
    of "strange":
      result.mass = mass_s
      
    of "light":
      result.mass = mass_l

    else:
      quit("Unknown quark = " & quark)

  result.mass_label  = "U" & formatFloat(result.mass, ffDecimal, 4)
  echo "mass_label= ", result.mass_label




#------------------------------------------------------------------------------
# Paths to all the various files
type
  RunPaths_t = object    ## Paths used for running
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
    t0*:               int
    num_vecs*:         int
    prefix*:           string
    prop_op_tmp*:      PathFile_t
    input_file*:       PathFile_t
    output_file*:      PathFile_t
    out_file*:         PathFile_t
    check_file*:       PathFile_t
    prop_op_file*:     PathFile_t
    

#------------------------------------------------------------------------------
proc constructPathNames*(t0: int): RunPaths_t =
  ## Construct the names for all the various paths
  result.stem     = getStem()
  result.cache    = getEnsemblePath()
  result.num_vecs = getNumVecs()
  result.scratch  = getScratchPath()
  result.t0       = t0

  # shortcuts
  let stem    = result.stem
  let cache   = result.cache
  let scratch = result.scratch
  let t0      = result.t0

  echo "stem= ", stem
  echo "cache= ", cache
  echo "scratch= ", scratch

  result.quark = readFile("quark_mass")
  removeSuffix(result.quark)
  echo "quark= ", result.quark

  result.seqno = readFile("list")
  removeSuffix(result.seqno)
  echo "seqno= ", result.seqno
  let seqno = result.seqno

  # Pull out the mass and label
  result.mm = quarkMass(result.stem, result.quark)

  # Main paths
  result.dataDir    = cache
  result.workDir    = scratch
  result.seqName    = result.seqno & "." & formatFloat(result.mm.mass, ffDecimal, 4) & ".allt"
  result.seqDir     = result.workdir & "/" & result.seqName
  echo "workDir= ", result.workDir
  echo "seqDir= ",  result.seqDir

  # Files
  result.cfg_file       = PathFile_t(fileDir: result.dataDir & "/cfgs", name: stem & "_cfg_" & seqno & ".lime")
  result.colorvec_files = @[PathFile_t(fileDir: result.dataDir & "/eigs_mod", name: stem & ".3d.eigs.mod" & seqno)]

  result.prefix         = stem & ".prop.n" & $result.num_vecs & "." & result.quark & ".t0_" & $t0 
  result.prop_op_tmp    = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".sdb" & seqno)
  result.input_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".ini.xml" & seqno)
  result.output_file    = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out.xml" & seqno)
  result.out_file       = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out" & seqno)
  result.check_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".check" & seqno)

  result.prop_op_file   = PathFile_t(fileDir: result.dataDir & "/prop_db_t0", name: result.prop_op_tmp.name)


#------------------------------------------------------------------------------
proc generateChromaXML*(run_paths: RunPaths_t) =
  ## Generate input file and return the path to the expected output file
  let mass        = run_paths.mm.mass

  # Main paths
  echo "workDir= ", run_paths.workDir
  echo "seqDir= ", run_paths.seqDir
  createDir(run_paths.workDir)
  createDir(run_paths.seqDir)

  # Common stuff
  let Rsd         = 1.0e-8
  let MaxIter     = 8

  let lattSize = extractLattSize(run_paths.stem)
  let Lt = lattSize[3]
  let t_origin = getTimeOrigin(Lt, run_paths.seqno)
  echo "Lt= ", Lt, "   t_origin= ", t_origin

  var (Nt_forward, Nt_backward) = if run_paths.t0 mod 16 == 0: (48, 0) else: (1, 0)

  # Used by distillation input
  let contract = matelem.Contractions_t(mass_label: run_paths.mm.mass_label,
                                        num_vecs: run_paths.num_vecs,
                                        t_sources: @[(run_paths.t0 + t_origin + Lt) mod Lt],
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
  #echo "Param:\n", xmlToStr(serializeXML(chromaParam, "chroma"))
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(run_paths.cfg_file), parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(genPath(run_paths.input_file), input)


#-----------------------------------------------------------------------------
# Types need for submitter
type
  PandaJob_t = object
    nodes:            int
    walltime:         string
    queuename:        string
    outputFile:       string
    iterable:         string
    command:          string

  PandaSubmitter_t = object
    campaign:         string
    jobs:             seq[PandaJob_t]


#------------------------------------------------------------------------------
proc generateNERSCRunScript*(run_paths: RunPaths_t): PandaJob_t =
  ## Generate input file
  # Common stuff
  #let propCheck = "/global/homes/r/redwards/bin/x86_64/prop_check"
  let propCheck = "/global/homes/r/redwards/qcd/git/nim-play/nstar/prop_check"
  let wallTime = "00:30:00"

  # This particular job
  result.nodes          = 1
  result.wallTime       = wallTime
  result.outputFile     = genPath(run_paths.prop_op_file)

  result.command = """
#!/bin/bash
#SBATCH -N 2
#SBATCH -C knl,quad,cache
#SBATCH -q debug
#SBATCH -t """ & wallTime & "\n" & """
#SBATCH -A m2156
#SBATCH -S 2

cd """ & run_paths.seqDir & "\n" & """

export OMP_NUM_THREADS=8
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

input="""" & genPath(run_paths.input_file) & """"
output="""" & genPath(run_paths.output_file) & """"
out="""" & genPath(run_paths.out_file) & """"
/bin/rm -f """ & genPath(run_paths.prop_op_tmp) & """

exe="$HOME/bin/exe/cori/hmc.cori.double.parscalar.oct_3_2018"

source """ & basedir & """/env_qphix.sh

rm -f ./ops_out/*
srun -n 32 -c 16 --cores-per-socket 256 --cpu_bind=cores $exe -i $input -o $output -geom 1 1 2 16 --qmp-alloc-map 3 2 1 0 --qmp-logic-map 3 2 1 0 -by 4 -bz 4 -c 4 -sy 1 -sz 2  > $out 2>&1

""" & propCheck & " 0.5 " & genPath(run_paths.prop_op_tmp) & " > " & genPath(run_paths.check_file) & """

stat=$?
if [ $stat -eq 0 ]
then
  /bin/mv """ & genPath(run_paths.prop_op_tmp) & " " & genPath(run_paths.prop_op_file) & """

fi
"""

  # Will hopefully remove writing any specific file
  let run_script = run_paths.seqDir & "/nersc.t0_" & $run_paths.t0 & ".sh"
  echo "writing run_script = ", run_script
  writeFile(run_script, result.command)
  var perm = getFilePermissions(run_script) + {fpUserExec}
  setFilePermissions(run_script, perm)



#------------------------------------------------------------------------------
when isMainModule:
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

    #for t0 in 0 .. Lt-1:
    for t0 in 0 .. 3:
      if (t0 mod 16) == 0: continue
      echo "Check t0= ", t0
      let run_paths = constructPathNames(t0)
      let outputFile = genPath(run_paths.prop_op_file)

      # Empty files are bad
      if existsFile(outputFile):
        if getFileSize(outputFile) == 0:
          discard tryRemoveFile(outputFile)

      # If the outputFile does not exist, do the thang!
      if fileExists(outputFile): continue
      echo "Generate job for prop= ", outputFile
      generateChromaXML(run_paths)
      let jj = generateNERSCRunScript(run_paths)
      Data.jobs.add(jj)

    # Dump the job script to titanManager
    writeFile("campaign.xml", xmlToStr(serializeXML(Data)))

    # popd
    setCurrentDir(cwd)
    
