## Hadron multi-particle operators projected onto an irrep

import particle_op, serializetools/array1d, hashes

#----------------------------------------------------------------------------
# Time slice collection of operators projected onto a definite irrep
type
  Slot_t* = object
    slot*:      string            ## At first level, the HadronOp index, at higher levels, the temporary 
    F*:         string            ## Target SU(N) flavor irrep - of form for SU(2) "3,1", or for SU(3) "8,1" 
    irrep*:     string            ## Target Octahedral/little-group irrep - of form   "Lambda,embed" 
    mom_type*:  seq[cint]         ## Target D-1 Canonical momentum type 
    
  CGPair_t* = object
    left*:      string            ## Left side of CG 
    right*:     string            ## Right side of CG 
    target*:    Slot_t            ## Target of CG 
  
  KeyHadronSUNNPartIrrepOp_t* = object
    CGs*:       Array1dO[CGPair_t]        ## Each pair of CG contractions 
    Operators*: Array1dO[KeyParticleOp_t] ## Each operator 


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


proc hash*(x: KeyHadronSUNNPartIrrepOp_t): Hash =
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

  var opsMap: Table[string, KeyHadronSUNNPartIrrepOp_t]
  var f: string = "ex.ops.8.xml"

  echo "Read file= ", f
  let xml: XmlNode = loadXml(f)

#  echo "Here is xml= ", xml

  echo "Let us serialize it"
  opsMap = deserializeXML[type(opsMap)](xml, "OpsList")
  
  echo "Check it out"
  let foo = opsMap["omega8_proj1_p200_H1D4E2__200xxomega1_proj0_p200_H1D4E2__200__F8,1_T2pM,1__000"]
  echo "Look up a key: result= ", foo
  echo "wunderbar, not pull out a mom_type"
  let ff: array[0..2,cint] = foo.Operators[1].mom_type
  echo "zoom in:  mom_type= ", @ff

  
