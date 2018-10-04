## Parameters used by the redstar chain, including redstar_gen_graph, hadron_node, redstar_npt

import
  op_params
  
#
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
    run_mode*:                  string
    include_all_rows*:          bool
    output_dir*:                string
    output_db*:                 string
    num_vecs*:                  cint            ## num_vecs for hadron_node
    Nt_corr*:                   cint            ## length of each correlator
    use_derivP*:                bool            ## use derivs for meson elementals
    autoIrrepCG*:               bool            ## Use auto spatial irreps
    rephaseIrrepCG*:            bool            ## Rephase irreps
    t_sources*:                 seq[int]        ## time sources
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


# 
type
  ColorvecRuns_t* = object                      ## Parameters for colorvec
    mass_l*:                    string          ## Light quark label
    mass_s*:                    string          ## Strange quark label
    mass_c*:                    string          ## Charm quark label
    prop_dbs*:                  seq[string]     ## The dbs that contains propagator bits
    glue_dbs*:                  seq[string]     ## The db that contains glueball colorvector contractions
    meson_dbs*:                 seq[string]     ## The db that contains meson colorvector contractions
    baryon_dbs*:                seq[string]     ## The db that contains baryon colorvector contractions
    tetra_dbs*:                 seq[string]     ## The db that contains tetraquark colorvector contractions
    

      
