## Generate a new correlator edb using a projected op file to add new linearly dependent row/columns.

import
  tables, complex,
  hadron_sun_npart_irrep_op, hadron_sun_npart_irrep, hadron_sun_npart_npt_corr,
  serializetools/serializexml, 
  serializetools/serializebin, 
  serializetools/array1d,
  particle_op, cgc_su3, cgc_irrep_mom,
  extract_all_v_coeffs_xml, niledb

import
  os, xmltree, xmlparser, posix, system

when defined(openmp):
  {.passC: "-O3 -fopenmp".}
  {.passL: "-fopenmp".}

  {.pragma: omp, header:"omp.h".}

  proc omp_set_num_threads*(x: cint) {.omp.}
  proc omp_get_num_threads*(): cint {.omp.}
  proc omp_get_max_threads*(): cint {.omp.} # This takes hyperthreading into account
  proc omp_get_thread_num*(): cint {.omp.}

else:
  template omp_set_num_threads*(x: cint) = discard
  template omp_get_num_threads*(): cint = 1
  template omp_get_max_threads*(): cint = 1
  template omp_get_thread_num*(): cint = 0

## ----------------------------------------------------------------------------
proc getNbins*(corrs: Table[KeyHadronSUNNPartNPtCorr_t,seq[seq[Complex64]]]): int =
  ## Construct a 2pt correlator key from the sink and source ops
  for k,v in pairs(corrs):
    result  = v.len()
    break


## ----------------------------------------------------------------------------------
proc readProjectOpWeights*(files: seq[string]): Table[KeyParticleOp_t, Table[KeyHadronSUNNPartIrrepOp_t,float64]] =
  ## Read proj ops files
  result = initTable[KeyParticleOp_t, Table[KeyHadronSUNNPartIrrepOp_t,float64]]()
  
  for file in items(files):
    if not fileExists(file): quit("file = " & file & " does not exist")
    let xml: XmlNode = loadXml(file)
    #echo "xml= ", $xml
    # Deserialize this table
    let proj_op_struct = deserializeXML[ProjectedOpWeights](xml)
    echo "file = ", file, "  version= ", proj_op_struct.version
    for k,v in pairs(proj_op_struct.ProjectedOps):
      result[k] = v


#[
## ----------------------------------------------------------------------------------
proc openTheSDB(out_file: string): ConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Declare conf db"
  result = newConfDataStoreDB()

  echo "open the db = ", out_file
  let ret = result.open(out_file, O_RDONLY, 0o400)
  echo "return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))
]#


## ----------------------------------------------------------------------------------
proc openTheEDB(out_file: string): AllConfDataStoreDB =
  ## Convenience function to open a DB
  echo "Declare conf db"
  result = newAllConfDataStoreDB()

  echo "open the db = ", out_file
  let ret = result.open(out_file, O_RDONLY, 0o400)
  echo "return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))


## ----------------------------------------------------------------------------------
proc readEDB*(edb: string): tuple[meta: string, nbins: int, corrs: Table[KeyHadronSUNNPartNPtCorr_t,seq[seq[Complex64]]]] =
  ## Read an edb
  echo "edb= ", edb

  type K = KeyHadronSUNNPartNPtCorr_t
  type V = seq[Complex64]

  # Quick sanity check
  if getFileSize(edb) == 0:
    quit("BAD EDB= " & edb)

  # Open it
  var db = openTheEDB(edb)

  # Try metadata
  result.meta = db.getUserdata()

  # Number of configs
  let nbins = db.getMaxNumberConfigs()
  echo "nbins= ", nbins

  # This is the big read of the db, returning all correlators into a table
  result.corrs = allPairs[K,V](db)
  echo "found num pairs= ", result.corrs.len
  
  # Close
  if db.close() != 0:
    quit("error closing db")

      
## ----------------------------------------------------------------------------
proc writeEDB*(meta, file: string; new_corrs, old_corrs: Table[KeyHadronSUNNPartNPtCorr_t, seq[seq[Complex64]]]) =
  ## Write the db
  echo "Declare conf db"
  var db = newAllConfDataStoreDB()

  # Let us write a file
  if fileExists(file):
    echo "It exists, so remove it"
    removeFile(file)
  else:
    echo "Does not exist"

  # Meta-data
  db.setMaxUserInfoLen(meta.len)

  # Number of configs
  let nbins = getNbins(old_corrs)
  echo "Set max configs= ", nbins
  db.setMaxNumberConfigs(nbins)

  echo "open the db = ", file
  var ret = db.open(file, O_RDWR or O_TRUNC or O_CREAT, 0o664)
  echo "open = ", file, "  return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))

  # Insert new DB-meta
  ret = db.insertUserdata(meta)
  if ret != 0:
    quit("strerror= " & $strerror(errno))
 
  # Write out the new corrs
  echo "Write out new corrs"
  if db.insert(new_corrs) != 0:
    quit("Error writing out new corrs")

  # Write out the old corrs
  echo "Write out old corrs"
  if db.insert(old_corrs) != 0:
    quit("Error writing out old corrs")

  # Close
  discard db.close()



