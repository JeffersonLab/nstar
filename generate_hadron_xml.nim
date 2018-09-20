## ---------------------------------------------------------------------------

proc iabs*(x: cint): cint =
  return if (x < 0): -x else: x

## ----------------------------------------------------------------------------
## ! Print a P/M

proc printPM*(p: cint): string =
  if p == -1: return "M"
  elif p == +1: return "P"
  return ""

## ----------------------------------------------------------------------------
## ! Number of flavor embeddings

proc numFlavorEmbed*(left_cont_op: string; right_cont_op: string; target_F: string): cint =
  var left: HadronContOpRegInfo_t = findContOp(left_cont_op)
  var right: HadronContOpRegInfo_t = findContOp(right_cont_op)
  ##  Check if the flavor combinations are allowed
  if left.N == 2:
    ##  SU(2)
    var target_twoI: cint = convertFlavToIrrep(target_F)
    var low: cint = iabs(left.twoI - right.twoI)
    var high: cint = iabs(left.twoI + right.twoI)
    return if ((target_twoI >= low) and (target_twoI <= high)): 1 else: 0
  elif left.N == 3:
    ##  SU(3)
    return numEmbed(left.F, right.F, target_F)
  else:
    cerr shl __func__ shl ": oops, invalid SU(N): N= " shl left.N shl endl
    exit(1)
  return 0

## ----------------------------------------------------------------------------
## ! Check G-parity

proc checkGParity*(left_cont_op: string; right_cont_op: string; target_G_parity: cint): bool =
  var result: bool = false
  ##  Check if the G-parity combination are allowed
  var left: HadronContOpRegInfo_t = findContOp(left_cont_op)
  var right: HadronContOpRegInfo_t = findContOp(right_cont_op)
  ##  If no G-parity then just bolt
  if target_G_parity == 0:
    return true
  if (left.G != 0) and (right.G != 0) and (target_G_parity != 0):
    if (left.G * right.G) == target_G_parity:
      return true
  if (left.G * right.G) == 0:
    if (left.G == 0) and (right.G == 0):
      if ((left.threeY + right.threeY) == 0) and ((left.c + right.c) == 0) and
          ((left.B + right.B) == 0):
        if target_G_parity != 0:
          return true
  if (left.G != 0) and (right.G != 0) and (target_G_parity == 0):
    if (left.G * right.G) == target_G_parity:
      return true
  return result

## ----------------------------------------------------------------------------
## ! Check C, B & S

proc checkCBS*(left: HadronContOpRegInfo_t; right: HadronContOpRegInfo_t;
              target_S: cint; target_c: cint; target_B: cint): bool =
  var ret: bool = true
  var target_3S: cint = 3 * target_S
  var left_3S: cint = left.threeY - 3 * left.B
  var right_3S: cint = right.threeY - 3 * right.B
  if 0:
    cout shl __func__ shl ": left_3S= " shl left_3S shl " right_3S= " shl right_3S shl
        " target_3S= " shl target_3S shl endl
    cout shl __func__ shl ": left_c= " shl left.c shl " right_c= " shl right.c shl
        " target_c= " shl target_c shl endl
    cout shl __func__ shl ": left_B= " shl left.B shl " right_B= " shl right.B shl
        " target_B= " shl target_B shl endl
  ret = ret and if (left_3S + right_3S == target_3S): true else: false
  ret = ret and if (left.c + right.c == target_c): true else: false
  ret = ret and if (left.B + right.B == target_B): true else: false
  return ret

## ----------------------------------------------------------------------------
## ! Check continuum op flavor

