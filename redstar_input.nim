## Params for redstar_gengraph and redstar_npt

import
  op_params, hadron_sun_npart_npt_corr, redstar_chain

type
  RedstarRuns_t* = object                       ## Parameters for redstar
    arch*:                      string          ## Architecture description ("12s", etc.)
    stem*:                      string          ## Convenience copy
    chan*:                      string          ## Channel like "Omega"
    irrep*:                     string          ## Irrep name of form 000_Hg, etc.
    t_origin*:                  cint            ## Time origin
    layout*:                    Layout_t        ## Lattice size info
    convertUDtoL*:              bool            ## Convert  u/d  quarks to l quarks
    convertUDtoS*:              bool            ## Convert  u/d  quarks to s quarks
    mass_l*:                    string
    mass_s*:                    string
    mass_c*:                    string
    run_mode*:                  string
    include_all_rows*:          bool
    output_dir*:                string
    output_db*:                 string
    num_vecs*:                  cint            ## num_vecs for hadron_node
    Nt_corr*:                   cint            ## length of each correlator
    use_derivP*:                bool            ## use derivs for meson elementals
    autoIrrepCG*:               bool            ## Use auto spatial irreps
    rephaseIrrepCG*:            bool            ## Rephase irreps
    t_sources*:                 seq[cint]       ## time sources
    proj_ops_xmls*:             seq[string]     ## The XML files with projected operator definitions
    corr_graph_xml*:            string          ## Map of correlator graph-map and weights in xml
    corr_graph_db*:             string          ## (Required) Map of correlator graph-map and weights
    hadron_npt_graph_db*:       string          ## Holds graphs - modified on output
    noneval_graph_xml*:         string          ## Keys of graphs not evaluatable
    hadron_node_dbs*:           seq[string]     ## Input hadron nodes
    smeared_hadron_node_xml*:   string          ## Smeared hadron nodes - output
    smeared_hadron_node_db*:    string          ## Smeared hadron nodes
    unsmeared_hadron_node_xml*: string          ## Unsmeared hadron nodes - output
    unsmeared_hadron_node_db*:  string          ## Smeared hadron nodes - output
    ensemble*:                  string          ## Information about this ensemble
    prop_dbs*:                  seq[string]     ## The dbs that contains propagator bits
    glue_dbs*:                  seq[string]     ## The db that contains glueball colorvector contractions
    meson_dbs*:                 seq[string]     ## The db that contains meson colorvector contractions
    baryon_dbs*:                seq[string]     ## The db that contains baryon colorvector contractions
    tetra_dbs*:                 seq[string]     ## The db that contains tetraquark colorvector contractions


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
  result.Param.t_origin = params.t_origin
  result.Param.bc_spec = -1
  result.Param.Layout = params.layout
  result.Param.ensemble = params.ensemble
  result.DBFiles.proj_ops_xmls = params.proj_ops_xmls
  result.DBFiles.corr_graph_xml = params.corr_graph_xml
  result.DBFiles.corr_graph_db = params.corr_graph_db
  result.DBFiles.hadron_npt_graph_db = params.hadron_npt_graph_db
  result.DBFiles.noneval_graph_xml = params.noneval_graph_xml
  result.DBFiles.hadron_node_dbs = params.hadron_node_dbs
  result.DBFiles.smeared_hadron_node_xml = params.smeared_hadron_node_xml
  result.DBFiles.smeared_hadron_node_db = params.smeared_hadron_node_db
  result.DBFiles.unsmeared_hadron_node_xml = params.unsmeared_hadron_node_xml
  result.DBFiles.unsmeared_hadron_node_db = params.unsmeared_hadron_node_db


#-----------------------------------------------------------------------------
proc newSmearedHadronNodeInput*(params: RedstarRuns_t): SmearedHadronNodeInput_t =
  ## Construct smeared hadron node params from output of user input
  result.Param.version = 5
  result.Param.num_vecs = params.num_vecs
  result.Param.use_derivP = params.use_derivP
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'l', mass: params.mass_l))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 's', mass: params.mass_s))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'c', mass: params.mass_c))
  result.DBFiles.hadron_node_xmls = @[params.smeared_hadron_node_xml]
  result.DBFiles.prop_dbs = params.prop_dbs
  result.DBFiles.meson_dbs = params.meson_dbs
  result.DBFiles.tetra_dbs = params.tetra_dbs
  result.DBFiles.output_db = params.smeared_hadron_node_db


#-----------------------------------------------------------------------------
proc newUnsmearedHadronNodeInput*(params: RedstarRuns_t): UnsmearedHadronNodeInput_t =
  ## Construct unsmeared hadron node params from output of user input
  result.Param.version = 5
  result.Param.num_vecs = params.num_vecs
  result.Param.use_derivP = false
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'l', mass: params.mass_l))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 's', mass: params.mass_s))
  result.Param.FlavorToMass.add(FlavorToMass_t(flavor: 'c', mass: params.mass_c))
  result.DBFiles.hadron_node_xmls = @[params.unsmeared_hadron_node_xml]
  result.DBFiles.unsmeared_meson_dbs = @[params.unsmeared_hadron_node_db]

  
