## Hadron multi-particle operators projected onto an irrep and specific row including creation op info

import hadron_sun_npart_irrep_op, cgc_su3, cgc_irrep_mom, hashes

## #----------------------------------------------------------------------------
# Time slice collection of operators projected onto a definite irrep and specific row
type
  KeyHadronSUNNPartIrrep_t* = object
    creation_op*: bool                       ## Are these creation ops on this time-slice? 
    smearedP*:    bool                       ## Do these operators use distillation/distillution? 
    flavor*:      KeyCGCSU3_t                ## Target flavor component 
    irmom*:       KeyCGCIrrepMom_t           ## Target irrep row and D-1 momentum of this N-particle op 
    Op*:          KeyHadronSUNNPartIrrepOp_t ## Operator
  

proc hash*(x: KeyHadronSUNNPartIrrep_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h


when isMainModule:
  import serializexml, tables, xmlparser, xmltree

  var opsList: Table[string, KeyHadronSUNNPartIrrep_t]
  var f: string = "ex.ops.8.xml"

  echo "Read file= ", f
  let xml: XmlNode = loadXml(f)

#  echo "Here is xml= ", xml

  echo "Let us serialize it"
  opsList = deserializeXML[type(opsList)](xml, "OpsList")


