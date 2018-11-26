## Generate redstar NPoint input xml for two-point functions and a list of source/sink ops

import
  tables, complex,
  hadron_sun_npart_irrep_op, hadron_sun_npart_irrep, hadron_sun_npart_npt_corr, irrep_util,
  serializetools/serializexml, 
  serializetools/serializebin, 
  serializetools/array1d,
  particle_op, cgc_su3, cgc_irrep_mom,
  ensem, extract_all_v_coeffs_xml, niledb

import
  os, strutils, xmltree, xmlparser, posix



#[
## ----------------------------------------------------------------------------------
proc printRedstarIrrep*(ops_list: seq[OpsList_t];
                        ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                        mom: seq[cint];
                        include_all_rows: bool;
                        creation_op: bool;
                        smearedP: bool): seq[IrrepOpList_t] =
  ##  Create single time-slice of operator constructions for all ops in ops_list
  ##  Input  pair of form    [000_T1mM, string=<operator_id>]
  ##  Return pair of form    [000_T1mM, KeyHadronSUNNPartIrrep_t]
  ## 
  #  Only select the irreps compatible with the mom_type
  let canon_mom = canonicalOrder(mom)
  #  Sink ops
  result.setLen(0)
  for irrep_op in items(ops_list):
    if not ops_map.has_key(irrep_op.op):
      quit(": missing op= " & irrep_op.op & " is not in ops_map")
    let mom_type = opListToIrrepMom(irrep_op.rep).mom
    if canon_mom != mom_type:
      continue
    var had: KeyHadronSUNNPartIrrep_t
    had.creation_op = creation_op
    had.smearedP = smearedP
    had.Op = ops_map[irrep_op.op]
    ##  Op
    let info = hadronIrrepOpInfo(had.Op)
    had.flavor = KeyCGCSU3_t(twoI: info.twoI, threeY: info.threeY, twoI_Z: info.twoI)
    var dim = if (include_all_rows): info.dim else: 1
    for row in 1 .. dim:
      had.irmom = KeyCGCIrrepMom_t(row: row, mom: mom)
      result.add((irrep_op.rep, had))


## ----------------------------------------------------------------------------------
proc printRedstar2PtsDefault*(source_ops_list: seq[OpsList_t];
                              sink_ops_list: seq[OpsList_t];
                              ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                              mom: seq[cint]; include_all_rows: bool;
                              t_sources: seq[cint]): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Default method
  #  Sink & source ops
  let sink_ops   = printRedstarIrrep(sink_ops_list, ops_map, mom, include_all_rows, false, true)
  let source_ops = printRedstarIrrep(source_ops_list, ops_map, mom, include_all_rows, true, true)
  ##  Output
  result.setLen(0)
  ##  Outer product of sink and source ops
  for snk in items(sink_ops):
    for src in items(source_ops):
      ##  The "default" version has the same source/sink irreps and the same rows
      if snk.rep != src.rep:
        continue
      if snk.op.irmom.row != src.op.irmom.row:
        continue
      ##  Loop over time sources
      for t_source in items(t_sources):
        var key: KeyHadronSUNNPartNPtCorr_t
        key.NPoint.setLen(2)
        key.NPoint[1].t_slice = -2
        key.NPoint[1].Irrep = snk.op
        key.NPoint[2].t_slice = t_source
        key.NPoint[2].Irrep = src.op
        result.add(key)
]#  


## ----------------------------------------------------------------------------------
proc readProjectOpWeights*(files: seq[string]): auto =
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
proc readSDB*(edb: string): auto = 
  ## Read an edb
  echo "edb= ", edb

  type K = KeyHadronSUNNPartNPtCorr_t
  type V = seq[Complex64]

  result = initTable[K,V]()

  # Quick sanity check
  if getFileSize(edb) == 0:
    quit("BAD EDB= " & edb)

  # Open it
  var db = openTheSDB(edb)

  # Read all the key/values
  let bin_pairs = allBinaryPairs(db)
  echo "found num pairs= ", bin_pairs.len
  echo "here are all the pairs: len= ", bin_pairs.len, "  keys:\n"
  
  #echo "deserialize the first val"
  #let foov = deserializeBinary[V](bin_pairs[0].val)
  #echo "foov= ", $foov

  #echo "deserialize the first key"
  #let fook = deserializeBinary[K](bin_pairs[0].key)
  #echo "fook= ", $fook

  # Loop over all the pairs and build a Table
  for k,v in items(bin_pairs):
    let kk = deserializeBinary[K](k)
    let vv = deserializeBinary[V](v)
    result.add(kk, vv)
      
  # Close
  if db.close() != 0:
    quit("error closing db")

      
## ----------------------------------------------------------------------------
proc writeSDB*(meta: string, file: string, corrs: Table[KeyHadronSUNNPartNPtCorr_t, seq[Complex64]]) =
  ## Write the db
  echo "Declare conf db"
  var db = newConfDataStoreDB()

  # Let us write a file
  if fileExists(file):
    echo "It exists, so remove it"
    removeFile(file)
  else:
    echo "Does not exist"

  # Meta-data
  db.setMaxUserInfoLen(meta.len)

  # Number of configs
  echo "Set max configs= ", 1
  #db.setMaxNumberConfigs(nbins)

  echo "open the db = ", file
  var ret = db.open(file, O_RDWR or O_TRUNC or O_CREAT, 0o664)
  echo "open = ", file, "  return type= ", ret
  if ret != 0:
    quit("strerror= " & $strerror(errno))

  # Insert new DB-meta
  ret = db.insertUserdata(meta)
  if ret != 0:
    quit("strerror= " & $strerror(errno))
 
  # For each key, built up some values and insert them
  for k,v in pairs(corrs):
    # Insert
    ret = db.insert(k,v)
    if ret != 0:
      echo "Ooops, ret= ", ret
      quit("Error in insertion")

  # Close
  discard db.close()



