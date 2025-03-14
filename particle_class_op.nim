## Hadron-like particle operators

import hashes

#----------------------------------------------------------------------------
# Key for a hadron-like particle operator
type
  KeyParticleClassOp_t* = object
    name*:      string            ## Some string label for the operator 
    smear*:     string            ## Some string label for the smearing of this operator 
    mom_class*: array[0..2, cint] ## D-1 Canonical momentum type 
#    disp_list*: seq[cint]         ## 1-based displacement list
  

#proc constructKeyParticleClassOp_t*(): KeyParticleClassOp_t 
#proc constructKeyParticleClassOp_t*(n: string; s: string; m: array[0..2, cint]): KeyParticleClassOp_t {.
#    constructor, importcpp: "Hadron::KeyParticleClassOp_t(@)", header: "particle_class_op.h".}
#proc constructKeyParticleClassOp_t*(vert: HadronVertex_t): KeyParticleClassOp_t {.constructor,
#    importcpp: "Hadron::KeyParticleClassOp_t(@)", header: "particle_class_op.h".}

proc hash*(x: KeyParticleClassOp_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h