proc checkFlavor*(left: HadronContOpRegInfo_t; right: HadronContOpRegInfo_t;
                 target_F: string): bool =
  var dest: bool = false
  ##  Check if the flavor combinations are allowed
  if left.N != right.N:
    return false
  if left.N == 2:
    ##  SU(2)
    var target_twoI: cint = convertFlavToIrrep(target_F)
    var low: cint = iabs(left.twoI - right.twoI)
    var high: cint = iabs(left.twoI + right.twoI)
    ## cout << __func__ << ": target_F= " <<  target_F << "  twoI= " << target_twoI << "  low= " << low << "  high= " << high << endl;
    ##  First of all, must be in allowed range
    var okay: bool = ((target_twoI >= low) and (target_twoI <= high))
    if not okay:
      return false
    var bits: cint = low and 1
    return (target_twoI and 1) == (low and 1)
  elif left.N == 3:
    ##  SU(3)
    ##  Check embeddings
    return if (numEmbed(left.F, right.F, target_F) > 0): true else: false
  else:
    cerr shl __func__ shl ": unsupported value of N = " shl left.N shl endl
    exit(1)
  return dest

## ----------------------------------------------------------------------------
## ! Return a subduced op

proc findSubducedOpReg*(subd_id: string): HadronOpsRegInfo_t =
  var `ptr`: string = TheHadronOpsRegInfoFactory.Instance().find(subd_id)
  if `ptr` == TheHadronOpsRegInfoFactory.Instance().`end`():
    cerr shl __func__ shl ": subduced op not registered = " shl subd_id
    exit(1)
  return `ptr`.second

## ----------------------------------------------------------------------------
## ! Return the subduced ops of a continuum op

proc findSubducedOps*(cont_id: string): vector[string] =
  var `ptr`: string = ContHadronOpEnv.TheHadronContOpSubducedOpFactory.Instance().find(
      cont_id)
  if `ptr` ==
      ContHadronOpEnv.TheHadronContOpSubducedOpFactory.Instance().`end`():
    cerr shl __func__ shl ": subduced op not registered = " shl cont_id
    exit(1)
  var subd_ops: vector[string]
  op = `ptr`.second.begin()
  while op != `ptr`.second.`end`():
    subd_ops.push_back(op.first)
    inc(op)
  return subd_ops

## ----------------------------------------------------------------------------
## ! Build a map of operators for a list of momenta

proc buildOpMomMap*(subd_ops: vector[string]; moms: list[Array[cint]]): map[
    Array[cint], vector[string]] =
  var target: map[Array[cint], vector[string]]
  mom = moms.begin()
  while mom != moms.`end`():
    var canon_mom: Array[cint] = canonicalOrder(mom[])
    var LG: string = generateLittleGroup(canon_mom)
    subd_op = subd_ops.begin()
    while subd_op != subd_ops.`end`():
      var subd_reg: HadronOpsRegInfo_t = findSubducedOpReg(subd_op[])
      if getIrrepLG(subd_reg.irrepPG) == LG:
        ##  If a projected op, then mom must match
        var `ptr`: string = Instance().find(subd_op[])
        if `ptr` != Instance().`end`():
          if `ptr`.second.mom_type != canon_mom:
            continue
        target[mom[]].push_back(subd_op[])
      inc(subd_op)
    inc(mom)
  return target

## ----------------------------------------------------------------------------
## ----------------------------------------------------------------------------
## ! Check continuum op flavor

proc checkContOp*(left_cont_op: string; right_cont_op: string; target_F: string): bool =
  ##  Check if the flavor combinations are allowed
  var left: string = findContOp(left_cont_op)
  var right: string = findContOp(right_cont_op)
  return checkFlavor(left, right, target_F)







## ----------------------------------------------------------------------------
## ----------------------------------------------------------------------------
## ! Generate all allowed two-body ops

