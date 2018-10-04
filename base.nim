## Generate params for redstar_npt

import
  system, strutils, os

import  
  redstar_chain,
  run/chroma/colorvec_work

# Hacks
let debug = false

#----------------------------------------------------------------------------------------------
proc redstar_setup*(arch: string; stem, chan, irrep: string, seqno: string): RedstarRuns_t =
  ## Construct parameters for redstar
  result.stem = stem
  result.chan = chan
  result.irrep = irrep
  result.arch  = arch

  # Extract file params
  result.layout.latt_size  = extractLattSize(stem)
  result.layout.decay_dir  = 3

  # Set time origin in canonical fashion
  result.t_origin = getTimeOrigin(result.layout.latt_size[3], seqno)

  # base params
  result.num_vecs = 256
  result.Nt_corr  = 40
  result.use_derivP = true
  result.autoIrrepCG = false

#  result.t_sources = @[0,16,32,48,64,80,96,112]
  result.t_sources = @[0,64,128,192]
#  result.t_sources = @[0]

  #----------------------------------------
# Hacks
  if debug:
    result.num_vecs = 3
    result.Nt_corr  = 4
    result.t_sources = @[0]
# end of hacks

  #----------------------------------------
  let cache_dir = "/cache/Spectrum/Clover/NF2+1"
  let lhpc_dir = "/cache/LHPC/Spectrum/Clover/NF2+1"
  let volatile_dir = "/volatile/Spectrum/Clover/NF2+1"
  let work_dir = "/work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1"

  let corr_tag = "corr1"

  result.proj_ops_xmls = @["../weights/weights.pion.xml",
                           "../weights/weights.kaon.xml",
                           "../weights/weights.kbar.xml",
                           "../weights/weights.eta.xml"
  ]

#  result.ops_xmls = @["../single.ops.xml"]
  
#  result.source_ops_list = "./orthog.list"
#  result.sink_ops_list = source_ops_list

  let momm = split(irrep, "_")
  let mom = momm[0]
  echo "irrep = ", irrep, "  mom = ", mom[0], mom[1], mom[2]

  result.convertUDtoL = true
  result.convertUDtoS = true

  result.runmode = "default"
  result.include_all_rows = false

  var corr  = stem & ".n" & $result.num_vecs & "." & chan & "." & irrep & "." & "t0"
  for tt in result.t_sources:
    corr = corr & "_" & $tt

  result.output_dir = work_dir & "/" & stem & "/redstar/" & chan & "/sdbs"
  result.output_db = corr & "." & corr_tag & ".sdb" & seqno

  result.corr_graph_db = corr & ".corr_graph.sdb" & seqno
  result.noneval_graph_xml = corr & "." & "noneval_graph.xml" & seqno

  result.smeared_hadron_node_db = corr & ".smeared_hadron_node.sdb" & seqno
  result.smeared_hadron_node_xml = corr & ".smeared_hadron_node.xml" & seqno

  result.unsmeared_hadron_node_db = corr & ".unsmeared_hadron_node.sdb" & seqno
  result.unsmeared_hadron_node_xml = corr & ".unsmeared_hadron_node.xml" & seqno

  result.hadron_node_dbs = @[result.smeared_hadron_node_db]
  result.hadron_npt_graph_db = volatile_dir & "/" & stem & "/rge_temp/graphs/" & stem & ".n" & $result.num_vecs & ".graph.sdb" & seqno
  discard tryRemoveFile(result.hadron_npt_graph_db)     # Check me

  result.ensemble = stem

  
#----------------------------------------------------------------------------------------------
proc colorvec_setup*(redstar: RedstarRuns_t, seqno: string): ColorvecRuns_t =
  ## Construct parameters for colorvec hadron node
  let stem = redstar.stem

# var use_cp = true
  var use_cp = false

  #----------------------------------------
# Hacks
  if debug:
    use_cp = false
# end of hacks

  result.mass_l   = "U-0.0860"
  result.mass_s   = "U-0.0743"

  let cache_dir = "/cache/Spectrum/Clover/NF2+1"
  let nn = ".n384"
  for quark_type in ["light", "strange"]:
    result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db_diagt0/" & stem & ".prop" & nn & "." & quark_type & ".diag_t0.sdb" & seqno, use_cp))

    for tt in redstar.t_sources:
      result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db/" & stem & ".prop" & nn & "." & quark_type & ".t0_" & $tt & ".sdb" & seqno, use_cp))

  result.meson_dbs = @[]
  
  # derivs
  let meson_path = cache_dir & "/" & stem & "/meson_db_deriv/" & stem & ".meson.deriv" & nn
  result.meson_dbs.add(copy_lustre_file(meson_path & ".d_0_1_2.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".d_3.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_1.d_0_1.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_1.d_2.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_2.d_0_1.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_2.d_2.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_3.d_0_1.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_3.d_2.sdb" & seqno, use_cp))

  result.baryon_dbs = @[]

  
