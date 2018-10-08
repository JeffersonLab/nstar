## Some tests

import prop_elem_type, niledb
import serializetools/serializebin, serializetools/serialstring, serializetools/array2d
import strutils, posix, os, hashes, complex
import reshift_origin
import re
  
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
  #let stem = "/lustre/cache/Spectrum/Clover/NF2+1/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265/prop_db_diagt0/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265.prop.n162.strange.diag_t0.sdb"
  #let stem = "/lustre/cache/Spectrum/Clover/NF2+1/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265/prop_db_diagt0/szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265.prop.n162.light.diag_t0.sdb"
  #echo stem

  # Loop over configs
  for n in 2..paramCount():
    # Has to be a sensible filename
    let sdb = paramStr(n)
    let seqno = sdb.replace(re"^.*sdb")
    let t_origin = getTimeOrigin(256,seqno)
    echo "Config= ", seqno, "  t_origin= ", t_origin
    #let sdb = stem & seqno

    # Quick sanity check
    if getFileSize(sdb) == 0:
      echo "CHECK_PROP: bad   ", sdb
      continue

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
    #for t in 1 .. 1:
    for t in 0 .. 255:
      var k: K
      let t_shift = cint((t_origin + t) mod 256)
      k.t_source = t_shift
      k.t_slice  = k.t_source
      k.spin_l   = 0
      k.spin_r   = 0
      k.mass_label = SerialString("U-0.0743")
      #k.mass_label = SerialString("U-0.0856")
      var v: V
      #if db.get(k,v) != 0: quit("Error reading " & $k)
      if db.get(k,v) != 0: continue
      var bb: string
      if v.mat[0,0].re < cutoff:
        bb = "  bad"
        bad = true
      else:
        bb = "  okay"
      echo "cfg: ", seqno, "  t= ", t, "  t_shifted= ", t_shift, "  v= ", v.mat[0,0].re, bb


    # Close
    if db.close() != 0:
      quit("error closing db")

    # Report status
    if bad:
      echo "CHECK_PROP: seqno= ", seqno, "  bad   ", sdb
    else:
      echo "CHECK_PROP: seqno= ", seqno, "  okay  ", sdb
    




