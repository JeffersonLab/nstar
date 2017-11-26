#!/usr/bin/env /home/edwards/bin/nimrunner
## Extract projected operator coefficients

import hadron_sun_npart_irrep_op, particle_op, streams, os, xmlparser, re,
       serializetools/serializexml, tables, xmltree, parseutils, strutils,
       ensem, serializetools/array1d

type
  # We choose some particular structure for the objects
  ProjectedOpWeights* = tuple
    version:      int
    ProjectedOps: Table[KeyParticleOp_t,Table[KeyHadronSUNNPartIrrepOp_t,float64]]
    
  # Structure that drives the extraction routine
  ExtractProjOps_t* = tuple
    dir:     string   ## 000_T1mP.fewer, etc.
    ir:      string   ## "T1"
    mom:     string   ## "000", etc.
    t0:      int      ## t0
    tZ:      int      ## tZ
    states:  seq[int] ## all the states


    
proc readOpsMapFiles*(opsMapFiles: seq[string]): Table[string, KeyHadronSUNNPartIrrepOp_t] =
  ## Read in several ops map files and return one table holding them all
  result = initTable[string, KeyHadronSUNNPartIrrepOp_t]()

  # Loop over each opsmap file and add it to the main table
  for f in items(opsMapFiles):
    # Read source ops xml and make a map
#   echo "Read file= ", f
    if not fileExists(f): quit("file = " & f & " does not exist")
    let xml: XmlNode = loadXml(f)

    # Deserialize this table
    let ops = deserializeXML[Table[string, KeyHadronSUNNPartIrrepOp_t]](xml)
  
    # Loop over its entries and add to the main table
    for k, v in pairs(ops):
      result.add(k,v)


proc extractProjectOpWeights*(state, t0, tZ: int; opsListFile: string; opsMap: Table[string,KeyHadronSUNNPartIrrepOp_t]): auto =
  ## Extract projected operator weights for state `state` at a fixed `t0` and `tZ`
  ## Return a table holding the operators and their weights (float64) - the "optimal" operator that projects onto this level.
  #
  echo "Extract weights for projected state = ", state

  # Output table starts empty
  result = initTable[KeyHadronSUNNPartIrrepOp_t,float64]()

  # The ensemble (mass) file we will use
  let massfile = readEnsemble("t0" & $t0 & "/MassJackFiles/mass_t0_" & $t0 & "_reorder_state" & $state & ".jack")

  # Slurp in the entire contents of the ops_phases file
  let inputString = readFile(opsListFile)
  
  # Loop over the operators for this state
  for line in splitLines(inputString):
    # Ignore empty lines
    if line.len < 1: continue

#   echo "parse line= ", line
    let ll = splitWhiteSpace(line)
    if ll.len != 4:
      quit("Input needs space split values, got: " & line)

    let ii = parseInt(ll[0])
    let subOpName = ll[1]

    if not opsMap.hasKey(subOpName):
      quit("Key=  " & subopName & "  not in operator opsMap")

    # V_t file
    let Vt = readEnsemble("t0" & $t0 & "/V_tJackFiles/V_t0_" & $t0 & "_reordered_state" & $state & "_op" & $ii & ".jack")
                    
    # Calc utils from module "ensem"
    let valc = calc(sqrt(2 * massfile) * exp(-0.5*massfile * t0) * extract(Vt, tZ))
    let val  = valc.data[0].avg.re
    echo "subopName= ", subopName, "  val= ", val

    # Here is the struct
    let op = opsMap[subopName]

    # add it into the table
    result[op] = val


proc momType*(mom: string): array[0..2, cint] =
  ## Extract a mom_type array from a string of momenta
  result[0] = int32(parseInt($mom[0]))
  result[1] = int32(parseInt($mom[1]))
  result[2] = int32(parseInt($mom[2]))

proc extractProjectOpWeights*(channel: string, irreps: seq[ExtractProjOps_t], opsMap: Table[string,KeyHadronSUNNPartIrrepOp_t]): Table[KeyParticleOp_t,Table[KeyHadronSUNNPartIrrepOp_t,float64]] =
  ## Loop over many irreps extract the projects operators for several states `states` within an irrep
  #
  result = initTable[KeyParticleOp_t, Table[KeyHadronSUNNPartIrrepOp_t,float64]]()

  # Loop over the irreps
  # For each irrep, extract the weights. 
  for rep in items(irreps):
    echo "\n--------------------------\nChannel= ", channel, "  irrep= ", rep.ir, " mom= ", rep.mom, " t0= ", rep.t0, " tZ= ", rep.tZ

    # Move into the expected dir
    if not dirExists(rep.dir):
      quit("dir = " & rep.dir & " does not exist")

    let cwd = getCurrentDir()
    setCurrentDir(rep.dir)

    # Loop over each state
    for state in items(rep.states):
      # Grab the projected ops, and insert into the big map
      let proj_op_name = channel & "_proj" & $state & "_p" & rep.mom & "_" & rep.ir
      echo "Projected op = ", proj_op_name
      let proj_op_key = KeyParticleOp_t(name: proj_op_name, smear: "", mom_type: momType(rep.mom))
      result[proj_op_key] = extractProjectOpWeights(state, rep.t0, rep.tZ, "ops_phases", opsMap)

    # Move back up
    setCurrentDir(cwd)


