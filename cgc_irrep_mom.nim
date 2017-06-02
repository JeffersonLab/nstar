## CG tables
##  
## Convention follows  arXiv:0508018

import hashes

## #---------------------------------
## #! CLEBSCH-GORDAN coefficients for use with rows of irreps and also momentum
## #!< The irrep rows are 1 based, and follow conventions from arXiv:0508018 

type
  KeyCGCIrrepMom_t* = object
    row*: cint
    mom*: array[0..2, cint]

#proc constructKeyCGCIrrepMom_t*(): KeyCGCIrrepMom_t {.constructor.}
#proc constructKeyCGCIrrepMom_t*(row_: cint; mom_: Array[cint]): KeyCGCIrrepMom_t {.
#    constructor.}

proc hash*(x: KeyCGCIrrepMom_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h



