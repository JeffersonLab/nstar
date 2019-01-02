## Run redstar

import redstar_chain, run/chroma/colorvec_work, redstar_input, cgc_su3, cgc_irrep_mom, hadron_sun_npart_npt_corr
import generate_redstar_2pt
import serializetools/serializexml
import serializetools/array1d
import times, xmltree, os
import redstar_exes

import xmlparser


## ----------------------------------------------------------------------------
proc generateCorr3Pt(params: RedstarRuns_t): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Generate an array of 2pt correlation keys from source and sink ops list
  result.setLen(0)
  for f in items(params.ops_xmls):
    echo "Read corr template = ", f
    if not fileExists(f): quit("file = " & f & " does not exist")
    let xml: XmlNode = loadXml(f)

    # Grab these corrs and reset the t_source/t_sink. Append this to the result
    var dest = deserializeXML[seq[KeyHadronSUNNPartNPtCorr_t]](xml)
    for d in mitems(dest):
      d.NPoint[1].t_slice = cint(params.t_sink)
      d.NPoint[2].t_slice = cint(-3)
      d.NPoint[3].t_slice = cint(params.t_source)
      result.add(d)


## ----------------------------------------------------------------------------
proc run_job(input, output, exe: string) = 
  ## Run the analysis program
  echo "Before analysis: " & $now()
  let run = exe & " " & input & " " & output
  echo run
  if execShellCmd(run) != 0:
      quit("Some error in run of " & output)
  echo "After analysis: " & $now()

    
## ----------------------------------------------------------------------------
proc copy_back(params: RedstarRuns_t) = 
  ## Desperate times call for desperate means - copy the output file back using a variety of methods
  discard execShellCmd("rcp " & params.work_files.output_db & " qcdi1401:" & params.work_files.output_dir)
  discard execShellCmd("cache_cp " & params.work_files.output_db & " " & params.work_files.output_dir)
  discard execShellCmd("cp " & params.work_files.output_db & " " & params.work_files.output_dir)


  
## ----------------------------------------------------------------------------
proc run_redstar_3pt*(stem, chan, irrep: string, seqno: string) =
  let exes = redstar_exe()             # Setup the executables
  let params = redstar_setup(stem, chan, irrep, seqno)

  echo "Time sources = ", params.t_sources
  echo "Ensemble = ", params.ensemble
  echo "Hadron node dbs = ", params.work_files.hadron_node_dbs
  echo "Output db = ", params.work_files.output_db
  echo "Redstar_gen_graph executable = ", exes.redstar_gen_graph
  echo "Redstar_npt executable = ", exes.redstar_npt
  echo "Smeared hadron_node executable = ", exes.smeared_hadron_node
  echo "Unsmeared hadron_node executable = ", exes.unsmeared_hadron_node
  echo "Hadron_npt_graph_db = ", params.work_files.hadron_npt_graph_db

  echo "Build a redstar hadron node input"
  var red_input = newRedstarInput(params)
  red_input.Param.NPointList = generateCorr3Pt(params)
  #echo $red_input
  writeFile(params.work_files.redstar_ini, xmlHeader & $xmlToStr(serializeXML(red_input, "RedstarNPt")))

  echo "Build a smeared hadron node input"
  let smeared_hadron_node_input = newSmearedHadronNodeInput(params)
  #echo $smeared_hadron_node_input
  writeFile(params.work_files.smeared_ini, xmlHeader & $xmlToStr(serializeXML(smeared_hadron_node_input, "ColorVecHadron")))

  echo "Build a unsmeared hadron node input"
  let unsmeared_hadron_node_input = newUnsmearedHadronNodeInput(params)
  #echo $unsmeared_hadron_node_input
  writeFile(params.work_files.unsmeared_ini, xmlHeader & $xmlToStr(serializeXML(unsmeared_hadron_node_input, "ColorVecHadron")))

  run_job(params.work_files.redstar_ini, params.work_files.file_out, exes.redstar_gen_graph)
  run_job(params.work_files.smeared_ini, params.work_files.file_out, exes.smeared_hadron_node)
  run_job(params.work_files.unsmeared_ini, params.work_files.file_out, exes.unsmeared_hadron_node)
  run_job(params.work_files.redstar_ini, params.work_files.file_out, exes.redstar_npt)

  #&merge_graph_db(hadron_npt_graph_db);

  echo "Copy files back"
  copy_back(params)


#----------------------------------------------------------------------------
when isMainModule:
  echo "Run redstar"
  let pwd = getCurrentDir()
  let path_irrep = splitPath(pwd)
  let path_chan  = splitPath(path_irrep.head)
  let path_stem  = splitPath(path_chan.head)
  let seqno = "1"
  run_redstar_3pt(path_stem.tail, path_chan.tail, path_irrep.tail, seqno)
  

