##  SU(3) irreps
## 

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
## ! SU2 subgroups

type
  SU2SubgroupSU3_t* = object
    twoI*: cint
    threeY*: cint


proc constructSU2SubgroupSU3_t*(): SU2SubgroupSU3_t {.constructor.} =
  discard

proc constructSU2SubgroupSU3_t*(I: cint; Y: cint): SU2SubgroupSU3_t {.constructor.} =
  discard

## ----------------------------------------------------------------------------------
## ! Type tags for SU(3)

type
  SU3withSU2Rep_t* = object
  

proc destroySU3withSU2Rep_t*(this: var SU3withSU2Rep_t) {.destructor.} =
  discard

proc getSU2s*(this: SU3withSU2Rep_t): list[SU2SubgroupSU3_t] {.noSideEffect.}
##  namespace Hadron
