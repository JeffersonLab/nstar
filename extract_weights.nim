#!/usr/bin/env /home/edwards/bin/nimrunner
## Extract projected operator coefficients

import hadron_sun_npart_irrep_op, streams, os, xmlparser,
       serializetools/serializexml, tables, xmltree, parseutils, strutils,
       ensem, extract_all_v_coeffs_xml, irrep_util

#-----------------------------------------------------------------------------
when isMainModule:
  # Read in all the operators and build one big operator map
  # Test dir is  /work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1/szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265/redstar/pion/fits_rge
  let pp = "/work/JLabLQCD/LHPC/Spectrum/Clover/NF2+1/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/redstar/rhopi.i2/fits_rge/"
  let opsMap = readOpsMapFiles(@[pp & "two.ops.xml"])

  # Output file
  var output: ProjectedOpWeights

  # Weights
  let chan = "boson2I4S0c0B0pM"
  let L    = 16
  let xi   = 3.444

  output.version = 3
  output.ProjectedOps = extractProjectOpWeights(chan, L, xi, @[
       (dir:   pp &    "000_T1pM",   ir: "T1p",       mom: "000", t0: 10, tZ: 14, states: @[0,1]),
       (dir:   pp &    "100_A2M",    ir: "H0D4A2",    mom: "100", t0: 10, tZ: 26, states: @[0,1,2]),
       (dir:   pp &    "100_E2M",    ir: "H0D4E2",    mom: "100", t0: 10, tZ: 10, states: @[0,1]),
       (dir:   pp &    "110_A2M",    ir: "H0D2A2",    mom: "110", t0: 10, tZ: 19, states: @[0,1,2,3,4]),
       (dir:   pp &    "110_B1M",    ir: "H0D2B1",    mom: "110", t0: 11, tZ: 17, states: @[0,1,2]),
       #(dir:       "200_A1P",    ir: "H0D4A1",    mom: "200", t0: 10, tZ: 19, states: @[0,1,2,3,4,5,6]),
       #(dir:       "210_nm0A1P",   ir: "H0C4nm0A1", mom: "210", t0:  10, tZ: 23, states: @[0,1,2,3,4,5]),
       #(dir:       "211_nnmA1P",   ir: "H0C4nnmA1", mom: "211", t0:  10, tZ: 27, states: @[0,1,2,3,4,5,6]),
       ],
       opsMap)

  # Write the xml
  writeProjOutput(chan, L, output)
 
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
  writeProjOutput("kbar", L, output)
 
]#


