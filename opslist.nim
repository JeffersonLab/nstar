## Hadron adjacency graphs

import 
  serializetools/serializexml,
  serializetools/array1d,
  tables,
  hadron_sun_npart_irrep,
  hadron_sun_npart_irrep_op,
  hadron_sun_npart_npt_corr


#[
import unittest
suite "Testing graphs":
  test "AdjMap":
    type T = HadronGraphAdjMap_t
    var x: T
    let xml = serializeXML(x)
    echo "test map[map] xml= ", xml
    let xx = deserializeXML[T](xml)
    echo "deserializeXML(map[map])= ", xx
    assert(x == xx)
]#


#----------------------------------------------------------------------------
when isMainModule:
  import serializetools/serializexml, tables, xmlparser, xmltree

  type T = Table[string, KeyHadronSUNNPartIrrepOp_t]
  let f: string = "ex.ops.8.xml"

  echo "Read file= ", f
  let xml: XmlNode = loadXml(f)

#  echo "Here is xml= ", xml

  echo "Let us serialize it"
  let opsMap = deserializeXML[T](xml)
  
  echo "Check it out"
  let foo = opsMap["omega8_proj1_p200_H1D4E2__200xxomega1_proj0_p200_H1D4E2__200__F8,1_T2pM,1__000"]
  echo "Look up a key: result= ", foo
  echo "wunderbar, not pull out a mom_type"
  let ff: array[0..2,cint] = foo.Operators[1].mom_type
  echo "zoom in:  mom_type= ", @ff

  #----
  proc readCorrList(corr_file: string): seq[KeyHadronSUNNPartNPtCorr_t] =
    ## Read correlator list from the file in the string `corr_file`
    try:
      let xml = loadXml(corr_file)
      echo "topmost node= ", tag(xml)
      let xml2 = xml.child("Param")
      #  echo "xml2 = ", xml2
      let xml3 = xml2.child("NPointList")
      #  echo "xml3 = ", xml3
      result = deserializeXML[type(result)](xml3)
    except IOError:
      echo "I/O error: " & getCurrentExceptionMsg()

  # Read the corr list
  let corr_list = readCorrList("a0.d3.xml")
  echo "corr_list[0] = ", corr_list[0]
  let corr_list0 = corr_list[0]
  echo "corr_list[0] = ", serializeXML(corr_list0)

  # Build up some tables
  var corrMap = initTable[KeyHadronSUNNPartNPtCorr_t, int]()
  var n: int = 0
  for e in items(corr_list):
    corrMap.add(e, n)
    inc(n)

  echo "finished building corrMap"
