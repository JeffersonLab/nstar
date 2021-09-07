## Extract operator properties

import irrep_util, strutils, tables

       
## ----------------------------------------------------------------------------------
proc getIrrep(opName: string): string =
  ## Get irrep name from operator name
  var opIrreps = opName.split("_")
  result = opIrreps[opIrreps.high()]

  # Remove the helicity label
  result = removeHelicity(result)

  # Perform check on irrep name (not necessary?)
  if getIrrepDim(result) < 1:
    quit(": ERROR: unknown irrep " & result & " from operator " & opName)
    

## ----------------------------------------------------------------------------------
proc extractContOpName*(opName: string): string =
  ## Extract continuum op name from subduced op name
  var opIrreps = opName.split("_")
  result = opIrreps[opIrreps.low()]


## ----------------------------------------------------------------------------------
## Particle ID stuff
type
  QuantumNum_t = object
    had: int   # 1->meson (no parity in op name), 2->baryon (parity is in op name)
    flavor: string   # Flavor
    N: int           # The N in SU(N)
    F: string        # Flavor irrep
    twoI: int        # 2*Isospin
    S: int           # Strangeness (s quark has strangeness -1)
    P: int           # Rest-frame parity
    G: int           # G-parity (if it exists)

# Initialize classnames
# Flavor -> isospin, strangeness, parity, charge-conj.
type
  Class_t = Table[string, QuantumNum_t]


