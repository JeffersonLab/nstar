## Fermion BC-s

import serializetools/serializexml
import xmltree

type
  SimpleFermBC_t* = object
    FermBC*:        string   #Name>SIMPLE_FERMBC</Name>
    boundary*:      seq[int]

proc newSimpleFermBC*(boundary: seq[int]): XmlNode =
  ## Return a new SimpleFermBC
  return serializeXML(SimpleFermBC_t(FermBC: "SIMPLE_FERMBC", boundary: boundary), "FermionBC")


when isMainModule:
  let bc = newSimpleFermBC(@[1,1,1,-1])
  echo "xml= ", $bc
