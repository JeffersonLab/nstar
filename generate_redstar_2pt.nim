## Generate redstar NPoint input xml for two-point functions and a list of source/sink ops

import
  tables,
  hadron_sun_npart_irrep_op, hadron_sun_npart_irrep, hadron_sun_npart_npt_corr, irrep_util,
  cgc_irrep_mom, cgc_su3, serializetools/array1d

# Types for various constructons
type
  OpsList_t* = tuple[rep: string, op: string]
  IrrepOpList_t* = tuple[rep: string, op: KeyHadronSUNNPartIrrep_t]

####### HACK ############
type
  HadronIrrepOpInfo_t* = object ## Given an IrrepOp struct, return useful information about the construction
    ## This construction is about the entire N-body construction, so not same as in HadronOpsRegInfo */
    N*:                cint           ##
    F*:                string         ## Flavor irrep
    irrepPG*:          string         ## total irrepPG
    dim*:              cint           ## total rows of irrep
    mom_type*:         seq[cint]      ## total mom_type
    twoI*:             cint           ## total twoI
    threeY*:           cint           ## total threeY
    P*:                cint           ## Parity of the rest frame op
    G*:                cint           ## G-parity of the op if it exists, otherwise 0
    c*:                cint           ## charm
    B*:                cint           ## Baryon num


proc hadronIrrepOpInfo*(irrep_op: KeyHadronSUNNPartIrrepOp_t): HadronIrrepOpInfo_t =
  return HadronIrrepOpInfo_t(N: 2, F: "3", irrepPG: "A1mM", dim: 1, mom_type: Mom3d(0,0,0),
                             twoI: 2, threeY: 0, P: -1, G: -1, c: 0, B: 0)
#######################################



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
proc printRedstar2PtsDiag*(source_ops_list: seq[OpsList_t];
                           sink_ops_list: seq[OpsList_t];
                           ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                           mom: seq[cint]; include_all_rows: bool;
                           t_sources: seq[cint]): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Create corr keys from operator list
  #  Sink & source ops - determined completely by source ops
  let source_ops = printRedstarIrrep(source_ops_list, ops_map, mom, include_all_rows, true, true)
  #  Output
  result.setLen(0)
  #  Outer product of sink and source ops
  for src in items(source_ops):
    ##  Loop over time sources
    for t_source in items(t_sources):
      var key: KeyHadronSUNNPartNPtCorr_t
      key.NPoint.setLen(2)
      key.NPoint[1].t_slice = -2
      key.NPoint[1].Irrep = src.op
      key.NPoint[1].Irrep.creation_op = false
      key.NPoint[2].t_slice = t_source
      key.NPoint[2].Irrep = src.op
      result.add(key)

## ----------------------------------------------------------------------------------
proc printRedstar2PtsOffDiag*(source_ops_list: seq[OpsList_t];
                              sink_ops_list: seq[OpsList_t];
                              ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                              mom: seq[cint]; include_all_rows: bool;
                              t_sources: seq[cint]): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Off-diagonal method
  #  Sink & source ops
  let sink_ops   = printRedstarIrrep(sink_ops_list, ops_map, mom, include_all_rows, false, true)
  let source_ops = printRedstarIrrep(source_ops_list, ops_map, mom, include_all_rows, true, true)
  #  Output
  result.setLen(0)
  #  All source ops to sink ops, independent of irrep
  for snk in items(sink_ops):
    for src in items(source_ops):
      ##  Loop over time sources
      for t_source in items(t_sources):
        var key: KeyHadronSUNNPartNPtCorr_t
        key.NPoint.setLen(2)
        key.NPoint[1].t_slice = -2
        key.NPoint[1].Irrep = snk.op
        key.NPoint[2].t_slice = t_source
        key.NPoint[2].Irrep = src.op
        result.add(key)

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
  

## ----------------------------------------------------------------------------------
proc printRedstar2Pts*(runmode: string;
                       source_ops_list: seq[OpsList_t];
                       sink_ops_list: seq[OpsList_t];
                       ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                       mom: seq[cint]; include_all_rows: bool;
                       t_sources: seq[cint]): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Generate all desired correlation functions dictated by the runmode but for a fixed momenta
  case runmode:
    of "diag":
      result = printRedstar2PtsDiag(source_ops_list, sink_ops_list,
                                    ops_map, mom,
                                    include_all_rows,
                                    t_sources)
    of "offdiag":
      result = printRedstar2PtsOffDiag(source_ops_list, sink_ops_list,
                                       ops_map, mom,
                                       include_all_rows,
                                       t_sources)
    of "default":
      result = printRedstar2PtsDefault(source_ops_list, sink_ops_list,
                                       ops_map, mom,
                                       include_all_rows,
                                       t_sources)
    else:
      quit("Unknown runmode = " & runmode)
      

