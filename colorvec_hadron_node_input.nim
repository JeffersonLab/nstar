##  Input for colorvec hadron_node
## 

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

