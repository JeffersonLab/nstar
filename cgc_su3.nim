## CG tables for SU(3)

import hashes

#---------------------------------
# Structure for SU(3)
# The conventions follow from arXiv:nucl-th/9502037 
type
  KeyCGCSU3_t* = object
    twoI*:    cint
    threeY*:  cint
    twoI_z*:  cint


#proc constructKeyCGCSU3_t*(): KeyCGCSU3_t {.constructor,
#    importcpp: "Hadron::KeyCGCSU3_t(@)", header: "cgc_su3.h".}
#proc constructKeyCGCSU3_t*(I: cint; Y: cint; Iz: cint): KeyCGCSU3_t {.constructor,
#    importcpp: "Hadron::KeyCGCSU3_t(@)", header: "cgc_su3.h".}


proc hash*(x: KeyCGCSU3_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h
