## Generate params for redstar_npt

import
  system, strutils, os

#
type
  RedstarWorkFiles_t* = object
    output_dir*:                string
    output_db*:                 string
    output_file_base*:          string          ## Output file name without the seqno
    redstar_ini*:               string
    smeared_ini*:               string
    unsmeared_ini*:             string
    file_out*:                  string
    corr_graph_xml*:            string          ## Map of correlator graph-map and weights in xml
    corr_graph_db*:             string          ## (Required) Map of correlator graph-map and weights
    hadron_npt_graph_db*:       string          ## Temporary graph output
    hadron_npt_graph_dir*:      string          ## Holds graphs - modified on output
    noneval_graph_xml*:         string          ## Keys of graphs not evaluatable
    hadron_node_dbs*:           seq[string]     ## Input hadron nodes
    smeared_hadron_node_xml*:   string          ## Smeared hadron nodes - output
    smeared_hadron_node_db*:    string          ## Smeared hadron nodes
    unsmeared_hadron_node_xml*: string          ## Unsmeared hadron nodes - output
    unsmeared_hadron_node_db*:  string          ## Smeared hadron nodes - output


#----------------------------------------------------------------------------------------------
proc redstar_work_files*(stem, chan, irrep: string,
                         corr_tag: string,
                         num_vecs: int,
                         t_sources: seq[int],
                         scratch_dir, work_dir, volatile_dir: string,
                         seqno: string): RedstarWorkFiles_t =
  ## Construct work filenames for redstar
  var corr  = stem & ".n" & $num_vecs & "." & chan & "." & irrep & "." & "t0"
  for tt in t_sources:
    corr = corr & "_" & $tt

  let scr = scratch_dir & "/"

  let out_db = corr & "." & corr_tag & ".sdb"
  result.output_dir = work_dir & "/" & stem & "/redstar/" & chan & "/sdbs_rge"
  result.output_db = scr & out_db & seqno
  result.output_file_base = result.output_dir & "/" & out_db

  result.redstar_ini = scr & corr & ".redstar.ini.xml" & seqno
  result.smeared_ini = scr & corr & ".smeared_hadron_node.ini.xml" & seqno
  result.unsmeared_ini = scr & corr & ".unsmeared_hadron_node.ini.xml" & seqno
  result.file_out = scr & corr & ".out.xml" & seqno

  result.corr_graph_db = scr & corr & ".corr_graph.sdb" & seqno
  result.noneval_graph_xml = scr & corr & "." & "noneval_graph.xml" & seqno

  result.smeared_hadron_node_db = scr & corr & ".smeared_hadron_node.sdb" & seqno
  result.smeared_hadron_node_xml = scr & corr & ".smeared_hadron_node.xml" & seqno

  result.unsmeared_hadron_node_db = scr & corr & ".unsmeared_hadron_node.sdb" & seqno
  result.unsmeared_hadron_node_xml = scr & corr & ".unsmeared_hadron_node.xml" & seqno

  result.hadron_node_dbs = @[result.smeared_hadron_node_db, result.unsmeared_hadron_node_db]

  result.hadron_npt_graph_db = scr & stem & ".n" & $num_vecs & ".graph.sdb" & seqno
  result.hadron_npt_graph_dir = volatile_dir & "/" & stem & "/rge_temp/graphs"

  

  