## ----------------------------------------------------------------------------------
proc printRedstar2Pts*(runmode: string;
                       source_ops_list: seq[OpsList_t];
                       sink_ops_list: seq[OpsList_t];
                       ops_map: Table[string, KeyHadronSUNNPartIrrepOp_t];
                       moms: seq[seq[cint]];
                       include_all_rows: bool;
                       t_sources: seq[cint]): seq[KeyHadronSUNNPartNPtCorr_t] =
  ## Generate all desired correlation functions dictated by the runmode but for all momenta
  result.setLen(0)
  for mom in items(moms):
    result.add(printRedstar2Pts(runmode, source_ops_list, sink_ops_list, ops_map, mom, include_all_rows, t_sources))


## ----------------------------------------------------------------------------------
import
  os, strutils, xmltree, xmlparser,
  serializetools/serializexml


## ----------------------------------------------------------------------------------
proc readOpsListFiles*(opsListFiles: seq[string]): seq[OpsList_t] =
  ##  Read ops list
  #  Format is "irrep opname"
  result.setLen(0)

  for f in items(opsListFiles):
    # Slurp in the entire contents of the ops_list file
    if not fileExists(f): quit("ops list file = " & f & " does not exist")
    let inputString = readFile(f)
  
    # Loop over the operators
    for line in splitLines(inputString):
      # Ignore empty lines
      if line.len < 1: continue

      let ll = splitWhiteSpace(line)
      if ll.len != 2:
        quit("Input needs space split values, got: " & line)

      let irrep_op: OpsList_t = (ll[0], ll[1])
      result.add(irrep_op)


## ----------------------------------------------------------------------------------
proc readOpsMapFiles*(opsMapFiles: seq[string]): Table[string, KeyHadronSUNNPartIrrepOp_t] =
  ## Read in several ops map files and return one table holding them all
  result = initTable[string, KeyHadronSUNNPartIrrepOp_t]()
#  result.clear()

  # Loop over each opsmap file and add it to the main table
  for f in items(opsMapFiles):
    # Read source ops xml and make a map
    if not fileExists(f): quit("file = " & f & " does not exist")
    let xml: XmlNode = loadXml(f)

    # Deserialize this table
    let ops = deserializeXML[Table[string, KeyHadronSUNNPartIrrepOp_t]](xml)
  
    # Loop over its entries and add to the main table
    for k, v in pairs(ops):
      result.add(k,v)




## ----------------------------------------------------------------------------------
## Parameters
type
  Param_t* = object
    runmode*: string           ## !< "diag", "offdiag", "offdiagIsospin", "default"
    include_all_rows*: bool    ## !< All the rows of the irrep?
    source_ops_list*: string   ## !< List of source ops
    sink_ops_list*: string     ## !< List of sink ops
    ops_xmls*: seq[string]     ## !< The XML files for all of the ops
    moms*: seq[seq[cint]]      ## !< The actual momentum - not mom_type
    t_sources*: seq[cint]      ## !< Array of all the requested time-sources
  
## ----------------------------------------------------------------------------
##  Generate redstar NPoint input xml for two-point functions and a list of source/sink ops
## 
#-----------------------------------------------------------------------------
when isMainModule:
  echo "paramCount = ", paramCount()
  if paramCount() < 2:
    quit("Usage: exe <in> <dir>")
    
  let input_xml = paramStr(1)
  let output_xml = paramStr(2)

  if not fileExists(input_xml): quit("file = " & input_xml & " does not exist")
  let xml: XmlNode = loadXml(input_xml)

  # Deserialize this table
  let params = deserializeXML[Param_t](xml)

  ##  Read the operator list file
  echo "Read source ops = ", params.source_ops_list
  let source_ops_list = readOpsListFiles(@[params.source_ops_list])

  echo "Read sink ops = ", params.sink_ops_list
  let sink_ops_list = readOpsListFiles(@[params.sink_ops_list])

  ##  Read the operator maps
  echo "Read ops map"
  let ops_map = readOpsMapFiles(params.ops_xmls)

  ##  Output corrs
  ##  Select the irreps commensurate with the momentum
  echo "Build 2pt correlation functions"
  var corrs = newSeq[KeyHadronSUNNPartNPtCorr_t](0)

  for mom in items(params.moms):
    let tmp = printRedstar2Pts(params.runmode, source_ops_list, sink_ops_list, ops_map, mom,
                               params.include_all_rows, params.t_sources)
    echo "Found ", tmp.len(), "  corr funcs compatible with mom= ", mom
    corrs.add(tmp)

  ##  Print keys
  echo "\nWrite out ", corrs.len(), " total number of corr funcs 2pt xml"
  # Write the xml
  var f: File
  if open(f, output_xml, fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(corrs, "NPointList"))
    f.close()
