##  Disconnected diagram building blocks
## 

import
  ensem, niledb, complex, hashes

## Meson operator
type
  DiscoKeyOperator_t* = object
    t_slice*: cushort                ## Meson operator time slice
    ndisp*:   cushort                ## This is unfortunate, but the length of disp was buried as part of key
    disp*:    seq[cshort]            ## Displacement dirs of quark (right)
    mom*:     array[0..2, cshort]    ## D-1 momentum of this operator
    #mom*:     seq[cshort]            ## D-1 momentum of this operator
  
type
  DiscoValOperator_t* = object
    op*: seq[Complex]


proc hash*(x: DiscoKeyOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

proc hash*(x: DiscoValOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

