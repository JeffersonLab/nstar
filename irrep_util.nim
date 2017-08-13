##  Support for manipulating irreps
## 

import lists, complex, serializetools/array1d

## ----------------------------------------------------------------------------------
## Get little group of irrep

proc getIrrepLG*(irrep: string): string
## Get dimension of irrep

proc getIrrepDim*(irrep: string): cint
## Representation including parity if it exists

proc buildIrrepWithParity*(irrep: string; P: cint): string
## Representation including parity and G-parity if it exists

proc buildIrrepWithPG*(irrep: string; P: cint; G: cint): string
## Remove helicity from an irrep name

proc removeHelicity*(irrep: string): string
## Get parity from an irrep name

proc getIrrepParity*(irrep: string): cint
## Remove G-parity from an irrep name

proc removeIrrepGParity*(irrep: string): string
## Get G-parity from an irrep name

proc getIrrepGParity*(irrep: string): cint
## Get Oh/LG irrep name with no parity from possible helicity name

proc getCubicRepNoParity*(irrep: string): string
## Remove LG from irrep name

proc removeIrrepLG*(irrep: string): string
## Irrep names (not including LG) with momentum
## Turns [D4A1, Array(1,0,0)]  ->  100_A1

proc momIrrepName*(irrep: string; mom: seq[cint]): string
## Inverse of momIrrepName. Turn an opList name back into irrep names (including LG) and momentum
## Turns 100_A1 ->  [D4A1, Array(1,0,0)]

proc opListToIrrepMom*(mom_irrep_name: string): tuple[first: string, second: seq[cint]]
## ----------------------------------------------------------------------------------
## Canonically order an array of momenta
## \return abs(mom[0]) >= abs(mom[1]) >= ... >= abs(mom[mu]) >= ... >= 0

proc canonicalOrder*(mom: seq[cint]): seq[cint]
## Decompose a lexicographic site into coordinates

proc crtesn*(ipos: cint; latt_size: seq[cint]): seq[cint]
## ----------------------------------------------------------------------------------
## Generate all momentum up to a maximum

proc generateAllMom*(mom2_min: cint; mom2_max: cint): SinglyLinkedList[seq[cint]]
## Generate canonical momenta up to some maximum value

proc generateCanonMoms*(mom2_min: cint; mom2_max: cint): SinglyLinkedList[seq[cint]]
## The name of the little group corresponding to this momentum

proc generateLittleGroup*(mom: seq[cint]): string
## Generate momentum for a little group from a canonical momentum

proc generateLittleGroupMom*(littleGroup: string; canon_mom: seq[cint]): SinglyLinkedList[
    seq[cint]]
## Find number of posible source 1 and source 2 momentum orientations for fixed target momentum

proc numMomentaCombin*(group1: string; group2: string; mom1: seq[cint];
                      mom2: seq[cint]; momt: seq[cint]): cint
## Find posible source 1 and source 2 momentum orientations for fixed target momentum

proc allowedMomentaCombin*(group1: string; group2: string; mom1: seq[cint];
                          mom2: seq[cint]; momt: seq[cint];
                          allowed_mom1: var SinglyLinkedList[seq[cint]];
                          allowed_mom2: var SinglyLinkedList[seq[cint]]): cint
## Generate a canonical combination of momenta for a given target momentum

proc canonMomCombin*(mom1: seq[cint]; mom2: seq[cint]; momt: seq[cint];
                    canon_mom1: var seq[cint]; canon_mom2: var seq[cint]): cint
## ----------------------------------------------------------------------------------
## Rotation angles for a vector to a canonical direction

type
  CubicCanonicalRotation_t* = object
    alpha*: cdouble
    beta*:  cdouble
    gamma*: cdouble


## Return rotation angles for a vector to a canonical direction

proc cubicCanonicalRotation*(mom: seq[cint]): CubicCanonicalRotation_t
## ----------------------------------------------------------------------------------
## Check group elem is within allowed range

proc checkIndexLimit*(elem: cint; dim: cint)
## ----------------------------------------------------------------------------------
## Conventional reference mom (for CGs) - not the same as canonical mom

proc referenceMom*(mom: seq[cint]): seq[cint]
## ----------------------------------------------------------------------------------
## Scale momentum

proc scaleMom*(mom: seq[cint]): seq[cint]
## ----------------------------------------------------------------------------------
## Unscale momentum

proc unscaleMom*(scaled_mom: seq[cint]; mom: seq[cint]): seq[cint]
## ----------------------------------------------------------------------------------
## Helper function

proc Mom3d*(p1: cint; p2: cint; p3: cint): seq[cint]
## ----------------------------------------------------------------------------------
## Helper functions for automated CGs
type
  RotateVec_t* = object
    p1*: cint
    p2*: cint
    p3*: cint

proc newRotateVec_t*(a: cint; b: cint; c: cint): RotateVec_t =
  discard






## ----------------------------------------------------------------------------------
import
  irreps_cubic, irreps_cubic_helicity

##  Irrep names
type
  IrrepNames_t* = object
    with_par*: string          ## Irrep with parity
    no_par*: string            ## Irrep no parity
    ferm*: bool                ## Is this a double cover?
    lg*: bool                  ## LG?
    dim*: cint                 ## dimension
    G*: cint                   ## G-parity
  

proc newIrrepNames_t*(no_par: string; ferm: bool; lg: bool; dim: cint; g: cint): IrrepNames_t =
  result.with_par = no_par
  result.no_par   = no_par
  result.ferm     = ferm
  result.lg       = lg
  result.dim      = dim
  result.G        = g

proc newIrrepNames_t*(with_par: string; no_par: string; ferm: bool; lg: bool;
                           dim: cint; g: cint): IrrepNames_t =
  result.with_par = with_par
  result.no_par   = no_par
  result.ferm     = ferm
  result.lg       = lg
  result.dim      = dim
  result.G        = g


##  Initialized

proc initIR*(a2: false): bool
##  Irrep names

type
  IRNames_t* = OrderedTable[string, IrrepNames_t]

var irrep_names_no_par*: IRNames_t

var irrep_names_with_par*: IRNames_t

var irrep_names_with_pg*: IRNames_t

## ---------------------------------------------------------------------------
##  Initialize irrep names

