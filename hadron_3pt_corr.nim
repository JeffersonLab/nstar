##  -*- C++ -*-
##  $Id: hadron_3pt_corr.h,v 2.4 2009/03/21 21:33:45 edwards Exp $
## ! \file
##  \brief Hadron 3pt correlators
## 

import
  ensem/ensem, adat/map_obj, io/key_val_db, ConfDataStoreDB

nil
nil
nil
## ----------------------------------------------------------------------------
## ! Hold momenta

type
  PiPf* {.bycopy.} = object
    p_i*: Array[cint]
    p_f*: Array[cint]


## ! Support for maps

proc `<`*(a: PiPf; b: PiPf): bool
## ! Reader

proc read*(xml: var XMLReader; path: string; val: var PiPf)
## ! Writer

proc write*(xml: var XMLWriter; path: string; val: PiPf)
## ----------------------------------------------------------------------------
## ! Key for Hadron 3pt corr

type
  KeyHadron3PtCorr_t* {.bycopy.} = object
    num_vecs*: cint            ## !< Number of vectors used in this corr
    pi_pf*: PiPf               ## !< Source and sink momenta
    gamma*: cint               ## !< Gamma matrix index (0 .. 15). In DP basis
    links*: Array[cint]        ## !< Gauge link insertions
    dt*: cint                  ## !< Source-sink separation
    quark*: cint               ## !< Some number indicating which quark line
    src_name*: string          ## !< Some string label for the operator
    src_smear*: string         ## !< Some string label for the smearing of this operator
    src_lorentz*: Array[cint]  ## !< Source Lorentz indices
    src_spin*: cint            ## !< Source Dirac spin indices
    snk_name*: string          ## !< Some string label for the operator
    snk_smear*: string         ## !< Some string label for the smearing of this operator
    snk_lorentz*: Array[cint]  ## !< Sink Lorentz indices
    snk_spin*: cint            ## !< Sink Dirac spin indices
    mass*: string              ## !< Some string label for the mass(es) in the corr
    ensemble*: string          ## !< Label for the ensemble
  

## ----------------------------------------------------------------------------
## ! Used for error output

proc `<<`*(os: var ostream; d: KeyHadron3PtCorr_t): var ostream
## ----------------------------------------------------------------------------
## ! KeyHadron3PtCorr reader

proc read*(xml: var XMLReader; path: string; param: var KeyHadron3PtCorr_t)
## ! KeyHadron3PtCorr writer

proc write*(xml: var XMLWriter; path: string; param: KeyHadron3PtCorr_t)
## ----------------------------------------------------------------------------
## ! KeyHadron3PtCorr reader

proc read*(bin: var BinaryReader; param: var KeyHadron3PtCorr_t)
## ! KeyHadron3PtCorr writer

proc write*(bin: var BinaryWriter; param: KeyHadron3PtCorr_t)
when 0:
  ## ----------------------------------------------------------------------------
  ## ! Merge this key with another key to produce a final key
  proc mergeKeys*(`out`: var KeyHadron3PtCorr_t; `in`: ThreePtArg;
                 prototype: KeyHadron3PtCorr_t)


  ## ----------------------------------------------------------------------------
  ## ! Use an in-memory map
  type
    MapHadron3PtCorr_t* = MapObject[KeyHadron3PtCorr_t, EnsemVectorComplex]


  ## ! Use a DB
  type
    DBHadron3PtSingleCorr_t* = ConfDataStoreDB[SerialDBKey[KeyHadron3PtCorr_t],
        SerialDBData[VectorComplex]]


  ## ! Use a DB
  type
    DBHadron3PtCorr_t* = ConfDataStoreDB[SerialDBKey[KeyHadron3PtCorr_t],
                                       SerialDBData[EnsemVectorComplex]]
##  namespace ColorVec
