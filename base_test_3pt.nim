## Generate params for redstar_npt

import system, strutils, os
import irrep_util, run/chroma/colorvec_work, cgc_su3, cgc_irrep_mom
import redstar_chain, redstar_input, run/chroma/colorvec_work, redstar_work_files, redstar_elemental_files

# Hacks
let debug = false

#----------------------------------------------------------------------------------------------
proc redstar_setup*(stem, chan, irrep: string, seqno: string): RedstarRuns_t =
  ## Construct parameters for redstar
  result.stem = stem
  result.chan = chan
  result.irrep = irrep

  # Extract file params
  #result.layout.lattSize  = [4,4,4,16]
  result.layout.lattSize  = extractLattSize(stem)
  result.layout.decayDir  = 3

  # Set time origin in canonical fashion
  result.t_origin = getTimeOrigin(result.layout.lattSize[3], seqno)

  # base params
  result.num_vecs = 64
  result.Nt_corr  = 25
  result.use_derivP = true
  result.autoIrrepCG = false

  result.mass_l   = "U-0.0840"
  result.mass_s   = "U-0.0743"
  result.mass_c   = "fred"

  result.t_source = 0
  result.t_sink   = 24
  result.t_sources = @[result.t_source]

# var use_cp = true
  var use_cp = false

  #----------------------------------------
# Hacks
  if debug:
    result.num_vecs = 16
    result.t_sources = @[0]
    use_cp = false
# end of hacks

  #----------------------------------------
  let cache_dir = "/lustre/cache/Spectrum/Clover/NF2+1"
  let volatile_dir = "/lustre/volatile/Spectrum/Clover/NF2+1"
  let work_dir = "/work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1"
  let scratch_dir = "/scratch"

  let corr_tag = "dt_0_24.corr1"

  result.proj_op_xmls = @["../weights/weights.pion.xml",
                          "../weights/weights.kaon.xml",
                          "../weights/weights.kbar.xml",
                          "../weights/weights.rho.xml"]

#  "../weights/weights.eta.xml"]
 
  result.ops_xmls = @["./pipi.kfac.xml"]
  
  result.source_ops_list = "./orthog.list"
  result.sink_ops_list   = result.source_ops_list

  result.convertUDtoL = true
  result.convertUDtoS = false

  #let mom_rep = opListToIrrepMom(irrep)
  #echo "irrep = ", irrep, "  mom = ", mom_rep.mom

  #result.irmom  = KeyCGCIrrepMom_t(row: 1, mom: mom_rep.mom)

  #result.flavor = KeyCGCSU3_t(twoI: 2, threeY: 0, twoI_Z: 2)    ## THIS IS A HACK ##

  result.runmode = "default"
  result.include_all_rows = false

  result.work_files = redstar_work_files(stem, chan, irrep, corr_tag, result.num_vecs, result.t_sources,
                                         scratch_dir, work_dir, volatile_dir,
                                         seqno)
  result.elemental_files = redstar_elemental_files(stem, result.t_sources, cache_dir, seqno, use_cp)

  discard tryRemoveFile(result.work_files.hadron_npt_graph_db)     # Check me

  result.ensemble = stem

  

  
