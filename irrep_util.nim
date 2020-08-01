##  Support for manipulating irreps
## 

import complex, serializetools/array1d
import strutils

type Mom_t = array[0..2,cint]    ## shorthand


## ----------------------------------------------------------------------------------
proc canonicalOrder*(mom: Mom_t): Mom_t =
  ## Canonically order an array of momenta
  ## return abs(mom[0]) >= abs(mom[1]) >= ... >= abs(mom[mu]) >= ... >= 0
  ##  first step: make all the components positive
  var mom_tmp = mom
  var mu: int = 0
  while mu < mom_tmp.len():
    if mom_tmp[mu] < 0:
      mom_tmp[mu] = - mom_tmp[mu]
    inc(mu)
  mu = 1
  while mu < mom_tmp.len():
    ##  Select the item at the beginning of the unsorted region
    var v = mom_tmp[mu]
    ##  Work backwards, finding where v should go
    var nu = mu
    ##  If this element is less than v, move it up one
    while mom_tmp[nu - 1] < v:
      mom_tmp[nu] = mom_tmp[nu - 1]
      dec(nu)
      if nu < 1: break
    ##  Stopped when mom_tmp[nu-1] >= v, so put v at postion nu
    mom_tmp[nu] = v
    inc(mu)
  return mom_tmp


proc crtesn*(ipos0: int; latt_size: seq[int]): seq[int] =
  ## Decompose a lexicographic site into coordinates
  ##  Calculate the Cartesian coordinates of the VALUE of IPOS where the 
  ##  value is defined by
  ## 
  ##      for i = 0 to NDIM-1  {
  ##         X_i  <- mod( IPOS, L(i) )
  ##         IPOS <- int( IPOS / L(i) )
  ##      }
  ## 
  ##  NOTE: here the coord(i) and IPOS have their origin at 0. 
  ## 
  result = newSeq[int](latt_size.len())
  var i: int = 0
  var ipos = ipos0
  while i < latt_size.len():
    result[i] = ipos mod latt_size[i]
    ipos = ipos div latt_size[i]
    inc(i)


proc local_site*(coord: seq[int]; latt_size: seq[int]): int =
  ## Calculates the lexicographic site index from the coordinate of a site
  ## 
  ##  Nothing specific about the actual lattice size, can be used for 
  ##  any kind of latt size 
  ## 
  var order: int = 0
  var mmu: int = latt_size.len() - 1
  while mmu >= 1:
    order = latt_size[mmu - 1] * (coord[mmu] + order)
    dec(mmu)
  inc(order, coord[0])
  return order

## ----------------------------------------------------------------------------------
## Rotation angles for a vector to a canonical direction

type
  CubicCanonicalRotation_t* = object
    alpha*: cdouble
    beta*:  cdouble
    gamma*: cdouble


## Return rotation angles for a vector to a canonical direction
proc cubicCanonicalRotation*(mom: Mom_t): CubicCanonicalRotation_t

## ----------------------------------------------------------------------------------
## Check group elem is within allowed range
#proc checkIndexLimit*(elem: cint; dim: cint)

## ----------------------------------------------------------------------------------
## Conventional reference mom (for CGs) - not the same as canonical mom
proc referenceMom*(mom: Mom_t): Mom_t

## ----------------------------------------------------------------------------------
## Scale momentum
proc scaleMom*(mom: Mom_t): Mom_t

## ----------------------------------------------------------------------------------
## Unscale momentum
proc unscaleMom*(scaled_mom: Mom_t; mom: Mom_t): Mom_t

## ----------------------------------------------------------------------------------
proc Mom3d*(p1: cint; p2: cint; p3: cint): Mom_t =
  ## Helper function
  result[0] = p1
  result[1] = p2
  result[2] = p3


## ----------------------------------------------------------------------------------
proc Mom3d*(p1: int; p2: int; p3: int): Mom_t =
  ## Helper function
  result[0] = cint(p1)
  result[1] = cint(p2)
  result[2] = cint(p3)

## ----------------------------------------------------------------------------------
proc Mom3d*(p1: char; p2: char; p3: char): Mom_t =
  ## Helper function
  result[0] = cint(parseInt($p1))
  result[1] = cint(parseInt($p2))
  result[2] = cint(parseInt($p3))

## ----------------------------------------------------------------------------------
## Helper functions for automated CGs
type
  RotateVec_t* = tuple[p1: cint, p2: cint, p3: cint]

proc newRotateVec_t*(a: cint; b: cint; c: cint): RotateVec_t =
  discard


## ----------------------------------------------------------------------------------
#import irreps_cubic, irreps_cubic_helicity

##  Irrep names
type
  IrrepNames_t = object
    wp: string          ## Irrep with parity
    np: string          ## Irrep no parity
    ferm: bool          ## Is this a double cover?
    lg: bool            ## LG?
    dim: int            ## dimension
    G: int              ## G-parity
  

## ---------------------------------------------------------------------------
##  Irrep names
import tables

type
  IRNames_t = Table[string, IrrepNames_t]

## ---------------------------------------------------------------------------
##  Initialize irrep names

