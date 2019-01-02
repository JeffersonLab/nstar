## Run redstar

import redstar_input, redstar_exes, run/chroma/colorvec_work, run/redstar/run_redstar_npt
import hadron_sun_npart_npt_corr
import generate_redstar_2pt
import serializetools/serializexml
import seqno_list


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
  result = printRedstar2Pts(params.runmode, source_ops_list, sink_ops_list, ops_map,
                            params.flavor, params.irmom,
                            params.include_all_rows, params.t_sources)


#----------------------------------------------------------------------------
when isMainModule:
  import os
  echo "Run redstar"
  let pwd = getCurrentDir()
  let path_irrep = splitPath(pwd)
  let path_chan  = splitPath(path_irrep.head)
  let path_stem  = splitPath(path_chan.head)
  let seqno = nextSeqno(path_stem.tail & ".list")

  let exes = redstar_exe()             # Setup the executables
  let params = redstar_setup(path_stem.tail, path_chan.tail, path_irrep.tail, seqno)
  let corrs = generateCorr2Pt(params)

  run_redstar_npt(params, corrs, exes)
  

