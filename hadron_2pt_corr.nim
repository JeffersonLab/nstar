## ! \file
##  \brief Hadron 2pt correlators
## 

import
  ensem, adat/map_obj, io/key_val_db, niledb

nil
nil
nil
## ----------------------------------------------------------------------------
## ! Key for Hadron 2pt corr

type
  KeyHadron2PtCorr_t* {.bycopy.} = object
    num_vecs*: cint            ## !< Number of vectors used in this corr
    src_name*: string          ## !< Some string label for the operator
    src_smear*: string         ## !< Some string label for the smearing of this operator
    src_lorentz*: Array[cint]  ## !< Source Lorentz indices
    src_spin*: cint            ## !< Source Dirac spin indices
    snk_name*: string          ## !< Some string label for the operator
    snk_smear*: string         ## !< Some string label for the smearing of this operator
    snk_lorentz*: Array[cint]  ## !< Sink Lorentz indices
    snk_spin*: cint            ## !< Sink Dirac spin indices
    mom*: Array[cint]          ## !< D-1 momentum of the sink operator
    mass*: string              ## !< Some string label for the mass(es) in the corr
    ensemble*: string          ## !< Label for the ensemble
  

## ----------------------------------------------------------------------------
## ! Used for error output

proc `<<`*(os: var ostream; d: KeyHadron2PtCorr_t): var ostream
## ----------------------------------------------------------------------------
## ! KeyHadron2PtCorr reader

proc read*(xml: var XMLReader; path: string; param: var KeyHadron2PtCorr_t)
## ! KeyHadron2PtCorr writer

proc write*(xml: var XMLWriter; path: string; param: KeyHadron2PtCorr_t)
## ----------------------------------------------------------------------------
## ! KeyHadron2PtCorr reader

proc read*(bin: var BinaryReader; param: var KeyHadron2PtCorr_t)
## ! KeyHadron2PtCorr writer

proc write*(bin: var BinaryWriter; param: KeyHadron2PtCorr_t)
## ----------------------------------------------------------------------------
## ! Use an in-memory map

type
  MapHadron2PtCorr_t* = MapObject[KeyHadron2PtCorr_t, EnsemVectorComplex]

## ! Use a DB

type
  DBHadron2PtSingleCorr_t* = ConfDataStoreDB[SerialDBKey[KeyHadron2PtCorr_t],
      SerialDBData[VectorComplex]]

## ! Use a DB

type
  DBHadron2PtCorr_t* = ConfDataStoreDB[SerialDBKey[KeyHadron2PtCorr_t],
                                     SerialDBData[EnsemVectorComplex]]

##  namespace ColorVec
