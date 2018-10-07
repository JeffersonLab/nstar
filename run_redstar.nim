## Driver of the redstar codes on SLURM

import
  restar_chain

# Types need for submitter
campaign: contractions
jobtemplate:
  nodes: 1
  walltime: "12:00:00"
  queuename: "ANALY_TJLAB_LQCD"
  outputFile: "/volatile/users/danielt/forDaniel/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265/kpi.3half/000_A1p/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265.out<iter>.gz"
  command: |+

  
#-----------------------------------------------------------------------------
when isMainModule:
  import base, redstar_input, colorvec_hadron_node_input, serializetools/serializexml, xmltree

  

  # We need the base

#proc basic_setup(arch: string; stem, chan, irrep: string, seqno: string): RedstarRuns_t =
  let params = basic_setup("12s", "szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265", "Omega", "000_Hg", "1000a")

  echo "Check params"
  echo $params

  echo "Build a Colorvec hadron node input"
  let had_node_input = newHadronNodeInput(params)
  echo $had_node_input
  writeFile("colorvec.xml", xmlHeader & $xmlToStr(serializeXML(had_node_input, "ColorVecHadron")))

  echo "Build a redstar hadron node input"
  let red_input = newRedstarInput(params)
  echo $red_input
  writeFile("redstar.xml", xmlHeader & $xmlToStr(serializeXML(red_input, "RedstarNPt")))