var classnames: Class_t = {
  "eta_": QuantumNum_t(had: 1, flavor: "eta", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "f_": QuantumNum_t(had: 1, flavor: "f", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "h_": QuantumNum_t(had: 1, flavor: "h", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "omega_": QuantumNum_t(had: 1, flavor: "omega", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "phi_": QuantumNum_t(had: 1, flavor: "phi", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "eta1_": QuantumNum_t(had: 1, flavor: "eta", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "f1_": QuantumNum_t(had: 1, flavor: "f", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "h1_": QuantumNum_t(had: 1, flavor: "h", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "omega1_": QuantumNum_t(had: 1, flavor: "omega", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "phi1_": QuantumNum_t(had: 1, flavor: "phi", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "eta8_": QuantumNum_t(had: 1, flavor: "eta", N: 3, F: "8", twoI: 0, S: 0, P: -1, G: +1),
  "f8_": QuantumNum_t(had: 1, flavor: "f", N: 3, F: "8", twoI: 0, S: 0, P: -1, G: +1),
  "h8_": QuantumNum_t(had: 1, flavor: "h", N: 3, F: "8", twoI: 0, S: 0, P: -1, G: +1),
  "omega8_": QuantumNum_t(had: 1, flavor: "omega", N: 3, F: "8", twoI: 0, S: 0, P: -1, G: +1),
  "phi8_": QuantumNum_t(had: 1, flavor: "phi", N: 3, F: "8", twoI: 0, S: 0, P: -1, G: +1),
  "fl_": QuantumNum_t(had: 1, flavor: "f", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "fs_": QuantumNum_t(had: 1, flavor: "f", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "chic_": QuantumNum_t(had: 1, flavor: "chi", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "chice_": QuantumNum_t(had: 1, flavor: "chi", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "hl_": QuantumNum_t(had: 1, flavor: "h", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "hs_": QuantumNum_t(had: 1, flavor: "h", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "hc_": QuantumNum_t(had: 1, flavor: "h", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "hce_": QuantumNum_t(had: 1, flavor: "h", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "etal_": QuantumNum_t(had: 1, flavor: "eta", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "etas_": QuantumNum_t(had: 1, flavor: "eta", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "etac_": QuantumNum_t(had: 1, flavor: "eta", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "etace_": QuantumNum_t(had: 1, flavor: "eta", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "omegal_": QuantumNum_t(had: 1, flavor: "omega", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "omegas_": QuantumNum_t(had: 1, flavor: "omega", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "psi_": QuantumNum_t(had: 1, flavor: "omega", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "psice_": QuantumNum_t(had: 1, flavor: "omega", N: 2, F: "1", twoI: 0, S: 0, P: -1, G: -1),
  "ubaruneg_": QuantumNum_t(had: 1, flavor: "ubaru", N: 2, F: "0", twoI: 0, S: 0, P: -1, G: -1),
  "dbardneg_": QuantumNum_t(had: 1, flavor: "dbard", N: 2, F: "0", twoI: 0, S: 0, P: -1, G: -1),
  "ubarupos_": QuantumNum_t(had: 1, flavor: "ubaru", N: 2, F: "0", twoI: 0, S: 0, P: +1, G: -1),
  "dbardpos_": QuantumNum_t(had: 1, flavor: "dbard", N: 2, F: "0", twoI: 0, S: 0, P: +1, G: -1),
  "Kpos_": QuantumNum_t(had: 1, flavor: "Kpos", N: 2, F: "2", twoI: 1, S: +1, P: +1, G: 0),
  "Kneg_": QuantumNum_t(had: 1, flavor: "Kneg", N: 2, F: "2", twoI: 1, S: +1, P: -1, G: 0),
  "Kbarpos_": QuantumNum_t(had: 1, flavor: "Kbarpos", N: 2, F: "2", twoI: 1, S: -1, P: +1, G: 0),
  "Kbarneg_": QuantumNum_t(had: 1, flavor: "Kbarneg", N: 2, F: "2", twoI: 1, S: -1, P: -1, G: 0),
  "Dpos_": QuantumNum_t(had: 1, flavor: "Dpos", N: 2, F: "2", twoI: 1, S: 0, P: +1, G: 0),
  "Dneg_": QuantumNum_t(had: 1, flavor: "Dneg", N: 2, F: "2", twoI: 1, S: 0, P: -1, G: 0),
  "Dbarpos_": QuantumNum_t(had: 1, flavor: "Dbarpos", N: 2, F: "2", twoI: 1, S: 0, P: +1, G: 0),
  "Dbarneg_": QuantumNum_t(had: 1, flavor: "Dbarneg", N: 2, F: "2", twoI: 1, S: 0, P: -1, G: 0),
  "Dspos_": QuantumNum_t(had: 1, flavor: "Dspos", N: 2, F: "1", twoI: 0, S: +1, P: +1, G: 0),
  "Dsneg_": QuantumNum_t(had: 1, flavor: "Dsneg", N: 2, F: "1", twoI: 0, S: +1, P: -1, G: 0),
  "Dsbarpos_": QuantumNum_t(had: 1, flavor: "Dsbarpos", N: 2, F: "1", twoI: 0, S: -1, P: +1, G: 0),
  "Dsbarneg_": QuantumNum_t(had: 1, flavor: "Dsbarneg", N: 2, F: "1", twoI: 0, S: -1, P: -1, G: 0),
  "Epos_": QuantumNum_t(had: 1, flavor: "Epos", N: 2, F: "2", twoI: 0, S: 0, P: +1, G: 0),
  "Eneg_": QuantumNum_t(had: 1, flavor: "Eneg", N: 2, F: "2", twoI: 0, S: 0, P: -1, G: 0),
  "Ebarpos_": QuantumNum_t(had: 1, flavor: "Ebarpos", N: 2, F: "2", twoI: 0, S: 0, P: +1, G: 0),
  "Ebarneg_": QuantumNum_t(had: 1, flavor: "Ebarneg", N: 2, F: "2", twoI: 0, S: 0, P: -1, G: 0),
  "Espos_": QuantumNum_t(had: 1, flavor: "Espos", N: 2, F: "1", twoI: 0, S: +1, P: +1, G: 0),
  "Esneg_": QuantumNum_t(had: 1, flavor: "Esneg", N: 2, F: "1", twoI: 0, S: +1, P: -1, G: 0),
  "Esbarpos_": QuantumNum_t(had: 1, flavor: "Esbarpos", N: 2, F: "1", twoI: 0, S: -1, P: +1, G: 0),
  "Esbarneg_": QuantumNum_t(had: 1, flavor: "Esbarneg", N: 2, F: "1", twoI: 0, S: -1, P: -1, G: 0),
  "a_": QuantumNum_t(had: 1, flavor: "a", N: 2, F: "3", twoI: 2, S: 0, P: +1, G: -1),
  "b_": QuantumNum_t(had: 1, flavor: "b", N: 2, F: "3", twoI: 2, S: 0, P: +1, G: +1),
  "pion_": QuantumNum_t(had: 1, flavor: "pion", N: 2, F: "3", twoI: 2, S: 0, P: -1, G: -1),
  "rho_": QuantumNum_t(had: 1, flavor: "rho", N: 2, F: "3", twoI: 2, S: 0, P: -1, G: +1),
  "gluepP_": QuantumNum_t(had: 3, flavor: "gluepP", N: 3, F: "1", twoI: 0, S: 0, P: +1, G: +1),
  "gluepM_": QuantumNum_t(had: 3, flavor: "gluepM", N: 3, F: "1", twoI: 0, S: 0, P: +1, G: -1),
  "gluemP_": QuantumNum_t(had: 3, flavor: "gluemP", N: 3, F: "1", twoI: 0, S: 0, P: -1, G: +1),
  "gluemM_": QuantumNum_t(had: 3, flavor: "gluemM", N: 3, F: "3", twoI: 0, S: 0, P: -1, G: -1),
  "Nucleon": QuantumNum_t(had: 2, flavor: "Nucleon", N: 2, F: "2", twoI: 1, S: 0, P: +1, G: 0),
  "Delta": QuantumNum_t(had: 2, flavor: "Delta", N: 2, F: "4", twoI: 3, S: 0, P: +1, G: 0),
  "Lambda1": QuantumNum_t(had: 2, flavor: "Lambda", N: 2, F: "1", twoI: 0, S: -1, P: +1, G: 0),
  "Lambda8": QuantumNum_t(had: 2, flavor: "Lambda", N: 2, F: "1", twoI: 0, S: -1, P: +1, G: 0),
  "Sigma8": QuantumNum_t(had: 2, flavor: "Sigma", N: 2, F: "3", twoI: 2, S: -1, P: +1, G: 0),
  "Sigma10": QuantumNum_t(had: 2, flavor: "Sigma", N: 2, F: "3", twoI: 2, S: -1, P: +1, G: 0),
  "Xi8": QuantumNum_t(had: 2, flavor: "Xi", N: 2, F: "2", twoI: 1, S: -2, P: +1, G: 0),
  "Xi10": QuantumNum_t(had: 2, flavor: "Xi", N: 2, F: "2", twoI: 1, S: -2, P: +1, G: 0),
  "Omega": QuantumNum_t(had: 2, flavor: "Omega", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "LambdacA": QuantumNum_t(had: 2, flavor: "LambdacA", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "LambdacM": QuantumNum_t(had: 2, flavor: "LambdacM", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "SigmacM": QuantumNum_t(had: 2, flavor: "SigmacM", N: 2, F: "3", twoI: 2, S: 0, P: +1, G: 0),
  "SigmacS": QuantumNum_t(had: 2, flavor: "SigmacS", N: 2, F: "3", twoI: 2, S: 0, P: +1, G: 0),
  "XicS": QuantumNum_t(had: 2, flavor: "XicS", N: 2, F: "2", twoI: 1, S: -1, P: +1, G: 0),
  "XipcM": QuantumNum_t(had: 2, flavor: "XipcM", N: 2, F: "2", twoI: 1, S: -1, P: +1, G: 0),
  "XicM": QuantumNum_t(had: 2, flavor: "XicM", N: 2, F: "2", twoI: 1, S: -1, P: +1, G: 0),
  "XiccS": QuantumNum_t(had: 2, flavor: "XiccS", N: 2, F: "2", twoI: 1, S: 0, P: +1, G: 0),
  "XiccM": QuantumNum_t(had: 2, flavor: "XiccM", N: 2, F: "2", twoI: 1, S: 0, P: +1, G: 0),
  "OmegacS": QuantumNum_t(had: 2, flavor: "OmegacS", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "OmegaccS": QuantumNum_t(had: 2, flavor: "OmegaccS", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "OmegaccS": QuantumNum_t(had: 2, flavor: "OmegaccS", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "OmegacM": QuantumNum_t(had: 2, flavor: "OmegacM", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "OmegaccM": QuantumNum_t(had: 2, flavor: "OmegaccM", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0),
  "OmegaccM": QuantumNum_t(had: 2, flavor: "OmegaccM", N: 2, F: "1", twoI: 0, S: 0, P: +1, G: 0)}.toTable

# SU(2)_F tetraquarks
for twoI in 0..4:
  for S in -2..2:
    for P in items(@[-1,1]):
      for G in items(@[-1,1]):
        var os = "tetra2I" & $twoI & "S"

        if S < 0:
          os &= "m" & $(-S)
        elif S == 0:
          os &= $S
        else:
          os &= "p" & $S

        if P < 0:
          os &= "m"
        else:
          os &= "p"

        if G < 0:
          os &= "M"
        elif G > 0:
          os &= "P"

        classnames[os & "_"] = QuantumNum_t(had: 4, flavor: os, N: 2, F: $(twoI+1), twoI: twoI, S: S, P: P, G: G)

# SU(3)_F tetraquarks
for tt in items(@["1", "8", "10", "27"]):
  for P in items(@[-1,1]):
    for G in items(@[-1,1]):
      var os = "tetraF" & tt

      if P < 0:
        os &= "m"
      else:
        os &= "p"

      if G < 0:
        os &= "M"
      elif G > 0:
        os &= "P"

      classnames[os & "_"] = QuantumNum_t(had: 4, flavor: os, N: 3, F: tt, twoI: 0, S: 0, P: P, G: G)


# ----------------------------------------------------------------------------------
proc getFlavorIndex(opName: string): QuantumNum_t =
  ## Get flavor of particle id
  for k,v in pairs(classnames):
    if startsWith(opName, k):
      return v

  quit(": ERROR: cannot extract flavor from operator name " & opName)


# ----------------------------------------------------------------------------------
proc getSUNF*(opName: string): int =
  ## Get the N in SU(N)
  return getFlavorIndex(opName).N


# ----------------------------------------------------------------------------------
proc getFlavorIrrep*(opName: string): string = 
  ## Get flavor irrep
  return getFlavorIndex(opName).F


# ----------------------------------------------------------------------------------
proc getFlavor*(opName: string): string = 
  ## Get flavor of particle id
  return getFlavorIndex(opName).flavor


# ----------------------------------------------------------------------------------
proc getNumQuarks*(opName: string): int =
  ## Get number of quarks
  let had = getFlavorIndex(opName).had
  if had == 1:
    return 2
  elif had == 2:
    return 3
  elif had == 3:
    return 2
  else:
    quit(": unknown hadron type= " & $had)

  return -1

#----------------------------------------------------------------------------------
proc getTwoIsospin*(opName: string): int =
  ## Get flavor of particle id
  return getFlavorIndex(opName).twoI
 
#----------------------------------------------------------------------------------
proc getThreeY*(opName: string): int = 
  ## Get threeY of id
  let qq = getFlavorIndex(opName)
  
  # Y = S + B
  var threeY = qq.S
  if qq.had == 2:
    threeY += 1 # baryon
    
  return 3*threeY

# ----------------------------------------------------------------------------------
proc getGParity*(opName: string): int =
  ## Get strangeness of particle id
  return getFlavorIndex(opName).G

# ----------------------------------------------------------------------------------
proc getStrangeness*(opName: string): int =
  ## Get strangeness of particle id
  return getFlavorIndex(opName).S

# ----------------------------------------------------------------------------------
proc getIrrepNoParity*(opName: string): string =
  ## Get irrep with parity
  return getCubicRepNoParity(getIrrep(opName))

# ----------------------------------------------------------------------------------
proc getIrrepWithParity*(opName: string): string =
  ## Get irrep with parity
  let irrep = getCubicRepNoParity(getIrrep(opName))
  let mm = getFlavorIndex(opName)
  
  return buildIrrepWithParity(irrep, mm.P)

# ----------------------------------------------------------------------------------
proc getIrrepWithGParity*(opName: string): string =
  ## Get irrep with parity
  let irrep = getCubicRepNoParity(getIrrep(opName))
  let mm = getFlavorIndex(opName)
  
  return buildIrrepWithParity(irrep, mm.P)

# ----------------------------------------------------------------------------------
proc getIrrepWithPG*(opName: string): string =
  ## Get irrep with parity
  let irrep = getCubicRepNoParity(getIrrep(opName))
  let mm = getFlavorIndex(opName)
  
  return buildIrrepWithPG(irrep, mm.P, mm.G)
  
