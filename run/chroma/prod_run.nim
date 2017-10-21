## Run 850-s within titanManager

import os, xmltree, strutils

import colorvec_work, serializetools/serializexml
import build_t0_list

import config

import chroma
import prop_and_matelem_distillation as matelem
#import prop_and_matelem_distillation
import fermbc, fermstate
import inverter
import clover_fermact
import propagator
import build_t0_list, titanManager


const basedir = strip(staticExec("pwd"))
echo "basedir= ", basedir


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
proc generateChromaXML(data: var TitanManager_t; t0: int) =
  ## Generate input file
  let stem     = getStem()
  let cache    = getEnsemblePath()
  let num_vecs = getNumVecs()
  let scratch  = getScratchPath()
  echo "stem= ", stem
  echo "cache= ", cache
  echo "scratch= ", scratch

  var quark = readFile("quark_mass")
  removeSuffix(quark)
  echo "quark= ", quark

  var seqno = readFile("list")
  removeSuffix(seqno)
  echo "seqno= ", seqno

  let mass        = -0.0850
  let mass_label  = "U" & formatFloat(mass, ffDecimal, 4)
  echo "mass_label= ", mass_label

  # Main paths
  let dataDir    = cache
  let workDir    = scratch
  let seqName    = seqno & "." & formatFloat(mass, ffDecimal, 4) & ".allt"
  let seqDir     = workdir & "/" & seqName
  echo "workDir= ", workDir
  echo "seqDir= ", seqDir
  createDir(workDir)
  createDir(seqDir)

  # Files
  let cfg_file       = PathFile_t(fileDir: dataDir & "/cfgs", name: stem & "_cfg_" & seqno & ".lime")
  let colorvec_files = @[PathFile_t(fileDir: dataDir & "/eigs_mod", name: stem & ".3d.eigs.mod" & seqno)]

  let prefix         = stem & ".prop.n" & $num_vecs & "." & quark & ".t0_" & $t0 
  let prop_op_file   = PathFile_t(fileDir: seqDir, name: prefix & ".sdb" & seqno)
  let input_file     = PathFile_t(fileDir: seqDir, name: prefix & ".ini.xml" & seqno)
  let output_file    = PathFile_t(fileDir: seqDir, name: prefix & ".out.xml" & seqno)
  #let out_file       = PathFile_t(fileDir: seqDir, name: prefix & ".out" & seqno)

  # Common stuff
  let Rsd         = 1.0e-8
  let MaxIter     = 1000

  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]
  let t_origin = getTimeOrigin(Lt,seqno)
  echo "Lt= ", Lt, "   t_origin= ", t_origin

  var (Nt_forward, Nt_backward) = if t0 mod 16 == 0: (48, 0) else: (1, 0)

  # Used by distillation input
  let contract = matelem.Contractions_t(mass_label: mass_label,
                                        num_vecs: num_vecs,
                                        t_sources: @[(t0 + t_origin + Lt) mod Lt],
                                        Nt_forward: Nt_forward,
                                        Nt_backward: Nt_backward,
                                        decay_dir: 3,
                                        num_tries: 1)
 
  # Fermion action and inverters
  let mg  = newQUDAMGParams24x256()
  let inv = newQUDAMGInv(mass, Rsd, MaxIter, mg)
  let fermact = newAnisoPrecCloverFermAct(mass)

  # Inline measurement
  let mat_named_obj = matelem.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: genPath(colorvec_files),
                                            prop_op_file: genPath(prop_op_file))
  let mat_prop      = newPropagator(fermact, inv)
  let mat_param     = matelem.DistParams_t(Contractions: contract, Propagator: mat_prop)
  let inline_dist   = matelem.newPropAndMatelemDistillation(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  #echo "Param:\n", xmlToStr(serializeXML(chromaParam, "chroma"))
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(cfg_file), parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(genPath(input_file), input)

  let script_name = "run.nersc.csh"
  let run_script = seqDir & "/" & script_name
  let script_exe = """
#!/bin/bash

tt=$1

stem="""" & stem & """"
seqno="""" & seqno & """"
scratch_dir="""" & seqDir & """"
pref="${scratch_dir}/${stem}.t0_${tt}"
input="${pref}.prop.ini.xml${seqno}"
output="${pref}.prop.out.xml${seqno}"
out="${pref}.prop.out${seqno}"

#basedir="$HOME/qcd/git/bw.3/scripts_rge/run/chroma"
exe="$HOME/bin/exe/ib9q/chroma.cori2.scalar.qphix.aug_28_2017"

source """ & basedir & """/env_qphix.sh
export KMP_AFFINITY=compact,granularity=thread
export KMP_PLACE_THREADS=1s,64c,2t

$exe -i $input -o $output -by 4 -bz 4 -pxy 0 -pxyz 0 -c 64 -sy 1 -sz 2 -minct 1 > $out 2>&1
"""
  writeFile(run_script, script_exe)

  #let QPHIXVARS = "-by 4 -bz 4 -pxy 0 -pxyz 0 -c 64 -sy 1 -sz 2 -minct 1 -poolsize 64"

  # This particular job
  var job: JobType_t

  job.campaign       = stem
  job.name           = seqName
  job.checkNodes     = 0
  job.checkWallTime  = " "
  job.nodes          = 1
  job.wallTime       = "00:30:00"
  job.inputFiles     = @[]
  job.inputfiles.add(input_file)
  job.inputFiles.add(cfg_file)
  job.inputFiles.add(colorvec_files)
  job.outputFiles    = @[]
  job.outputFiles.add(output_file)
  job.outputFiles.add(prop_op_file)

# run.nersc.csh szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265 32 1860d
#  job.executionCommand  = "serial chroma -i " & genPath(job.inputFiles[0]) & " -o " & genPath(job.outputFiles[0]) & " " & QPHIXVARS & ">&" & seqDir & "/" & out_file
#  job.executionCommand  = "export KMP_AFFINITY=compact,granularity=thread; export KMP_PLACE_THREADS=1s,64c,2t ; chroma -i " & genPath(job -o job.output_file & '&>' job.out_file
  job.executionCommand   = "./serial " & seqName & "/" & script_name & " "& $t0
  job.checkOutputCommand = " "
  job.checkOutputScript  = "prop_check 0.5 " & genPath(prop_op_file)

  # Each instance modified the campaign. Not needed
  data.Campaign.name          = stem
  data.Campaign.wallTime      = job.wallTime
  data.Campaign.checkWallTime = job.checkWallTime
  data.Campaign.workDir       = workDir
  data.Campaign.header        = "\n#SBATCH -p debug\n#SBATCH -C knl,quad,cache\nmodule load python\nsource " & basedir & "/env_qphix.sh; export KMP_AFFINITY=compact,granularity=thread; export KMP_PLACE_THREADS=1s,64c,2t\n"
  data.Campaign.footer        = " "
  data.Campaign.wallTime      = job.wallTime 
  data.Campaign.checkHeader   = " "
  data.Campaign.checkFooter   = " "

  # Add on this job
  data.Job.add(job)



#------------------------------------------------------------------------------
when isMainModule:
  echo "paramCount()= ", paramCount()

  # All the jobs to accumulate
  var Data: TitanManager_t
  Data.Job = @[]

  # The t0 list filename is always the same for each config
  let list = getStem() & ".list"

  # This vesion assumes the arguments are the pre-existing directories
  for dir in commandLineParams():
    # build input for each directory
    echo dir
    let cwd = getCurrentDir()
    setCurrentDir(dir)
    buildT0List()

    for t0str in splitLines(readFile(list)):
      if t0str.len == 0: continue
      let t0 = parseInt(t0str)
      echo "  t0= ", t0
      generateChromaXML(Data, t0)

    # popd
    setCurrentDir(cwd)
    
  # Dump the job script to titanManager
  writeFile("campaign.xml", xmlToStr(serializeXML(Data)))
