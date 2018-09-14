##  Input for colorvec hadron_node
## 

import
  redstar_chain

## Map a flavor label to a mass label
type
  FlavorToMass_t* = object
    flavor*: char
    mass*:   string


## Parameters for running program, include isospin information here?
type
  HadronNodeParam_t* = object
    num_vecs*:       cint                ## The number of vectors to use. Not an array
    use_derivP*:     bool                ## Meson (& glueball) elementals use derivatives
    flavor_to_mass*: seq[FlavorToMass_t] ## Mass flavor labels to mass labels
  

## DB files
type
  HadronNodeDBFiles_t* = object
    hadron_node_xmls*: seq[string]       ## The XML file with all the nodes
    prop_dbs*:   seq[string]             ## The dbs that contains propagator bits
    glue_dbs*:   seq[string]             ## The db that contains glueball colorvector contractions
    meson_dbs*:  seq[string]             ## The db that contains meson colorvector contractions
    baryon_dbs*: seq[string]             ## The db that contains baryon colorvector contractions
    tetra_dbs*:  seq[string]             ## The db that contains tetraquark colorvector contractions
    output_db*:  string                  ## The db that holds the hadron node db
  

## Mega-structure of all input
type
  ColorVecHadronInput_t* = object
    param*:      HadronNodeParam_t
    db_files*:   HadronNodeDBFiles_t


#-----------------------------------------------------------------------------
proc newHadronNodeInput*(params: RedstarRuns_t): ColorVecHadronInput_t =
  ## Construct redstar params from output of user input
  result.param.num_vecs = params.num_vecs
  result.param.use_derivP = params.use_derivP
  result.param.flavor_to_mass.add(FlavorToMass_t(flavor: 'l', mass: params.mass_l))
  result.param.flavor_to_mass.add(FlavorToMass_t(flavor: 's', mass: params.mass_s))
  result.param.flavor_to_mass.add(FlavorToMass_t(flavor: 'c', mass: params.mass_c))
  result.db_files.hadron_node_xmls = @[params.smeared_hadron_node_xml]
  result.db_files.prop_dbs = params.prop_dbs
  result.db_files.meson_dbs = params.meson_dbs
  result.db_files.tetra_dbs = params.tetra_dbs
  result.db_files.output_db = params.smeared_hadron_node_db

