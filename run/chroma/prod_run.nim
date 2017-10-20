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
  let dataDir    = cache & "/" & stem
  let workDir    = scratch & "/" & seqno & "." & formatFloat(mass, ffDecimal, 4) & ".allt"

  # Files
  let cfg_file       = PathFile_t(fileDir: dataDir & "/cfgs", name: stem & "_cfg_" & seqno & ".lime")
  let colorvec_files = @[PathFile_t(fileDir: dataDir & "/eigs_mod", name: stem & ".3d.eigs." & seqno)]

  let prefix        = stem & ".prop.n" & $num_vecs & "." & quark & ".t0_" & $t0 
  let propOpFile    = prefix & ".sdb" & seqno
  let input_file    = prefix & ".ini.xml" & seqno
  let output_file   = prefix & ".out.xml" & seqno
  let out_file      = prefix & ".out" & seqno

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
                                            prop_op_file: workDir & "/" & prop_op_file)
  let mat_prop      = newPropagator(fermact, inv)
  let mat_param     = matelem.DistParams_t(Contractions: contract, Propagator: mat_prop)
  let inline_dist   = matelem.newPropAndMatelemDistillation(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  #echo "Param:\n", xmlToStr(serializeXML(chromaParam, "chroma"))
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(cfg_file), parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(input_file, input)

  let QPHIXVARS = "-by 4 -bz 4 -pxy 0 -pxyz 0 -c 64 -sy 1 -sz 2 -minct 1 -poolsize 64"

  # This particular job
  var job: JobType_t

  job.campaign       = stem
  job.name           = quark & "." & seqno & ".t0_" & $t0
  job.checkNodes     = 0
  job.checkWallTime  = " "
  job.nodes          = 1
  job.wallTime       = "05:00:00"
  job.inputFiles     = @[]
  job.inputfiles.add(PathFile_t(fileDir: workDir, name: input_file))
  job.inputFiles.add(cfg_file)
  job.inputFiles.add(colorvec_files)
  job.outputFiles    = @[]
  job.outputFiles.add(PathFile_t(fileDir: workDir, name: output_file))
  job.outputFiles.add(PathFile_t(fileDir: workDir, name: prop_op_file))

  #job.propOpFile        = workDir & "/" & prop_op_file
  job.executionCommand  = "serial chroma -i " & genPath(job.inputFiles[0]) & " -o " & genPath(job.outputFiles[0]) & " " & QPHIXVARS & ">&" & workDir & "/" & out_file
#  job.executionCommand  = "export KMP_AFFINITY=compact,granularity=thread; export KMP_PLACE_THREADS=1s,64c,2t ; chroma -i " & genPath(job -o job.output_file & '&>' job.out_file
  job.checkOutputCommand = " "
  job.checkOutputScript  = "prop_check 0.5 " & workDir & "/" & prop_op_file

  # Each instance modified the campaign. Not needed
  data.Campaign.name          = stem
  data.Campaign.wallTime      = job.wallTime
  data.Campaign.checkWallTime = job.checkWallTime
  data.Campaign.workDir       = workDir
  data.Campaign.header        = "export KMP_AFFINITY=compact,granularity=thread; export KMP_PLACE_THREADS=1s,64c,2t"
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
