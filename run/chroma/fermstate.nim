## Fermion states

import serializetools/serializexml
import xmltree

type
  SimpleFermState_t* = object
    Name*:        string
    FermionBC*:   XmlNode


proc newSimpleFermState*(FermionBC: XmlNode): XmlNode =
  ## Return a new StoutFermState
  serializeXML(SimpleFermState_t(Name: "SIMPLE_FERM_STATE", FermionBC: FermionBC), "FermState")


type
  StoutFermState_t* = object
    Name*:        string
    rho*:         float
    n_smear*:     int
    orthog_dir*:  int
    FermionBC*:   XmlNode


proc newStoutFermState*(rho: float, n_smear: int, orthog_dir: int, FermionBC: XmlNode): XmlNode =
  ## Return a new StoutFermState
  serializeXML(StoutFermState_t(Name: "STOUT_FERM_STATE", rho: rho, n_smear: n_smear, orthog_dir: orthog_dir, FermionBC: FermionBC), "FermState")
  



