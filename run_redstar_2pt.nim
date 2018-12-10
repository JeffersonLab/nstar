## Run redstar

import redstar_chain, run/chroma/colorvec_work, redstar_input, cgc_su3, cgc_irrep_mom, hadron_sun_npart_npt_corr
import generate_redstar_2pt
import serializetools/serializexml
import times, xmltree, os
import redstar_exes


## ----------------------------------------------------------------------------
proc generateCorr2Pt(params: RedstarRuns_t): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Generate an array of 2pt correlation keys from source and sink ops list
  echo "Read source ops = ", params.source_ops_list
  let source_ops_list = readOpsListFiles(@[params.source_ops_list])

  echo "Read sink ops = ", params.sink_ops_list
  let sink_ops_list = readOpsListFiles(@[params.sink_ops_list])

  #  Read the operator maps
  echo "Read ops map"
  let ops_map = readOpsMapFiles(params.ops_xmls)

  #  Output corrs
  #  Select the irreps commensurate with the momentum
  echo "Build 2pt correlation functions"
  result = printRedstar2Pts(params.runmode, source_ops_list, sink_ops_list, ops_map, params.irmom.mom,
                            params.include_all_rows, params.t_sources)


## ----------------------------------------------------------------------------
proc run_job(input, output, exe: string) = 
  ## Run the analysis program
  #if execShellCmd("echo 'Here is /scratch'; /bin/ls -lt /scratch") != 0:
  #  quit("Some error in run of " & output)

  echo "Before analysis: " & $now()
  let run = exe & " " & input & " " & output
  echo run
  if execShellCmd(run) != 0:
      quit("Some error in run of " & output)
  echo "After analysis: " & $now()

    
## ----------------------------------------------------------------------------
proc copy_back(params: RedstarRuns_t) = 
  ## Desperate times call for desperate means - copy the output file back using a variety of methods
  discard execShellCmd("rcp " & params.output_db & " qcdi1401:" & params.output_dir)
  discard execShellCmd("cache_cp " & params.output_db & " " & params.output_dir)
  discard execShellCmd("cp " & params.output_db & " " & params.output_dir)
  #let emerg = "/lustre/volatile/Spectrum/Clover/NF2+1/${stem}/sdbs_rge"
  #system("mkdir -p ${emerg}; /bin/cp /scratch/${output_db} $emerg");   # Yuck. Always keep an emergency backup
  #unlink("/scratch/$output_db");



  
## ----------------------------------------------------------------------------
proc run_redstar_2pt*(arch: string; stem, chan, irrep: string, seqno: string) =
  let exes = redstar_exe()             # Setup the executables
  let params = redstar_setup(arch, stem, chan, irrep, seqno)

  echo "Time sources = ", params.t_sources
  echo "Ensemble = ", params.ensemble
  echo "Hadron node dbs = ", params.hadron_node_dbs
  echo "Output db = ", params.output_db
  echo "Redstar_gen_graph executable = ", exes.redstar_gen_graph
  echo "Redstar_npt executable = ", exes.redstar_npt
  echo "Smeared hadron_node executable = ", exes.smeared_hadron_node
  echo "Unsmeared hadron_node executable = ", exes.unsmeared_hadron_node
  echo "Hadron_npt_graph_db = ", params.hadron_npt_graph_db

  let scratch = params.scratch & "/"
  #discard tryRemoveFile(scratch & params.hadron_node_xml)
  #unlink(scratch & $unsmeared_hadron_node_db);  # remove any extraneous copies first - not sure of their state
  #unlink(scratch & $smeared_hadron_node_db);  # remove any extraneous copies first - not sure of their state
  #discard tryRemoveFile(scratch & params.output_db)

  # Always remove a possible local graph db
  # If the global graph db exists, copy it in
  #$local_graph_db = &copy_graph_db($hadron_npt_graph_db);
  ##$local_graph_db = $hadron_npt_graph_db;

  #printf("local_graph_db = $local_graph_db\n");

  #print "Host = ", `hostname`;

  let redstar_ini     = scratch & stem & ".redstar.ini.xml" & seqno
  let smeared_ini     = scratch & stem & ".smeared_hadron_node.ini.xml" & seqno
  let unsmeared_ini   = scratch & stem & ".unsmeared_hadron_node.ini.xml" & seqno
  let file_out        = scratch & stem & ".out.xml" & seqno
 
  echo "Build a redstar hadron node input"
  var red_input = newRedstarInput(params)
  red_input.Param.NPointList = generateCorr2Pt(params)
  #echo $red_input
  writeFile(redstar_ini, xmlHeader & $xmlToStr(serializeXML(red_input, "RedstarNPt")))

  echo "Build a smeared hadron node input"
  let smeared_hadron_node_input = newSmearedHadronNodeInput(params)
  #echo $smeared_hadron_node_input
  writeFile(smeared_ini, xmlHeader & $xmlToStr(serializeXML(smeared_hadron_node_input, "ColorVecHadron")))

  echo "Build a unsmeared hadron node input"
  let unsmeared_hadron_node_input = newUnsmearedHadronNodeInput(params)
  #echo $unsmeared_hadron_node_input
  writeFile(unsmeared_ini, xmlHeader & $xmlToStr(serializeXML(unsmeared_hadron_node_input, "ColorVecHadron")))

  run_job(redstar_ini, file_out, exes.redstar_gen_graph)
  run_job(smeared_ini, file_out, exes.smeared_hadron_node)
  run_job(unsmeared_ini, file_out, exes.unsmeared_hadron_node)
  run_job(redstar_ini, file_out, exes.redstar_npt)

  #&merge_graph_db(hadron_npt_graph_db);

  echo "Copy files back"
  copy_back(params)


#----------------------------------------------------------------------------
when isMainModule:
  echo "Run redstar"
  run_redstar_2pt("nstar", "test", "rho", "000_T1mP", "1")
  