proc generateTwoHadronOps*(left_cont_op: fred; right_cont_op: fred; target_F: string;
                          target_G_parity: cint; mom2_max: cint;
                          target_moms: list[vector[cint]]): pair[map[vector[cint],
    map[string, MapObject[KeyHadronSUNNPartIrrepOp_t, cint]]], map[string, string]] =
  ##  Target map
  ##   [target_mom -> [irrep -> [op,int]]]
  var targets: map[vector[cint],
                 map[string, MapObject[KeyHadronSUNNPartIrrepOp_t, cint]]]
  ##  Subduced ops and their continuum parent
  ##  [subd_op -> cont_op]
  var subduced_ops: map[string, string]
  ##  First check if the flavor combinations are allowed
  if not checkContOp(left_cont_op, right_cont_op, target_F):
    cerr shl __func__ shl ": invalid continuum flavor op construction" shl endl
    exit(1)
  if not checkGParity(left_cont_op, right_cont_op, target_G_parity):
    cerr shl __func__ shl ": invalid G-parity combination for target_G= " shl
        target_G_parity shl endl
    exit(1)
  var one_orderP: bool = (left_cont_op == right_cont_op)
  ##  Will generate pairs for all possible flavor embeddings
  var numEmbedF: cint = numFlavorEmbed(left_cont_op, right_cont_op, target_F)
  ##  Find the subduced ops in the map keyed by the continuum ops
  var left_subd_ops: vector[string] = findSubducedOps(left_cont_op)
  var right_subd_ops: vector[string] = findSubducedOps(right_cont_op)
  ## ! Generate all momentum up to a maximum
  var all_moms: list[vector[cint]] = generateAllMom(0, mom2_max)
  ##  Find each momenta, find the allowed operators
  var left_op_map: map[vector[cint], vector[string]] = buildOpMomMap(left_subd_ops,
      all_moms)
  var right_op_map: map[vector[cint], vector[string]] = buildOpMomMap(right_subd_ops,
      all_moms)
  ##  Loop over the target momenta
  target_mom = target_moms.begin()
  while target_mom != target_moms.`end`():
    var target_canon_mom: vector[cint] = canonicalOrder(target_mom[])
    var target_lg: string = generateLittleGroup(target_canon_mom)
    ##  Target irreps under this LG
    var rept_list: vector[string]
    if 1:
      var group: Handle[LatticeGroup] = Instance().createObject(target_lg)
      var j: cint = 0
      while j < group.numIrreps():
        rept_list.push_back(group.irrepName(j + 1))
        inc(j)
    left_mom_op = left_op_map.begin()
    while left_mom_op != left_op_map.`end`():
      ##  All allowed subduced ops (right)
      right_mom_op = right_op_map.begin()
      while right_mom_op != right_op_map.`end`():
        ##  Check if the momenta are commensurate
        var mom: vector[cint] = left_mom_op.first + right_mom_op.first
        if canonicalOrder(mom) != target_canon_mom:
          continue
        if norm2(mom) > mom2_max:
          continue
        if one_orderP and
            (norm2(left_mom_op.first) < norm2(right_mom_op.first)):
          continue


        left_op = left_mom_op.second.begin()
        while left_op != left_mom_op.second.`end`():
          right_op = right_mom_op.second.begin()
          while right_op != right_mom_op.second.`end`():
            var left_reg: HadronOpsRegInfo_t = findSubducedOpReg(left_op[])
            var right_reg: HadronOpsRegInfo_t = findSubducedOpReg(right_op[])
            var left_lg: string = removeIrrepGParity(left_reg.irrepPG)
            var right_lg: string = removeIrrepGParity(right_reg.irrepPG)
              ##  Loop over possible target irreps
              ##  Check if there is an embedding of this target irrep among the product of the two source irreps
            ##  Loop over possible target irreps
            ##  Check if there is an embedding of this target irrep among the product of the two source irreps

            it = rept_list.begin()
            while it != rept_list.`end`():
              var numEmbedIR: cint = numEmbedStrict(left_lg, right_lg, it, left_mom_op.first,
                                                    right_mom_op.first, mom)
              if numEmbedIR == 0:
                continue
                var embIR: cint = 1
                while embIR <= numEmbedIR:
                  var embF: cint = 1
                  while embF <= numEmbedF:
                    ##  Build the two-hadron op
                    var op: KeyHadronSUNNPartIrrepOp_t
                    op.ops.push_back(KeyParticleOp_t(left_op, "",
                                                     canonicalOrder(left_mom_op.first)))
                    op.ops.push_back(KeyParticleOp_t(right_op, "",
                                                     canonicalOrder(right_mom_op.first)))
                    var cg: CGPair_t
                    cg.left = "1"
                    cg.right = "2"
                    cg.target.slot = "12"
                    cg.target.mom_type = target_canon_mom
    ## 		    if (1)
    ## 		    {
    ## 		      ostringstream os;
    ## 		      os << target_F << "," << embF;
    ## 		      cg.target.F = os.str();
    ## 		    }
    ## 	      
    ## 		    if (1)
    ## 		    {
    ## 		      ostringstream os;
    ## 		      os << it << printPM(target_G_parity) << "," << embIR;
    ## 		      cg.target.irrep = os.str();
    ## 		    }
                    op.CGs.push_back(cg)
                    ##  Keep track of the subduced operators and their corresponding parent continuum op
                    subduced_ops[left_op] = left_cont_op
                    subduced_ops[right_op] = right_cont_op
                    var irrep: string = momIrrepName(convertTargetToIrrep(op.CGs[1].target.irrep),
                                                     target_canon_mom)
                      ##  Insert
                    targets[target_canon_mom][irrep].insert(op, 1)
                    inc(embF)
                  ##  for embF
                  inc(embIR)
                  ##  for embIR
                inc(it)
                ##  for target irrep
              inc(right_op)
            ##  for right_op
          inc(left_op)
        ##  for left_op
        inc(right_mom_op)
      ##  for right_mom
      inc(left_mom_op)
    ##  for left_mom
    inc(target_mom)
  ##  for target_mom
  return make_pair(targets, subduced_ops)


