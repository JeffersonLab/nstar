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

  #const use_argsP = true
  const use_argsP = false

  when use_argsP:
    if paramCount() != 5:
      quit("Usage: exe <output dir> <dup forward dir> <input dir> <stem> <file of seqnos>")

    # Get params
    let outdir     = paramStr(1)
    let dupdir     = paramStr(2)
    let  indir     = paramStr(3)
    let long_stem  = paramStr(4)
    let seqno_file = paramStr(5)

    let stem = long_stem.replace(re"\..*$")  # remove trailing tags after stem
  else:
    if paramCount() != 2:
      quit("Usage: exe <quark> <file of seqnos>")

    let quark      = paramStr(1)
    let seqno_file = paramStr(2)

    let  stem     = "szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265"
    let lustre    = "/lustre/cache/Spectrum/Clover/NF2+1"
    let outdir    = lustre & "/" & stem & "/prop_db_t0.shift"
    let dupdir    = lustre & "/" & stem & "/prop_db_t0.dup"
    let  indir    = lustre & "/" & stem & "/prop_db_t0"
    let long_stem = stem & ".prop.n162." & quark

  # Sanity checks
  assert(dirExists(outdir))
  assert(dirExists(dupdir))
  assert(dirExists(indir))

  # The stem gives the time extent
  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]

  # Slurp in all the seqnos
  assert(fileExists(seqno_file))
  let seqnos = readFile(seqno_file)

  # Loop over the seqnos
  for seqno in splitLines(seqnos):
    if seqno.len == 0: continue

    let t_origin = getTimeOrigin(Lt, seqno)
    echo "seqno= ", seqno, "  t_origin= ", t_origin

    # Check each of the t-sliced sdbs
    for t0 in 0..Lt-1:
      # Has to be a sensible filename
      let infile  = indir & "/" & long_stem & ".t0_" & $t0 & ".sdb" & seqno
      #echo "  input file= ", infile
      if not fileExists(infile): continue

      # Quick sanity check
      assert(getFileSize(infile) > 0)

      # Read all the keys/vals
      var old_db = newConfDataStoreDB()
      assert(old_db.open(infile, O_RDONLY, 0o400) == 0)

      type K = KeyPropElementalOperator_t
      let all_keys = allKeys[K](old_db)
      #echo "found num keys= ", all_keys.len
      discard close(old_db)

      # Only need to check one of the keys, find its origin and decide on the new name
      let first_key = all_keys[0]

      let correct_t_source = (t0 + t_origin + Lt) mod Lt
      if correct_t_source != first_key.t_source:
        let use_t0 = (t0 - correct_t_source + first_key.t_source + Lt) mod Lt
        let destdir = if use_t0 mod 16 == 0: dupdir else: outdir
        let outfile = destdir & "/" & long_stem & ".t0_" & $use_t0 & ".sdb" & seqno
        echo "  rename infile= ", infile, "  outfile= ", outfile
        moveFile(infile, outfile)

