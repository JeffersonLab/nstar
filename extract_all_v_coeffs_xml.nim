#!/usr/bin/env /home/edwards/bin/nimrunner
## Extract projected operator coefficients

import hadron_sun_npart_irrep_op, particle_op, streams, os, xmlparser, re,
       serializetools/serializexml, tables, xmltree, parseutils, strutils,
       irrep_util, ensem, serializetools/array1d, operator_name_util, math

type
  # Output for an irrep
  ProjOpVals* = tuple
    E_cm:    float64
    E_lab:   float64
    weights: Table[KeyHadronSUNNPartIrrepOp_t,float64]
    
  # We choose some particular structure for the objects
  ProjectedOpWeights* = tuple
    version:      int
    ProjectedOps: Table[KeyParticleOp_t,ProjOpVals]
    
  ProjectedOpWeightsSlim = tuple
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
      result[k] = v


proc computeEcm(E_lab: float64, L:int, xi: float64, p: array[0..2,cint]): float64 = 
  let pi = 3.14159265359
  let f  = 2.0*pi / (xi*float64(L))
  result = sqrt(E_lab*E_lab - float64(p[0]*p[0] + p[1]*p[1] + p[2]*p[2])*f*f)


proc fredextractProjectOpWeights*(L: int, xi: float64, mom_type: array[0..2, cint], state, t0, tZ: int; opsListFile: string; opsMap: Table[string,KeyHadronSUNNPartIrrepOp_t]): ProjOpVals =
  ## Extract projected operator weights for state `state` at a fixed `t0` and `tZ`
  ## Return a table holding the operators and their weights (float64) - the "optimal" operator that projects onto this level.
  #
  echo "Extract weights for projected state = ", state

  # Output table starts empty
  result.weights = initTable[KeyHadronSUNNPartIrrepOp_t,float64]()

  # The ensemble (mass) file we will use
  let massfile = readEnsemble("t0" & $t0 & "/MassJackFiles/mass_t0_" & $t0 & "_reorder_state" & $state & ".jack")

  # Compute E_cm and E_lab
  let E_labb   = calc(massfile)
  result.E_lab = E_labb.data[0].avg.re
  result.E_cm  = computeEcm(result.E_lab, L, xi, mom_type)

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
    #echo "subopName= ", subopName, "  val= ", val
    echo "subopName= ", subopName, "  val= ", val, "  E_cm= ", result.E_cm, "  E_lab= ", result.E_lab

    # Here is the struct
    let op = opsMap[subopName]

    # add it into the table
    result.weights[op] = val


proc momType*(mom: string): array[0..2, cint] =
  ## Extract a mom_type array from a string of momenta
  result[0] = int32(parseInt($mom[0]))
  result[1] = int32(parseInt($mom[1]))
  result[2] = int32(parseInt($mom[2]))

proc extractProjectOpWeights*(channel: string, L: int, xi: float64, irreps: seq[ExtractProjOps_t], opsMap: Table[string,KeyHadronSUNNPartIrrepOp_t]): Table[KeyParticleOp_t, ProjOpVals] =
  ## Loop over many irreps extract the projects operators for several states `states` within an irrep
  result = initTable[KeyParticleOp_t, ProjOpVals]()

  #Table[KeyHadronSUNNPartIrrepOp_t,float64]] =
  
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
      let mom_type = momType(rep.mom)
      let proj_op_key = KeyParticleOp_t(name: proj_op_name, smear: "", mom_type: mom_type)
      result[proj_op_key] = fredextractProjectOpWeights(L, xi, mom_type, state, rep.t0, rep.tZ, "ops_phases", opsMap)

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

    # Trigger based on op name
    # Also must handle the isospin designations that change
    var kk = k
    var subopname = kk.Operators[1].name
    subopname = replace(subopname, "Kneg", "Kbarneg")
    subopname = replace(subopname, "Kpos", "Kbarpos")
    subopname = replace(subopname, "Dneg", "Dbarneg")
    subopname = replace(subopname, "Dpos", "Dbarpos")
    subopname = replace(subopname, "Eneg", "Ebarneg")
    subopname = replace(subopname, "Epos", "Ebarpos")
    kk.Operators.data[0].name = subopname
    
    var C = 0   # set to something bogus to trigger a failure if not properly set

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

    result[kk] = float64(C)*v


