##  -*- C++ -*-
## ! \file
##  \brief SU(2) irreps
## 

## ----------------------------------------------------------------------------------
## ! Type tags for basic irrep names

type
  SU2Rep* = object
  

proc destroySU2Rep*(this: var SU2Rep) {.destructor.} =
  discard

proc dim*(this: SU2Rep): cint {.noSideEffect.}
proc rep*(this: SU2Rep): string {.noSideEffect.}
## ------------------------------------------------------------------------------------
##  Continuum reps

type
  J0Rep* = object of SU2Rep
  

const
  Size_t* = 1

proc dim*(this: J0Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J0Rep): string {.noSideEffect.} =
  return "J0"

type
  J1Rep* = object of SU2Rep
  

const
  Size_t* = 3

proc dim*(this: J1Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J1Rep): string {.noSideEffect.} =
  return "J1"

type
  J2Rep* = object of SU2Rep
  

const
  Size_t* = 5

proc dim*(this: J2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J2Rep): string {.noSideEffect.} =
  return "J2"

type
  J3Rep* = object of SU2Rep
  

const
  Size_t* = 7

proc dim*(this: J3Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J3Rep): string {.noSideEffect.} =
  return "J3"

type
  J4Rep* = object of SU2Rep
  

const
  Size_t* = 9

proc dim*(this: J4Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J4Rep): string {.noSideEffect.} =
  return "J4"

type
  J5Rep* = object of SU2Rep
  

const
  Size_t* = 11

proc dim*(this: J5Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J5Rep): string {.noSideEffect.} =
  return "J5"

## ----------------------------------------------------------------------------------

type
  J1o2Rep* = object of SU2Rep
  

const
  Size_t* = 2

proc dim*(this: J1o2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J1o2Rep): string {.noSideEffect.} =
  return "J1o2"

type
  J3o2Rep* = object of SU2Rep
  

const
  Size_t* = 4

proc dim*(this: J3o2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J3o2Rep): string {.noSideEffect.} =
  return "J3o2"

type
  J5o2Rep* = object of SU2Rep
  

const
  Size_t* = 6

proc dim*(this: J5o2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J5o2Rep): string {.noSideEffect.} =
  return "J5o2"

type
  J7o2Rep* = object of SU2Rep
  

const
  Size_t* = 8

proc dim*(this: J7o2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J7o2Rep): string {.noSideEffect.} =
  return "J7o2"

type
  J9o2Rep* = object of SU2Rep
  

const
  Size_t* = 10

proc dim*(this: J9o2Rep): cint {.noSideEffect.} =
  return Size_t

proc rep*(this: J9o2Rep): string {.noSideEffect.} =
  return "J9o2"

##  namespace Hadron
