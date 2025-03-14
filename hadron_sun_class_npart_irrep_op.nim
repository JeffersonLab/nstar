## Hadron multi-particle operators projected onto an irrep

import particle_class_op, serializetools/array1d, hashes

#----------------------------------------------------------------------------
# Time slice collection of operators projected onto a definite irrep
type
  Slot_t* = object
    slot*:       string            ## At first level, the HadronOp index, at higher levels, the temporary 
    irrep*:      string            ## Target Octahedral/little-group irrep - of form   "Lambda,embed" 
    F*:          string            ## Target SU(N) flavor irrep - of form for SU(2) "3,1", or for SU(3) "8,1" 
    mom_class*:  seq[cint]         ## Target D-1 Canonical momentum type
    
  CGPair_t* = object
    left*:      string            ## Left side of CG 
    right*:     string            ## Right side of CG 
    target*:    Slot_t            ## Target of CG 
  
  KeyHadronSUNClassNPartIrrepOp_t* = object
    Operators*: Array1dO[KeyParticleClassOp_t] ## Each operator 
    CGs*:       Array1dO[CGPair_t]        ## Each pair of CG contractions 


proc hash*(x: Slot_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h


proc hash*(x: CGPair_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h


proc hash*(x: KeyHadronSUNClassNPartIrrepOp_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h


#----------------------------------------------------------------------------
when isMainModule:
  import serializetools/serializexml, tables, xmlparser, xmltree

  var opsMap: Table[string, KeyHadronSUNClassNPartIrrepOp_t]
  var f: string = "3pi.ops.xml"

  echo "Read file= ", f
  let xml: XmlNode = loadXml(f)

#  echo "Here is xml= ", xml

  echo "Let us serialize it"
  opsMap = deserializeXML[type(opsMap)](xml, "OpsList")
  
  echo "Check it out"
  let foo = opsMap["XXpion_pionxD0_J0__J0_H0D2A2__-101xxpion_pionxD0_J0__J0_H0D2A2__110__F3,1_D2B1P,1__011XXpion_pionxD0_J0__J0_H0D2A2__0-1-1__F5,1_T1mM,1__000"]
  echo "Look up a key: result= ", foo
  echo "wunderbar, pull out a mom_class"
  let ff: array[0..2,cint] = foo.Operators[1].mom_class
  echo "zoom in:  mom_class= ", @ff

  
