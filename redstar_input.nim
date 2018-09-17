## Params for redstar_gengraph and redstar_npt

import
  op_params, hadron_sun_npart_npt_corr,
  redstar_chain

## Redstar input params
type
  RedstarParam_t* = object
    version*: cint                    ## Version number of input
    diagnostic_level*: cint           ## How much verbosity you are willing to stand
    Nt_corr*: cint                    ## Length of correlator to compute
    t_origin*: cint                   ## Where is the actual time origin of the lattice
    bc_spec*: cint                    ## Sign for the boundary conditions multiplier at the border
    convertUDtoL*: bool               ## Convert  u/d  quarks to l quarks
    convertUDtoS*: bool               ## Convert  u/d  quarks to s quarks
    average_1pt_diagrams*: bool       ## Time-slice average diagrams composed of 1pts
    autoIrrepCG*: bool                ## Use automatically generated irrep CGs
    rephaseIrrepCG*: bool             ## Rephase irrep CGs
    zeroUnsmearedGraphsP*: bool       ## Zero out graphs that are not computable because of lack of distillation
    ensemble*: string                 ## Information about this ensemble
    Layout*: Layout_t                 ## Lattice size info
    NPointList*: seq[KeyHadronSUNNPartNPtCorr_t] ## Particles involved in the contractions
  

## DB files
type
  DBFiles_t* = object
    proj_op_xmls*: seq[string]        ## The XML files with projected operator definitions
    corr_graph_xml*: string           ## Map of correlator graph-map and weights in xml
    corr_graph_db*: string            ## (Required) Map of correlator graph-map and weights
    hadron_npt_graph_db*: string      ## Holds graphs - modified on output
    noneval_graph_xml*: string        ## Keys of graphs not evaluatable
    hadron_node_dbs*: seq[string]     ## Input hadron nodes
    smeared_hadron_node_xml*:   string          ## Smeared hadron nodes - output
    smeared_hadron_node_db*:    string          ## Smeared hadron nodes
    unsmeared_hadron_node_xml*: string          ## Unsmeared hadron nodes - output
    unsmeared_hadron_node_db*:  string          ## Smeared hadron nodes - output
  

## Mega-structure of all input
type
  RedstarInput_t* = object
    Param*:    RedstarParam_t
    DBFiles*: DBFiles_t


#-----------------------------------------------------------------------------
proc newRedstarInput*(params: RedstarRuns_t): RedstarInput_t =
  ## Construct redstar params from output of user input
  result.Param.version = 11
  result.Param.convertUDtoL = params.convertUDtoL
  result.Param.convertUDtoS = params.convertUDtoS
  result.Param.average_1pt_diagrams = true
  result.Param.Nt_corr = params.Nt_corr
  result.Param.diagnostic_level = 0
  result.Param.zeroUnsmearedGraphsP = true
  result.Param.autoIrrepCG = params.autoIrrepCG
  result.Param.rephaseIrrepCG = params.rephaseIrrepCG
  result.Param.t_origin = cint(params.t_origin)
  result.Param.bc_spec = -1
  result.Param.Layout = params.layout
  result.Param.ensemble = params.ensemble
  result.DBFiles.proj_op_xmls = params.proj_ops_xmls
  result.DBFiles.corr_graph_xml = params.corr_graph_xml
  result.DBFiles.corr_graph_db = params.corr_graph_db
  result.DBFiles.hadron_npt_graph_db = params.hadron_npt_graph_db
  result.DBFiles.noneval_graph_xml = params.noneval_graph_xml
  result.DBFiles.hadron_node_dbs = params.hadron_node_dbs
  result.DBFiles.smeared_hadron_node_xml = params.smeared_hadron_node_xml
  result.DBFiles.smeared_hadron_node_db = params.smeared_hadron_node_db
  result.DBFiles.unsmeared_hadron_node_xml = params.unsmeared_hadron_node_xml
  result.DBFiles.unsmeared_hadron_node_db = params.unsmeared_hadron_node_db

