##  Unittests for niledb

import niledb, tables,
       serializetools/serializebin, serializetools/serialstring
import unittest
import strutils, posix, os, hashes
#import discoblocks
import streams
  
# Useful for debugging
proc printBin(x:string): string =
  ## Print a binary string
  result = "0x"
  for e in items(x):
    result.add(toHex(e))

type
  Fred1_t* = object
    t_slice*: cushort                ## Meson operator time slice
  
  Fred2_t* = object
    t_slice*: cushort                ## Meson operator time slice
    junk*:    cushort
  
  Fred3_t* = object
    t_slice*: cushort                ## Meson operator time slice
    junk*:    cushort
    disp*:    seq[cshort]            ## Displacement dirs of quark (right)
  
  Fred4_t* = object
    t_slice*: cushort                ## Meson operator time slice
    junk*:    cushort
    disp*:    seq[cshort]            ## Displacement dirs of quark (right)
    mom*:     seq[cshort]    ## D-1 momentum of this operator
  

proc hash*(x: Fred1_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

proc hash*(x: Fred2_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

proc hash*(x: Fred3_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

proc hash*(x: Fred4_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h



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

  # Stuff
  echo "\n\nStuff:"
  echo "sizeof(cushort)= ", sizeof(cushort), "  cshort= ", sizeof(cshort), " mom= ", sizeof(array[0..2, cshort])

  # Crazy
  echo "\nTime to go off-grid"
  if true:
    var ss = newStringStream(des_keys[8])
    var t_slice: cushort
    var junk: cushort
    var mom: array[0..2, cshort]
    var disp: seq[cshort]
    doLoadBinary[type(t_slice)](ss, t_slice)
    echo "t_slice= ", t_slice, "  size= ", sizeof(t_slice)
    doLoadBinary[type(junk)](ss, junk)
    echo "junk= ", junk, "  size= ", sizeof(junk)
    var nn: int32
    doLoadBinary[type(nn)](ss, nn)
    echo "nn= ", nn, "  size= ", sizeof(nn)
    var fred: cshort
    doLoadBinary[type(fred)](ss, fred)
    echo "d[0]= ", fred, "  size= ", sizeof(fred)
    doLoadBinary[type(nn)](ss, nn)
    echo "nn= ", nn, "  size= ", sizeof(nn)
    doLoadBinary[type(fred)](ss, fred)
    echo "m[0]= ", fred, "  size= ", sizeof(fred)
    doLoadBinary[type(fred)](ss, fred)
    echo "m[1]= ", fred, "  size= ", sizeof(fred)
    doLoadBinary[type(fred)](ss, fred)
    echo "m[2]= ", fred, "  size= ", sizeof(fred)
    #quit("bye")

    echo "0000 0000 0000"


  # Test
  echo "Fred1"
  echo deserializeBinary[Fred1_t](des_keys[8])

  echo "Fred2"
  echo deserializeBinary[Fred2_t](des_keys[8])

  echo "Fred3"
  echo deserializeBinary[Fred3_t](des_keys[8])

  quit("bye")

  echo "Fred4"
  echo deserializeBinary[Fred4_t](des_keys[8])

  echo "Convert a binary key to a struct"
  #let foobar = deserializeBinary[DiscoKeyOperator_t](des_keys[0])
  #echo "foobar= ", foobar
  
  # Close
  assert(odb.close() == 0)
  quit("bye")


#[
  # New file
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
    
