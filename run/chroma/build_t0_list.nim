## Build a list of missing t0-s

import os, ospaths, strutils
import config

proc buildT0List*() = 
  let list = "./list"

  var quark = readFile("quark_mass")
  removeSuffix(quark)
  echo "quark= ", quark

  let stem = getStem()
  let cache = getEnsemblePath()
  let mss = cache

  let dir_cache = cache & "/" & stem
  let dir_mss   = mss & "/" & stem

  let num_vecs = getNumVecs()
  let suffix  = "prop.n" & $num_vecs & "." & quark

  let Lt = 256

  # The config
  if not fileExists(list):
    quit("list $list does not exist")

  var seqno = readFile(list)
  removeSuffix(seqno)
  echo "seqno= ", seqno

  # The t0 list file
  let t0_list = stem & ".list"

  var LIST: File
  if not open(LIST, t0_list, fmWrite):
    quit("error opening file")

  for t0 in 0..Lt-1:
    if t0 mod 16 == 0: continue
    write(stdout, "checking t0= " & $t0)

    let f  = stem & "." & suffix & ".t0_" & $t0 & ".sdb" & seqno
    let fv = dir_cache & "/prop_db_t0/" & f
    let fs = dir_mss & "/prop_db_t0/" & f
    let fd = dir_cache & "/prop_db/" & f
    let fe = dir_mss & "/prop_db/" & f

    #if (! -f $fv && ! -f $fs && ! -f $fd && ! -f $fe)
    #if not fileExists(fv) and not fileExists(fd):
    if not fileExists(fv) and not fileExists(fs) and not fileExists(fd) and not fileExists(fe):
      writeLine(stdout, "   missing")
      writeLine(LIST, $t0)

  close(LIST)


when isMainModule:
  buildT0List()

