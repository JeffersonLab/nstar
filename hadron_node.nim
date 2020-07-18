## Hadron single particle nodes

import hadron_vertex, serializetools/array1d, tables
import hashes



## ----------------------------------------------------------------------------
## ! Key for Hadron operator

type
  KeyHadronNode_t* = object
    vertex*: HadronVertex_t    ## !< Hadron vertex info
    self*: Table[cint, cint]   ## !< Self contractions: [left_slot -> right_slot]
    quarks*: Array1dO[Quark_t] ## !< Each quark field

  Quark_t* = object
    prop_type*: string         ## !< Distillution source/solution type
    t_source*: cint            ## !< Propagator source time slice
    t_slice*: cint             ## !< Propagator sink time slice
    conj*: bool                ## !< Is quark conjugated
    flavor*: char              ## !< Flavor label for this quark field

#[
proc hash*(x: KeyHadronNode_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h
]#