## ----------------------------------------------------------------------------
##  Cooked up method. Nothing to see here. Move along. Move along.

proc compare_helper*(a: KeyHadronSUNNPartIrrepOp_t): vector[cint] =
  var aa: vector[cint]
  aa.resize(4)
  aa[0] = norm2(a.ops[1].mom_type)
  aa[1] = norm2(a.ops[2].mom_type)
  aa[2] = if (aa[0] == 0): -1 else: 0
  aa[3] = if (aa[1] == 0): -1 else: 0
  return aa

##  This comparison is solely for "pretty printing" the output by givin an ordering. Nothing deep.

proc sort_compare_function*(a: SortHadronOp_t; b: SortHadronOp_t): bool =
  return compare_helper(a.key) < compare_helper(b.key)

## ----------------------------------------------------------------------------
## ! Sort two-particle ops

proc sortTwoHadronOps*(targets: MapObject[KeyHadronSUNNPartIrrepOp_t, cint]): deque[
    SortHadronOp_t] =
  ##  The thing we want to sort
  var dq: deque[SortHadronOp_t]
  ##  Sort ops according to some arbitrary name
  targ = targets.begin()
  while targ != targets.`end`():
    ##  Build up the object to sort
    var dairy_queen: SortHadronOp_t
    dairy_queen.opname = ensemFileName(targ.first)
    ##  Invent a short name for this key
    dairy_queen.key = targ.first
    dq.push_back(dairy_queen)
    inc(targ)
  ##  Sort
  sort(dq.begin(), dq.`end`(), sort_compare_function)
  return dq

##  Compare the energies

proc en_compare_function*(a: HadronOpEnergy_t; b: HadronOpEnergy_t): bool =
  var stat: bool = false
  if a.E_lab == b.E_lab:
    stat = a.opname < b.opname
  else:
    stat = a.E_lab < b.E_lab
  return stat

## ! Dispersion relation

proc dispersion*(op: KeyHadronSUNNPartIrrepOp_t; subd_ops: map[string, string];
                masses: map[string, cdouble]; xi: cdouble; L: cint): pair[cdouble,
    cdouble] =
  var f: cdouble = (2.0 * 3.14159265359) div (xi * L)
  var f2: cdouble = f * f
  var E_lab: cdouble = 0.0
  `ptr` = op.ops.`ref`().begin()
  while `ptr` != op.ops.`ref`().`end`():
    ##  Look op the cont op mass
    var cont_op: string = subd_ops.at(`ptr`.name)
    ##  Determine the projected op energy using the dispersion relation
    var m: cdouble = masses.at(cont_op)
    var p2: cdouble = norm2(`ptr`.mom_type)
    inc(E_lab, sqrt(m * m + f2 * p2))
    inc(`ptr`)
  ##  CM energy
  var p2_target: cdouble = norm2(op.CGs.`ref`().back().target.mom_type)
  var E_cm: cdouble = sqrt(E_lab * E_lab - p2_target * f2)
  return make_pair(E_lab, E_cm)

