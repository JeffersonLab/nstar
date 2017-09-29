## reshift_origin
##
## Grrh, it is annoying I need this code. It'll read in prop sdbs for all time-slices that had
## a bogus t_origin=74, and will rename them with the proper time-origin based on the
## drand48 RNG version of t_origin.

import prop_elem_type, niledb, drand48
import serializetools/serializebin, serializetools/serialstring, serializetools/array2d
import strutils, posix, os, hashes, complex, re
  
#------------------------------------------------------------------------
proc extractLattSize(data: string): array[4,int] =
  ## Determine the lattice size
  # Yuk, do some file name surgery
  var stem = data.replace(re"\..*$")
  stem = stem.replace(re"per\..*$")
  stem = stem.replace(re"non\..*$")
  stem = stem.replace(re"dir\..*$")

  let F  = stem.split('_')
  let Ls = parseInt(F[1])
  let Lt = parseInt(F[2])
  result = [Ls, Ls, Ls, Lt]


proc getTimeOrigin(Lt: int, trajj: string): int =
  ## Displace the origin of the time slices using the trajectory as a seed to a RNG
  # Clean out characters and set the rng with the traj number as an int
  var traj = parseInt(trajj.replace(re"[a-zA-Z]"))
  srand48(traj)
  
  # Clean out rngs
  for i in 1..20:
    discard drand48()

  # Origin is in the interval [0,Lt-1)
  result = int(float(Lt)*drand48())


#------------------------------------------------------------------------
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
      echo "  input file= ", infile
      if not fileExists(infile): continue

      # Quick sanity check
      assert(getFileSize(infile) > 0)

      # Read all the keys/vals
      var old_db = newConfDataStoreDB()
      assert(old_db.open(infile, O_RDONLY, 0o400) == 0)

      type K = KeyPropElementalOperator_t
      let all_keys = allKeys[K](old_db)
      echo "found num keys= ", all_keys.len
      discard close(old_db)

      # Only need to check one of the keys, find its origin and decide on the new name
      let first_key = all_keys[0]

      let new_t_source = first_key.t_source - 74 + t_origin
      let outfile = outdir & "/" & long_stem & ".t0_" & $new_t_source & ".sdb" & seqno
      echo "new file= ", outfile


      

#-------------------------------------------------------------------------
when isMainModule:
  echo "hello"
