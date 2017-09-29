## reshift_origin
##
## Grrh, it is annoying I need this code. It'll read in prop sdbs for all time-slices that had
## a bogus t_origin=74, and will rename them with the proper time-origin based on the
## drand48 RNG version of t_origin.

import prop_elem_type, niledb
import serializetools/serializebin, serializetools/serialstring, serializetools/array2d
import strutils, posix, os, hashes, complex
  
proc openOldDB(out_file: string): ConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Open the db = ", out_file
  result = newConfDataStoreDB()
  let ret = result.open(out_file, O_RDONLY, 0o400)
  assert(ret == 0)

proc openNewDB(out_file: string): ConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Write the db = ", out_file
  result = newConfDataStoreDB()
  let ret = result.open(out_file, O_WRONLY or O_TRUNC, 0o644)
  assert(ret == 0)


when isMainModule:
  # Open the DB
  echo "paramCount = ", paramCount()
  if paramCount() != 4:
    quit("Usage: exe <output dir> <input dir> <stem> <file of seqnos>")
    
  # Sanity checks
  let outdir    = paramStr(1)
  let  indir    = paramStr(2)
  let long_stem = paramStr(3)

  assert(dirExists(outdir))
  assert(dirExists(indir))

  # The stem gives the time extent
  let stem = long_stem.replace(re"\..*$")  # remove trailing tags after stem
  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]

  # Slurp in all the seqnos
  assert(fileExists(paramStr(4)))
  let seqnos = readFile(paramStr(4))

  # Loop over the seqnos
  for seqno in splitLines(seqnos):
    if seqno.len == 0: continue

    let t_origin = getTimeOrigin(Lt, seqno)
    echo "seqno= ", seqno, "  t_origin= ", t_origin

    # Check each of the t-sliced sdbs
    for t0 in 0..Lt-1:
      # Has to be a sensible filename
      let infile  = indir & "/" & long_stem & ".t0_" & $t0 & ".sdb" & seqno
      let outfile = outdir & "/" & sdb
      echo "  input file= ", infile
      if not fileExists(infile): continue

      # Quick sanity check
      if getFileSize(infile) == 0:
        echo "CHECK_PROP: bad   ", sdb
        continue

      # Read all the keys/vals
      var old_db = newConfDataStoreDB()
      assert(old_db.open(infile, O_RDONLY, 0o400) == 0)
      let meta_data = old_db.getUserdata()

      type K = KeyPropElementalOperator_t
      let all_keys = allKeys[K](old_db)
      echo "found num keys= ", all_keys.len
      old_db.close()

      # Only need to check one of the keys, find its origin and decide on the new name
      let first_key = all_keys[0]

      let new_t_source = all_keys[0].t_source - 74 + t_origin
      let outfile = outdir & "/" & long_stem & ".t0_" & $new_t_source & ".sdb" & seqno
      echo "new file= ", outfile


      

#-------------------------------------------------------------------------
when isMainModule:
  echo "hello"