## ----------------------------------------------------------------------------
proc newVal(Lt: int): seq[Complex64] =
  result.setLen(Lt)
  for v in mitems(result):
    v = complex64(0.0)
  

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
  result.NPoint[2].t_slice = 0    # FIXME
  result.NPoint[2].Irrep = newSrcIrrep(flavor, irmom, src)


## ----------------------------------------------------------------------------
##  Read database and an opslist file. Reweight the corrs
## 
#-----------------------------------------------------------------------------
when isMainModule:
  echo "paramCount = ", paramCount()
  if paramCount() < 4:
    quit("Usage: exe <out> <in> <proj op name> <proj op file> <ops map 1> <ops map 2> ...")
    
  let output_edb    = paramStr(1)
  let input_edb     = paramStr(2)
  let proj_op_xml   = paramStr(3)

  echo "Read proj ops map"
  let projOpsMap = readProjectOpWeights(@[proj_op_xml])

  # Read the ops files
  var ops_map_files = newSeq[string](0)

  for n in 4 .. paramCount():
    let f = paramStr(n)
    ops_map_files.add(f)
    
  # Op files
  let opsMap = readOpsMapFiles(ops_map_files)

  echo "Read edb = ", input_edb
  let corrs = readSDB(input_edb)
  
  #echo "Here is the contents of corrs\n", $corrs
  #echo "Here is the xml version of corrs\n", serializeXML(corrs)

  # Write the xml
  var f: File
  if open(f, "debug.xml", fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(corrs, "Corrs"))
    f.close()
  

  echo "Grab the flavor, irrepmom, and ops from the first npt of the first correlator"
  var flavor:   KeyCGCSU3_t
  var irmom:    KeyCGCIrrepMom_t
  var Lt:       int
  var irrep_ops = initTable[KeyHadronSUNNPartIrrepOp_t,int]()

  for k,v in pairs(corrs):
    flavor = k.NPoint[1].Irrep.flavor
    irmom  = k.NPoint[1].Irrep.irmom
    Lt     = v.len()
    irrep_ops.add(k.NPoint[1].Irrep.Op,1)

  echo "flavor= ", $flavor
  echo "irmom= ",  $irmom
  echo "Lt= ",     Lt
  echo "\n\n"

  # Construct a new project correlator
  # Table[KeyParticleOp_t, Table[KeyHadronSUNNPartIrrepOp_t,float64]]()
  var new_corrs = initTable[KeyHadronSUNNPartNPtCorr_t, seq[Complex64]]()

  # Construct a new projop-projop submatrix
  for nk1,nv1 in pairs(projOpsMap):
    for nk2,nv2 in pairs(projOpsMap):
      echo "key1= ",nk1, "  key2= ",nk2
      let key = constructCorr(flavor, irmom, newIrrepOp(nk1), newIrrepOp(nk2))
      var val = newVal(Lt)
      
      for kk1,vv1 in pairs(nv1):
        for kk2,vv2 in pairs(nv2):
          #echo $serializeXML(kk1)
          echo "Construct this corr"
          let cr = constructCorr(flavor, irmom, kk1, kk2)
          echo $serializeXML(cr)
          if not corrs.hasKey(cr):
            quit("oops, corr does not exist: cr= " & $cr)
          # Accumulate
          for i in 0..Lt-1:
            val[i] += corrs[cr][i] * vv1 * vv2

      new_corrs.add(key, val)


  # Construct a new projop-projop submatrix
  for nk1,nv1 in pairs(projOpsMap):
    for nk2 in keys(irrep_ops):
      echo "key1= ",nk1
      let key = constructCorr(flavor, irmom, newIrrepOp(nk1), nk2)
      var val = newVal(Lt)
      
      for kk1,vv1 in pairs(nv1):
        #echo $serializeXML(kk1)
        echo "Construct this corr"
        let cr = constructCorr(flavor, irmom, kk1, nk2)
        echo $serializeXML(cr)
        if not corrs.hasKey(cr):
          quit("oops, corr does not exist: cr= " & $cr)
        # Accumulate
        for i in 0..Lt-1:
          val[i] += corrs[cr][i] * vv1

      new_corrs.add(key, val)


  # Construct a new vanilla-projop submatrix
  for nk1 in keys(irrep_ops):
    for nk2,nv2 in pairs(projOpsMap):
      echo "  key2= ",nk2
      let key = constructCorr(flavor, irmom, nk1, newIrrepOp(nk2))
      var val = newVal(Lt)
      
      for kk2,vv2 in pairs(nv2):
        #echo $serializeXML(kk1)
        echo "Construct this corr"
        let cr = constructCorr(flavor, irmom, nk1, kk2)
        echo $serializeXML(cr)
        if not corrs.hasKey(cr):
          quit("oops, corr does not exist: cr= " & $cr)
        # Accumulate
        for i in 0..Lt-1:
          val[i] += corrs[cr][i] * vv2

      new_corrs.add(key, val)

  # More debugging
  if open(f, "new_corrs.xml", fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(new_corrs, "NewCorrs"))
    f.close()
 
  # Write the new db
  #<?xml version="1.0"?>

  let meta = """
<DBMetaData>
  <id>hadronSUNNPartNPtCorr</id>
  <lattSize>4 4 4 16</lattSize>
  <decay_dir>3</decay_dir>
  <t_origin>0</t_origin>
  <version>3</version>
  <ensemble></ensemble>
</DBMetaData>
"""

  writeSDB(meta, "new_corrs.sdb", new_corrs)
