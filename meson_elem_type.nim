# Propagator elemental types

import niledb, tables
import serializetools/serializebin, serializetools/serialstring, serializetools/sqarray2d
import strutils, posix, os, hashes, complex
  
# Useful for debugging
#[
proc printBin(x:string): string =
  ## Print a binary string
  result = "0x"
  for e in items(x):
    result.add(toHex(e))
]#


# Key type used for tests
type
  KeyMesonElementalOperator_t* = object
    t_slice*:         cint              ## Meson time slice
    displacement*:    seq[cint]         ## The displacement path for this gamma
    mom*:             array[0..2,cint]  ## Array of momenta to generate 
    #mom*:             seq[cint]  ## Array of momenta to generate 

  ValMesonElementalOperator_t* = object
    type_of_data*:    cint
    mat*:             SqArray2d[Complex64]   ## Meson time slice

proc hash*(x: KeyMesonElementalOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h


