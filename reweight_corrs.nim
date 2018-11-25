## Generate redstar NPoint input xml for two-point functions and a list of source/sink ops

import
  tables, complex,
  hadron_sun_npart_irrep_op, hadron_sun_npart_irrep, hadron_sun_npart_npt_corr, irrep_util,
  serializetools/serializexml, 
  serializetools/serializebin, 
  serializetools/array1d,
  particle_op,
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
  type V = seq[Complex]

  result = initTable[K,V]()

  # Quick sanity check
  if getFileSize(edb) == 0:
    quit("BAD EDB= " & edb)

  # Open it
  var db = openTheSDB(edb)

  # Read all the keys
  echo "try getting all the keys"
  #let des_keys = allKeys[K](db)
  #echo "found num keys= ", des_keys.len
  #echo "here are all the keys: len= ", des_keys.len, "  keys:\n"

  let bin_keys = allBinaryKeys(db)
  echo "found num keys= ", bin_keys.len
  echo "here are all the keys: len= ", bin_keys.len, "  keys:\n"
  
  let bin_pairs = allBinaryPairs(db)
  echo "found num pairs= ", bin_pairs.len
  echo "here are all the pairs: len= ", bin_pairs.len, "  keys:\n"
  
  echo "deserialize the first val"
  let foov = deserializeBinary[V](bin_pairs[0].val)
  echo "foov= ", $foov

  echo "deserialize the first key"
  let fook = deserializeBinary[K](bin_pairs[0].key)
  echo "fook= ", $fook

#[
  # Loop over all the keys, and find the t-to-t perams. Check their values.
  for k in des_keys:
    if (k.t_source == k.t_slice) and (k.spin_l == 0) and (k.spin_r == 0):
      # Read the prop elemental
      var v: V
      if db.get(k,v) != 0: quit("Error reading " & $k)
      #let N = v.mat.nrows
      #for i in 0..N-1:
      var i = 0
      if v.mat[0,0].re < cutoff:
        echo "k= ", k, "  v[", i, ",",i,"]= ",v.mat[i,i], "  bad"
        bad = true
]#
      
  # Close
  if db.close() != 0:
    quit("error closing db")
      


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
  

#[
  #  Output corrs
  #  Select the irreps commensurate with the momentum
  echo "Build 2pt correlation functions"
  var corrs = newSeq[KeyHadronSUNNPartNPtCorr_t](0)

  for mom in items(params.moms):
    let tmp = printRedstar2Pts(params.runmode, source_ops_list, sink_ops_list, ops_map, mom,
                               params.include_all_rows, params.t_sources)
    echo "Found ", tmp.len(), "  corr funcs compatible with mom= ", mom
    corrs.add(tmp)

  #  Print keys
  echo "\nWrite out ", corrs.len(), " total number of corr funcs 2pt xml"
  # Write the xml
  writeFile(output_xml, xmlHeader & $serializeXML(corrs, "NPointList"))
]#
