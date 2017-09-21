## Clover fermion actions

import serializetools/serializexml
import xmltree

type
  AnisoParam_t* = object
    anisoP*:        bool
    xi_0*:          float
    nu*:            float
    t_dir*:         int

  AnisoCloverFermionAction_t* = object
    FermAct*:        string  ## PRECONDITIONED_CLOVER
    Mass*:           float
    clovCoeffR*:     float
    clovCoeffT*:     float
    AnisoParam*:     AnisoParam_t
    FermState*:      XmlNode
    
  IsoCloverFermionAction_t* = object
    FermAct*:        string  ## CLOVER
    Mass*:           float
    clovCoeff*:      float
    FermState*:      XmlNode

proc newCloverFermionAction*(FermAct: string, Mass, clovCoeffR, clovCoeffT: float, AnisoParam: AnisoParam_t, FermState: XmlNode): XmlNode =
  ## Return a new CloverFermionAction
  return serializeXML(AnisoCloverFermionAction_t(FermAct: FermAct, Mass: Mass, clovCoeffR: clovCoeffR, clovCoeffT: clovCoeffT, AnisoParam: AnisoParam, FermState: FermState), "FermionAction")


proc newPreconditionedCloverFermionAction*(Mass, clovCoeffR, clovCoeffT: float, AnisoParam: AnisoParam_t, FermState: XmlNode): XmlNode =
  ## Return a new PreconditionedCloverFermionAction
  return newCloverFermionAction("PRECONDITIONED_CLOVER", Mass, clovCoeffR, clovCoeffT, AnisoParam, FermState)


proc newUnpreconditionedCloverFermionAction*(Mass, clovCoeffR, clovCoeffT: float, AnisoParam: AnisoParam_t, FermState: XmlNode): XmlNode =
  ## Return a new UnpreconditionedCloverFermionAction
  return newCloverFermionAction("UNPRECONDITIONED_CLOVER", Mass, clovCoeffR, clovCoeffT, AnisoParam, FermState)
