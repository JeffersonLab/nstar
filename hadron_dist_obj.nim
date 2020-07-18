##  -*- C++ -*-
## ! \file
##  \brief Generic hadron distilled operator with spin.
##
##  Container which is always dense in distillation space, but maybe
##  sparse in spin.
##

## ----------------------------------------------------------------------------
## ! Distillution and spin matrix element

type
  HadronDistOperatorRep* {.bycopy.} = object ## ! Default construction only
                                         ## ! Set default num spins
    ## !< Spin indices


proc constructHadronDistOperatorRep*(): HadronDistOperatorRep {.constructor.}
proc sync*(this: var HadronDistOperatorRep): cint
proc reshape*(this: HadronDistOperatorRep; dim_spins: vector[cint];
             dim_dils: vector[cint]): HadronDistOperatorRep {.noSideEffect.}
proc clear*(this: var HadronDistOperatorRep)
proc getNumDims*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc setNumDils*(this: var HadronDistOperatorRep; left_num_dils: cint)
proc setNumDils*(this: var HadronDistOperatorRep; left_num_dils: cint;
                right_num_dils: cint)
proc setNumDils*(this: var HadronDistOperatorRep; left_num_dils: cint;
                middle_num_dils: cint; right_num_dils: cint)
proc setNumDils*(this: var HadronDistOperatorRep; left_left_num_dils: cint;
                left_right_num_dils: cint; right_left_num_dils: cint;
                right_right_num_dils: cint)
proc setNumDils*(this: var HadronDistOperatorRep; num_dils: vector[cint])
proc getLeftNumDils*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getMiddleNumDils*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getRightNumDils*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getNumDils*(this: HadronDistOperatorRep): vector[cint] {.noSideEffect.}
proc setNumSpins*(this: var HadronDistOperatorRep; left_num_dils: cint)
proc setNumSpins*(this: var HadronDistOperatorRep; left_num_dils: cint;
                 right_num_dils: cint)
proc setNumSpins*(this: var HadronDistOperatorRep; left_num_dils: cint;
                 middle_num_dils: cint; right_num_dils: cint)
proc setNumSpins*(this: var HadronDistOperatorRep; left_left_num_dils: cint;
                 left_right_num_dils: cint; right_left_num_dils: cint;
                 right_right_num_dils: cint)
proc setNumSpins*(this: var HadronDistOperatorRep; num_dils: vector[cint])
proc getLeftNumSpins*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getMiddleNumSpins*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getRightNumSpins*(this: HadronDistOperatorRep): cint {.noSideEffect.}
proc getNumSpins*(this: HadronDistOperatorRep): vector[cint] {.noSideEffect.}
proc spin*(this: var HadronDistOperatorRep; spin_1: cint): var Spin_t
proc spin*(this: HadronDistOperatorRep; spin_1: cint): Spin_t {.noSideEffect.}
proc exist*(this: HadronDistOperatorRep; spin_1: cint): bool {.noSideEffect.}
proc spin*(this: var HadronDistOperatorRep; spin_1: cint; spin_2: cint): var Spin_t
proc spin*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint): Spin_t {.
    noSideEffect.}
proc exist*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint): bool {.
    noSideEffect.}
proc spin*(this: var HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint): var Spin_t
proc spin*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint): Spin_t {.
    noSideEffect.}
proc exist*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint): bool {.
    noSideEffect.}
proc spin*(this: var HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint;
          spin_4: cint): var Spin_t
proc spin*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint;
          spin_4: cint): Spin_t {.noSideEffect.}
proc exist*(this: HadronDistOperatorRep; spin_1: cint; spin_2: cint; spin_3: cint;
           spin_4: cint): bool {.noSideEffect.}
proc spin*(this: var HadronDistOperatorRep; spin_indices: vector[cint]): var Spin_t
proc spin*(this: HadronDistOperatorRep; spin_indices: vector[cint]): Spin_t {.
    noSideEffect.}
proc spinRef*(this: HadronDistOperatorRep; spin_indices: vector[cint]): Spin_t {.
    noSideEffect.}
proc exist*(this: HadronDistOperatorRep; spin_indices: vector[cint]): bool {.
    noSideEffect.}
proc print*(this: HadronDistOperatorRep; os: var ostream): var ostream {.noSideEffect.}
proc size*(this: HadronDistOperatorRep): cint {.noSideEffect.}
type
  K* = vector[cint]
  V* = Spin_t
  MapType_t* = map[K, V]

proc begin*(this: HadronDistOperatorRep): const_iterator {.noSideEffect.}
proc `end`*(this: HadronDistOperatorRep): const_iterator {.noSideEffect.}
proc insert*(this: var HadronDistOperatorRep; key: K; val: V)
## ----------------------------------------------------------------------------
## ! HadronDistOperatorRep output

proc `<<`*(os: var ostream; param: HadronDistOperatorRep): var ostream
##  namespace Hadron
