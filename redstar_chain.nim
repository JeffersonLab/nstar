## Parameters used by the redstar chain, including redstar_gen_graph, hadron_node, redstar_npt

import
  op_params, hadron_sun_npart_npt_corr
  
#
type
  RedstarParams_t* = object                     ## Parameters for redstar
    version*:                   int             ## Version number of input
    diagnostic_level*:          int             ## How much verbosity you are willing to stand
    Nt_corr*:                   int             ## Length of correlator to compute
    convertUDtoL*:              bool            ## Convert  u/d  quarks to l quarks
    convertUDtoS*:              bool            ## Convert  u/d  quarks to s quarks
    average_1pt_diagrams*:      bool            ## Time-slice average diagrams composed of 1pts
    zeroUnsmearedGraphsP*:      bool            ## Zero out graphs that are not computable because of lack of distillation
    autoIrrepCG*:               bool            ## Use automatically generated irrep CGs
    rephaseIrrepCG*:            bool            ## Rephase irrep CGs
    t_origin*:                  int             ## Where is the actual time origin of the lattice
    bc_spec*:                   int             ## Sign for the boundary conditions multiplier at the border
    Layout*:                    Layout_t        ## Lattice size info
    ensemble*:                  string          ## Information about this ensemble
    NPointList*:                seq[KeyHadronSUNNPartNPtCorr_t]  ## Particles involved in the contractions

  RedstarDBFiles_t* = object                    ## Parameters for redstar
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

  RedstarInput_t* = object                       ## Parameters for colorvec
    Param*:                     RedstarParams_t            
    DBFiles*:                   RedstarDBFiles_t

type
  FlavorToMass_t* = object                      ## Map a flavor label to a mass label
    flavor*:                    char         
    mass*:                      string  



type
  SmearedHadronNodeParams_t* = object           ## Parameters for smeared hadron nodes
    version*:                   int             ## Version number of input
    num_vecs*:                  int             ## Not an array
    use_derivP*:                bool            ## Meson (& glueball) elementals use derivatives
    FlavorToMass*:              seq[FlavorToMass_t]  ## Mass flavor labels to mass labels
    
  SmearedHadronNodeDBFiles_t* = object          ## Parameters for smeared hadron nodes
    hadron_node_xmls*:          seq[string]     ## The XML file with all the nodes
    prop_dbs*:                  seq[string]     ## The dbs that contains propagator bits
    glue_dbs*:                  seq[string]     ## The db that contains glueball colorvector contractions
    meson_dbs*:                 seq[string]     ## The db that contains meson colorvector contractions
    baryon_dbs*:                seq[string]     ## The db that contains baryon colorvector contractions
    tetra_dbs*:                 seq[string]     ## The db that contains tetraquark colorvector contractions
    output_db*:                 string          ## The db that holds the hadron node db
    
  SmearedHadronNodeInput_t* = object             ## Parameters for colorvec
    Param*:                     SmearedHadronNodeParams_t            
    DBFiles*:                   SmearedHadronNodeDBFiles_t


type
  UnsmearedHadronNodeParams_t* = object         ## Parameters for colorvec
    version*:                   int             ## Version number of input
    num_vecs*:                  int             ## Not an array
    use_derivP*:                bool            ## Meson (& glueball) elementals use derivatives
    FlavorToMass*:              seq[FlavorToMass_t]  ## Mass flavor labels to mass labels
    
  UnsmearedDBFiles_t* = object
    hadron_node_xmls*:          seq[string]     ## The XML file with all the nodes
    unsmeared_meson_dbs*:       seq[string]     ## The db that contains meson colorvector contractions
    output_db*:                 string          ## The db that holds the hadron node db
      
  UnsmearedHadronNodeInput_t* = object           ## Parameters for colorvec
    Param*:                     UnsmearedHadronNodeParams_t            
    DBFiles*:                   UnsmearedDBFiles_t

    
