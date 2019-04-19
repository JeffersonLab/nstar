## Some tests

import meson_elem_type, niledb
import serializetools/serializebin, serializetools/serialstring, serializetools/sqarray2d
import strutils, posix, os, hashes, complex
  
proc openTheDB(out_file: string): ConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Declare conf db"
  result = newConfDataStoreDB()

  echo "open the db = ", out_file
  let ret = result.open(out_file, O_RDONLY, 0o400)
  echo "return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))


when isMainModule:
  # Open the DB
  echo "paramCount = ", paramCount()
  if paramCount() < 2:
    quit("Usage: exe <cutoff> <dir>")
    
  let cutoff = parseFloat(paramStr(1))
  echo "cutoff= ", cutoff

  # Loop over the sdbs within a dir
  for n in 1..paramCount():
    # Has to be a sensible filename
    let sdb = paramStr(n)
    echo "sdb= ", sdb
    if not sdb.contains(".sdb"): continue

    # Quick sanity check
    if getFileSize(sdb) == 0:
      echo "CHECK_PROP: bad   ", sdb
      continue

    # Open it
    var db = openTheDB(sdb)

    # Read all the keys
    #echo "try getting all the keys"
    type K = KeyMesonElementalOperator_t
    type V = ValMesonElementalOperator_t
    let des_keys = allKeys[K](db)
    echo "found num keys= ", des_keys.len
    echo "here are all the keys: len= ", des_keys.len, "  keys:\n"
    echo "keys= ", des_keys
  
    var bad = false

    # Loop over all the keys, and find the t-to-t perams. Check their values.
    for k in des_keys:
      # Read the prop elemental
      var v: V
      if db.get(k,v) != 0: quit("Error reading " & $k)
      let N = v.mat.nrows
      if k.t_slice == 173:
        for i in 0..N-1:
          for j in 0..N-1:
            if v.mat[i,j].re < cutoff:
              echo "k= ", k, "  v[", i, ",",j,"]= ",v.mat[i,j], "  bad"
              bad = true
      
    # Close
    if db.close() != 0:
      quit("error closing db")

    # Report status
    if bad:
      echo "CHECK_MESON: bad   ", sdb
    else:
      echo "CHECK_MESON: okay  ", sdb
    