## ----------------------------------------------------------------------------
## ! Sort two-particle ops

proc sortTwoHadronEnergies*(targets: MapObject[KeyHadronSUNNPartIrrepOp_t, cint];
                           subd_ops: map[string, string];
                           masses: map[string, cdouble]; xi: cdouble; L: cint): deque[
    HadronOpEnergy_t] =
  ##  The thing we want to sort
  var dq: deque[HadronOpEnergy_t]
  ##  Sort ops according to some arbitrary name
  targ = targets.begin()
  while targ != targets.`end`():
    var en: pair[cdouble, cdouble] = dispersion(targ.first, subd_ops, masses, xi, L)
    ##  Build up the object to sort
    var dairy_queen: HadronOpEnergy_t
    dairy_queen.E_lab = en.first
    dairy_queen.E_cm = en.second
    dairy_queen.opname = ensemFileName(targ.first)
    ##  Invent a short name for this key
    dairy_queen.key = targ.first
    dq.push_back(dairy_queen)
    inc(targ)
  ##  Sort
  sort(dq.begin(), dq.`end`(), en_compare_function)
  return dq

##  Intel compiler stupidities

proc toStr*(f: cint): string =
  return to_string(cast[clonglong](f))

## ----------------------------------------------------------------------------
##  Build a short version of momentum

proc shortMom*(mom: vector[cint]): string =
  return toStr(mom[0]) + toStr(mom[1]) + toStr(mom[2])

## ----------------------------------------------------------------------------
## ! Generate all allowed one-body ops

proc generateOneHadronOps*(cont_ops: vector[string]; canon_moms: list[vector[cint]]): map[
    vector[cint], vector[pair[string, KeyHadronSUNNPartIrrepOp_t]]] =
  ##  Target map
  var targets: map[vector[cint], vector[pair[string, KeyHadronSUNNPartIrrepOp_t]]]
  ##  For each continuum op, generate all the subduced ops
  cont_op = cont_ops.begin()
  while cont_op != cont_ops.`end`():
    ##  Find the subduced ops in the map keyed by the continuum ops
    var subd_ops: vector[string] = findSubducedOps(cont_op[])
    ##  Find each momenta, find the allowed operators
    var subd_op_map: map[vector[cint], vector[string]] = buildOpMomMap(subd_ops,
        canon_moms)
    ##  Bung onto the big op map
    mm = subd_op_map.begin()
    while mm != subd_op_map.`end`():
      ##  Build the one-hadron op
      subd_op = mm.second.begin()
      while subd_op != mm.second.`end`():
        var op: KeyHadronSUNNPartIrrepOp_t
        op.ops.push_back(KeyParticleOp_t(subd_op[], "", mm.first))
        ##  Invent a new name including the canonical momentum
        var short_name: string = subd_op[] + "__" + shortMom(mm.first)
        ##  Insert
        targets[mm.first].push_back(make_pair(short_name, op))
        inc(subd_op)
      ##  for subd_op
      inc(mm)
    ##  for mm
    inc(cont_op)
  ##  for cont_op
  return targets

## ----------------------------------------------------------------------------------
## ! Check if this pair is legal