proc flipSignOddChargeConj*(opsMap: Table[KeyHadronSUNNPartIrrepOp_t,float64]): Table[KeyHadronSUNNPartIrrepOp_t,float64] =
  ## Flip the sign of the weight for odd charge-conjugation operators
  #
  result = initTable[KeyHadronSUNNPartIrrepOp_t,float64]()

  # Loop through each op. Only supports 1 op per structure
  for k,v in pairs(opsMap):
    if k.Operators.data.len != 1:
      quit("Only allow 1 operator")

    var C = 0   # set to something bogus to trigger a failure if not properly set
    let subopname = k.Operators[1].name

    if contains(subopname, re"_a0x"): C = +1
    if contains(subopname, re"_a1x"): C = +1
    if contains(subopname, re"_pionx"): C = +1
    if contains(subopname, re"_pion_2x"): C = +1

    if contains(subopname, re"_b0x"): C = -1
    if contains(subopname, re"_b1x"): C = -1
    if contains(subopname, re"_rhox"): C = -1
    if contains(subopname, re"_rho_2x"): C = -1
  
    if contains(subopname, re"xD0_"): C *= +1
    if contains(subopname, re"xD2_J0_"): C *= +1
    if contains(subopname, re"xD2_J2_"): C *= +1
    if contains(subopname, re"xD3_J131_"): C *= +1

    if contains(subopname, re"xD1_"): C *= -1
    if contains(subopname, re"xD2_J1_"): C *= -1
    if contains(subopname, re"xD3_J130_"): C *= -1
    if contains(subopname, re"xD3_J132_"): C *= -1

    if C == 0: quit("Error in flipSignOddCC: found C=0")

    result[k] = float64(C)*v



#-----------------------------------------------------------------------------
when isMainModule:
  # Read in all the operators and build one big operator map
  # Test dir is  /work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1/szscl3_20_128_b1p50_t_x4p300_um0p0743_n1p265_per/redstar/h8/fits_rge
  let opsMap = readOpsMapFiles(@["./h8.ops.xml", "./omega8.ops.xml"])

  # Output file
  var output: ProjectedOpWeights

  # Weights
  # Work on multiple directories
  let ot = "../../omega8/fits_rge"

  output.version = 3
  output.ProjectedOps = extractProjectOpWeights("h8", @[
       #(dir:       "000_T1pP.fewer", ir: "T1",     mom: "000", t0: 8, tZ:10, states: @[0]),
       #(dir:       "100_A2P",        ir: "H0D4A2", mom: "100", t0: 8, tZ: 9, states: @[0]),
       #(dir: ot & "/100_E2P",        ir: "H1D4E2", mom: "100", t0: 9, tZ:10, states: @[1]),
       #(dir:       "110_A2P",        ir: "H0D2A2", mom: "110", t0: 8, tZ: 6, states: @[0]),
       #(dir: ot & "/110_B1P",        ir: "H1D2B1", mom: "110", t0: 9, tZ:11, states: @[1]),
       #(dir: ot & "/110_B2P",        ir: "H1D2B2", mom: "110", t0:10, tZ:11, states: @[1]),
       #(dir:       "110_A2P",        ir: "H0D3A2", mom: "111", t0: 8, tZ:10, states: @[0]),
       #(dir: ot & "/111_E2P",        ir: "H1D3E2", mom: "100", t0: 8, tZ:11, states: @[1]),
       (dir:       "200_A2P",        ir: "H0D4A2", mom: "200", t0: 7, tZ:10, states: @[0]),
       #(dir: ot & "/200_E2P",        ir: "H1D4E2", mom: "200", t0: 8, tZ:11, states: @[1])
       ],
       opsMap)

  # Write the xml
  var f: File
  if open(f, "new_all_proj_op.xml", fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(output, "ProjectedOpWeights"))
    f.close()
  