proc extractWeightsSlim(input: ProjectedOpWeights): ProjectedOpWeightsSlim =
  ## Extract just the weights
  result.version      = input.version
  result.ProjectedOps = initTable[KeyParticleOp_t,Table[KeyHadronSUNNPartIrrepOp_t,float64]]() # local copy

  for k,v in pairs(input.ProjectedOps):
    result.ProjectedOps[k] = v.weights

 
proc writeProjOpsXML*(chan: string, output: ProjectedOpWeights) =
  ## Write the xml
  var weights = extractWeightsSlim(output)

  var f: File
  if open(f, "weights." & chan & ".xml", fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(weights, "ProjectedOpWeights"))
    f.close()
 

proc writeProjOpsList*(chan: string, output: ProjectedOpWeights) =
  ## Write the list
  var f: File
  if open(f, "weights." & chan & ".list", fmWrite):
    for k,v in pairs(output.ProjectedOps):
      #pion_proj0_p100_H0D4A2
      let pp = split(k.name,'_')
      var mom = pp[2]
      mom.delete(0,0)
      let ir = mom & "_" & getIrrepWithPG(k.name)
      f.write(ir & " " & k.name & "\n")
    f.close()


proc writeProjOpsDat*(chan: string, L: int, output: ProjectedOpWeights) =
  ## Write the list
  var f: File
  if open(f, "weights." & chan & ".dat", fmWrite):
    for k,v in pairs(output.ProjectedOps):
      #pion_proj0_p100_H0D4A2
      let pp = split(k.name,'_')
      var mom = pp[2]
      mom.delete(0,0)
      #let irr = removeIrrepLG(removeHelicity(k.name))
      let irr = getIrrepWithPG(k.name)
      let irrr = removeIrrepLG(irr)
      let ir = mom & "_" & irrr
      #echo "k.name= ", k.name, "  irr= ", irr, "  irrr= ", irrr
      f.write(" " & $L & " " & ir & " " & $v.E_cm & " " & $v.E_lab & " " & k.name & "\n")
    f.close()
 


#-----------------------------------------------------------------------------
when isMainModule:
  # Read in all the operators and build one big operator map
  # Test dir is  /work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1/szscl21_32_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265/redstar/pion/fits_rge
  let opsMap = readOpsMapFiles(@["./single.ops.xml"])

  # Output file
  var output: ProjectedOpWeights

  # Weights
  let chan = "tetra2I2S0mM"
  let L    = 32
  let xi   = 3.461

#m = 0.04724 +/- 0.00013
#xi = 3.461 +/- 0.005

  output.version = 3
  output.ProjectedOps = extractProjectOpWeights(chan, L, xi, @[
       (dir:       "000_A1mM.no_2",     ir: "A1",        mom: "000", t0: 11, tZ: 14, states: @[0]),
       (dir:       "100_A2M.no_2",      ir: "H0D4A2",    mom: "100", t0: 10, tZ: 15, states: @[0]),
       (dir:       "110_A2M.no_2",      ir: "H0D2A2",    mom: "110", t0: 10, tZ: 15, states: @[0]),
       (dir:       "111_A2M.no_2",      ir: "H0D3A2",    mom: "111", t0: 10, tZ: 16, states: @[0]),
       (dir:       "200_A2M.no_2",      ir: "H0D4A2",    mom: "200", t0: 10, tZ: 18, states: @[0]),
       (dir:       "210_nm0A2M.no_2",   ir: "H0C4nm0A2", mom: "210", t0: 10, tZ: 18, states: @[0]),
       (dir:       "211_nnmA2M.no_2",   ir: "H0C4nnmA2", mom: "211", t0:  9, tZ: 24, states: @[0]),
       ],
       opsMap)


  # Write the xml
  writeProjOpsXML(chan, output)
  writeProjOpsList(chan, output)
  writeProjOpsDat(chan, L, output)
