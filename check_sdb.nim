## Some tests

import niledb, tables,
       serializetools/serializebin, serializetools/serialstring, ffdb_header
import strutils, posix, os, hashes
import random
  
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
  KeyPropElementalOperator_t = object
    t_slice:    cint           ## Propagator time slice
    t_source:   cint           ## Source time slice
    spin_l:     cint           ## Sink spin index
    spin_r:     cint           ## spin index
    mass_label: SerialString   ## A mass label

proc hash(x: KeyPropElementalOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h


proc openTheDB(out_file: string): ConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Declare conf db"
  result = newConfDataStoreDB()

  # Open a file
  echo "Is file= ", out_file, "  present?"
  if fileExists(out_file):
    echo "hooray, it exists"
  else:
    quit("oops, does not exist")

  echo "open the db = ", out_file
  let ret = result.open(out_file, O_RDONLY, 0o400)
  echo "return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))


when isMainModule:
  # Open the DB
  var db = openTheDB("foo.sdb")

  # Read all the keys & data
  echo "try getting all the deserialized pairs"
  let des_pairs = allPairs[KeyPropElementalOperator_t,float](db)
  echo "found num keys= ", des_pairs.len
  echo "here are all the keys: len= ", des_pairs.len, "  keys:\n"
  for k,v in des_pairs:
    echo "k= ", $k, "  v= ", $v

  # Close
  if db.close() != 0:
     quit("error closing db")




