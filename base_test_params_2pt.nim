## Generate params for redstar_npt

import base_test_2pt
import redstar_exe_nstar
import irrep_util, run/chroma/colorvec_work, cgc_su3, cgc_irrep_mom
import redstar_chain, redstar_input, run/chroma/colorvec_work, redstar_work_files

# Hacks
let debug = true

#----------------------------------------------------------------------------------------------
proc redstar_setup*(arch: string; stem, chan, irrep: string, seqno: string): RedstarRuns_t =
  ## Construct parameters for redstar
  result.stem = stem
  result.chan = chan
  result.irrep = irrep
  result.arch  = arch

  # Extract file params
  result.layout.lattSize  = [4,4,4,16]
  result.layout.decayDir  = 3

  # Set time origin in canonical fashion
  result.t_origin = 0

  # base params
  result.num_vecs = 10
  result.Nt_corr  = 16
  result.use_derivP = true
  result.autoIrrepCG = false

  result.mass_l   = "U0.05"
  result.mass_s   = "U0.1"
  result.mass_c   = "fred"

#  result.t_sources = @[0,16,32,48,64,80,96,112]
  result.t_sources = @[0,4,8]
#  result.t_sources = @[0]

# var use_cp = true
  var use_cp = false

  #----------------------------------------
# Hacks
  if debug:
    result.num_vecs = 3
    result.Nt_corr  = 4
    result.t_sources = @[0]
    use_cp = false
# end of hacks

  #----------------------------------------
  let cache_dir = "/Users/edwards/Documents/qcd/data/redstar/test/test_dirs"
  let volatile_dir = "/Users/edwards/Documents/qcd/data/redstar/test/test_dirs"
  let work_dir = "/Users/edwards/Documents/qcd/data/redstar/test/test_dirs"
  let scratch_dir = "/tmp"

  let corr_tag = "corr1"

  result.proj_op_xmls = @["../weights/weights.pion.xml",
                          "../weights/weights.kaon.xml",
                          "../weights/weights.kbar.xml",
                          "../weights/weights.eta.xml"]
 
  result.ops_xmls = @["../single.ops.xml",
                      "../two.ops.xml"]
  
  result.source_ops_list = "./orthog.list"
  result.sink_ops_list   = result.source_ops_list

  result.convertUDtoL = true
  result.convertUDtoS = true

  let mom_rep = opListToIrrepMom(irrep)
  echo "irrep = ", irrep, "  mom = ", mom_rep.mom

  result.irmom  = KeyCGCIrrepMom_t(row: 1, mom: mom_rep.mom)

  result.flavor = KeyCGCSU3_t(twoI: 2, threeY: 0, twoI_Z: 2)    ## THIS IS A HACK ##

  result.runmode = "default"
  result.include_all_rows = false

  result.work_files = redstar_work_files(stem, chan, irrep, corr_tag, result.num_vecs, result.t_sources,
                                         scratch_dir, work_dir, volatile_dir,
                                         seqno)
  result.elemental_files = redstar_elemental_files(stem, t_sources, cache_dir, seqno, use_cp)

  discard tryRemoveFile(result.work_files.hadron_npt_graph_db)     # Check me

  result.ensemble = stem

  

  