##  Oh and LG
let irrep_names_no_par: IRNames_t = {
  "A1": IrrepNames_t(wp: "A1", np: "A1", ferm: false, lg: false, dim: 1, G: 0),
  "A2": IrrepNames_t(wp: "A2", np: "A2", ferm: false, lg: false, dim: 1, G: 0),
  "T1": IrrepNames_t(wp: "T1", np: "T1", ferm: false, lg: false, dim: 3, G: 0),
  "T2": IrrepNames_t(wp: "T2", np: "T2", ferm: false, lg: false, dim: 3, G: 0),
  "E":  IrrepNames_t(wp: "E", np: "E", ferm: false, lg: false, dim: 2, G: 0),
  "G1": IrrepNames_t(wp: "G1", np: "G1", ferm: true, lg: false, dim: 2, G: 0),
  "G2": IrrepNames_t(wp: "G2", np: "G2", ferm: true, lg: false, dim: 2, G: 0),
  "H":  IrrepNames_t(wp: "H", np: "H", ferm: true, lg: false, dim: 4, G: 0),
  "D4A1": IrrepNames_t(wp: "D4A1", np: "D4A1", ferm: false, lg: true, dim: 1, G: 0),
  "D4A2": IrrepNames_t(wp: "D4A2", np: "D4A2", ferm: false, lg: true, dim: 1, G: 0),
  "D4E1": IrrepNames_t(wp: "D4E1", np: "D4E1", ferm: true, lg: true, dim: 2, G: 0),
  "D4E2": IrrepNames_t(wp: "D4E2", np: "D4E2", ferm: false, lg: true, dim: 2, G: 0),
  "D4E3": IrrepNames_t(wp: "D4E3", np: "D4E3", ferm: true, lg: true, dim: 2, G: 0),
  "D4B1": IrrepNames_t(wp:"D4B1", np: "D4B1", ferm: false, lg: true, dim: 1, G: 0),
  "D4B2": IrrepNames_t(wp:"D4B2", np: "D4B2", ferm: false, lg: true, dim: 1, G: 0),
  "D3A1": IrrepNames_t(wp:"D3A1", np: "D3A1", ferm: false, lg: true, dim: 1, G: 0),
  "D3A2": IrrepNames_t(wp:"D3A2", np: "D3A2", ferm: false, lg: true, dim: 1, G: 0),
  "D3E1": IrrepNames_t(wp:"D3E1", np: "D3E1", ferm: true, lg: true, dim: 2, G: 0),
  "D3E2": IrrepNames_t(wp:"D3E2", np: "D3E2", ferm: false, lg: true, dim: 2, G: 0),
  "D3B1": IrrepNames_t(wp:"D3B1", np: "D3B1", ferm: false, lg: true, dim: 1, G: 0),
  "D3B2": IrrepNames_t(wp:"D3B2", np: "D3B2", ferm: false, lg: true, dim: 1, G: 0),
  "D2A1": IrrepNames_t(wp:"D2A1", np: "D2A1", ferm: false, lg: true, dim: 1, G: 0),
  "D2A2": IrrepNames_t(wp:"D2A2", np: "D2A2", ferm: false, lg: true, dim: 1, G: 0),
  "D2E": IrrepNames_t(wp:"D2E", np: "D2E", ferm: true, lg: true, dim: 2, G: 0),
  "D2B1": IrrepNames_t(wp:"D2B1", np: "D2B1", ferm: false, lg: true, dim: 1, G: 0),
  "D2B2": IrrepNames_t(wp:"D2B2", np: "D2B2", ferm: false, lg: true, dim: 1, G: 0),
  "C4nm0A1": IrrepNames_t(wp:"C4nm0A1", np: "C4nm0A1", ferm: false, lg: true, dim: 1, G: 0),
  "C4nm0A2": IrrepNames_t(wp:"C4nm0A2", np: "C4nm0A2", ferm: false, lg: true, dim: 1, G: 0),
  "C4nm0E": IrrepNames_t(wp:"C4nm0E", np: "C4nm0E", ferm: true, lg: true, dim: 2, G: 0),
  "C4nnmA1": IrrepNames_t(wp:"C4nnmA1", np: "C4nnmA1", ferm: false, lg: true, dim: 1, G: 0),
  "C4nnmA2": IrrepNames_t(wp:"C4nnmA2", np: "C4nnmA2", ferm: false, lg: true, dim: 1, G: 0),
  "C4nnmE": IrrepNames_t(wp:"C4nnmE", np: "C4nnmE", ferm: true, lg: true, dim: 2, G: 0)}.toTable


# Convenience for G-parity
let PG = {-1: "M", 0: "", +1: "P"}.toTable

## ----------------------------------------------------------------------------------
# Irreps with parity
proc createWithParTable(): IRNames_t =
  ## Create irreps with parity
  result = initTable[string, IrrepNames_t]()
  for k,v in pairs(irrep_names_no_par):
    if not v.lg:
      if v.ferm:
        result[k & "g"] = IrrepNames_t(wp: k & "g", np: v.np, ferm: v.ferm, lg: v.lg, dim: v.dim, G: v.G)
        result[k & "u"] = IrrepNames_t(wp: k & "u", np: v.np, ferm: v.ferm, lg: v.lg, dim: v.dim, G: v.G)
      else:
        result[k & "p"] = IrrepNames_t(wp: k & "p", np: v.np, ferm: v.ferm, lg: v.lg, dim: v.dim, G: v.G)
        result[k & "m"] = IrrepNames_t(wp: k & "m", np: v.np, ferm: v.ferm, lg: v.lg, dim: v.dim, G: v.G)
    else:
      result[k] = v

let irrep_names_with_par = createWithParTable()

## ----------------------------------------------------------------------------------
# Irreps with G-parity
proc createWithPGTable(): IRNames_t =
  # Create irreps with G-parity
  result = initTable[string, IrrepNames_t]()
  #  Loop over G parity of (-1, 0, +1)
  for k,v in pairs(irrep_names_no_par):
    if not v.ferm:
      for p,g in pairs(PG):
        result[k & g] = IrrepNames_t(wp: k & g, np: v.np, ferm: v.ferm, lg: v.lg, dim: v.dim, G: p)

let irrep_names_with_pg: IRNames_t = createWithPGTable()


## ----------------------------------------------------------------------------------
proc getIrrepIndex*(irrep: string): IrrepNames_t =
  ## Get irrep
  # First check the ones with parity and G-parity
  for k,v in pairs(irrep_names_with_pg):
    if startsWith(irrep, k):
      return v

  #  Check the ones with parity
  for k,v in pairs(irrep_names_with_par):
    if startsWith(irrep, k):
      return v

  #  Next try the non-parity versions
  for k,v in pairs(irrep_names_no_par):
    if startsWith(irrep, k):
      return v

  quit(": ERROR: cannot extract irrep= " & irrep)

## ----------------------------------------------------------------------------------
proc removeHelicity*(irrep: string): string =
  ##  Remove the helicity label
  result = irrep
  if (irrep.startsWith("H0D") or irrep.startsWith("H1D") or
      irrep.startsWith("H2D") or irrep.startsWith("H3D") or
      irrep.startsWith("H4D") or irrep.startsWith("H0C") or
      irrep.startsWith("H1C") or irrep.startsWith("H2C") or
      irrep.startsWith("H3C") or irrep.startsWith("H4C")):
    result.delete(0,2)
    return

  if (irrep.startsWith("H1o2D") or irrep.startsWith("H3o2D") or
      irrep.startsWith("H5o2D") or irrep.startsWith("H7o2D") or
      irrep.startsWith("H1o2C") or irrep.startsWith("H3o2C") or
      irrep.startsWith("H5o2C") or irrep.startsWith("H7o2C")):
    result.delete(0,4)

  return

## ----------------------------------------------------------------------------------
proc removeIrrepLG*(rep: string): string =
  ## Irrep names (not including LG) with momentum
  ## Turns [D4A1, Array(1,0,0)]  ->  100_A1
  result = rep
  if (rep.startsWith("D4") or rep.startsWith("D2") or
      rep.startsWith("D3") or rep.startsWith("C4") or
      rep.startsWith("C2")):
    result.delete(0,1)
  return

## ----------------------------------------------------------------------------------
proc removeIrrepGParity*(irrep: string): string =
  ## Remove G-parity from an irrep name
  result = irrep
  result.removeSuffix({'P','M'})
  
