##  -*- C++ -*-
## ! \file
##  \brief Two quark operators
## 

## ----------------------------------------------------------------------------------
## ! Type tags for basic permutation group names

type
  PermS3Rep* = object
  

proc destroyPermS3Rep*(this: var PermS3Rep) {.destructor.} =
  discard

proc dim*(this: PermS3Rep): cint {.noSideEffect.}
proc rep*(this: PermS3Rep): string {.noSideEffect.}
## ----------------------------------------------------------------------------------
##  Type tags for symmetry transformations

type
  S_sym_t* = object of PermS3Rep
  

const
  Size_t* = 1

proc dim*(this: S_sym_t): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: S_sym_t): string {.noSideEffect.} =
  return "S"

type
  M_sym_t* = object of PermS3Rep
  

const
  Size_t* = 2

proc dim*(this: M_sym_t): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: M_sym_t): string {.noSideEffect.} =
  return "M"

type
  A_sym_t* = object of PermS3Rep
  

const
  Size_t* = 1

proc dim*(this: A_sym_t): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: A_sym_t): string {.noSideEffect.} =
  return "A"

##  namespace Hadron
