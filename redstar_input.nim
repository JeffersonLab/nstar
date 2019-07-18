## Params for redstar_gengraph and redstar_npt

import cgc_su3, cgc_irrep_mom
import op_params, hadron_sun_npart_npt_corr, redstar_chain, redstar_work_files, redstar_elemental_files
  

type
  RedstarRuns_t* = object                       ## Parameters for redstar
    arch*:                      string          ## Architecture description ("12s", etc.)
    stem*:                      string          ## Convenience copy
    chan*:                      string          ## Channel like "Omega"
    irrep*:                     string          ## Irrep name of form 000_Hg, etc.
    t_origin*:                  int             ## Time origin
    layout*:                    Layout_t        ## Lattice size info
    convertUDtoL*:              bool            ## Convert  u/d  quarks to l quarks
    convertUDtoS*:              bool            ## Convert  u/d  quarks to s quarks
    mass_l*:                    string
    mass_s*:                    string
    mass_c*:                    string
    run_mode*:                  string
    include_all_rows*:          bool
    num_vecs*:                  int             ## num_vecs for hadron_node
    Nt_corr*:                   int             ## length of each correlator
    use_derivP*:                bool            ## use derivs for meson elementals
    autoIrrepCG*:               bool            ## Use auto spatial irreps
    rephaseIrrepCG*:            bool            ## Rephase irreps
    t_sources*:                 seq[int]        ## time sources
    t_source*:                  int             ## time source for 3pt
    t_sink*:                    int             ## time sink for 3pt
    flavor*:                    KeyCGCSU3_t
    irmom*:                     KeyCGCIrrepMom_t
    source_ops_list*:           string
    sink_ops_list*:             string
    work_files*:                RedstarWorkFiles_t ## Convenient place to hold the worker-bee files for running redstar
    elemental_files*:           RedstarElementalFiles_t ## Convenient place to hold the worker-bee files for running redstar
    ops_xmls*:                  seq[string]
    proj_op_xmls*:              seq[string]     ## The XML files with projected operator definitions
    ensemble*:                  string          ## Information about this ensemble


#-----------------------------------------------------------------------------
proc newRedstarInput*(params: RedstarRuns_t; corrs: seq[KeyHadronSUNNPartNPtCorr_t]): RedstarInput_t =
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
  result.Param.t_origin = params.t_origin
  result.Param.bc_spec = -1
  result.Param.Layout = params.layout
  result.Param.ensemble = params.ensemble
  result.Param.NPointList = corrs
  result.DBFiles.proj_op_xmls = params.proj_op_xmls
  result.DBFiles.corr_graph_xml = params.work_files.corr_graph_xml
  result.DBFiles.corr_graph_db = params.work_files.corr_graph_db
  result.DBFiles.hadron_npt_graph_db = params.work_files.hadron_npt_graph_db
  result.DBFiles.noneval_graph_xml = params.work_files.noneval_graph_xml
  result.DBFiles.hadron_node_dbs = params.work_files.hadron_node_dbs
  result.DBFiles.smeared_hadron_node_xml = params.work_files.smeared_hadron_node_xml
  result.DBFiles.smeared_hadron_node_db = params.work_files.smeared_hadron_node_db
  result.DBFiles.unsmeared_hadron_node_xml = params.work_files.unsmeared_hadron_node_xml
  result.DBFiles.unsmeared_hadron_node_db = params.work_files.unsmeared_hadron_node_db
  result.DBFiles.output_db = params.work_files.output_db


#-----------------------------------------------------------------------------
proc newSmearedHadronNodeInput*(params: RedstarRuns_t): SmearedHadronNodeInput_t =
  ## Construct smeared hadron node params from output of user input
  result.Param.version = 5
  result.Param.num_vecs = params.num_vecs
  result.Param.use_derivP = params.use_derivP
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'l', mass: params.mass_l))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 's', mass: params.mass_s))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'c', mass: params.mass_c))
  result.DBFiles.hadron_node_xmls = @[params.work_files.smeared_hadron_node_xml]
  result.DBFiles.prop_dbs = params.elemental_files.prop_dbs
  result.DBFiles.meson_dbs = params.elemental_files.meson_dbs
  result.DBFiles.baryon_dbs = params.elemental_files.baryon_dbs
  result.DBFiles.tetra_dbs = params.elemental_files.tetra_dbs
  result.DBFiles.output_db = params.work_files.smeared_hadron_node_db


#-----------------------------------------------------------------------------
proc newUnsmearedHadronNodeInput*(params: RedstarRuns_t): UnsmearedHadronNodeInput_t =
  ## Construct unsmeared hadron node params from output of user input
  result.Param.version = 5
  result.Param.num_vecs = params.num_vecs
  result.Param.use_derivP = false
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'l', mass: params.mass_l))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 's', mass: params.mass_s))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'c', mass: params.mass_c))
  result.DBFiles.hadron_node_xmls = @[params.work_files.unsmeared_hadron_node_xml]
  result.DBFiles.unsmeared_meson_dbs = params.elemental_files.unsmeared_meson_dbs
  result.DBFiles.output_db = params.work_files.unsmeared_hadron_node_db

  