proc initIrrepNames*() =
  if initIR:
    return
  irrep_names_no_par.insert(make_pair("D4A1",
                                      IrrepNames_t("D4A1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D4A2",
                                      IrrepNames_t("D4A2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D4E1",
                                      IrrepNames_t("D4E1", true, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D4E2",
                                      IrrepNames_t("D4E2", false, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D4E3",
                                      IrrepNames_t("D4E3", true, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D4B1",
                                      IrrepNames_t("D4B1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D4B2",
                                      IrrepNames_t("D4B2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D3A1",
                                      IrrepNames_t("D3A1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D3A2",
                                      IrrepNames_t("D3A2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D3E1",
                                      IrrepNames_t("D3E1", true, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D3E2",
                                      IrrepNames_t("D3E2", false, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D3B1",
                                      IrrepNames_t("D3B1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D3B2",
                                      IrrepNames_t("D3B2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D2A1",
                                      IrrepNames_t("D2A1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D2A2",
                                      IrrepNames_t("D2A2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D2E",
                                      IrrepNames_t("D2E", true, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("D2B1",
                                      IrrepNames_t("D2B1", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("D2B2",
                                      IrrepNames_t("D2B2", false, true, 1, 0)))
  irrep_names_no_par.insert(make_pair("C4nm0A1", IrrepNames_t("C4nm0A1", false,
      true, 1, 0)))
  irrep_names_no_par.insert(make_pair("C4nm0A2", IrrepNames_t("C4nm0A2", false,
      true, 1, 0)))
  irrep_names_no_par.insert(make_pair("C4nm0E",
                                      IrrepNames_t("C4nm0E", true, true, 2, 0)))
  irrep_names_no_par.insert(make_pair("C4nnmA1", IrrepNames_t("C4nnmA1", false,
      true, 1, 0)))
  irrep_names_no_par.insert(make_pair("C4nnmA2", IrrepNames_t("C4nnmA2", false,
      true, 1, 0)))
  irrep_names_no_par.insert(make_pair("C4nnmE",
                                      IrrepNames_t("C4nnmE", true, true, 2, 0)))
  ##  Oh
  irrep_names_no_par.insert(make_pair("A1",
                                      IrrepNames_t("A1", false, false, 1, 0)))
  irrep_names_no_par.insert(make_pair("A2",
                                      IrrepNames_t("A2", false, false, 1, 0)))
  irrep_names_no_par.insert(make_pair("T1",
                                      IrrepNames_t("T1", false, false, 3, 0)))
  irrep_names_no_par.insert(make_pair("T2",
                                      IrrepNames_t("T2", false, false, 3, 0)))
  irrep_names_no_par.insert(make_pair("E", IrrepNames_t("E", false, false, 2, 0)))
  irrep_names_no_par.insert(make_pair("G1", IrrepNames_t("G1", true, false, 2, 0)))
  irrep_names_no_par.insert(make_pair("G2", IrrepNames_t("G2", true, false, 2, 0)))
  irrep_names_no_par.insert(make_pair("H", IrrepNames_t("H", true, false, 4, 0)))
  ## for(IRNames_t::const_iterator ir = irrep_names_no_par.begin(); ir != irrep_names_no_par.end(); ++ir)
  ir = irrep_names_no_par.begin()
  while ir != irrep_names_no_par.`end`():
    if not ir.second.lg:
      var o: var IrrepNames_t = ir.second
      if ir.second.ferm:
        irrep_names_with_par.insert(make_pair(ir.first + "g",
            IrrepNames_t(ir.first + "g", o.no_par, o.ferm, o.lg, o.dim, o.G)))
        irrep_names_with_par.insert(make_pair(ir.first + "u",
            IrrepNames_t(ir.first + "u", o.no_par, o.ferm, o.lg, o.dim, o.G)))
      else:
        irrep_names_with_par.insert(make_pair(ir.first + "p",
            IrrepNames_t(ir.first + "p", o.no_par, o.ferm, o.lg, o.dim, o.G)))
        irrep_names_with_par.insert(make_pair(ir.first + "m",
            IrrepNames_t(ir.first + "m", o.no_par, o.ferm, o.lg, o.dim, o.G)))
    else:
      irrep_names_with_par.insert(make_pair(ir.first, ir.second))
    inc(ir)
  ##  Loop over G parity of (-1, 0, +1)
  ## for(IRNames_t::const_iterator ir = irrep_names_with_par.begin(); ir != irrep_names_with_par.end(); ++ir)
  ir = irrep_names_with_par.begin()
  while ir != irrep_names_with_par.`end`():
    var o: var IrrepNames_t = ir.second
    if not ir.second.ferm:
      var ig1: cint = - 1
      while ig1 <= 1:
        var g1: string = ""
        if ig1 == - 1:
          g1 = "M"
        elif ig1 == 1:
          g1 = "P"
        irrep_names_with_pg.insert(make_pair(ir.first + g1,
            IrrepNames_t(ir.first + g1, o.no_par, o.ferm, o.lg, o.dim, ig1)))
        inc(ig1)
    inc(ir)
  initIR = true

## ----------------------------------------------------------------------------------
##  Get irrep

proc getIrrepIndex*(irrep: string): IrrepNames_t =
  initIrrepNames()
  ##  First check the ones with parity and G-parity
  ## for(IRNames_t::const_iterator mm = irrep_names_with_pg.begin();
  mm = irrep_names_with_pg.begin()
  while mm != irrep_names_with_pg.`end`():
    if (irrep.size() == mm.first.size()) and
        (irrep.compare(0, mm.first.size(), mm.first) == 0):
      return mm.second
    inc(mm)
  ##  First check the ones with parity
  ## for(IRNames_t::const_iterator mm = irrep_names_with_par.begin();
  mm = irrep_names_with_par.begin()
  while mm != irrep_names_with_par.`end`():
    if (irrep.size() == mm.first.size()) and
        (irrep.compare(0, mm.first.size(), mm.first) == 0):
      return mm.second
    inc(mm)
  ##  Next try the non-parity versions
  mm = irrep_names_no_par.begin()
  while mm != irrep_names_no_par.`end`():
    if (irrep.size() == mm.first.size()) and
        (irrep.compare(0, mm.first.size(), mm.first) == 0):
      return mm.second
    inc(mm)
  cerr shl __func__ shl ": ERROR: cannot extract irrep " shl irrep shl endl
  exit(1)

## ----------------------------------------------------------------------------------
## Remove helicity from an irrep name

proc removeHelicity*(irrep: string): string =
  ##  Remove the helicity label
  if (irrep.substr(0, 3) == "H0D") or (irrep.substr(0, 3) == "H1D") or
      (irrep.substr(0, 3) == "H2D") or (irrep.substr(0, 3) == "H3D") or
      (irrep.substr(0, 3) == "H4D") or (irrep.substr(0, 3) == "H0C") or
      (irrep.substr(0, 3) == "H1C") or (irrep.substr(0, 3) == "H2C") or
      (irrep.substr(0, 3) == "H3C") or (irrep.substr(0, 3) == "H4C"):
    return irrep.substr(2, npos)
  if (irrep.substr(0, 5) == "H1o2D") or (irrep.substr(0, 5) == "H3o2D") or
      (irrep.substr(0, 5) == "H5o2D") or (irrep.substr(0, 5) == "H7o2D") or
      (irrep.substr(0, 5) == "H1o2C") or (irrep.substr(0, 5) == "H3o2C") or
      (irrep.substr(0, 5) == "H5o2C") or (irrep.substr(0, 5) == "H7o2C"):
    return irrep.substr(4, npos)
  return irrep

## ----------------------------------------------------------------------------------
## Remove LG from irrep name

proc removeIrrepLG*(irrep: string): string =
  var rep: string = irrep
  ##  Remove the helicity label
  if (rep.substr(0, 2) == "D4") or (rep.substr(0, 2) == "D2") or
      (rep.substr(0, 2) == "D3") or (rep.substr(0, 2) == "C4") or
      (rep.substr(0, 2) == "C2"):
    return rep.substr(2, npos)
  return rep

## ----------------------------------------------------------------------------------
## Get parity from an irrep name

proc getIrrepParity*(irrep: string): cint =
  var irrep_noG: string = removeIrrepGParity(irrep)
  var test_string: string = irrep_noG.substr(irrep_noG.length() - 1)
  if (test_string == "p") or (test_string == "g"): return 1
  elif (test_string == "m") or (test_string == "u"): return - 1
  else: return 0
  
## ----------------------------------------------------------------------------------
## Remove G-parity from an irrep name

proc removeIrrepGParity*(irrep: string): string =
  var test_string: string = irrep.substr(irrep.length() - 1)
  if (test_string == "P") or (test_string == "M"):
    return irrep.substr(0, irrep.length() - 1)
  else:
    return irrep
  
## ----------------------------------------------------------------------------------
## Get G-parity from an irrep name

proc getIrrepGParity*(irrep: string): cint =
  var test_string: string = irrep.substr(irrep.length() - 1)
  if test_string == "P": return 1
  elif test_string == "M": return - 1
  else: return 0
  
## ----------------------------------------------------------------------------------
## Get little group of irrep

proc getIrrepLG*(long_irrep: string): string =
  var irrep: string = removeHelicity(long_irrep)
  ##  Format of irrep label is D4A1 etc
  var irrepLG: string = ""
  var opLG: string = irrep.substr(0, 2)
  var opLGlong: string = irrep.substr(0, 5)
  if (opLG == "D2") or (opLG == "D3") or (opLG == "D4"): irrepLG = opLG
  elif (opLGlong == "C4nm0") or (opLGlong == "C4nnm"): irrepLG = opLGlong
  else: irrepLG = "Oh"
  return irrepLG

## ----------------------------------------------------------------------------------
## Get dimension of irrep

proc getIrrepDim*(irrep: string): cint =
  var mm: IrrepNames_t = getIrrepIndex(irrep)
  return mm.dim

## ----------------------------------------------------------------------------------
## Get Oh/LG irrep name with no parity from possible helicity name

proc getCubicRepNoParity*(irrep: string): string =
  var mm: IrrepNames_t = getIrrepIndex(removeHelicity(irrep))
  return mm.no_par

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## Representation including parity if it exists

proc buildIrrepWithParity*(irrep: string; P: cint): string =
  var mm: IrrepNames_t = getIrrepIndex(irrep)
  if mm.lg:
    ##  In flight, so no parity
    return mm.no_par
  var rep: string = mm.no_par
  if mm.ferm:
    if P == + 1:
      inc(rep, "g")
    elif P == - 1:
      inc(rep, "u")
  else:
    if P == + 1:
      inc(rep, "p")
    elif P == - 1:
      inc(rep, "m")
  return rep

## Representation including parity and G-parity if it exists

proc buildIrrepWithPG*(irrep: string; P: cint; G: cint): string =
  var rep: string = buildIrrepWithParity(irrep, P)
  var mm: IrrepNames_t = getIrrepIndex(irrep)
  if not mm.ferm:
    ##  Only put in G parity if non-zero
    if G == + 1:
      inc(rep, "P")
    elif G == - 1:
      inc(rep, "M")
  return rep

## ----------------------------------------------------------------------------------

proc generateLittleGroup*(mom: seq[cint]): string =
  var momCan: seq[cint] = canonicalOrder(mom)
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

## ----------------------------------------------------------------------------------
## Canonically order an array of momenta
## \return abs(mom[0]) >= abs(mom[1]) >= ... >= abs(mom[mu]) >= ... >= 0

proc canonicalOrder*(mom: seq[cint]): seq[cint] =
  ##  first step: make all the components positive
  var mom_tmp: seq[cint] = mom
  var mu: cint = 0
  while mu < mom_tmp.size():
    if mom_tmp[mu] < 0:
      mom_tmp[mu] = - mom_tmp[mu]
    inc(mu)
  var mu: cint = 1
  while mu < mom_tmp.size():
    ##  Select the item at the beginning of the unsorted region
    var v: cint = mom_tmp[mu]
    ##  Work backwards, finding where v should go
    var nu: cint = mu
    ##  If this element is less than v, move it up one
    while mom_tmp[nu - 1] < v:
      mom_tmp[nu] = mom_tmp[nu - 1]
      dec(nu)
      if nu < 1: break
    ##  Stopped when mom_tmp[nu-1] >= v, so put v at postion nu
    mom_tmp[nu] = v
    inc(mu)
  return mom_tmp

## Decompose a lexicographic site into coordinates

proc crtesn*(ipos: cint; latt_size: seq[cint]): seq[cint] =
  var coord: seq[cint]
  coord.resize(latt_size.size())
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
  var i: cint = 0
  while i < latt_size.size():
    coord[i] = ipos mod latt_size[i]
    ipos = ipos div latt_size[i]
    inc(i)
  return coord

## Calculates the lexicographic site index from the coordinate of a site
## 
##  Nothing specific about the actual lattice size, can be used for 
##  any kind of latt size 
## 

proc local_site*(coord: seq[cint]; latt_size: seq[cint]): cint =
  var order: cint = 0
  var mmu: cint = latt_size.size() - 1
  while mmu >= 1:
    order = latt_size[mmu - 1] * (coord[mmu] + order)
    dec(mmu)
  inc(order, coord[0])
  return order

## ----------------------------------------------------------------------------------
## Generate all momentum up to a maximum

proc generateAllMom*(mom2_min: cint; mom2_max: cint): SinglyLinkedList[seq[cint]] =
  var dest: SinglyLinkedList[seq[cint]]
  var mom: seq[cint]
  mom.resize(3)
  mom[0] = - mom2_max
  while mom[0] <= mom2_max:
    mom[1] = - mom2_max
    while mom[1] <= mom2_max:
      mom[2] = - mom2_max
      while mom[2] <= mom2_max:
        if (norm2(mom) < mom2_min) or (norm2(mom) > mom2_max):
          continue
        dest.push_back(mom)
        inc(mom[2])
      inc(mom[1])
    inc(mom[0])
  return dest

## ----------------------------------------------------------------------------
##  Generate canonical momenta up to some maximum value

proc generateCanonMoms*(mom2_min: cint; mom2_max: cint): SinglyLinkedList[seq[cint]] =
  var canon_moms: SinglyLinkedList[seq[cint]]
  ##  Loop over all desired canonical momentum
  ##  This loop allows us to have, for example,  p= 100, 200, 300,  which all fall in D4
  var mom: seq[cint]
  mom.resize(3)
  mom[0] = 0
  while mom[0] <= mom2_max:
    mom[1] = 0
    while mom[1] <= mom[0]:
      mom[2] = 0
      while mom[2] <= mom[1]:
        if (norm2(mom) < mom2_min) or (norm2(mom) > mom2_max):
          continue
        canon_moms.push_back(mom)
        inc(mom[2])
      inc(mom[1])
    inc(mom[0])
  return canon_moms

## ----------------------------------------------------------------------------------
## Generate momentum for a little group from a canonical momentum

proc generateLittleGroupMom*(littleGroup0: string; canon_mom0: seq[cint]): SinglyLinkedList[
    seq[cint]] =
  var dest: SinglyLinkedList[seq[cint]]
  var littleGroup: string = getIrrepLG(littleGroup0)
  var canon_mom: seq[cint] = canonicalOrder(canon_mom0)
  var mom2: cint = norm2(canon_mom)
  if generateLittleGroup(canon_mom) != littleGroup:
    cerr shl __func__ shl ": little group name= " shl littleGroup shl
        " inconsistent with canonical mom= " shl canon_mom shl "\x0A"
    exit(1)
  var px: cint = - mom2
  while px <= mom2:
    var py: cint = - mom2
    while py <= mom2:
      var pz: cint = - mom2
      while pz <= mom2:
        ##  Check if valid
        var mom: seq[cint]
        mom.resize(3)
        mom[0] = px
        mom[1] = py
        mom[2] = pz
        if norm2(mom) != mom2:
          continue
        var momCan: seq[cint] = canonicalOrder(mom)
        if momCan != canon_mom:
          continue
        if generateLittleGroup(momCan) != littleGroup:
          continue
        dest.push_back(mom)
        inc(pz)
      inc(py)
    inc(px)
  return dest

## ----------------------------------------------------------------------------------
## Find number of posible source 1 and source 2 momentum orientations for fixed target momentum

proc numMomentaCombin*(group1: string; group2: string; mom1: seq[cint];
                      mom2: seq[cint]; momt: seq[cint]): cint =
  var num: cint = 0
  var mom_list1: SinglyLinkedList[seq[cint]] = generateLittleGroupMom(group1, mom1)
  var mom_list2: SinglyLinkedList[seq[cint]] = generateLittleGroupMom(group2, mom2)
  var iterator1: const_iterator
  var iterator2: const_iterator
  iterator1 = mom_list1.begin()
  while iterator1 != mom_list1.`end`():
    iterator2 = mom_list2.begin()
    while iterator2 != mom_list2.`end`():
      if momt == ((iterator1[]) + (iterator2[])): inc(num)
      inc(iterator2)
    inc(iterator1)
  return num

## ----------------------------------------------------------------------------------
## Find posible source 1 and source 2 momentum orientations for fixed target momentum

proc allowedMomentaCombin*(group1: string; group2: string; mom1: seq[cint];
                          mom2: seq[cint]; momt: seq[cint];
                          allowed_mom1: var SinglyLinkedList[seq[cint]];
                          allowed_mom2: var SinglyLinkedList[seq[cint]]): cint =
  var num: cint = 0
  allowed_mom1.clear()
  allowed_mom2.clear()
  var mom_list1: SinglyLinkedList[seq[cint]] = generateLittleGroupMom(group1, mom1)
  var mom_list2: SinglyLinkedList[seq[cint]] = generateLittleGroupMom(group2, mom2)
  var iterator1: const_iterator
  var iterator2: const_iterator
  iterator1 = mom_list1.begin()
  while iterator1 != mom_list1.`end`():
    iterator2 = mom_list2.begin()
    while iterator2 != mom_list2.`end`():
      if momt == ((iterator1[]) + (iterator2[])):
        inc(num)
        allowed_mom1.push_back(iterator1[])
        allowed_mom2.push_back(iterator2[])
      nil
      inc(iterator2)
    inc(iterator1)
  return num

## ----------------------------------------------------------------------------------
## Generate a canonical combination of momenta for a given target momentum

proc canonMomCombin*(mom1: seq[cint]; mom2: seq[cint]; momt: seq[cint];
                    canon_mom1: var seq[cint]; canon_mom2: var seq[cint]): cint =
  var group1: string = generateLittleGroup(mom1)
  var group2: string = generateLittleGroup(mom2)
  var groupt: string = generateLittleGroup(momt)
  var allowed_mom1: SinglyLinkedList[seq[cint]]
  allowed_mom1.clear()
  var allowed_mom2: SinglyLinkedList[seq[cint]]
  allowed_mom2.clear()
  var normalisation: cint = allowedMomentaCombin(group1, group2, mom1, mom2, momt,
      allowed_mom1, allowed_mom2)
  if normalisation == 0: return normalisation
  if groupt == "Oh":
    canon_mom1 = referenceMom(mom1)
    canon_mom2 = - canon_mom1
  else:
    canon_mom1 = allowed_mom1.front()
    canon_mom2 = allowed_mom2.front()
  return normalisation

## ----------------------------------------------------------------------------------
## Return rotation angles for a seq to a canonical direction

proc cubicCanonicalRotation*(mom: seq[cint]): CubicCanonicalRotation_t =
  var pi: cdouble = 3.14159265359
  ##  Lists of momentum directions
  var momListD2: ptr array[3, cint] = [[1, 1, 0], [0, 1, 1], [1, 0, 1], [1, - 1, 0], [0, 1, - 1],
                                 [- 1, 0, 1], [- 1, 1, 0], [0, - 1, 1], [1, 0, - 1],
                                 [- 1, - 1, 0], [0, - 1, - 1], [- 1, 0, - 1]]
  var dimMomListD2: cint = 12
  var rotAnglesListD2: ptr array[3, cdouble] = [[1.0 div 4.0, 1.0 div 2.0, 0],
      [1.0 div 2.0, 1.0 div 4.0, - (1.0 div 2.0)], [0, 1.0 div 4.0, - (1.0 div 2.0)],
      [- (1.0 div 4.0), 1.0 div 2.0, 0],
      [- (1.0 div 2.0), - (3.0 div 4.0), - (1.0 div 2.0)],
      [- 1.0, 1.0 div 4.0, - (1.0 div 2.0)], [- (1.0 div 4.0), - (1.0 div 2.0), 0],
      [- (1.0 div 2.0), 1.0 div 4.0, - (1.0 div 2.0)], [0, 3.0 div 4.0, - (1.0 div 2.0)],
      [1.0 div 4.0, - (1.0 div 2.0), 0],
      [1.0 div 2.0, - (3.0 div 4.0), - (1.0 div 2.0)],
      [- 1.0, 3.0 div 4.0, - (1.0 div 2.0)]]
  ##  {phi, theta, psi} in units of pi
  var momListD3: ptr array[3, cint] = [[1, 1, 1], [- 1, 1, 1], [1, - 1, 1], [1, 1, - 1],
                                 [- 1, - 1, 1], [1, - 1, - 1], [- 1, 1, - 1], [- 1, - 1, - 1]]
  var dimMomListD3: cint = 8
  var rotAnglesListD3: ptr array[3, cdouble] = [
      [pi div 4.0, acos(1 div sqrt(3.0)), 0.0],
      [(3 * pi) div 4.0, acos(1 div sqrt(3.0)), 0.0],
      [- (pi div 4.0), acos(1 div sqrt(3.0)), 0.0],
      [pi div 4.0, acos(- (1 div sqrt(3.0))), - (pi div 3.0)],
      [(- (3 * pi)) div 4.0, acos(1 div sqrt(3.0)), 0.0],
      [(3 * pi) div 4.0, - acos(- (1 div sqrt(3.0))), 0.0],
      [- (pi div 4.0), - acos(- (1 div sqrt(3.0))), 0.0],
      [pi div 4.0, - acos(- (1 div sqrt(3.0))), 0.0]]
  var momListC4nm0: ptr array[3, cint] = [[0, 1, 2], [1, 2, 0], [2, 0, 1], [0, 2, 1], [2, 1, 0],
                                    [1, 0, 2], [0, 1, - 2], [1, - 2, 0], [- 2, 0, 1],
                                    [0, - 2, 1], [- 2, 1, 0], [1, 0, - 2], [0, - 1, 2],
                                    [- 1, 2, 0], [2, 0, - 1], [0, 2, - 1], [2, - 1, 0],
                                    [- 1, 0, 2], [0, - 1, - 2], [- 1, - 2, 0], [- 2, 0, - 1],
                                    [0, - 2, - 1], [- 2, - 1, 0], [- 1, 0, - 2]]
  var dimMomListC4nm0: cint = 24
  var rotAnglesListC4nm0: ptr array[3, cdouble] = [
      [pi div 2.0, acos(2.0 div sqrt(5.0)), 0.0],
      [- acos(- (1.0 div sqrt(5.0))), - (pi div 2.0), pi div 2.0],
      [- pi, - acos(1.0 div sqrt(5.0)), 0.0],
      [- (pi div 2.0), - acos(1.0 div sqrt(5.0)), 0.0],
      [acos(2.0 div sqrt(5.0)), pi div 2.0, pi div 2.0],
      [0.0, acos(2.0 div sqrt(5.0)), 0.0],
      [- (pi div 2.0), - acos(- (2.0 div sqrt(5.0))), 0.0],
      [- acos(1.0 div sqrt(5.0)), pi div 2.0, pi div 2.0],
      [0.0, - acos(1.0 div sqrt(5.0)), 0.0],
      [pi div 2.0, - acos(1.0 div sqrt(5.0)), 0.0],
      [- acos(2.0 div sqrt(5.0)), - (pi div 2.0), pi div 2.0],
      [- pi, - acos(- (2.0 div sqrt(5.0))), 0.0],
      [- (pi div 2.0), acos(2.0 div sqrt(5.0)), 0.0],
      [acos(- (1.0 div sqrt(5.0))), pi div 2.0, pi div 2.0],
      [0.0, acos(- (1.0 div sqrt(5.0))), 0.0],
      [pi div 2.0, acos(- (1.0 div sqrt(5.0))), 0.0],
      [acos(- (2.0 div sqrt(5.0))), - (pi div 2.0), pi div 2.0],
      [- pi, acos(2.0 div sqrt(5.0)), 0.0],
      [pi div 2.0, - acos(- (2.0 div sqrt(5.0))), 0.0],
      [acos(1.0 div sqrt(5.0)), - (pi div 2.0), pi div 2.0],
      [- pi, acos(- (1.0 div sqrt(5.0))), 0.0],
      [- (pi div 2.0), acos(- (1.0 div sqrt(5.0))), 0.0],
      [- acos(- (2.0 div sqrt(5.0))), pi div 2.0, pi div 2.0],
      [0.0, - acos(- (2.0 div sqrt(5.0))), 0.0]]
  var momListC4nnm: ptr array[3, cint] = [[1, 1, 2], [1, 2, 1], [2, 1, 1], [- 1, 1, 2],
                                    [- 1, 2, 1], [1, - 1, 2], [1, 2, - 1], [2, - 1, 1],
                                    [2, 1, - 1], [1, 1, - 2], [1, - 2, 1], [- 2, 1, 1],
                                    [- 1, - 1, 2], [- 1, 2, - 1], [2, - 1, - 1], [- 1, 1, - 2],
                                    [- 1, - 2, 1], [1, - 1, - 2], [1, - 2, - 1], [- 2, - 1, 1],
                                    [- 2, 1, - 1], [- 1, - 1, - 2], [- 1, - 2, - 1],
                                    [- 2, - 1, - 1]]
  var dimMomListC4nnm: cint = 24
  var rotAnglesListC4nnm: ptr array[3, cdouble] = [
      [(- (3.0 * pi)) div 4.0, - acos(sqrt(2.0 div 3.0)), 0.0], [
      - acos(- (1.0 div sqrt(5.0))), - acos(1.0 div sqrt(6.0)),
      pi div 2.0 + acos(- sqrt(3.0 div 5.0))], [acos(2.0 div sqrt(5.0)),
                                        acos(1.0 div sqrt(6.0)),
                                        pi div 2.0 - acos(- sqrt(3.0 div 5.0))],
      [- (pi div 4.0), - acos(sqrt(2.0 div 3.0)), 0.0], [acos(- (1.0 div sqrt(5.0))),
      acos(1.0 div sqrt(6.0)), pi div 2.0 - acos(- sqrt(3.0 div 5.0))],
      [(3.0 * pi) div 4.0, - acos(sqrt(2.0 div 3.0)), 0.0], [
      - acos(- (1.0 div sqrt(5.0))), - acos(- (1.0 div sqrt(6.0))),
      pi div 2.0 - acos(- sqrt(3.0 div 5.0))], [acos(- (2.0 div sqrt(5.0))),
                                        - acos(1.0 div sqrt(6.0)),
                                        pi div 2.0 + acos(- sqrt(3.0 div 5.0))], [
      acos(2.0 div sqrt(5.0)), acos(- (1.0 div sqrt(6.0))),
      pi div 2.0 + acos(- sqrt(3.0 div 5.0))],
      [pi div 4.0, acos(- sqrt(2.0 div 3.0)), 0.0], [- acos(1.0 div sqrt(5.0)),
      acos(1.0 div sqrt(6.0)), pi div 2.0 - acos(- sqrt(3.0 div 5.0))], [
      - acos(2.0 div sqrt(5.0)), - acos(1.0 div sqrt(6.0)),
      pi div 2.0 + acos(- sqrt(3.0 div 5.0))],
      [pi div 4.0, - acos(sqrt(2.0 div 3.0)), 0.0], [acos(- (1.0 div sqrt(5.0))),
      acos(- (1.0 div sqrt(6.0))), pi div 2.0 + acos(- sqrt(3.0 div 5.0))], [
      acos(- (2.0 div sqrt(5.0))), - acos(- (1.0 div sqrt(6.0))),
      pi div 2.0 - acos(- sqrt(3.0 div 5.0))],
      [(3.0 * pi) div 4.0, acos(- sqrt(2.0 div 3.0)), 0.0], [acos(1.0 div sqrt(5.0)),
      - acos(1.0 div sqrt(6.0)), pi div 2.0 + acos(- sqrt(3.0 div 5.0))],
      [- (pi div 4.0), acos(- sqrt(2.0 div 3.0)), 0.0], [- acos(1.0 div sqrt(5.0)),
      acos(- (1.0 div sqrt(6.0))), pi div 2.0 + acos(- sqrt(3.0 div 5.0))], [
      - acos(- (2.0 div sqrt(5.0))), acos(1.0 div sqrt(6.0)),
      pi div 2.0 - acos(- sqrt(3.0 div 5.0))], [- acos(2.0 div sqrt(5.0)),
                                        - acos(- (1.0 div sqrt(6.0))),
                                        pi div 2.0 - acos(- sqrt(3.0 div 5.0))],
      [(- (3.0 * pi)) div 4.0, acos(- sqrt(2.0 div 3.0)), 0.0], [acos(1.0 div sqrt(5.0)),
      - acos(- (1.0 div sqrt(6.0))), pi div 2.0 - acos(- sqrt(3.0 div 5.0))], [
      - acos(- (2.0 div sqrt(5.0))), acos(- (1.0 div sqrt(6.0))),
      pi div 2.0 + acos(- sqrt(3.0 div 5.0))]]
  var momListC4nnm113: ptr array[3, cint] = [[1, 1, 3], [1, 3, 1], [3, 1, 1], [- 1, 1, 3],
                                       [- 1, 3, 1], [1, - 1, 3], [1, 3, - 1], [3, - 1, 1],
                                       [3, 1, - 1], [1, 1, - 3], [1, - 3, 1], [- 3, 1, 1],
                                       [- 1, - 1, 3], [- 1, 3, - 1], [3, - 1, - 1],
                                       [- 1, 1, - 3], [- 1, - 3, 1], [1, - 1, - 3],
                                       [1, - 3, - 1], [- 3, - 1, 1], [- 3, 1, - 1],
                                       [- 1, - 1, - 3], [- 1, - 3, - 1], [- 3, - 1, - 1]]
  var rotAnglesListC4nnm113: ptr array[3, cdouble] = [
      [(- (3 * pi)) div 4.0, - atan(sqrt(2) div 3.0), 0],
      [atan(3), atan(sqrt(10)), atan(sqrt(11) div 3.0)],
      [atan(1.0 div 3.0), atan(sqrt(10)), - atan(sqrt(11) div 3.0)],
      [- (pi div 4.0), - atan(sqrt(2) div 3.0), 0],
      [- atan(3), - atan(sqrt(10)), pi - atan(sqrt(11) div 3.0)],
      [- (pi div 4.0), atan(sqrt(2) div 3.0), pi],
      [atan(3), pi - atan(sqrt(10)), pi - atan(sqrt(11) div 3.0)],
      [- atan(1.0 div 3.0), atan(sqrt(10)), atan(sqrt(11) div 3.0)],
      [atan(1.0 div 3.0), pi - atan(sqrt(10)), - pi + atan(sqrt(11) div 3.0)],
      [(- (3 * pi)) div 4.0, - pi + atan(sqrt(2) div 3.0), pi],
      [- atan(3), atan(sqrt(10)), - atan(sqrt(11) div 3.0)],
      [- atan(1.0 div 3.0), - atan(sqrt(10)), - pi + atan(sqrt(11) div 3.0)],
      [(- (3 * pi)) div 4.0, atan(sqrt(2) div 3.0), pi],
      [- atan(3), - pi + atan(sqrt(10)), atan(sqrt(11) div 3.0)],
      [- atan(1.0 div 3.0), pi - atan(sqrt(10)), pi - atan(sqrt(11) div 3.0)],
      [- (pi div 4.0), - pi + atan(sqrt(2) div 3.0), pi],
      [atan(3), - atan(sqrt(10)), - pi + atan(sqrt(11) div 3.0)],
      [- (pi div 4.0), pi - atan(sqrt(2) div 3.0), 0],
      [- atan(3), pi - atan(sqrt(10)), - pi + atan(sqrt(11) div 3.0)],
      [atan(1.0 div 3.0), - atan(sqrt(10)), pi - atan(sqrt(11) div 3.0)],
      [- atan(1.0 div 3.0), - pi + atan(sqrt(10)), - atan(sqrt(11) div 3.0)],
      [(- (3 * pi)) div 4.0, pi - atan(sqrt(2) div 3.0), 0],
      [atan(3), - pi + atan(sqrt(10)), - atan(sqrt(11) div 3.0)],
      [atan(1.0 div 3.0), - pi + atan(sqrt(10)), atan(sqrt(11) div 3.0)]]
  var momMag: cdouble = sqrt(pow(double(mom[0]), 2) + pow(double(mom[1]), 2) +
      pow(double(mom[2]), 2))
  var alpha: cdouble = 0.0
  var beta: cdouble = 0.0
  var gamma: cdouble = 0.0
  var littleGroup: string = generateLittleGroup(mom)
  if littleGroup == "D4":
    alpha = atan2(double(mom[1]), double(mom[0]))
    beta = acos(double(mom[2]) div momMag)
    gamma = 0.0
  elif littleGroup == "D2":
    var momIndex: cint = - 1
    var i: cint = 0
    while i < dimMomListD2:
      if (momListD2[i][0] == int(double(mom[0]) * sqrt(2.0) div momMag)) and
          (momListD2[i][1] == int(double(mom[1]) * sqrt(2.0) div momMag)) and
          (momListD2[i][2] == int(double(mom[2]) * sqrt(2.0) div momMag)):
        alpha = rotAnglesListD2[i][0] * pi
        beta = rotAnglesListD2[i][1] * pi
        gamma = rotAnglesListD2[i][2] * pi
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      cerr shl __func__ shl ": ERROR: can\'t find match for LG= " shl littleGroup shl
          "  and momentum " shl mom[0] shl " " shl mom[1] shl " " shl mom[2] shl "\x0A"
      exit(1)
  elif littleGroup == "D3":
    var momIndex: cint = - 1
    var i: cint = 0
    while i < dimMomListD3:
      if (momListD3[i][0] == int(double(mom[0]) * sqrt(3.0) div momMag)) and
          (momListD3[i][1] == int(double(mom[1]) * sqrt(3.0) div momMag)) and
          (momListD3[i][2] == int(double(mom[2]) * sqrt(3.0) div momMag)):
        ## 		std::cout << __func__ << ": momentum direction " << momListD3[i][0] << momListD3[i][1] << momListD3[i][2] << "\n";
        alpha = rotAnglesListD3[i][0]
        beta = rotAnglesListD3[i][1]
        gamma = rotAnglesListD3[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      cerr shl __func__ shl ": ERROR: can\'t find match for LG= " shl littleGroup shl
          "  and momentum " shl mom[0] shl " " shl mom[1] shl " " shl mom[2] shl "\x0A"
      exit(1)
  elif littleGroup == "C4nm0":
    var momIndex: cint = - 1
    var i: cint = 0
    while i < dimMomListC4nm0:
      if (momListC4nm0[i][0] == int(double(mom[0]) * sqrt(5.0) div momMag)) and
          (momListC4nm0[i][1] == int(double(mom[1]) * sqrt(5.0) div momMag)) and
          (momListC4nm0[i][2] == int(double(mom[2]) * sqrt(5.0) div momMag)):
        ## 		std::cout << __func__ << ": momentum direction " << momListC4nm0[i][0] << momListC4nm0[i][1] << momListC4nm0[i][2] << "\n";
        alpha = rotAnglesListC4nm0[i][0]
        beta = rotAnglesListC4nm0[i][1]
        gamma = rotAnglesListC4nm0[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      cerr shl __func__ shl ": ERROR: can\'t find match for LG= " shl littleGroup shl
          "  and momentum " shl mom[0] shl " " shl mom[1] shl " " shl mom[2] shl "\x0A"
      exit(1)
  elif littleGroup == "C4nnm":
    var momIndex: cint = - 1
    var i: cint = 0
    while i < dimMomListC4nnm:
      if (momListC4nnm[i][0] == int(double(mom[0]) * sqrt(6.0) div momMag)) and
          (momListC4nnm[i][1] == int(double(mom[1]) * sqrt(6.0) div momMag)) and
          (momListC4nnm[i][2] == int(double(mom[2]) * sqrt(6.0) div momMag)):
        ## std::cout << __func__ << ": momentum direction " << momListC4nnm[i][0] << momListC4nnm[i][1] << momListC4nnm[i][2] << "\n";
        alpha = rotAnglesListC4nnm[i][0]
        beta = rotAnglesListC4nnm[i][1]
        gamma = rotAnglesListC4nnm[i][2]
        momIndex = i
        break
      elif (momListC4nnm113[i][0] == int(double(mom[0]) * sqrt(11.0) div momMag)) and
          (momListC4nnm113[i][1] == int(double(mom[1]) * sqrt(11.0) div momMag)) and
          (momListC4nnm113[i][2] == int(double(mom[2]) * sqrt(11.0) div momMag)): ##  Momenta proportional to 113 etc
        ## std::cout << __func__ << ": momentum direction " << momListC4nnm113[i][0] << momListC4nnm113[i][1] << momListC4nnm113[i][2] << "\n";
        alpha = rotAnglesListC4nnm113[i][0]
        beta = rotAnglesListC4nnm113[i][1]
        gamma = rotAnglesListC4nnm113[i][2]
        momIndex = i
        break
      inc(i)
    if momIndex < 0:
      cerr shl __func__ shl ": ERROR: can\'t find match for LG= " shl littleGroup shl
          "  and momentum " shl mom[0] shl " " shl mom[1] shl " " shl mom[2] shl "\x0A"
      exit(1)
  else:
    cerr shl __func__ shl ": ERROR: unsupported momentum " shl mom[0] shl " " shl
        mom[1] shl " " shl mom[2] shl "\x0A"
    exit(1)
  ##     std::cout << "alpha= " << alpha << ", beta= " << beta << ", gamma= " << gamma << "\n";
  var rot: CubicCanonicalRotation_t
  rot.alpha = alpha
  rot.beta = beta
  rot.gamma = gamma
  return rot

## ----------------------------------------------------------------------------
##  Build a short version of momentum

proc shortMom*(mom: seq[cint]): string =
  var os: ostringstream
  os shl mom[0] shl mom[1] shl mom[2]
  return os.str()

## ----------------------------------------------------------------------------
## Irrep names (not including LG) with momentum used for opLists
## Turns [D4A1, Array(1,0,0)]  ->  100_A1

proc momIrrepName*(irrep: string; mom: seq[cint]): string =
  var f: string = shortMom(mom) + "_" + removeIrrepLG(irrep)
  return f

## ----------------------------------------------------------------------------
## Inverse of momIrrepName. Turn an opList name back into irrep names (including LG) and momentum
## Turns 100_A1 ->  [D4A1, Array(1,0,0)]

proc opListToIrrepMom*(mom_irrep_name: string): pair[string, seq[cint]] =
  var mom_str: string = mom_irrep_name.substr(0, 3)
  var rep: string = mom_irrep_name.substr(4, npos)
  var mom: seq[cint]
  mom.resize(3)
  mom[0] = stoi(mom_str.substr(0, 1))
  mom[1] = stoi(mom_str.substr(1, 1))
  mom[2] = stoi(mom_str.substr(2, 1))
  var lg: string = generateLittleGroup(mom)
  var f: string
  if lg == "Oh":
    f = removeIrrepLG(rep)
  else:
    f = lg + removeIrrepLG(rep)
  return make_pair(f, mom)

## ----------------------------------------------------------------------------------
##  Check group elem is within allowed range

proc checkIndexLimit*(el: cint; dd: cint) =
  if (el < 1) or (el > dd):
    cerr shl __func__ shl ": ERROR: index= " shl el shl
        " is outside range of 1-based elements, dimension= " shl dd shl "\x0A"
    exit(1)

## ----------------------------------------------------------------------------------
## Conventional reference mom (for CGs) - not the same as canonical mom

proc referenceMom*(mom: seq[cint]): seq[cint] =
  var group: string = generateLittleGroup(mom)
  var momCan: seq[cint] = canonicalOrder(mom)
  var momRef: seq[cint] = Mom3d(0, 0, 0)
  if group == "Oh":
    momRef = mom
  elif group == "D4":            ##  n00 -> 00n
    var n: cint = momCan[0]
    momRef = Mom3d(0, 0, n)
  elif group == "D2":            ##  nn0 -> 0nn
    var n: cint = momCan[0]
    momRef = Mom3d(0, n, n)
  elif group == "D3":            ##  nnn -> nnn
    momRef = momCan
  elif group == "C4nm0":         ##  nm0 -> 0mn
    var n: cint = momCan[0]
    var m: cint = momCan[1]
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
    cerr shl __func__ shl ": ERROR: unknown group= " shl group shl " for mom= " shl
        mom shl "\x0A"
    exit(1)
  return momRef

## ----------------------------------------------------------------------------------
## Scale momentum to get to form 100, 110, 111, 210, 221 or 321

proc scaleMom*(mom: seq[cint]): seq[cint] =
  var group: string = generateLittleGroup(mom)
  var momCan: seq[cint] = canonicalOrder(mom)
  var scaled_mom: seq[cint] = Mom3d(0, 0, 0)
  if group == "Oh":
    scaled_mom = mom
  elif (group == "D4") or (group == "D3") or (group == "D2"): ##  n00,nn0,nnn -> 100,110,111
    var n: cint = momCan[0]
    scaled_mom = mom div n
  elif group == "C4nm0":         ##  nm0 -> 210
    var n: cint = momCan[0]
    var m: cint = momCan[1]
    var i: cint = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 2 * mom[i] div n
      elif abs(mom[i]) == m:
        scaled_mom[i] = 1 * mom[i] div m
      elif mom[i] == 0:
        scaled_mom[i] = 0
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
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
    var i: cint = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 2 * mom[i] div n
      elif abs(mom[i]) == m:
        scaled_mom[i] = 1 * mom[i] div m
      elif mom[i] == 0:
        scaled_mom[i] = 0
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
      inc(i)
  elif group == "C2":            ##  nmp -> 321
    var n: cint = momCan[0]
    var m: cint = momCan[1]
    var p: cint = momCan[2]
    var i: cint = 0
    while i < 3:
      if abs(mom[i]) == n:
        scaled_mom[i] = 3 * mom[i] div n
      elif abs(mom[i]) == m:
        scaled_mom[i] = 2 * mom[i] div m
      elif abs(mom[i]) == p:
        scaled_mom[i] = 1 * mom[i] div p
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
      inc(i)
  else:
    cerr shl __func__ shl ": ERROR: unknown group= " shl group shl " for mom= " shl
        mom shl "\x0A"
    exit(1)
  return scaled_mom

## ----------------------------------------------------------------------------------
## Unscale momentum from form 100, 110, 111, 210, 221 or 321

proc unscaleMom*(scaled_mom: seq[cint]; mom: seq[cint]): seq[cint] =
  var group: string = generateLittleGroup(mom)
  if group != generateLittleGroup(scaled_mom):
    cerr shl __func__ shl ": ERROR: scaled_mom= " shl scaled_mom shl
        " is not consistent with mom= " shl mom shl "\x0A"
    exit(1)
  var momCan: seq[cint] = canonicalOrder(mom)
  var unscaled_mom: seq[cint] = Mom3d(0, 0, 0)
  if group == "Oh":
    unscaled_mom = mom
  elif (group == "D4") or (group == "D3") or (group == "D2"): ##  100,110,111 -> n00,nn0,nnn
    var n: cint = momCan[0]
    unscaled_mom = scaled_mom * n
  elif group == "C4nm0":         ##  210 -> nm0
    var n: cint = momCan[0]
    var m: cint = momCan[1]
    var i: cint = 0
    while i < 3:
      if abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = n * scaled_mom[i] div 2
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = m * scaled_mom[i] div 1
      elif scaled_mom[i] == 0:
        unscaled_mom[i] = 0
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
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
    var i: cint = 0
    while i < 3:
      if abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = n * scaled_mom[i] div 2
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = m * scaled_mom[i] div 1
      elif scaled_mom[i] == 0:
        unscaled_mom[i] = 0
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
      inc(i)
  elif group == "C2":            ##  nmp -> 321
    var n: cint = momCan[0]
    var m: cint = momCan[1]
    var p: cint = momCan[2]
    var i: cint = 0
    while i < 3:
      if abs(scaled_mom[i]) == 3:
        unscaled_mom[i] = n * scaled_mom[i] div 3
      elif abs(scaled_mom[i]) == 2:
        unscaled_mom[i] = m * scaled_mom[i] div 2
      elif abs(scaled_mom[i]) == 1:
        unscaled_mom[i] = p * scaled_mom[i] div 1
      else:
        cerr shl __func__ shl
            ": ERROR: shouldn\'t reach here - something is broken" shl "\x0A"
        exit(1)
      inc(i)
  else:
    cerr shl __func__ shl ": ERROR: unknown group= " shl group shl " for mom= " shl
        mom shl "\x0A"
    exit(1)
  return unscaled_mom

## ----------------------------------------------------------------------------------
##  Helper function

proc Mom3d*(p1: cint; p2: cint; p3: cint): seq[cint] =
  var d = newSeq[cint](3)
  d[0] = p1
  d[1] = p2
  d[2] = p3
  return d

## ----------------------------------------------------------------------------------
##  Shortcut

##  Helper functions for automated CGs
proc isZeroArray*(a: Array1dO[Complex]): bool =
  var i: cint = 1
  while i <= a.size():
    if real(a[i]) != 0.0 or imag(a[i]) != 0.0: return false
    inc(i)
  return true

proc modsqArray*(a: Array1dO[Complex]): Complex =
  var modsq: Complex = 0.0
  var i: cint = 1
  while i <= a.size():
    inc(modsq, real(a[i]) * real(a[i]))
    inc(modsq, imag(a[i]) * imag(a[i]))
    inc(i)
  return modsq

proc dotArrays*(a1: Array1dO[Complex]; a2: Array1dO[Complex]): Complex =
  var result: Complex = 0.0
  if a1.size() != a2.size():
    quit("ERROR: arrays have different sizes")
  var i: cint = 1
  while i <= a1.size():
    inc(result, conj(a1[i]) * a2[i])
    inc(i)
  return result


proc generateLGRotation*(rep: string): seq[RotateVec_t] =
  ## Return the rotations for a LG
  var rot: seq[RotateVec_t]
  if rep == "D4":
    rot.push_back(RotateVec_t(3, 2, - 1))
    rot.push_back(RotateVec_t(- 2, 3, - 1))
    rot.push_back(RotateVec_t(1, 2, 3))
    rot.push_back(RotateVec_t(- 3, - 2, - 1))
    rot.push_back(RotateVec_t(2, - 3, - 1))
    rot.push_back(RotateVec_t(- 1, 2, - 3))
  elif rep == "D2":
    rot.push_back(RotateVec_t(3, 2, - 1))
    rot.push_back(RotateVec_t(1, 2, 3))
    rot.push_back(RotateVec_t(2, - 1, 3))
    rot.push_back(RotateVec_t(2, - 3, - 1))
    rot.push_back(RotateVec_t(- 1, 2, - 3))
    rot.push_back(RotateVec_t(- 2, 1, 3))
    rot.push_back(RotateVec_t(- 3, 2, 1))
    rot.push_back(RotateVec_t(- 1, - 2, 3))
    rot.push_back(RotateVec_t(3, - 1, - 2))
    rot.push_back(RotateVec_t(- 2, - 3, 1))
    rot.push_back(RotateVec_t(1, - 2, - 3))
    rot.push_back(RotateVec_t(- 3, 1, - 2))
  elif rep == "D3":
    rot.push_back(RotateVec_t(1, 2, 3))
    rot.push_back(RotateVec_t(- 2, 1, 3))
    rot.push_back(RotateVec_t(2, - 1, 3))
    rot.push_back(RotateVec_t(1, 3, - 2))
    rot.push_back(RotateVec_t(- 1, - 2, 3))
    rot.push_back(RotateVec_t(1, - 2, - 3))
    rot.push_back(RotateVec_t(- 1, 2, - 3))
    rot.push_back(RotateVec_t(- 2, - 1, - 3))
  elif rep == "C4nm0":
    rot.push_back(RotateVec_t(1, 2, 3))
    rot.push_back(RotateVec_t(2, 3, 1))
    rot.push_back(RotateVec_t(3, 1, 2))
    rot.push_back(RotateVec_t(- 1, 3, 2))
    rot.push_back(RotateVec_t(3, 2, - 1))
    rot.push_back(RotateVec_t(2, - 1, 3))
    rot.push_back(RotateVec_t(- 1, 2, - 3))
    rot.push_back(RotateVec_t(2, - 3, - 1))
    rot.push_back(RotateVec_t(- 3, - 1, 2))
    rot.push_back(RotateVec_t(1, - 3, 2))
    rot.push_back(RotateVec_t(- 3, 2, 1))
    rot.push_back(RotateVec_t(2, 1, - 3))
    rot.push_back(RotateVec_t(- 1, - 2, 3))
    rot.push_back(RotateVec_t(- 2, 3, - 1))
    rot.push_back(RotateVec_t(3, - 1, - 2))
    rot.push_back(RotateVec_t(1, 3, - 2))
    rot.push_back(RotateVec_t(3, - 2, 1))
    rot.push_back(RotateVec_t(- 2, 1, 3))
    rot.push_back(RotateVec_t(1, - 2, - 3))
    rot.push_back(RotateVec_t(- 2, - 3, 1))
    rot.push_back(RotateVec_t(- 3, 1, - 2))
    rot.push_back(RotateVec_t(- 1, - 3, - 2))
    rot.push_back(RotateVec_t(- 3, - 2, - 1))
    rot.push_back(RotateVec_t(- 2, - 1, - 3))
  elif rep == "C4nnm":
    rot.push_back(RotateVec_t(1, 2, 3))
    rot.push_back(RotateVec_t(2, 3, 1))
    rot.push_back(RotateVec_t(3, 1, 2))
    rot.push_back(RotateVec_t(- 2, 1, 3))
    rot.push_back(RotateVec_t(- 1, 3, 2))
    rot.push_back(RotateVec_t(2, - 1, 3))
    rot.push_back(RotateVec_t(1, 3, - 2))
    rot.push_back(RotateVec_t(3, - 2, 1))
    rot.push_back(RotateVec_t(3, 2, - 1))
    rot.push_back(RotateVec_t(2, 1, - 3))
    rot.push_back(RotateVec_t(1, - 3, 2))
    rot.push_back(RotateVec_t(- 3, 2, 1))
    rot.push_back(RotateVec_t(- 1, - 2, 3))
    rot.push_back(RotateVec_t(- 2, 3, - 1))
    rot.push_back(RotateVec_t(3, - 1, - 2))
    rot.push_back(RotateVec_t(- 1, 2, - 3))
    rot.push_back(RotateVec_t(- 2, - 3, 1))
    rot.push_back(RotateVec_t(1, - 2, - 3))
    rot.push_back(RotateVec_t(2, - 3, - 1))
    rot.push_back(RotateVec_t(- 3, - 1, 2))
    rot.push_back(RotateVec_t(- 3, 1, - 2))
    rot.push_back(RotateVec_t(- 2, - 1, - 3))
    rot.push_back(RotateVec_t(- 1, - 3, - 2))
    rot.push_back(RotateVec_t(- 3, - 2, - 1))
  else:
    cerr shl __func__ shl ": unsupported LG= " shl rep shl "\x0A"
    exit(1)
  return rot

proc isign*(x: cint): cint =
  return if (x > 0): + 1 else: - 1