proc checkContOpPair*(left_op: string; right_op: string; target_F: string;
                     target_G_parity: cint; target_S: cint; target_c: cint;
                     target_B: cint): bool =
  ##  Check if the flavor combinations are allowed
  var left: var HadronContOpRegInfo_t = findContOp(left_op)
  var right: var HadronContOpRegInfo_t = findContOp(right_op)
  var dest: bool = true
  var foo: bool
  foo = checkFlavor(left, right, target_F)
  when 0:
    if foo:
      cout shl __func__ shl ": allowed continuum flavor -  left= " shl left_op shl
          "  right= " shl right_op shl endl
    else:
      cout shl __func__ shl ": invalid flavor -  left= " shl left_op shl "  right= " shl
          right_op shl endl
  dest = dest and foo
  foo = checkGParity(left_op, right_op, target_G_parity)
  when 0:
    if foo:
      cout shl __func__ shl ": allowed G-parity -  left= " shl left_op shl
          "  right= " shl right_op shl endl
    else:
      cout shl __func__ shl ": invalid G-parity -  left= " shl left_op shl
          "  right= " shl right_op shl endl
  dest = dest and foo
  foo = checkCBS(left, right, target_S, target_c, target_B)
  when 0:
    if foo:
      cout shl __func__ shl ": allowed SCB -  left= " shl left_op shl "  right= " shl
          right_op shl endl
    else:
      cout shl __func__ shl ": invalid SCB -  left= " shl left_op shl "  right= " shl
          right_op shl endl
  dest = dest and foo
  return dest

## ----------------------------------------------------------------------------------
## ! Order the ops

proc orderContOpPair*(left_op: string; right_op: string): pair[string, string] =
  var left: var HadronContOpRegInfo_t = findContOp(left_op)
  var right: var HadronContOpRegInfo_t = findContOp(right_op)
  ##  First order by J
  if left.twoJ > right.twoJ:
    return make_pair(left_op, right_op)
  elif left.twoJ < right.twoJ:   ##  Order by flavor rep
    return make_pair(right_op, left_op)
  if left.F > right.F:
    return make_pair(left_op, right_op)
  elif left.F < right.F:         ##  Finally, order by name
    return make_pair(right_op, left_op)
  if left.F > right.F: return make_pair(left_op, right_op)
  else: return make_pair(right_op, left_op)
  
## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## ! Create single time-slice of operator constructions for all ops in ops_list
## !< 
##  Input  pair of form    [000_T1mM, string=<operator_id>]
##  Return pair of form    [000_T1mM, KeyHadronSUNNPartIrrep_t]
## 

proc printRedstarIrrep*(ops_list: vector[pair[string, string]];
                       ops_map: map[string, KeyHadronSUNNPartIrrepOp_t];
                       mom: vector[cint]; include_all_rows: bool; creation_op: bool;
                       smearedP: bool): list[
    pair[string, KeyHadronSUNNPartIrrep_t]] =
  ##  Only select the irreps compatible with the mom_type
  var canon_mom: vector[cint] = canonicalOrder(mom)
  ##  Sink ops
  var dest: list[pair[string, KeyHadronSUNNPartIrrep_t]]
  op = ops_list.begin()
  while op != ops_list.`end`():
    if ops_map.find(op.second) == ops_map.`end`():
      cout shl __func__ shl ": missing op= " shl op.second shl " is not in ops_map" shl
          endl
      exit(1)
    var mom_type: string = opListToIrrepMom(op.first).second
    if canon_mom != mom_type:
      continue
    var had: KeyHadronSUNNPartIrrep_t
    had.creation_op = creation_op
    had.smearedP = smearedP
    had.op = ops_map.at(op.second)
    ##  Op
    var info: HadronIrrepOpInfo_t = hadronIrrepOpInfo(had.op)
    had.flavor = KeyCGCSU3_t(info.twoI, info.threeY, info.twoI)
    var dim: cint = if (include_all_rows): info.dim else: 1
    var row: cint = 1
    while row <= dim:
      had.irrep_mom = KeyCGCIrrepMom_t(row, mom)
      dest.push_back(make_pair(op.first, had))
      inc(row)
    inc(op)
  return dest

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## ! Create corr keys from operator list

