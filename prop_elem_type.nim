# Propagator elemental types

import niledb, tables
import serializetools/serializebin, serializetools/serialstring, serializetools/array2d
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
  KeyPropElementalOperator_t* = object
    t_slice*:    cint           ## Propagator time slice
    t_source*:   cint           ## Source time slice
    spin_l*:     cint           ## Sink spin index
    spin_r*:     cint           ## spin index
    mass_label*: SerialString   ## A mass label

  ValPropElementalOperator_t* = object
    mat*:  Array2d[Complex64]   ## Propagator time slice

proc hash*(x: KeyPropElementalOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h


