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
  echo "Declare conf db"
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
  #let nrow = [32, 32, 32, 96

  # Read all the keys
  echo "try getting all the deserialized keys"
  #let des_keys = allKeys[DiscoKeyOperator_t](odb)
  let des_keys = allBinaryKeys(odb)
  echo "found num all keys= ", des_keys.len
  echo "here is the first all key: len= ", des_keys.len, "  val= ", printBin(des_keys[8])
  #echo "here is the first all key: len= ", des_keys.len, "  val= ", des_keys[0]
  echo "here are 10 of the keys"
  #for i in 0..des_keys.len-1:
  for i in 0..9:
    echo "k[",i,"]= ", printBin(des_keys[i]), " len= ", des_keys[i].len
    #echo "k[",i,"]= ", des_keys[i]

  # Test
  if true:
    echo "Convert a binary key to a struct"
    let foobar = deserializeBinary[DiscoKeyOperator_t](des_keys[8])
    echo "foobar= ", foobar
  
  # Now try
  if true:
    echo "\n\nNow try values"
    var val0: DiscoValOperator_t
    var sval: string
    var ret = getBinary(odb, des_keys[8], sval)
    echo "got ret= ", ret
    echo "sval = ", printBin(sval)
    ret = get(odb, deserializeBinary[DiscoKeyOperator_t](des_keys[8]), val0)
    echo "get ret= ", ret
    echo "val0= ", val0

  # Close
  #assert(odb.close() == 0)


#[
  #
  # New file
  #
  echo "Declare conf db"
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
  echo "Here is the metadata to insert:\n", meta
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
  var kv = initTable[DiscoKeyOperator_t,float]()

  for ll in items(labels):
    for t_slice in 9..10:
      for sl in 0..3:
        for sr in 0..3:
          #echo "t_slice= ", t_slice, " sl= ", sl, " sr= ", sr
          let key = KeyPropElementalOperator_t(t_slice: cint(t_slice), t_source: 5, 
                                               spin_l: cint(sl), spin_r: cint(sr), 
                                               mass_label: SerialString(ll))
          let val = random(3.0)  # some arbitrary number
          kv.add(key,val)

    # insert the entire table
    ret = db.insert(kv)
    if ret != 0:
      echo "Ooops, ret= ", ret
      quit("Error in insertion")

    # Close
    require(db.close() == 0)
]#    
