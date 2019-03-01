## Run redstar

import redstar_input, redstar_exes, run/chroma/colorvec_work, run/redstar/run_redstar_npt, hadron_sun_npart_npt_corr
import serializetools/serializexml
import serializetools/array1d
import seqno_list
import os, xmltree
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


#----------------------------------------------------------------------------
when isMainModule:
  import times
  echo "Run run_redstar_3pt: " & $now()
  #let pwd = getCurrentDir()
  #let pwd = "/home/edwards/qcd/data/redstar/analysis/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/k_kstar_3pt/000_T1mP"
  let pwd = "/home/edwards/qcd/data/redstar/analysis/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/pi_rho_3pt/000_T1mP"
  let path_irrep = splitPath(pwd)
  let path_chan  = splitPath(path_irrep.head)
  let path_stem  = splitPath(path_chan.head)
  let seqno = nextSeqno(path_stem.tail & ".list")

  let exes = redstar_exe()             # Setup the executables
  let params = redstar_setup(path_stem.tail, path_chan.tail, path_irrep.tail, seqno)
  let corrs = generateCorr3Pt(params)

  run_redstar_npt(params, corrs, exes)

  for f in items(params.elemental_files.unsmeared_meson_dbs):
    echo "Removing ", f
    discard tryRemoveFile(f)

  echo "Finished run_redstar_3pt: " & $now()
