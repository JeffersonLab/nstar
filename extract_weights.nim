#!/usr/bin/env /home/edwards/bin/nimrunner
## Extract projected operator coefficients

import hadron_sun_npart_irrep_op, streams, os, xmlparser,
       serializetools/serializexml, tables, xmltree, parseutils, strutils,
       ensem, extract_all_v_coeffs_xml, irrep_util

#-----------------------------------------------------------------------------
when isMainModule:
  # Read in all the operators and build one big operator map
  # Test dir is  /work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1/szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265/redstar/pion/fits_rge
  let opsMap = readOpsMapFiles(@["./single.ops.xml"])

  # Output file
  var output: ProjectedOpWeights

  # Weights
  let chan = "pion"

  output.version = 3
  output.ProjectedOps = extractProjectOpWeights(chan, @[
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
 
#[
  # Now, make Kbarneg version
  var orig = output.ProjectedOps
  clear(output.ProjectedOps)

  # Flip sign of odd charge-conj ops
  for k,v in pairs(orig):
    var kk = k
    kk.name = replace(k.name, "Kneg", "Kbarneg")
    let vv = flipSignOddChargeConj(v)
    #echo "k= ", k, "  kk= ", kk
    output.ProjectedOps[kk] = vv

  # Write the xml
  writeProjOpsXML("kbar", output)
  writeProjOpsList("kbar", output)
 
]#


