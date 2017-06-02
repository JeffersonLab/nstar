## Hadron-like particle operators

import hadron_vertex, hashes

#----------------------------------------------------------------------------
# Key for a hadron-like particle operator
type
  KeyParticleOp_t* = object
    name*:     string            ## Some string label for the operator 
    smear*:    string            ## Some string label for the smearing of this operator 
    mom_type*: array[0..2, cint] ## D-1 Canonical momentum type 
  

#proc constructKeyParticleOp_t*(): KeyParticleOp_t 
#proc constructKeyParticleOp_t*(n: string; s: string; m: array[0..2, cint]): KeyParticleOp_t {.
#    constructor, importcpp: "Hadron::KeyParticleOp_t(@)", header: "particle_op.h".}
#proc constructKeyParticleOp_t*(vert: HadronVertex_t): KeyParticleOp_t {.constructor,
#    importcpp: "Hadron::KeyParticleOp_t(@)", header: "particle_op.h".}

proc hash*(x: KeyParticleOp_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h

