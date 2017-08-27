#!/usr/bin/env /home/edwards/bin/nimrunner
## Extract projected operator coefficients

import hadron_sun_npart_irrep_op, streams, os, xmlparser,
       serializetools/serializexml, tables, xmltree, parseutils, strutils,
       ensem, extract_all_v_coeffs_xml


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
       (dir:       "000_T1pP.fewer", ir: "T1",     mom: "000", t0: 8, tZ:10, states: @[0]),
       (dir:       "100_A2P",        ir: "H0D4A2", mom: "100", t0: 8, tZ: 9, states: @[0]),
       (dir: ot & "/100_E2P",        ir: "H1D4E2", mom: "100", t0: 9, tZ:10, states: @[1]),
       (dir:       "110_A2P",        ir: "H0D2A2", mom: "110", t0: 8, tZ: 6, states: @[0]),
       (dir: ot & "/110_B1P",        ir: "H1D2B1", mom: "110", t0: 9, tZ:11, states: @[1]),
       (dir: ot & "/110_B2P",        ir: "H1D2B2", mom: "110", t0:10, tZ:11, states: @[1]),
       (dir:       "110_A2P",        ir: "H0D3A2", mom: "111", t0: 8, tZ:10, states: @[0]),
       (dir: ot & "/111_E2P",        ir: "H1D3E2", mom: "100", t0: 8, tZ:11, states: @[1]),
       (dir:       "200_A2P",        ir: "H0D4A2", mom: "200", t0: 7, tZ:10, states: @[0]),
       (dir: ot & "/200_E2P",        ir: "H1D4E2", mom: "200", t0: 8, tZ:11, states: @[1])
       ],
       opsMap)

  # Write the xml
  var f: File
  if open(f, "new_all_proj_op.xml", fmWrite):
    f.write(xmlHeader)
    f.write(serializeXML(output, "ProjectedOpWeights"))
    f.close()
  