## ----------------------------------------------------------------------------------
proc getIrrepParity*(irrep: string): int =
  ## Get parity from an irrep name
  var irrep_noG = removeIrrepGParity(irrep)
  if (irrep_noG.endsWith('p') or irrep_noG.endsWith('g')):
    return 1
  elif (irrep_noG.endsWith('m') or irrep_noG.endsWith('u')):
    return -1
  else:
    return 0
  
## ----------------------------------------------------------------------------------
proc getIrrepGParity*(irrep: string): int =
  ## Get Oh/LG irrep name with no parity from possible helicity name
  if irrep.endsWith('P'):
    return 1
  elif irrep.endsWith('M'):
    return -1
  else:
    return 0
  
## ----------------------------------------------------------------------------------
proc getIrrepLG*(long_irrep: string): string =
  ## Get little group of irrep
  ##  Format of irrep label is D4A1 etc
  result = removeHelicity(long_irrep)
  if (result.startsWith("D2") or result.startsWith("D3") or result.startsWith("D4")):
    result.delete(0,1)
    return
  if (result.startsWith("C4nm0") or result.startsWith("C4nnm")): 
    result.delete(0,4)
    return
  result = "Oh"


## ----------------------------------------------------------------------------------
proc getIrrepDim*(irrep: string): int =
  ## Get dimension of irrep
  return getIrrepIndex(irrep).dim


## ----------------------------------------------------------------------------------
proc getCubicRepNoParity*(irrep: string): string =
  ## Get Oh/LG irrep name with no parity from possible helicity name
  return getIrrepIndex(removeHelicity(irrep)).np


## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
proc buildIrrepWithParity*(irrep: string; P: int): string =
  ## Representation including parity if it exists
  let mm = getIrrepIndex(irrep)
  if mm.lg:
    ##  In flight, so no parity
    return mm.np
  var rep = mm.np
  if mm.ferm:
    if P == + 1:
      rep &= "g"
    elif P == - 1:
      rep &= "u"
  else:
    if P == + 1:
      rep &= "p"
    elif P == - 1:
      rep &= "m"
  return rep

proc buildIrrepWithPG*(irrep: string; P: cint; G: cint): string = 
  ## Representation including parity and G-parity if it exists
  var rep: string = buildIrrepWithParity(irrep, P)
  var mm: IrrepNames_t = getIrrepIndex(irrep)
  if not mm.ferm:
    ##  Only put in G parity if non-zero
    if G == + 1:
      rep &= "P"
    elif G == - 1:
      rep &= "M"
  return rep

## ----------------------------------------------------------------------------------
proc generateLittleGroup*(mom: Mom_t): string =
  ## The name of the little group corresponding to this momentum
  var momCan: Mom_t = canonicalOrder(mom)
  var littleGroup: string = ""
  if momCan[2] == 0:
    if momCan[1] == 0:
      if momCan[0] == 0:         ##  n 0 0
        littleGroup = "Oh"
      else:
        littleGroup = "D4"
    else:
      if momCan[0] == momCan[1]:
        littleGroup = "D2"
      else:
        littleGroup = "C4nm0"
      ##  n m 0
  else:
    if (momCan[0] == momCan[1]) and (momCan[0] == momCan[2]): ##  n m p
      littleGroup = "D3"
    elif (momCan[0] == momCan[1]) or (momCan[0] == momCan[2]) or
        (momCan[1] == momCan[2]): ##  n n m
      littleGroup = "C4nnm"
    else:
      littleGroup = "C2"
  return littleGroup


proc norm2*(mom: Mom_t): cint =
  ## Compute norm2 of a sequence
  result = 0
  for m in items(mom):
    result += m*m

## ----------------------------------------------------------------------------------
proc generateAllMom*(mom2_min: cint; mom2_max: cint): seq[Mom_t] =
  ## Generate all momentum up to a maximum
  result = newSeq[Mom_t](0)
  var mom: Mom_t
  for px in -mom2_max .. mom2_max:
    for py in -mom2_max .. mom2_max:
      for pz in -mom2_max .. mom2_max:
        mom = [px,py,pz]
        if (norm2(mom) < mom2_min) or (norm2(mom) > mom2_max):
          continue
        result.add(mom)

## ----------------------------------------------------------------------------
proc generateCanonMoms*(mom2_min: cint; mom2_max: cint): seq[Mom_t] =
  ##  Generate canonical momenta up to some maximum value
  result = newSeq[Mom_t](0)
  ##  Loop over all desired canonical momentum
  ##  This loop allows us to have, for example,  p= 100, 200, 300,  which all fall in D4
  var mom: Mom_t
  for px in 0 .. mom2_max:
    for py in mom[0] .. mom2_max:
      for pz in mom[1] .. mom2_max:
        ##  Check if valid
        mom = [px,py,pz]
        if (norm2(mom) < mom2_min) or (norm2(mom) > mom2_max):
          continue
        result.add(mom)

## ----------------------------------------------------------------------------------
proc generateLittleGroupMom*(littleGroup0: string; canon_mom0: Mom_t): seq[Mom_t] =
  ## Generate momentum for a little group from a canonical momentum
  result = newSeq[Mom_t](0)
  var littleGroup = getIrrepLG(littleGroup0)
  var canon_mom = canonicalOrder(canon_mom0)
  var mom2 = norm2(canon_mom)
  if generateLittleGroup(canon_mom) != littleGroup:
    quit("little group name= " & littleGroup & " inconsistent with canonical mom= " & $canon_mom)

  var mom: Mom_t
  for px in -mom2 .. mom2:
    for py in -mom2 .. mom2:
      for pz in -mom2 .. mom2:
        ##  Check if valid
        mom = [px,py,pz]
        if norm2(mom) != mom2:
          continue
        var momCan = canonicalOrder(mom)
        if momCan != canon_mom:
          continue
        if generateLittleGroup(momCan) != littleGroup:
          continue
        result.add(mom)


proc addSeq(m1, m2: Mom_t): Mom_t =
  ## Add two sequences
  for i in 0..3:
    result[i] = m1[i] + m2[i]


proc multSeq(m1: Mom_t, n: cint): Mom_t =
  ## Add two sequences
  for i in 0..3:
    result[i] = m1[i] * n


proc divSeq(m1: Mom_t, n: cint): Mom_t =
  ## Divide a sequence
  for i in 0..3:
    result[i] = m1[i] div n


## ----------------------------------------------------------------------------------
proc numMomentaCombin*(group1: string; group2: string;
                       mom1, mom2, momt: Mom_t): int =
  ## Find number of possible source 1 and source 2 momentum orientations for fixed target momentum
  result = 0
  var mom_list1 = generateLittleGroupMom(group1, mom1)
  var mom_list2 = generateLittleGroupMom(group2, mom2)
  for m1 in items(mom_list1):
    for m2 in items(mom_list2):
      if momt == addSeq(m1, m2):
        inc(result)