## ----------------------------------------------------------------------------
proc newVal(nbins, Lt: int): seq[seq[Complex64]] =
  ## Initialize a proper size ensemble with 0
  result.setLen(nbins)
  for v in mitems(result):
    v.setLen(Lt)
    for t in 0..v.len()-1:
      v[t] = complex64(0.0)

  
## ----------------------------------------------------------------------------
proc newIrrepOp*(op: KeyParticleOp_t): KeyHadronSUNNPartIrrepOp_t =
  ## Construct a 2pt correlator key from the sink and source ops
  result.Operators.setLen(1)
  result.Operators[1] = op
  

## ----------------------------------------------------------------------------
proc newSnkIrrep*(flavor: KeyCGCSU3_t; irmom: KeyCGCIrrepMom_t; op: KeyHadronSUNNPartIrrepOp_t): KeyHadronSUNNPartIrrep_t =
  ## Construct a 2pt correlator key from the sink and source ops
  result.creation_op = false
  result.smearedP    = true
  result.flavor      = flavor
  result.irmom       = irmom
  result.Op          = op
  

## ----------------------------------------------------------------------------
proc newSrcIrrep*(flavor: KeyCGCSU3_t; irmom: KeyCGCIrrepMom_t; op: KeyHadronSUNNPartIrrepOp_t): KeyHadronSUNNPartIrrep_t =
  ## Construct a 2pt correlator key from the sink and source ops
  result.creation_op = true
  result.smearedP    = true
  result.flavor      = flavor
  result.irmom       = irmom
  result.Op          = op
  

## ----------------------------------------------------------------------------
proc constructCorr*(flavor: KeyCGCSU3_t; irmom: KeyCGCIrrepMom_t; snk, src: KeyHadronSUNNPartIrrepOp_t): KeyHadronSUNNPartNPtCorr_t =
  ## Construct a 2pt correlator key from the sink and source ops
  result.NPoint.setLen(2)
  result.NPoint[1].t_slice = -2
  result.NPoint[1].Irrep = newSnkIrrep(flavor, irmom, snk)
  result.NPoint[2].t_slice = -2
  result.NPoint[2].Irrep = newSrcIrrep(flavor, irmom, src)


## ----------------------------------------------------------------------------
##  Read database and an opslist file. Reweight the corrs
## 
#-----------------------------------------------------------------------------
when isMainModule:
  echo "paramCount = ", paramCount()
  if paramCount() < 5:
    quit("Usage: exe <out> <proj op xml> <use_herm? [Y/N]> <in 1> ... <in N>")
    
  let output_edb    = paramStr(1)
  let proj_op_xml   = paramStr(2)
  let herm          = paramStr(3)

  echo "Read proj ops map"
  let projOpsMap = readProjectOpWeights(@[proj_op_xml])

#[
  # Read the ops files
  var ops_map_files = newSeq[string](0)

  for n in 5 .. paramCount():
    let f = paramStr(n)
    ops_map_files.add(f)
    
  # Op files
  let opsMap = readOpsMapFiles(ops_map_files)
]#

  var meta: string
  var corrs = initTable[KeyHadronSUNNPartNPtCorr_t,seq[seq[Complex64]]]()

  # Go through each of the input tables and put them in the big table
  for n in 4 .. paramCount():
    let input_edb     = paramStr(n)
    echo "Read edb = ", input_edb
    let meta_corrs = readEDB(input_edb)
    meta  = meta_corrs.meta
    let corrs_tmp = meta_corrs.corrs
    for k,v in corrs_tmp:
      corrs[k] = v
    
  #echo "Here is the contents of corrs\n", $corrs
  #echo "Here is the xml version of corrs\n", serializeXML(corrs)

  # Write the xml
  #var f: File
  #if open(f, "debug.xml", fmWrite):
  #  f.write(xmlHeader)
  #  f.write(serializeXML(corrs, "Corrs"))
  #  f.close()
  

  echo "Grab the flavor, irrepmom, and ops from the first npt of the first correlator"
  var flavor:   KeyCGCSU3_t
  var irmom:    KeyCGCIrrepMom_t
  var Lt:       int
  var nbins:    int
  var irrep_ops = initTable[KeyHadronSUNNPartIrrepOp_t,int]()

