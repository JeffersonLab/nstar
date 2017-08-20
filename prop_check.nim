## Some tests

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
  KeyPropElementalOperator_t = object
    t_slice:    cint           ## Propagator time slice
    t_source:   cint           ## Source time slice
    spin_l:     cint           ## Sink spin index
    spin_r:     cint           ## spin index
    mass_label: SerialString   ## A mass label

  ValPropElementalOperator_t = object
    mat:  Array2d[Complex]     ## Propagator time slice

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
    if getFileSize(out_file) == 0:
      quit("oops, file is empty in size")
    else:
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
  echo "paramCount = ", paramCount()
  if paramCount() < 3: 
    quit("Usage: exe <cutoff> <sdb1> [<sdb2>...]")
    
  let cutoff = parseFloat(paramStr(1))
  echo "cutoff= ", cutoff

  # Loop over the sdbs
  for n in 2..paramCount():
    echo "sdb= ", paramStr(n)
    var db = openTheDB(paramStr(n))

    # Read all the keys
    echo "try getting all the keys"
    type K = KeyPropElementalOperator_t
    type V = ValPropElementalOperator_t
    let des_keys = allKeys[K](db)
    echo "found num keys= ", des_keys.len
    echo "here are all the keys: len= ", des_keys.len, "  keys:\n"
  
    var bad = false

    # Loop over all the keys, and find the t-to-t perams. Check their values.
    for k in des_keys:
      if (k.t_source == k.t_slice) and (k.spin_l == 0) and (k.spin_r == 0):
        # Read the prop elemental
        var v: V
        if db.get(k,v) != 0: quit("Error reading " & $k)
        let N = v.mat.nrows
        #for i in 0..N-1:
        var i = 0
        if v.mat[0,0].re < cutoff:
          echo "k= ", k, "  v[", i, ",",i,"]= ",v.mat[i,i], "  bad"
          bad = true
      
    # Close
    if db.close() != 0:
      quit("error closing db")

    # Report status
    if bad:
      echo "CHECK_PROP: bad   ", paramStr(n)
    else:
      echo "CHECK_PROP: okay  ", paramStr(n)
    