## ----------------------------------------------------------------------------------
proc allowedMomentaCombin*(group1, group2: string;
                           mom1, mom2, momt: Mom_t,
                           allowed_mom1, allowed_mom2: var seq[Mom_t]): int = 
  ## Find posible source 1 and source 2 momentum orientations for fixed target momentum
  result = 0
  allowed_mom1 = newSeq[Mom_t](0)
  allowed_mom2 = newSeq[Mom_t](0)
  var mom_list1 = generateLittleGroupMom(group1, mom1)
  var mom_list2 = generateLittleGroupMom(group2, mom2)
  for m1 in items(mom_list1):
    for m2 in items(mom_list2):
      if momt == addSeq(m1,m2):
        inc(result)
        allowed_mom1.add(m1)
        allowed_mom2.add(m2)


## ----------------------------------------------------------------------------------
proc canonMomCombin*(mom1, mom2, momt: Mom_t;
                     canon_mom1, canon_mom2: var Mom_t): int =
  ## Generate a canonical combination of momenta for a given target momentum
  var group1 = generateLittleGroup(mom1)
  var group2 = generateLittleGroup(mom2)
  var groupt = generateLittleGroup(momt)
  var allowed_mom1: seq[Mom_t]
  var allowed_mom2: seq[Mom_t]
  var normalisation = allowedMomentaCombin(group1, group2, mom1, mom2, momt,
      allowed_mom1, allowed_mom2)
  if normalisation == 0: return normalisation
  if groupt == "Oh":
    canon_mom1 = referenceMom(mom1)
    canon_mom2 = canon_mom1
    for m in mitems(canon_mom2):
      m = -m
  else:
    canon_mom1 = allowed_mom1[0]
    canon_mom2 = allowed_mom2[0]
  return normalisation

import math