proc printRedstar2PtsDiag*(source_ops_list: vector[pair[string, string]];
                          sink_ops_list: vector[pair[string, string]];
                          ops_map: map[string, KeyHadronSUNNPartIrrepOp_t];
                          mom: vector[cint]; include_all_rows: bool;
                          t_sources: vector[cint]): list[
    KeyHadronSUNNPartNPtCorr_t] =
  ##  Sink & source ops - determined completely by source ops
  var source_ops: string = printRedstarIrrep(source_ops_list, ops_map, mom,
      include_all_rows, true, true)
  ##  Output
  var dest: list[KeyHadronSUNNPartNPtCorr_t]
  ##  Outer product of sink and source ops
  src = source_ops.begin()
  while src != source_ops.`end`():
    ##  Loop over time sources
    t_source = t_sources.begin()
    while t_source != t_sources.`end`():
      var key: KeyHadronSUNNPartNPtCorr_t
      key.npoint.resize(2)
      key.npoint[1].t_slice = -2
      key.npoint[1].irrep = src.second
      key.npoint[1].irrep.creation_op = false
      key.npoint[2].t_slice = t_source[]
      key.npoint[2].irrep = src.second
      dest.push_back(key)
      inc(t_source)
    inc(src)
  return dest

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## ! Off-diagonal method

proc printRedstar2PtsOffDiag*(source_ops_list: vector[pair[string, string]];
                             sink_ops_list: vector[pair[string, string]];
                             ops_map: map[string, KeyHadronSUNNPartIrrepOp_t];
                             mom: vector[cint]; include_all_rows: bool;
                             t_sources: vector[cint]): list[
    KeyHadronSUNNPartNPtCorr_t] =
  ##  Sink & source ops
  var sink_ops: fred = printRedstarIrrep(sink_ops_list, ops_map, mom, include_all_rows,
                                     false, true)
  var source_ops: fred = printRedstarIrrep(source_ops_list, ops_map, mom,
                                       include_all_rows, true, true)
  ##  Output
  var dest: list[KeyHadronSUNNPartNPtCorr_t]
  ##  All source ops to sink ops, independent of irrep
  snk = sink_ops.begin()
  while snk != sink_ops.`end`():
    src = source_ops.begin()
    while src != source_ops.`end`():
      ##  Loop over time sources
      t_source = t_sources.begin()
      while t_source != t_sources.`end`():
        var key: KeyHadronSUNNPartNPtCorr_t
        key.npoint.resize(2)
        key.npoint[1].t_slice = -2
        key.npoint[1].irrep = snk.second
        key.npoint[2].t_slice = t_source[]
        key.npoint[2].irrep = src.second
        dest.push_back(key)
        inc(t_source)
      inc(src)
    inc(snk)
  return dest

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## ! Default method

proc printRedstar2PtsDefault*(source_ops_list: vector[pair[string, string]];
                             sink_ops_list: vector[pair[string, string]];
                             ops_map: map[string, KeyHadronSUNNPartIrrepOp_t];
                             mom: vector[cint]; include_all_rows: bool;
                             t_sources: vector[cint]): list[
    KeyHadronSUNNPartNPtCorr_t] =
  ##  Sink & source ops
  var sink_ops: fred = printRedstarIrrep(sink_ops_list, ops_map, mom, include_all_rows,
                                     false, true)
  var source_ops: fred = printRedstarIrrep(source_ops_list, ops_map, mom,
                                       include_all_rows, true, true)
  ##  Output
  var dest: list[KeyHadronSUNNPartNPtCorr_t]
  ##  Outer product of sink and source ops
  snk = sink_ops.begin()
  while snk != sink_ops.`end`():
    src = source_ops.begin()
    while src != source_ops.`end`():
      ##  The "default" version has the same source/sink irreps and the same rows
      if snk.first != src.first:
        continue
      if snk.second.irrep_mom.row != src.second.irrep_mom.row:
        continue
      t_source = t_sources.begin()
      while t_source != t_sources.`end`():
        var key: KeyHadronSUNNPartNPtCorr_t
        key.npoint.resize(2)
        key.npoint[1].t_slice = -2
        key.npoint[1].irrep = snk.second
        key.npoint[2].t_slice = t_source[]
        key.npoint[2].irrep = src.second
        dest.push_back(key)
        inc(t_source)
      inc(src)
    inc(snk)
  return dest
  