#  var count: int
  var irrep_ops2 = initTable[KeyHadronSUNNPartIrrepOp_t,int]()

  for k,v in pairs(corrs):
    flavor = k.NPoint[1].Irrep.flavor
    irmom  = k.NPoint[1].Irrep.irmom
    nbins  = v.len()
    Lt     = v[0].len()
#    echo k.NPoint[1]
#    echo k.NPoint[1].Irrep.Op
    irrep_ops.add(k.NPoint[1].Irrep.Op,1)
    irrep_ops2[k.NPoint[1].Irrep.Op]=1


  echo "flavor= ", $flavor
  echo "irmom= ",  $irmom
  echo "Lt= ",     Lt
  echo "nbins= ",  nbins
  echo "\n"

  # Construct a new project correlator
  # Table[KeyParticleOp_t, Table[KeyHadronSUNNPartIrrepOp_t,float64]]()
  var new_corrs = initTable[KeyHadronSUNNPartNPtCorr_t, seq[seq[Complex64]]]()

  # Construct a new projop-projop submatrix
  echo "Build new-new corrs"
  for nk1,nv1 in pairs(projOpsMap):
    for nk2,nv2 in pairs(projOpsMap):
      echo "key1= ",nk1, "  key2= ",nk2
      let key = constructCorr(flavor, irmom, newIrrepOp(nk1), newIrrepOp(nk2))
      var val = newVal(nbins,Lt)
      
      for kk1,vv1 in pairs(nv1):
        for kk2,vv2 in pairs(nv2):
          #echo "Construct this corr"
          let vvv = vv1 * vv2
          let cr = constructCorr(flavor, irmom, kk1, kk2)
          var crcorrs = newVal(nbins,Lt)
          for n in 0..nbins-1:
            for i in 0..Lt-1:
              crcorrs[n][i] = corrs[cr][n][i]
          #echo $serializeXML(cr)
          if not corrs.hasKey(cr):
            quit("oops, corr does not exist: cr= " & $cr)
          # Accumulate
          #for n in 0..nbins-1:
          for n in `||`(0,nbins-1,1):
            for i in 0..Lt-1:
              val[n][i] += crcorrs[n][i] * vvv

      new_corrs[key] = val



  # Construct a new projop-vanilla submatrix
  echo "Build new-old corrs"
  for nk1,nv1 in pairs(projOpsMap):
    for nk2 in keys(irrep_ops2):
      echo "key1= ",nk1, "  key2= ",nk2
      let key = constructCorr(flavor, irmom, newIrrepOp(nk1), nk2)
      var val = newVal(nbins,Lt)
      
      for kk1,vv1 in pairs(nv1):
        #echo "Construct this corr"
        let cr = constructCorr(flavor, irmom, kk1, nk2)
        #echo $serializeXML(cr)
        if not corrs.hasKey(cr):
          quit("oops, corr does not exist: cr= " & $cr)
        # Accumulate
        for n in 0..nbins-1:
          for i in 0..Lt-1:
            val[n][i] += corrs[cr][n][i] * vv1

#      echo "done key= ",key
      new_corrs[key] = val

  if herm == "N":
    echo "No herm, building conjugate keys..."
 
  # Construct a new vanilla-projop submatrix
    echo "Build old-new corrs"
    for nk1 in keys(irrep_ops2):
      for nk2,nv2 in pairs(projOpsMap):
        echo "key1= ",nk1, "  key2= ",nk2
        let key = constructCorr(flavor, irmom, nk1, newIrrepOp(nk2))
        var val = newVal(nbins,Lt)
      
        for kk2,vv2 in pairs(nv2):
          #echo "Construct this corr"
          let cr = constructCorr(flavor, irmom, nk1, kk2)
          #echo $serializeXML(cr)
          if not corrs.hasKey(cr):
            quit("oops, corr does not exist: cr= " & $cr)
          # Accumulate
          for n in 0..nbins-1:
            for i in 0..Lt-1:
              val[n][i] += corrs[cr][n][i] * vv2

        new_corrs[key] = val

  elif herm == "Y":
    echo "Use herm, haven't build conjugate keys..."

  # Debugging output
  #echo "Write out all corrs"
  #if open(f, "new_corrs.xml", fmWrite):
  #  f.write(xmlHeader)
  #  f.write(serializeXML(new_corrs, "NewCorrs"))
  #  f.close()
 
  # Write the new db
  echo "Write out new edb"
  writeEDB(meta, output_edb, new_corrs, corrs)