## ----------------------------------------------------------------------------------
proc cubicCanonicalRotation*(mom: Mom_t): CubicCanonicalRotation_t =
  ## Return rotation angles for a seq to a canonical direction
  var pi: cdouble = 3.14159265359
  ##  Lists of momentum directions
  var momListD2 = [[1, 1, 0], [0, 1, 1], [1, 0, 1], [1, - 1, 0], [0, 1, - 1],
                                 [- 1, 0, 1], [- 1, 1, 0], [0, - 1, 1], [1, 0, - 1],
                                 [- 1, - 1, 0], [0, - 1, - 1], [- 1, 0, - 1]]
  var dimMomListD2: int = 12
  var rotAnglesListD2 = [[1.0/4.0, 1.0/2.0, 0.0],
      [1.0/2.0, 1.0/4.0, - (1.0/2.0)], [0.0, 1.0/4.0, - (1.0/2.0)],
      [- (1.0/4.0), 1.0/2.0, 0.0],
      [- (1.0/2.0), - (3.0/4.0), - (1.0/2.0)],
      [- 1.0, 1.0/4.0, - (1.0/2.0)], [- (1.0/4.0), - (1.0/2.0), 0.0],
      [- (1.0/2.0), 1.0/4.0, - (1.0/2.0)], [0.0, 3.0/4.0, - (1.0/2.0)],
      [1.0/4.0, - (1.0/2.0), 0],
      [1.0/2.0, - (3.0/4.0), - (1.0/2.0)],
      [- 1.0, 3.0/4.0, - (1.0/2.0)]]
  ##  {phi, theta, psi} in units of pi
  var momListD3 = [[1, 1, 1], [- 1, 1, 1], [1, - 1, 1], [1, 1, - 1],
                                 [- 1, - 1, 1], [1, - 1, - 1], [- 1, 1, - 1], [- 1, - 1, - 1]]
  var dimMomListD3: int = 8
  var rotAnglesListD3 = [
      [pi/4.0, arccos(1/sqrt(3.0)), 0.0],
      [(3 * pi)/4.0, arccos(1/sqrt(3.0)), 0.0],
      [- (pi/4.0), arccos(1/sqrt(3.0)), 0.0],
      [pi/4.0, arccos(- (1/sqrt(3.0))), - (pi/3.0)],
      [(- (3 * pi))/4.0, arccos(1/sqrt(3.0)), 0.0],
      [(3 * pi)/4.0, - arccos(- (1/sqrt(3.0))), 0.0],
      [- (pi/4.0), - arccos(- (1/sqrt(3.0))), 0.0],
      [pi/4.0, - arccos(- (1/sqrt(3.0))), 0.0]]
  var momListC4nm0 = [[0, 1, 2], [1, 2, 0], [2, 0, 1], [0, 2, 1], [2, 1, 0],
                                    [1, 0, 2], [0, 1, - 2], [1, - 2, 0], [- 2, 0, 1],
                                    [0, - 2, 1], [- 2, 1, 0], [1, 0, - 2], [0, - 1, 2],
                                    [- 1, 2, 0], [2, 0, - 1], [0, 2, - 1], [2, - 1, 0],
                                    [- 1, 0, 2], [0, - 1, - 2], [- 1, - 2, 0], [- 2, 0, - 1],
                                    [0, - 2, - 1], [- 2, - 1, 0], [- 1, 0, - 2]]
  var dimMomListC4nm0: int = 24
  var rotAnglesListC4nm0 = [
      [pi/2.0, arccos(2.0/sqrt(5.0)), 0.0],
      [- arccos(- (1.0/sqrt(5.0))), - (pi/2.0), pi/2.0],
      [- pi, - arccos(1.0/sqrt(5.0)), 0.0],
      [- (pi/2.0), - arccos(1.0/sqrt(5.0)), 0.0],
      [arccos(2.0/sqrt(5.0)), pi/2.0, pi/2.0],
      [0.0, arccos(2.0/sqrt(5.0)), 0.0],
      [- (pi/2.0), - arccos(- (2.0/sqrt(5.0))), 0.0],
      [- arccos(1.0/sqrt(5.0)), pi/2.0, pi/2.0],
      [0.0, - arccos(1.0/sqrt(5.0)), 0.0],
      [pi/2.0, - arccos(1.0/sqrt(5.0)), 0.0],
      [- arccos(2.0/sqrt(5.0)), - (pi/2.0), pi/2.0],
      [- pi, - arccos(- (2.0/sqrt(5.0))), 0.0],
      [- (pi/2.0), arccos(2.0/sqrt(5.0)), 0.0],
      [arccos(- (1.0/sqrt(5.0))), pi/2.0, pi/2.0],
      [0.0, arccos(- (1.0/sqrt(5.0))), 0.0],
      [pi/2.0, arccos(- (1.0/sqrt(5.0))), 0.0],
      [arccos(- (2.0/sqrt(5.0))), - (pi/2.0), pi/2.0],
      [- pi, arccos(2.0/sqrt(5.0)), 0.0],
      [pi/2.0, - arccos(- (2.0/sqrt(5.0))), 0.0],
      [arccos(1.0/sqrt(5.0)), - (pi/2.0), pi/2.0],
      [- pi, arccos(- (1.0/sqrt(5.0))), 0.0],
      [- (pi/2.0), arccos(- (1.0/sqrt(5.0))), 0.0],
      [- arccos(- (2.0/sqrt(5.0))), pi/2.0, pi/2.0],
      [0.0, - arccos(- (2.0/sqrt(5.0))), 0.0]]
  var momListC4nnm = [[1, 1, 2], [1, 2, 1], [2, 1, 1], [- 1, 1, 2],
                                    [- 1, 2, 1], [1, - 1, 2], [1, 2, - 1], [2, - 1, 1],
                                    [2, 1, - 1], [1, 1, - 2], [1, - 2, 1], [- 2, 1, 1],
                                    [- 1, - 1, 2], [- 1, 2, - 1], [2, - 1, - 1], [- 1, 1, - 2],
                                    [- 1, - 2, 1], [1, - 1, - 2], [1, - 2, - 1], [- 2, - 1, 1],
                                    [- 2, 1, - 1], [- 1, - 1, - 2], [- 1, - 2, - 1],
                                    [- 2, - 1, - 1]]
  var dimMomListC4nnm: int = 24
  var rotAnglesListC4nnm = [
      [(- (3.0 * pi))/4.0, - arccos(sqrt(2.0/3.0)), 0.0], [
      - arccos(- (1.0/sqrt(5.0))), - arccos(1.0/sqrt(6.0)),
      pi/2.0 + arccos(- sqrt(3.0/5.0))], [arccos(2.0/sqrt(5.0)),
                                        arccos(1.0/sqrt(6.0)),
                                        pi/2.0 - arccos(- sqrt(3.0/5.0))],
      [- (pi/4.0), - arccos(sqrt(2.0/3.0)), 0.0], [arccos(- (1.0/sqrt(5.0))),
      arccos(1.0/sqrt(6.0)), pi/2.0 - arccos(- sqrt(3.0/5.0))],
      [(3.0 * pi)/4.0, - arccos(sqrt(2.0/3.0)), 0.0], [
      - arccos(- (1.0/sqrt(5.0))), - arccos(- (1.0/sqrt(6.0))),
      pi/2.0 - arccos(- sqrt(3.0/5.0))], [arccos(- (2.0/sqrt(5.0))),
                                        - arccos(1.0/sqrt(6.0)),
                                        pi/2.0 + arccos(- sqrt(3.0/5.0))], [
      arccos(2.0/sqrt(5.0)), arccos(- (1.0/sqrt(6.0))),
      pi/2.0 + arccos(- sqrt(3.0/5.0))],
      [pi/4.0, arccos(- sqrt(2.0/3.0)), 0.0], [- arccos(1.0/sqrt(5.0)),
      arccos(1.0/sqrt(6.0)), pi/2.0 - arccos(- sqrt(3.0/5.0))], [
      - arccos(2.0/sqrt(5.0)), - arccos(1.0/sqrt(6.0)),
      pi/2.0 + arccos(- sqrt(3.0/5.0))],
      [pi/4.0, - arccos(sqrt(2.0/3.0)), 0.0], [arccos(- (1.0/sqrt(5.0))),
      arccos(- (1.0/sqrt(6.0))), pi/2.0 + arccos(- sqrt(3.0/5.0))], [
      arccos(- (2.0/sqrt(5.0))), - arccos(- (1.0/sqrt(6.0))),
      pi/2.0 - arccos(- sqrt(3.0/5.0))],
      [(3.0 * pi)/4.0, arccos(- sqrt(2.0/3.0)), 0.0], [arccos(1.0/sqrt(5.0)),
      - arccos(1.0/sqrt(6.0)), pi/2.0 + arccos(- sqrt(3.0/5.0))],
      [- (pi/4.0), arccos(- sqrt(2.0/3.0)), 0.0], [- arccos(1.0/sqrt(5.0)),
      arccos(- (1.0/sqrt(6.0))), pi/2.0 + arccos(- sqrt(3.0/5.0))], [
      - arccos(- (2.0/sqrt(5.0))), arccos(1.0/sqrt(6.0)),
      pi/2.0 - arccos(- sqrt(3.0/5.0))], [- arccos(2.0/sqrt(5.0)),
                                        - arccos(- (1.0/sqrt(6.0))),
                                        pi/2.0 - arccos(- sqrt(3.0/5.0))],
      [(- (3.0 * pi))/4.0, arccos(- sqrt(2.0/3.0)), 0.0], [arccos(1.0/sqrt(5.0)),
      - arccos(- (1.0/sqrt(6.0))), pi/2.0 - arccos(- sqrt(3.0/5.0))], [
      - arccos(- (2.0/sqrt(5.0))), arccos(- (1.0/sqrt(6.0))),
      pi/2.0 + arccos(- sqrt(3.0/5.0))]]
  var momListC4nnm113 = [[1, 1, 3], [1, 3, 1], [3, 1, 1], [- 1, 1, 3],
                                       [- 1, 3, 1], [1, - 1, 3], [1, 3, - 1], [3, - 1, 1],
                                       [3, 1, - 1], [1, 1, - 3], [1, - 3, 1], [- 3, 1, 1],
                                       [- 1, - 1, 3], [- 1, 3, - 1], [3, - 1, - 1],
                                       [- 1, 1, - 3], [- 1, - 3, 1], [1, - 1, - 3],
                                       [1, - 3, - 1], [- 3, - 1, 1], [- 3, 1, - 1],
                                       [- 1, - 1, - 3], [- 1, - 3, - 1], [- 3, - 1, - 1]]
  var rotAnglesListC4nnm113 = [
      [(- (3 * pi))/4.0, - arctan(sqrt(2.0)/3.0), 0],
      [arctan(3.0), arctan(sqrt(10.0)), arctan(sqrt(11.0)/3.0)],
      [arctan(1.0/3.0), arctan(sqrt(10.0)), - arctan(sqrt(11.0)/3.0)],
      [- (pi/4.0), - arctan(sqrt(2.0)/3.0), 0],
      [- arctan(3.0), - arctan(sqrt(10.0)), pi - arctan(sqrt(11.0)/3.0)],
      [- (pi/4.0), arctan(sqrt(2.0)/3.0), pi],
      [arctan(3.0), pi - arctan(sqrt(10.0)), pi - arctan(sqrt(11.0)/3.0)],
      [- arctan(1.0/3.0), arctan(sqrt(10.0)), arctan(sqrt(11.0)/3.0)],
      [arctan(1.0/3.0), pi - arctan(sqrt(10.0)), - pi + arctan(sqrt(11.0)/3.0)],
      [(- (3 * pi))/4.0, - pi + arctan(sqrt(2.0)/3.0), pi],
      [- arctan(3.0), arctan(sqrt(10.0)), - arctan(sqrt(11.0)/3.0)],
      [- arctan(1.0/3.0), - arctan(sqrt(10.0)), - pi + arctan(sqrt(11.0)/3.0)],
      [(- (3 * pi))/4.0, arctan(sqrt(2.0)/3.0), pi],
      [- arctan(3.0), - pi + arctan(sqrt(10.0)), arctan(sqrt(11.0)/3.0)],
      [- arctan(1.0/3.0), pi - arctan(sqrt(10.0)), pi - arctan(sqrt(11.0)/3.0)],
      [- (pi/4.0), - pi + arctan(sqrt(2.0)/3.0), pi],
      [arctan(3.0), - arctan(sqrt(10.0)), - pi + arctan(sqrt(11.0)/3.0)],
      [- (pi/4.0), pi - arctan(sqrt(2.0)/3.0), 0],
      [- arctan(3.0), pi - arctan(sqrt(10.0)), - pi + arctan(sqrt(11.0)/3.0)],
      [arctan(1.0/3.0), - arctan(sqrt(10.0)), pi - arctan(sqrt(11.0)/3.0)],
      [- arctan(1.0/3.0), - pi + arctan(sqrt(10.0)), - arctan(sqrt(11.0)/3.0)],
      [(- (3 * pi))/4.0, pi - arctan(sqrt(2.0)/3.0), 0],
      [arctan(3.0), - pi + arctan(sqrt(10.0)), - arctan(sqrt(11.0)/3.0)],
      [arctan(1.0/3.0), - pi + arctan(sqrt(10.0)), arctan(sqrt(11.0)/3.0)]]
  var momMag: cdouble = sqrt(pow(cdouble(mom[0]), 2) + pow(cdouble(mom[1]), 2) +
      pow(cdouble(mom[2]), 2))
  var alpha: cdouble = 0.0
  var beta: cdouble = 0.0
  var gamma: cdouble = 0.0
  var littleGroup: string = generateLittleGroup(mom)
  if littleGroup == "D4":
    alpha = arctan2(cdouble(mom[1]), cdouble(mom[0]))
    beta = arccos(cdouble(mom[2])/momMag)
    gamma = 0.0
  elif littleGroup == "D2":
    var momIndex: int = - 1
    var i: int = 0
    while i < dimMomListD2:
      if (momListD2[i][0] == int(cdouble(mom[0]) * sqrt(2.0)/momMag)) and
          (momListD2[i][1] == int(cdouble(mom[1]) * sqrt(2.0)/momMag)) and
          (momListD2[i][2] == int(cdouble(mom[2]) * sqrt(2.0)/momMag)):
        alpha = rotAnglesListD2[i][0] * pi
        beta = rotAnglesListD2[i][1] * pi
        gamma = rotAnglesListD2[i][2] * pi
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      quit(": ERROR: cannot find match for LG= " & littleGroup & "  and momentum " &
           $mom[0] & " " & $mom[1] & " " & $mom[2])
  elif littleGroup == "D3":
    var momIndex: int = - 1
    var i: int = 0
    while i < dimMomListD3:
      if (momListD3[i][0] == int(cdouble(mom[0]) * sqrt(3.0)/momMag)) and
          (momListD3[i][1] == int(cdouble(mom[1]) * sqrt(3.0)/momMag)) and
          (momListD3[i][2] == int(cdouble(mom[2]) * sqrt(3.0)/momMag)):
        ## 		std::cout << __func__ << ": momentum direction " << momListD3[i][0] << momListD3[i][1] << momListD3[i][2] << "\n";
        alpha = rotAnglesListD3[i][0]
        beta = rotAnglesListD3[i][1]
        gamma = rotAnglesListD3[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      quit(": ERROR: cannot find match for LG= " & littleGroup &
        "  and momentum " & $mom[0] & " " & $mom[1] & " " & $mom[2])
  elif littleGroup == "C4nm0":
    var momIndex: int = - 1
    var i: int = 0
    while i < dimMomListC4nm0:
      if (momListC4nm0[i][0] == int(cdouble(mom[0]) * sqrt(5.0)/momMag)) and
          (momListC4nm0[i][1] == int(cdouble(mom[1]) * sqrt(5.0)/momMag)) and
          (momListC4nm0[i][2] == int(cdouble(mom[2]) * sqrt(5.0)/momMag)):
        ## 		std::cout << __func__ << ": momentum direction " << momListC4nm0[i][0] << momListC4nm0[i][1] << momListC4nm0[i][2] << "\n";
        alpha = rotAnglesListC4nm0[i][0]
        beta = rotAnglesListC4nm0[i][1]
        gamma = rotAnglesListC4nm0[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      quit(": ERROR: cannot find match for LG= " & littleGroup &
        "  and momentum " & $mom[0] & " " & $mom[1] & " " & $mom[2])
  elif littleGroup == "C4nnm":
    var momIndex: int = - 1
    var i: int = 0
    while i < dimMomListC4nnm:
      if (momListC4nnm[i][0] == int(cdouble(mom[0]) * sqrt(6.0)/momMag)) and
          (momListC4nnm[i][1] == int(cdouble(mom[1]) * sqrt(6.0)/momMag)) and
          (momListC4nnm[i][2] == int(cdouble(mom[2]) * sqrt(6.0)/momMag)):
        ## std::cout << __func__ << ": momentum direction " << momListC4nnm[i][0] << momListC4nnm[i][1] << momListC4nnm[i][2] << "\n";
        alpha = rotAnglesListC4nnm[i][0]
        beta = rotAnglesListC4nnm[i][1]
        gamma = rotAnglesListC4nnm[i][2]
        momIndex = i
        break
      elif (momListC4nnm113[i][0] == int(cdouble(mom[0]) * sqrt(11.0)/momMag)) and
          (momListC4nnm113[i][1] == int(cdouble(mom[1]) * sqrt(11.0)/momMag)) and
          (momListC4nnm113[i][2] == int(cdouble(mom[2]) * sqrt(11.0)/momMag)): ##  Momenta proportional to 113 etc
        ## std::cout << __func__ << ": momentum direction " << momListC4nnm113[i][0] << momListC4nnm113[i][1] << momListC4nnm113[i][2] << "\n";
        alpha = rotAnglesListC4nnm113[i][0]
        beta = rotAnglesListC4nnm113[i][1]
        gamma = rotAnglesListC4nnm113[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      quit(": ERROR: cannot find match for LG= " & littleGroup &
          "  and momentum " & $mom[0] & " " & $mom[1] & " " & $mom[2])
  else:
    quit(": ERROR: unsupported momentum " & $mom[0] & " " & $mom[1] & " " & $mom[2])
  ##     std::cout << "alpha= " << alpha << ", beta= " << beta << ", gamma= " << gamma << "\n";
  var rot: CubicCanonicalRotation_t
  rot.alpha = alpha
  rot.beta = beta
  rot.gamma = gamma
  return rot

## ----------------------------------------------------------------------------
proc shortMom*(mom: Mom_t): string =
  ##  Build a short version of momentum
  result = $mom[0] & $mom[1] & $mom[2]

## ----------------------------------------------------------------------------
proc momIrrepName*(irrep: string; mom: Mom_t): string =
  ## Irrep names (not including LG) with momentum used for opLists
  ## Turns [D4A1, Array(1,0,0)]  ->  100_A1
  result = shortMom(mom) & "_" & removeIrrepLG(irrep)

## ----------------------------------------------------------------------------
type
  IrrepMom_t* = tuple[rep: string, mom: Mom_t]  ## Meant for datatypes  [D4A1, Array(1,0,0)]

proc opListToIrrepMom*(mom_irrep_name: string): IrrepMom_t =
  ## Inverse of momIrrepName. Turn an opList name back into irrep names (including LG) and momentum
  ## Turns 100_A1 ->  [D4A1, Array(1,0,0)]
  var rep = mom_irrep_name
  rep.delete(0,3)
  result.mom = Mom3d(parseInt($mom_irrep_name[0]),
                     parseInt($mom_irrep_name[1]),
                     parseInt($mom_irrep_name[2]))
  var lg = generateLittleGroup(result.mom)
  if lg == "Oh":
    result.rep = removeIrrepLG(result.rep)
  else:
    result.rep = lg & removeIrrepLG(result.rep)


## ----------------------------------------------------------------------------------
proc checkIndexLimit*(el: int; dd: int) =
  ##  Check group elem is within allowed range
  if (el < 1) or (el > dd):
    quit(": ERROR: index= " & $el & " is outside range of 1-based elements, dimension= " & $dd)


## ----------------------------------------------------------------------------------
proc referenceMom*(mom: Mom_t): Mom_t =
  ## Conventional reference mom (for CGs) - not the same as canonical mom
  var group = generateLittleGroup(mom)
  var momCan = canonicalOrder(mom)
  var momRef = Mom3d(0, 0, 0)
  if group == "Oh":
    momRef = mom
  elif group == "D4":            ##  n00 -> 00n
    var n: int = momCan[0]
    momRef = Mom3d(0, 0, n)
  elif group == "D2":            ##  nn0 -> 0nn
    var n: int = momCan[0]
    momRef = Mom3d(0, n, n)
  elif group == "D3":            ##  nnn -> nnn
    momRef = momCan
  elif group == "C4nm0":         ##  nm0 -> 0mn
    var n: int = momCan[0]
    var m: int = momCan[1]
    momRef = Mom3d(0, m, n)
  elif group == "C4nnm":         ##  nnm/mnn -> nnm
    var n: cint = 0
    var m: cint = 0
    if momCan[0] == momCan[1]:   ##  mnn
      n = momCan[0]
      m = momCan[2]
    else:
      n = momCan[1]
      m = momCan[0]
    momRef = Mom3d(n, n, m)
  elif group == "C2":            ##  nmp
    momRef = momCan
  else:
    quit(": ERROR: unknown group= " & group & " for mom= " & $mom)
  return momRef

## ----------------------------------------------------------------------------------
proc scaleMom*(mom: Mom_t): Mom_t =
  ## Scale momentum to get to form 100, 110, 111, 210, 221 or 321
  var group = generateLittleGroup(mom)
  var momCan = canonicalOrder(mom)
  var scaled_mom = Mom3d(0, 0, 0)
  if group == "Oh":
    scaled_mom = mom
  elif (group == "D4") or (group == "D3") or (group == "D2"): ##  n00,nn0,nnn -> 100,110,111
    var n = momCan[0]
    scaled_mom = divSeq(mom,n)
  elif group == "C4nm0":         ##  nm0 -> 210
    var n = momCan[0]
    var m = momCan[1]
    var i = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 2 * (mom[i] div n)
      elif abs(mom[i]) == m:
        scaled_mom[i] = 1 * (mom[i] div m)
      elif mom[i] == 0:
        scaled_mom[i] = 0
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  elif group == "C4nnm":         ##  nnm -> 221
    var n: cint = 0
    var m: cint = 0
    if momCan[0] == momCan[1]:   ##  mnn
      n = momCan[0]
      m = momCan[2]
    else:
      n = momCan[1]
      m = momCan[0]
    var i: int = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 2 * (mom[i] div n)
      elif abs(mom[i]) == m:
        scaled_mom[i] = 1 * (mom[i] div m)
      elif mom[i] == 0:
        scaled_mom[i] = 0
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  elif group == "C2":            ##  nmp -> 321
    var n = momCan[0]
    var m = momCan[1]
    var p = momCan[2]
    var i: int = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 3 * (mom[i] div n)
      elif abs(mom[i]) == m:
        scaled_mom[i] = 2 * (mom[i] div m)
      elif abs(mom[i]) == p:
        scaled_mom[i] = 1 * (mom[i] div p)
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  else:
    quit(": ERROR: unknown group= " & group & " for mom= " & $mom)
  return scaled_mom

## ----------------------------------------------------------------------------------
proc unscaleMom*(scaled_mom: Mom_t; mom: Mom_t): Mom_t =
  ## Unscale momentum from form 100, 110, 111, 210, 221 or 321
  var group: string = generateLittleGroup(mom)
  if group != generateLittleGroup(scaled_mom):
    quit(": ERROR: scaled_mom= " & $scaled_mom & " is not consistent with mom= " & $mom)
  var momCan = canonicalOrder(mom)
  var unscaled_mom = Mom3d(0, 0, 0)
  if group == "Oh":
    unscaled_mom = mom
  elif (group == "D4") or (group == "D3") or (group == "D2"): ##  100,110,111 -> n00,nn0,nnn
    var n = momCan[0]
    unscaled_mom = multSeq(scaled_mom,n)
  elif group == "C4nm0":         ##  210 -> nm0
    var n = momCan[0]
    var m = momCan[1]
    var i: int = 0
    while i < 3:
      if abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = n * (scaled_mom[i] div 2)
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = m * (scaled_mom[i] div 1)
      elif scaled_mom[i] == 0:
        unscaled_mom[i] = 0
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  elif group == "C4nnm":         ##  nnm -> 221
    var n: cint = 0
    var m: cint = 0
    if momCan[0] == momCan[1]:   ##  mnn
      n = momCan[0]
      m = momCan[2]
    else:
      n = momCan[1]
      m = momCan[0]
    var i: int = 0
    while i < 3:
      if abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = n * (scaled_mom[i] div 2)
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = m * (scaled_mom[i] div 1)
      elif scaled_mom[i] == 0:
        unscaled_mom[i] = 0
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  elif group == "C2":            ##  nmp -> 321
    var n = momCan[0]
    var m = momCan[1]
    var p = momCan[2]
    var i: int = 0
    while i < 3:
      if abs(scaled_mom[i]) == 3:
        unscaled_mom[i] = n * (scaled_mom[i] div 3)
      elif abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = m * (scaled_mom[i] div 2)
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = p * (scaled_mom[i] div 1)
      else:
        quit(": ERROR: shouldnot reach here - something is broken")
      inc(i)
  else:
    quit(": ERROR: unknown group= " & group & " for mom= " & $mom)
  return unscaled_mom

## ----------------------------------------------------------------------------------
##  Shortcut
proc isZeroArray*(a: Array1dO[Complex64]): bool =
  ##  Helper functions for automated CGs
  var i: int = 1
  while i <= a.data.len():
    if a[i].re != 0.0 or a[i].im != 0.0: return false
    inc(i)
  return true

proc modsqArray*(a: Array1dO[Complex64]): float =
  ##  Helper functions for automated CGs
  result = 0.0
  var i: int = 1
  while i <= a.data.len():
    result += a[i].re * a[i].re
    result += a[i].im * a[i].im
    inc(i)

proc dotArrays*(a1: Array1dO[Complex64]; a2: Array1dO[Complex64]): Complex64 =
  result.re = 0.0
  result.im = 0.0
  if a1.data.len() != a2.data.len():
    quit("ERROR: arrays have different sizes")
  var i: int = 1
  while i <= a1.data.len():
    result += conjugate(a1[i]) * a2[i]
    inc(i)


proc generateLGRotation*(rep: string): seq[RotateVec_t] =
  ## Return the rotations for a LG
  result = newSeq[RotateVec_t](0)
  if rep == "D4":
    result.add(newRotateVec_t(3, 2, - 1))
    result.add(newRotateVec_t(- 2, 3, - 1))
    result.add(newRotateVec_t(1, 2, 3))
    result.add(newRotateVec_t(- 3, - 2, - 1))
    result.add(newRotateVec_t(2, - 3, - 1))
    result.add(newRotateVec_t(- 1, 2, - 3))
  elif rep == "D2":
    result.add(newRotateVec_t(3, 2, - 1))
    result.add(newRotateVec_t(1, 2, 3))
    result.add(newRotateVec_t(2, - 1, 3))
    result.add(newRotateVec_t(2, - 3, - 1))
    result.add(newRotateVec_t(- 1, 2, - 3))
    result.add(newRotateVec_t(- 2, 1, 3))
    result.add(newRotateVec_t(- 3, 2, 1))
    result.add(newRotateVec_t(- 1, - 2, 3))
    result.add(newRotateVec_t(3, - 1, - 2))
    result.add(newRotateVec_t(- 2, - 3, 1))
    result.add(newRotateVec_t(1, - 2, - 3))
    result.add(newRotateVec_t(- 3, 1, - 2))
  elif rep == "D3":
    result.add(newRotateVec_t(1, 2, 3))
    result.add(newRotateVec_t(- 2, 1, 3))
    result.add(newRotateVec_t(2, - 1, 3))
    result.add(newRotateVec_t(1, 3, - 2))
    result.add(newRotateVec_t(- 1, - 2, 3))
    result.add(newRotateVec_t(1, - 2, - 3))
    result.add(newRotateVec_t(- 1, 2, - 3))
    result.add(newRotateVec_t(- 2, - 1, - 3))
  elif rep == "C4nm0":
    result.add(newRotateVec_t(1, 2, 3))
    result.add(newRotateVec_t(2, 3, 1))
    result.add(newRotateVec_t(3, 1, 2))
    result.add(newRotateVec_t(- 1, 3, 2))
    result.add(newRotateVec_t(3, 2, - 1))
    result.add(newRotateVec_t(2, - 1, 3))
    result.add(newRotateVec_t(- 1, 2, - 3))
    result.add(newRotateVec_t(2, - 3, - 1))
    result.add(newRotateVec_t(- 3, - 1, 2))
    result.add(newRotateVec_t(1, - 3, 2))
    result.add(newRotateVec_t(- 3, 2, 1))
    result.add(newRotateVec_t(2, 1, - 3))
    result.add(newRotateVec_t(- 1, - 2, 3))
    result.add(newRotateVec_t(- 2, 3, - 1))
    result.add(newRotateVec_t(3, - 1, - 2))
    result.add(newRotateVec_t(1, 3, - 2))
    result.add(newRotateVec_t(3, - 2, 1))
    result.add(newRotateVec_t(- 2, 1, 3))
    result.add(newRotateVec_t(1, - 2, - 3))
    result.add(newRotateVec_t(- 2, - 3, 1))
    result.add(newRotateVec_t(- 3, 1, - 2))
    result.add(newRotateVec_t(- 1, - 3, - 2))
    result.add(newRotateVec_t(- 3, - 2, - 1))
    result.add(newRotateVec_t(- 2, - 1, - 3))
  elif rep == "C4nnm":
    result.add(newRotateVec_t(1, 2, 3))
    result.add(newRotateVec_t(2, 3, 1))
    result.add(newRotateVec_t(3, 1, 2))
    result.add(newRotateVec_t(- 2, 1, 3))
    result.add(newRotateVec_t(- 1, 3, 2))
    result.add(newRotateVec_t(2, - 1, 3))
    result.add(newRotateVec_t(1, 3, - 2))
    result.add(newRotateVec_t(3, - 2, 1))
    result.add(newRotateVec_t(3, 2, - 1))
    result.add(newRotateVec_t(2, 1, - 3))
    result.add(newRotateVec_t(1, - 3, 2))
    result.add(newRotateVec_t(- 3, 2, 1))
    result.add(newRotateVec_t(- 1, - 2, 3))
    result.add(newRotateVec_t(- 2, 3, - 1))
    result.add(newRotateVec_t(3, - 1, - 2))
    result.add(newRotateVec_t(- 1, 2, - 3))
    result.add(newRotateVec_t(- 2, - 3, 1))
    result.add(newRotateVec_t(1, - 2, - 3))
    result.add(newRotateVec_t(2, - 3, - 1))
    result.add(newRotateVec_t(- 3, - 1, 2))
    result.add(newRotateVec_t(- 3, 1, - 2))
    result.add(newRotateVec_t(- 2, - 1, - 3))
    result.add(newRotateVec_t(- 1, - 3, - 2))
    result.add(newRotateVec_t(- 3, - 2, - 1))
  else:
    quit(": unsupported LG= " & rep)


#proc isign*(x: int): int =
#  return if (x > 0): + 1 else: - 1

