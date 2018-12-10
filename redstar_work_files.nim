## Generate params for redstar_npt

import
  system, strutils, os

#
type
  RedstarWorkFiles_t* = object
    output_dir*:                 string
    output_db*:                  string
    output_file_base*:           string
    corr_graph_db*:              string
    noneval_graph_xml*:          string
    smeared_hadron_node_db*:     string
    smeared_hadron_node_xml*:    string
    unsmeared_hadron_node_db*:   string
    unsmeared_hadron_node_xml*:  string
    hadron_npt_graph_db*:        string
    hadron_npt_graph_dir*:       string


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
  result.output_dir = work_dir & "/" & stem & "/redstar/" & chan & "/sdbs"
  result.output_db = scr & out_db & seqno
  result.output_file_base = result.output_dir & "/" & out_db

  result.corr_graph_db = scr & corr & ".corr_graph.sdb" & seqno
  result.noneval_graph_xml = scr & corr & "." & "noneval_graph.xml" & seqno

  result.smeared_hadron_node_db = scr & corr & ".smeared_hadron_node.sdb" & seqno
  result.smeared_hadron_node_xml = scr & corr & ".smeared_hadron_node.xml" & seqno

  result.unsmeared_hadron_node_db = scr & corr & ".unsmeared_hadron_node.sdb" & seqno
  result.unsmeared_hadron_node_xml = scr & corr & ".unsmeared_hadron_node.xml" & seqno

  result.hadron_npt_graph_db = scr & stem & ".n" & $num_vecs & ".graph.sdb" & seqno
  result.hadron_npt_graph_dir = volatile_dir & "/" & stem & "/rge_temp/graphs"

  

  
