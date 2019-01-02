## Run redstar

import redstar_input, redstar_exes, run/chroma/colorvec_work, run/redstar/run_redstar_npt, hadron_sun_npart_npt_corr
import serializetools/serializexml
import serializetools/array1d
import xmltree, os
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
  echo "Run redstar"
  let pwd = getCurrentDir()
  let path_irrep = splitPath(pwd)
  let path_chan  = splitPath(path_irrep.head)
  let path_stem  = splitPath(path_chan.head)
  let seqno = "1"

  let exes = redstar_exe()             # Setup the executables
  let params = redstar_setup(path_stem.tail, path_chan.tail, path_irrep.tail, seqno)
  let corrs = generateCorr3Pt(params)

  run_redstar_npt(params, corrs, exes)
  

