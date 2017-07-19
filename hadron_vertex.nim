## Reduced set of hadron vertex info

import hashes

##----------------------------------------------------------------------------------
## The key for the hadron nodes used here

type
  HadronVertex_t* = object
    name*:        string              ## Some string label for the operator 
    smear*:       string              ## Some string label for the smearing of this operator 
    `type`*:      char                ## Type of hadron, e.g. M=2-quark meson, B=3-quark baryon, etc. 
    piece_num*:   cint                ## 1-based piece number of a hadron 
    Cconj*:       bool                ## Is the node (gamma matrix structure) C-conjugated? 
    twoI_z*:      cint                ## Isospin_z - here, always set to 0 for compatibility purposes 
    row*:         cint                ## Some row indicator of irrep, etc. 
    #mom*:         array[0..2, cint]   ## D-1 momentum of the operator 
    mom*:         seq[cint]           ## D-1 momentum of the operator 
    creation_op*: bool                ## Is this a creation ops?  
    smearedP*:    bool                ## Does this operators use distillation/distillution? 
  

proc newHadronVertex_t*(): HadronVertex_t =
  ## Constructor
  result.`type`        = '\0'
  result.piece_num     = 0
  result.Cconj         = false
  result.twoI_z        = 0
  result.row           = 0
  result.creation_op   = false
  result.smearedP      = false


proc hash*(x: HadronVertex_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h

