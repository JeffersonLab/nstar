##  Unittests for niledb

import niledb, tables,
       serializetools/serializebin, serializetools/serialstring
import unittest
import strutils, posix, os, hashes
import discoblocks
import streams
  
# Useful for debugging
proc printBin(x:string): string =
  ## Print a binary string
  result = "0x"
  for e in items(x):
    result.add(toHex(e))


when isMainModule:
  ## Convenience function to open a SDB
  echo "Declare disco conf odb"
  var odb = newConfDataStoreDB()

  # Open a file
  let hada_file = "hada_0-511_SVD_disco_cfg_cl21_32_64_b6p3_m0p2390_m0p2050_cfg_1000.ref0001.sdb"
  echo "Is file= ", hada_file, "  present?"
  if fileExists(hada_file):
    echo "hooray, it exists"
  else:
    quit("oops, does not exist")

  echo "open the odb = ", hada_file
  var ret = odb.open(hada_file, O_RDONLY, 0o400)
  echo "return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))

  # Try metadata
  echo "Get metadata"
  var meta = odb.getUserdata()
  echo "it did not blowup..."
  #echo " meta= ", meta
  let nrow = [32, 32, 32, 96]
  let mom2_max = 0

  # Read all the keys
  var bin_keys: seq[string]
  if false:
    echo "try getting all the deserialized keys"
    #let des_keys = allKeys[DiscoKeyOperator_t](odb)
    bin_keys = allBinaryKeys(odb)
    echo "found num all keys= ", bin_keys.len
    echo "here is the first all key: len= ", bin_keys.len, "  val= ", printBin(bin_keys[8])
    #echo "here is the first all key: len= ", bin_keys.len, "  val= ", bin_keys[0]
    echo "here are 10 of the keys"
    #for i in 0..bin_keys.len-1:
    for i in 0..9:
      echo "k[",i,"]= ", printBin(bin_keys[i]), " len= ", bin_keys[i].len
      #echo "k[",i,"]= ", bin_keys[i]

  # Test
  if false:
    echo "Convert a binary key to a struct"
    let foobar = deserializeBinary[DiscoKeyOperator_t](bin_keys[8])
    echo "foobar= ", foobar

  # Now try
  if false:
    echo "\n\nNow try values"
    var val0: DiscoValOperator_t
    var sval: string
    var ret = getBinary(odb, bin_keys[8], sval)
    echo "got ret= ", ret
    echo "sval = ", printBin(sval)
    ret = get(odb, deserializeBinary[DiscoKeyOperator_t](bin_keys[8]), val0)
    echo "get ret= ", ret
    echo "val0= ", val0

  # Close
  #assert(odb.close() == 0)


  #
  # New file
  #
  echo "Declare redstar conf ndb"
  var ndb = newConfDataStoreDB()

  # Let us write a file
  let single_file = "graph.sdb"
  echo "Is file= ", single_file, "  present?"
  if fileExists(single_file):
    echo "It exists, so remove it"
    removeFile(single_file)
  else:
    echo "Does not exist"

  # Meta-data
  #echo "Here is the metadata to insert:\n", meta
  ndb.setMaxUserInfoLen(meta.len)

  echo "open the ndb = ", single_file
  ret = ndb.open(single_file, O_RDWR or O_TRUNC or O_CREAT, 0o664)
  echo "open = ", single_file, "  return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))

  # Insert new DB-meta
  ret = ndb.insertUserdata(meta)
  if ret != 0:
    quit("strerror= " & $strerror(errno))
 
  # Build up some keys and associated values in a table
  #var kv = initTable[DiscoKeyOperator_t,float]()

  # parameters
  var disps  = [[cshort(0)]]
  var disps2 = [[cshort(1)], [cshort(2)], [cshort(3)], [cshort(4)], [cshort(-1)], [cshort(-2)], [cshort(-3)], [cshort(-4)]]

  # Loop over all possible keys
  for px in -mom2_max..mom2_max:
    for py in -mom2_max..mom2_max:
      for pz in -mom2_max..mom2_max:
        let mom2 = px*px+py*py+pz*pz
        if mom2 > mom2_max: continue
        let cmom = [cshort(px), cshort(py), cshort(pz)]

        for disp in items(disps):
          echo "disp= ", @disp

          #for t_slice in 0..nrow[3]-1:
          for t_slice in 0..2:
            #echo "t_slice= ", t_slice, " disp= ", disp, " mom= ", cmom
            let key = DiscoKeyOperator_t(t_slice: cushort(t_slice), mom: @cmom,
                                         disp: @disp, ndisp: cushort(disp.len))
            echo "key= ", key

            # val
            echo "get the val"
            var val: DiscoValOperator_t
            let ret = get(odb, key, val)
            assert(ret == 0)
            let op = val.op
            echo "val: len= ", op.len, "  op= ", op



  # insert the entire table
  #ret = db.insert(kv)
  #assert(ret == 0)

  # Close
  assert(ndb.close() == 0)
