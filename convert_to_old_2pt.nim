## Read hadspec files and convert them into a Hadron2PtCorr

import prop_elem_type, niledb
import serializetools/serializebin, serializetools/serialstring
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
  if paramCount() != 4:
    quit("Usage: exe <edb> <light label> <strange label>")
    
  let edb = paramStr(1)
  echo "edb= ", edb
  let light   = paramStr(2)
  let strange = paramStr(3)
  let width   = paramStr(4)
  
  type
    Smearing_t* = tuple
      ttype: char
      width: string
      
  var smearings: seq[Smearing_t] = @[(ttype: 'P', width: "P"), (ttype: 'S', width: "DG2")]
  var mesons = @["pion"]
  var masses = @["D" & light, "H" & light & "_" & strange, "D" & strange]

  # Loop over the hadspec files within a dir
  for chan in items(mesons):
    for mm in items(masses):
      for sm1 in items(smearings):
        for sm2 in items(smearings):
          # Build filename
          let dat = chan & "." & mm & "." & sm1.width & "_1." & sm2.width & "_1." & sm1.ttype & sm2.ttype
          echo "dat= ", dat
        
          # Quick sanity check
          if not fileExists(dat):
            echo "File not found: ", dat
            continue

          # Quick sanity check
          if getFileSize(dat) == 0:
            echo "CHECK_PROP: bad   ", dat
            continue

#[
    # Open it
    var db = openTheDB(sdb)

    # Read all the keys
    #echo "try getting all the keys"
    type K = KeyPropElementalOperator_t
    type V = ValPropElementalOperator_t
    let des_keys = allKeys[K](db)
    echo "found num keys= ", des_keys.len
    #echo "here are all the keys: len= ", des_keys.len, "  keys:\n"
  
    var bad = false

    # Loop over all the keys, and find the t-to-t perams. Check their values.
    for k in des_keys:
      if (k.t_source == k.t_slice) and (k.spin_l == 0) and (k.spin_r == 0):
        # Read the prop elemental
        var v: V
        if db.get(k,v) != 0: quit("Error reading " & $k)
        #let N = v.mat.nrows
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
      echo "CHECK_PROP: bad   ", sdb
    else:
      echo "CHECK_PROP: okay  ", sdb
]#
    




