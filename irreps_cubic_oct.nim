## Octahedral cubic group
## 

import
  irreps_cubic, cubic_groups

## ----------------------------------------------------------------------------------
##  Single cover cubic group irreps

type
  A1Rep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A1Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: A1Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A1Rep): string {.noSideEffect.} =
  return "A1"

type
  A2Rep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A2Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: A2Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A2Rep): string {.noSideEffect.} =
  return "A2"

type
  T1Rep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T1Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: T1Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T1Rep): string {.noSideEffect.} =
  return "T1"

type
  T2Rep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T2Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: T2Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T2Rep): string {.noSideEffect.} =
  return "T2"

type
  ERep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: ERep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: ERep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: ERep): string {.noSideEffect.} =
  return "E"

## ----------------------------------------------------------------------------------
##  Double cover cubic group irreps

type
  G1Rep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G1Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: G1Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G1Rep): string {.noSideEffect.} =
  return "G1"

type
  G2Rep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G2Rep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: G2Rep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G2Rep): string {.noSideEffect.} =
  return "G2"

type
  HRep* = object of CubicRep
  

const
  Size_t* = 4

proc dim*(this: HRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: HRep): cint {.noSideEffect.} =
  return 0

proc group*(this: HRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: HRep): string {.noSideEffect.} =
  return "H"

## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
##  Single cover cubic group irreps with parity

type
  A1pRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A1pRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A1pRep): cint {.noSideEffect.} =
  return 0

proc group*(this: A1pRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A1pRep): string {.noSideEffect.} =
  return "A1"

proc repChar*(this: A1pRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: A1pRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  mat(1, 1) = repChar(elem)
  return mat

type
  A2pRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A2pRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A2pRep): cint {.noSideEffect.} =
  return 0

proc group*(this: A2pRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A2pRep): string {.noSideEffect.} =
  return "A2"

proc repChar*(this: A2pRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1,
                    - 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1,
                    - 1, - 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1,
                    - 1, - 1, - 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1,
                    - 1, - 1, - 1, - 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: A2pRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  mat(1, 1) = repChar(elem)
  return mat

type
  T1pRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T1pRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T1pRep): cint {.noSideEffect.} =
  return 0

proc group*(this: T1pRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T1pRep): string {.noSideEffect.} =
  return "T1"

proc repChar*(this: T1pRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [3, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, 3,
                    - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, 3,
                    - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, 3,
                    - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: T1pRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[3, array[3, cdouble]] = [[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]]]
  var mats_im: ptr array[3, array[3, cdouble]] = [[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  T2pRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T2pRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T2pRep): cint {.noSideEffect.} =
  return 0

proc group*(this: T2pRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T2pRep): string {.noSideEffect.} =
  return "T2"

proc repChar*(this: T2pRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [3, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 3,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 3,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 3,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: T2pRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[3, array[3, cdouble]] = [[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]]]
  var mats_im: ptr array[3, array[3, cdouble]] = [[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  EpRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: EpRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: EpRep): cint {.noSideEffect.} =
  return 0

proc group*(this: EpRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: EpRep): string {.noSideEffect.} =
  return "E"

proc repChar*(this: EpRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [2, 2, 2, 2, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 2, 2,
                    2, 2, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2,
                    0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0,
                    0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: EpRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, - 1]], [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[1, 0], [0, 1]], [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, - 1]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[1, 0], [0, 1]], [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, - 1]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[1, 0], [0, 1]], [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, - 1]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats[elem - 1][i - 1][j - 1]), double(0))
      inc(j)
    inc(i)
  return mat

## ----------------------------------------------------------------------------------
##  Single cover cubic group irreps with parity

type
  A1mRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A1mRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A1mRep): cint {.noSideEffect.} =
  return 0

proc group*(this: A1mRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A1mRep): string {.noSideEffect.} =
  return "A1"

proc repChar*(this: A1mRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1,
                    - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1,
                    - 1, - 1, - 1, - 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: A1mRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  mat(1, 1) = repChar(elem)
  return mat

type
  A2mRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A2mRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A2mRep): cint {.noSideEffect.} =
  return 0

proc group*(this: A2mRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A2mRep): string {.noSideEffect.} =
  return "A2"

proc repChar*(this: A2mRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1,
                    - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1,
                    1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1,
                    - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 1, 1, 1,
                    1, 1, 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: A2mRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  mat(1, 1) = repChar(elem)
  return mat

type
  T1mRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T1mRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T1mRep): cint {.noSideEffect.} =
  return 0

proc group*(this: T1mRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T1mRep): string {.noSideEffect.} =
  return "T1"

proc repChar*(this: T1mRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [3, - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1,
                    - 3, 1, 1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 3,
                    - 1, - 1, - 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 3, 1,
                    1, 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: T1mRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[3, array[3, cdouble]] = [[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 1, 0, 0], [0, - 1, 0], [0, 0, - 1]], [[1, 0, 0], [0, - 1, 0], [0, 0, 1]],
      [[0, 0, 1], [0, 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [1 div sqrt(2), 0, - (1 div sqrt(2))],
      [- 0.5, 1 div sqrt(2), - 0.5]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [1 div sqrt(2), 0, - (1 div sqrt(2))],
      [0.5, - (1 div sqrt(2)), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 1 div sqrt(2), 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), - 0.5]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 1, 0, 0], [0, - 1, 0], [0, 0, - 1]], [[1, 0, 0], [0, - 1, 0], [0, 0, 1]],
      [[0, 0, 1], [0, 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [0, 0, 0], [0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [1 div sqrt(2), 0, - (1 div sqrt(2))],
      [- 0.5, 1 div sqrt(2), - 0.5]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), 0.5], [1 div sqrt(2), 0, - (1 div sqrt(2))],
      [0.5, - (1 div sqrt(2)), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 1 div sqrt(2), 0.5]]]
  var mats_im: ptr array[3, array[3, cdouble]] = [[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]],
      [[1, 0, 0], [0, 0, 0], [0, 0, - 1]], [[0, - (1 div sqrt(2)), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [[0, 1 div sqrt(2), 0],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, - (1 div sqrt(2)), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, 1 div sqrt(2), 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, - (1 div sqrt(2)), 0],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]],
      [[1, 0, 0], [0, 0, 0], [0, 0, - 1]], [[0, - (1 div sqrt(2)), 0],
                                  [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [[0, 1 div sqrt(2), 0],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, 0, 0.5]], [[0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 0, - 0.5]],
      [[- 0.5, 0, 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, 0, 0.5]],
      [[0.5, 0, - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 0, - 0.5]],
      [[- 0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), 0.5]], [
      [0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), 0.5]],
      [[0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, - (1 div sqrt(2)), 0],
                                  [1 div sqrt(2), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, 1 div sqrt(2), 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  T2mRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T2mRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T2mRep): cint {.noSideEffect.} =
  return 0

proc group*(this: T2mRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T2mRep): string {.noSideEffect.} =
  return "T2"

proc repChar*(this: T2mRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [3, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
                    - 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, 3,
                    - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, - 3, 1,
                    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: T2mRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[3, array[3, cdouble]] = [[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]], [[0, 0, 1], [0, - 1, 0], [1, 0, 0]],
      [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]],
      [[- 1, 0, 0], [0, - 1, 0], [0, 0, - 1]], [[1, 0, 0], [0, - 1, 0], [0, 0, 1]],
      [[0, 0, - 1], [0, 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
      [- 0.5, 1 div sqrt(2), 0.5]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, - (1 div sqrt(2)), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 1 div sqrt(2), - 0.5]],
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]], [[- 1, 0, 0], [0, 1, 0], [0, 0, - 1]],
      [[0, 0, 1], [0, - 1, 0], [1, 0, 0]], [[0, 0, - 1], [0, - 1, 0], [- 1, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]], [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [1 div sqrt(2), 0, 1 div sqrt(2)],
      [- 0.5, 1 div sqrt(2), 0.5]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [- 0.5, - (1 div sqrt(2)), 0.5]],
      [[- 1, 0, 0], [0, - 1, 0], [0, 0, - 1]], [[1, 0, 0], [0, - 1, 0], [0, 0, 1]],
      [[0, 0, - 1], [0, 1, 0], [- 1, 0, 0]], [[0, 0, 1], [0, 1, 0], [1, 0, 0]],
      [[0, 0, 0], [0, 1, 0], [0, 0, 0]], [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]],
      [[0.5, 0, 0.5], [0, 0, 0], [0.5, 0, 0.5]], [[0.5, - (1 div sqrt(2)), - 0.5],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))],
      [- 0.5, 1 div sqrt(2), 0.5]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, - (1 div sqrt(2)), 0], [0, 0, 0], [0, - (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2), 0], [0, 0, 0], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [1 div sqrt(2), 0, 1 div sqrt(2)], [0, 0, 0]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, - (1 div sqrt(2)), 0.5],
      [- (1 div sqrt(2)), 0, - (1 div sqrt(2))], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, 0], [0, - 1, 0], [0, 0, 0]],
      [[- 0.5, 0, - 0.5], [0, 0, 0], [- 0.5, 0, - 0.5]], [[- 0.5, 1 div sqrt(2), 0.5],
      [1 div sqrt(2), 0, 1 div sqrt(2)], [0.5, 1 div sqrt(2), - 0.5]]]
  var mats_im: ptr array[3, array[3, cdouble]] = [[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]],
      [[1, 0, 0], [0, 0, 0], [0, 0, - 1]], [[0, - (1 div sqrt(2)), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, 1 div sqrt(2), 0],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, - (1 div sqrt(2)), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, 1 div sqrt(2), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[1, 0, 0], [0, 0, 0], [0, 0, - 1]],
      [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]], [[0, 1 div sqrt(2), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, - (1 div sqrt(2)), 0]], [
      [0, - (1 div sqrt(2)), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]],
      [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [[0, 1 div sqrt(2), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [
      [0, - (1 div sqrt(2)), 0], [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[- 1, 0, 0], [0, 0, 0], [0, 0, 1]],
      [[1, 0, 0], [0, 0, 0], [0, 0, - 1]], [[0, - (1 div sqrt(2)), 0],
                                  [- (1 div sqrt(2)), 0, 1 div sqrt(2)],
                                  [0, 1 div sqrt(2), 0]], [[0, 1 div sqrt(2), 0],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0.5, 0, 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [1 div sqrt(2), 0, - (1 div sqrt(2))], [0.5, 0, 0.5]], [[0.5, 0, 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [- 0.5, 0, - 0.5]], [[- 0.5, 0, - 0.5],
      [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0.5, 0, 0.5]], [
      [0.5, - (1 div sqrt(2)), - 0.5], [0, 0, 0], [0.5, 1 div sqrt(2), - 0.5]], [
      [- 0.5, 1 div sqrt(2), 0.5], [0, 0, 0], [- 0.5, - (1 div sqrt(2)), 0.5]], [
      [0.5, 1 div sqrt(2), - 0.5], [0, 0, 0], [0.5, - (1 div sqrt(2)), - 0.5]], [
      [- 0.5, - (1 div sqrt(2)), 0.5], [0, 0, 0], [- 0.5, 1 div sqrt(2), 0.5]],
      [[0, 0, 1], [0, 0, 0], [- 1, 0, 0]], [[0, - (1 div sqrt(2)), 0],
                                  [1 div sqrt(2), 0, - (1 div sqrt(2))],
                                  [0, 1 div sqrt(2), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]], [[0, 0, - 1], [0, 0, 0], [1, 0, 0]], [
      [0, 1 div sqrt(2), 0], [- (1 div sqrt(2)), 0, 1 div sqrt(2)], [0, - (1 div sqrt(2)), 0]],
      [[0, 0, 0], [0, 0, 0], [0, 0, 0]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  EmRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: EmRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: EmRep): cint {.noSideEffect.} =
  return 0

proc group*(this: EmRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: EmRep): string {.noSideEffect.} =
  return "E"

proc repChar*(this: EmRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cint = [2, 2, 2, 2, 0, 0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, - 2,
                    - 2, - 2, - 2, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0,
                    0, 0, 0, 0, 0, - 1, - 1, - 1, - 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, - 2, - 2, - 2, - 2, 0,
                    0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: EmRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, - 1]], [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 1, 0], [0, - 1]], [[- 1, 0], [0, - 1]], [[- 1, 0], [0, - 1]],
                                        [[- 1, 0], [0, - 1]], [[- 1, 0], [0, 1]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, - 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]], [[0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), 0.5]], [[0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), 0.5]], [
      [0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), 0.5]], [[0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), 0.5]], [[0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]], [[0.5, - (sqrt(3) div 2.0)],
      [sqrt(3) div 2.0, 0.5]], [[0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, 1]], [[1, 0], [0, 1]],
                                        [[1, 0], [0, - 1]], [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [
      [- 0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
                                [- (sqrt(3) div 2.0), - 0.5]], [
      [- 0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), - 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), - 0.5]], [[1, 0], [0, - 1]], [[- 0.5, - (sqrt(3) div 2.0)],
      [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, 0.5]],
                                        [[1, 0], [0, - 1]], [
      [- 0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), 0.5]], [[- 0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, 0.5]], [[- 1, 0], [0, - 1]], [[- 1, 0], [0, - 1]], [[- 1, 0], [0, - 1]],
                                        [[- 1, 0], [0, - 1]], [[- 1, 0], [0, 1]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, sqrt(3) div 2.0], [sqrt(3) div 2.0, - 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]], [[0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), 0.5]], [[0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), 0.5]], [
      [0.5, sqrt(3) div 2.0], [- (sqrt(3) div 2.0), 0.5]], [[0.5, sqrt(3) div 2.0],
      [- (sqrt(3) div 2.0), 0.5]], [[0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]], [
      [0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]], [[0.5, - (sqrt(3) div 2.0)],
      [sqrt(3) div 2.0, 0.5]], [[0.5, - (sqrt(3) div 2.0)], [sqrt(3) div 2.0, 0.5]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]],
                                        [[- 1, 0], [0, 1]], [[0.5, sqrt(3) div 2.0],
      [sqrt(3) div 2.0, - 0.5]], [[0.5, - (sqrt(3) div 2.0)], [- (sqrt(3) div 2.0), - 0.5]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats[elem - 1][i - 1][j - 1]), double(0))
      inc(j)
    inc(i)
  return mat

## ----------------------------------------------------------------------------------
##  Double cover cubic group irreps with parity

type
  G1gRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G1gRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G1gRep): cint {.noSideEffect.} =
  return 0

proc group*(this: G1gRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G1gRep): string {.noSideEffect.} =
  return "G1"

proc repChar*(this: G1gRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [2, 0, 0, 0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0),
                       sqrt(2.0), sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 2,
                       0, 0, 0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0),
                       sqrt(2.0), sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0,
                       - 2, 0, 0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0),
                       - sqrt(2.0), - sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 2, 0,
                       0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0), - sqrt(2.0),
                       - sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: G1gRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[0, 0], [0, 0]],
      [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[1, 0], [0, 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]]]
  var mats_im: ptr array[2, array[2, cdouble]] = [[[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[- 1, 0], [0, 1]], [[0, 1], [1, 0]], [[0, 0], [0, 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[1, 0], [0, - 1]], [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[1, 0], [0, - 1]],
      [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  G2gRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G2gRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G2gRep): cint {.noSideEffect.} =
  return 0

proc group*(this: G2gRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G2gRep): string {.noSideEffect.} =
  return "G2"

proc repChar*(this: G2gRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [2, 0, 0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0),
                       - sqrt(2.0), - sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0,
                       2, 0, 0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0),
                       - sqrt(2.0), - sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0,
                       - 2, 0, 0, 0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0),
                       sqrt(2.0), sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 2, 0, 0,
                       0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0), sqrt(2.0),
                       sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: G2gRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[0, 0], [0, 0]],
      [[0, 0], [0, 0]], [[0, 1], [- 1, 0]], [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[1, 0], [0, 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]]]
  var mats_im: ptr array[2, array[2, cdouble]] = [[[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[1, 0], [0, - 1]],
      [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[1, 0], [0, - 1]], [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  HgRep* = object of CubicRep
  

const
  Size_t* = 4

proc dim*(this: HgRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: HgRep): cint {.noSideEffect.} =
  return 0

proc group*(this: HgRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: HgRep): string {.noSideEffect.} =
  return "H"

proc repChar*(this: HgRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 4, 0, 0,
                       0, 0, 0, 0, 0, 0, 0, 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 4, 0, 0, 0, 0, 0,
                       0, 0, 0, 0, - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, - 4, 0, 0, 0, 0, 0, 0,
                       0, 0, 0, - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: HgRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[4, array[4, cdouble]] = [
      [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 1], [0, 0, - 1, 0], [0, 1, 0, 0], [- 1, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 0,
      1 div (2.0 * sqrt(2)), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                        - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))]], [[
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                        - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))]], [[0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
                           [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [0.25, - (sqrt(3) div 4.0),
      - (sqrt(3) div 4.0), 0.25]], [[- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), - 0.25, - 0.25,
      - (sqrt(3) div 4.0)], [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0],
      [1 div sqrt(2), 0, 0, 0]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
                            [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), 0,
      sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 1], [0, 0, - 1, 0], [0, 1, 0, 0], [- 1, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 0,
      1 div (2.0 * sqrt(2)), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                        - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))]], [[
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                        - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))]], [[0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
                           [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [0.25, - (sqrt(3) div 4.0),
      - (sqrt(3) div 4.0), 0.25]], [[- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), - 0.25, - 0.25,
      - (sqrt(3) div 4.0)], [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0],
      [1 div sqrt(2), 0, 0, 0]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
                            [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), 0,
      sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, - 1], [0, 0, 1, 0], [0, - 1, 0, 0], [1, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[- (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                           1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]], [[- (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0),
                               - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)),
                           1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
      - (1 div (2.0 * sqrt(2)))]], [[- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25], [
      - (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), 0.25,
      - 0.25, sqrt(3) div 4.0], [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, - (1 div sqrt(2))],
      [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, - 1], [0, 0, 1, 0], [0, - 1, 0, 0], [1, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[- (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                           1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]], [[- (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0),
                               - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)),
                           1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
      - (1 div (2.0 * sqrt(2)))]], [[- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25], [
      - (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), 0.25,
      - 0.25, sqrt(3) div 4.0], [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, - (1 div sqrt(2))],
      [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]]
  var mats_im: ptr array[4, array[4, cdouble]] = [
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, - 1], [0, 0, - 1, 0], [0, - 1, 0, 0], [- 1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0], [0, - (1 div (2.0 * sqrt(2))), 0,
      - (sqrt(1.5) div 2.0)], [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0,
      1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
                        - (1 div (2.0 * sqrt(2)))]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                           - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, - 1], [0, 0, - 1, 0], [0, - 1, 0, 0], [- 1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0], [0, - (1 div (2.0 * sqrt(2))), 0,
      - (sqrt(1.5) div 2.0)], [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0,
      1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
                        - (1 div (2.0 * sqrt(2)))]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                           - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0, 1 div (2.0 * sqrt(2)), 0,
      sqrt(1.5) div 2.0], [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                             1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0,
                           - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                          - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0,
                        1 div (2.0 * sqrt(2))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0, 1 div (2.0 * sqrt(2)), 0,
      sqrt(1.5) div 2.0], [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                             1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0,
                           - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                          - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0,
                        1 div (2.0 * sqrt(2))]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  G1uRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G1uRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G1uRep): cint {.noSideEffect.} =
  return 0

proc group*(this: G1uRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G1uRep): string {.noSideEffect.} =
  return "G1"

proc repChar*(this: G1uRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [2, 0, 0, 0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0),
                       sqrt(2.0), sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0,
                       - 2, 0, 0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0),
                       - sqrt(2.0), - sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 2, 0,
                       0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0), - sqrt(2.0),
                       - sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
                       - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0), sqrt(2.0),
                       sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: G1uRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[0, 0], [0, 0]],
      [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[1, 0], [0, 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]]]
  var mats_im: ptr array[2, array[2, cdouble]] = [[[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[1, 0], [0, - 1]], [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[1, 0], [0, - 1]],
      [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  G2uRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: G2uRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: G2uRep): cint {.noSideEffect.} =
  return 0

proc group*(this: G2uRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: G2uRep): string {.noSideEffect.} =
  return "G2"

proc repChar*(this: G2uRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [2, 0, 0, 0, sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0),
                       - sqrt(2.0), - sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0,
                       - 2, 0, 0, 0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0),
                       sqrt(2.0), sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 2, 0, 0,
                       0, - sqrt(2.0), sqrt(2.0), - sqrt(2.0), - sqrt(2.0), sqrt(2.0),
                       sqrt(2.0), 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
                       sqrt(2.0), - sqrt(2.0), sqrt(2.0), sqrt(2.0), - sqrt(2.0),
                       - sqrt(2.0), - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: G2uRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[2, array[2, cdouble]] = [[[1, 0], [0, 1]], [[0, 0], [0, 0]],
      [[0, 0], [0, 0]], [[0, 1], [- 1, 0]], [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[- 1, 0], [0, - 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, - 1], [1, 0]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), - (1 div sqrt(2))], [1 div sqrt(2), 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0.5, - 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [0.5, 0.5]], [[0.5, - 0.5], [0.5, 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[0.5, 0.5], [- 0.5, 0.5]], [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[1, 0], [0, 1]],
      [[0, 0], [0, 0]], [[0, 0], [0, 0]], [[0, 1], [- 1, 0]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 0], [0, 1 div sqrt(2)]], [[- (1 div sqrt(2)), 1 div sqrt(2)],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[- (1 div sqrt(2)), - (1 div sqrt(2))],
                                        [1 div sqrt(2), - (1 div sqrt(2))]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [- 0.5, 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [1 div sqrt(2), 0]], [[0, 0], [0, 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]]]
  var mats_im: ptr array[2, array[2, cdouble]] = [[[0, 0], [0, 0]], [[- 1, 0], [0, 1]],
      [[0, 1], [1, 0]], [[0, 0], [0, 0]], [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]], [[0, 0], [0, 0]], [[1, 0], [0, - 1]],
      [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[1, 0], [0, - 1]], [[0, - 1], [- 1, 0]], [[0, 0], [0, 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[0.5, 0.5], [0.5, - 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0.5, - 0.5], [- 0.5, - 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[0.5, 0.5], [0.5, - 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]], [
      [- (1 div sqrt(2)), - (1 div sqrt(2))], [- (1 div sqrt(2)), 1 div sqrt(2)]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[- (1 div sqrt(2)), 1 div sqrt(2)], [1 div sqrt(2), 1 div sqrt(2)]], [[0, 0], [0, 0]],
      [[- 1, 0], [0, 1]], [[0, 1], [1, 0]], [[0, 0], [0, 0]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[1 div sqrt(2), 0], [0, - (1 div sqrt(2))]],
      [[0, 1 div sqrt(2)], [1 div sqrt(2), 0]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]], [[0, 0], [0, 0]], [[0, 0], [0, 0]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[- 0.5, 0.5], [0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[- 0.5, - 0.5], [- 0.5, 0.5]],
      [[- 0.5, 0.5], [0.5, 0.5]], [[0.5, - 0.5], [- 0.5, - 0.5]],
      [[- 0.5, - 0.5], [- 0.5, 0.5]], [[0.5, 0.5], [0.5, - 0.5]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]],
      [[1 div sqrt(2), 1 div sqrt(2)], [1 div sqrt(2), - (1 div sqrt(2))]],
      [[0, - (1 div sqrt(2))], [- (1 div sqrt(2)), 0]],
      [[- (1 div sqrt(2)), 0], [0, 1 div sqrt(2)]], [[1 div sqrt(2), - (1 div sqrt(2))],
      [- (1 div sqrt(2)), - (1 div sqrt(2))]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

type
  HuRep* = object of CubicRep
  

const
  Size_t* = 4

proc dim*(this: HuRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: HuRep): cint {.noSideEffect.} =
  return 0

proc group*(this: HuRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: HuRep): string {.noSideEffect.} =
  return "H"

proc repChar*(this: HuRep; elem: cint): complex[cdouble] {.noSideEffect.} =
  var chars: ptr cdouble = [4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, - 4, 0, 0,
                       0, 0, 0, 0, 0, 0, 0, - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, - 4, 0, 0, 0,
                       0, 0, 0, 0, 0, 0, - 1, 1, - 1, 1, - 1, - 1, - 1, - 1, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
                       0, 0, 0, 0, 0, 1, - 1, 1, - 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
  checkIndexLimit(elem, OhDim)
  return complex[cdouble](double(chars[elem - 1]), double(0))

proc repMatrix*(this: HuRep; elem: cint): Array2dO[complex[cdouble]] {.noSideEffect.} =
  checkIndexLimit(elem, OhDim)
  var mats_re: ptr array[4, array[4, cdouble]] = [
      [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 1], [0, 0, - 1, 0], [0, 1, 0, 0], [- 1, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 0,
      1 div (2.0 * sqrt(2)), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                        - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))]], [[
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                        - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))]], [[0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
                           [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [0.25, - (sqrt(3) div 4.0),
      - (sqrt(3) div 4.0), 0.25]], [[- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), - 0.25, - 0.25,
      - (sqrt(3) div 4.0)], [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0],
      [1 div sqrt(2), 0, 0, 0]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
                            [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), 0,
      sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, - 1], [0, 0, 1, 0], [0, - 1, 0, 0], [1, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[- (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                           1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]], [[- (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0),
                               - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)),
                           1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
      - (1 div (2.0 * sqrt(2)))]], [[- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25], [
      - (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), 0.25,
      - 0.25, sqrt(3) div 4.0], [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, - (1 div sqrt(2))],
      [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, - 1], [0, 0, 1, 0], [0, - 1, 0, 0], [1, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[- (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                           1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]], [[- (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0),
                               - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))),
      - (sqrt(1.5) div 2.0)], [- (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)),
                           1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
      - (1 div (2.0 * sqrt(2)))]], [[- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25], [
      - (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), 0.25,
      - 0.25, sqrt(3) div 4.0], [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, - (1 div sqrt(2))],
      [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 1], [0, 0, - 1, 0], [0, 1, 0, 0], [- 1, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 0,
      1 div (2.0 * sqrt(2)), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                        - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))]], [[
      1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                        - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))]], [[0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
                           [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [0.25, - (sqrt(3) div 4.0),
      - (sqrt(3) div 4.0), 0.25]], [[- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25], [
      sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)], [- (sqrt(3) div 4.0), - 0.25, - 0.25,
      - (sqrt(3) div 4.0)], [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, - (1 div sqrt(2)), 0], [0, 1 div sqrt(2), 0, 0],
      [1 div sqrt(2), 0, 0, 0]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
                            [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0,
      - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), 0,
      sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, 1 div sqrt(2), 0], [0, - (1 div sqrt(2)), 0, 0], [- (1 div sqrt(2)), 0, 0, 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]]
  var mats_im: ptr array[4, array[4, cdouble]] = [
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, - 1], [0, 0, - 1, 0], [0, - 1, 0, 0], [- 1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0], [0, - (1 div (2.0 * sqrt(2))), 0,
      - (sqrt(1.5) div 2.0)], [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0,
      1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
                        - (1 div (2.0 * sqrt(2)))]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                           - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0, 1 div (2.0 * sqrt(2)), 0,
      sqrt(1.5) div 2.0], [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                             1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0,
                           - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                          - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0,
                        1 div (2.0 * sqrt(2))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[- 1, 0, 0, 0], [0, 1, 0, 0], [0, 0, - 1, 0], [0, 0, 0, 1]],
      [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[1 div sqrt(2), 0, 0, 0],
      [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0], [0, 0, 0, - (1 div sqrt(2))]], [
      [1 div sqrt(2), 0, 0, 0], [0, 1 div sqrt(2), 0, 0], [0, 0, - (1 div sqrt(2)), 0],
      [0, 0, 0, - (1 div sqrt(2))]], [[0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))], [
      sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0], [0, 1 div (2.0 * sqrt(2)), 0,
      sqrt(1.5) div 2.0], [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]], [
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))],
      [- (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25],
      [sqrt(3) div 4.0, - 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), - 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))], [- (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))),
                             1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [- (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0,
                           - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2))]], [
      [0, 0, 0, - (1 div sqrt(2))], [0, 0, 1 div sqrt(2), 0], [0, 1 div sqrt(2), 0, 0],
      [- (1 div sqrt(2)), 0, 0, 0]], [[1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0], [0,
      1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0], [- (sqrt(1.5) div 2.0), 0,
      - (1 div (2.0 * sqrt(2))), 0], [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))]], [[
      - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0, - (sqrt(1.5) div 2.0),
      1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))),
                          - (1 div (2.0 * sqrt(2))), sqrt(1.5) div 2.0], [
      - (sqrt(1.5) div 2.0), - (1 div (2.0 * sqrt(2))), 1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), sqrt(1.5) div 2.0, sqrt(1.5) div 2.0,
                        1 div (2.0 * sqrt(2))]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[1, 0, 0, 0], [0, - 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, - 1]],
      [[0, 0, 0, - 1], [0, 0, - 1, 0], [0, - 1, 0, 0], [- 1, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[- (1 div sqrt(2)), 0, 0, 0],
      [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0], [0, 0, 0, 1 div sqrt(2)]], [
      [- (1 div sqrt(2)), 0, 0, 0], [0, - (1 div sqrt(2)), 0, 0], [0, 0, 1 div sqrt(2), 0],
      [0, 0, 0, 1 div sqrt(2)]], [[0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))], [
      - (sqrt(1.5) div 2.0), 0, - (1 div (2.0 * sqrt(2))), 0], [0, - (1 div (2.0 * sqrt(2))), 0,
      - (sqrt(1.5) div 2.0)], [1 div (2.0 * sqrt(2)), 0, - (sqrt(1.5) div 2.0), 0]], [
      [0, sqrt(1.5) div 2.0, 0, - (1 div (2.0 * sqrt(2)))],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, 1 div (2.0 * sqrt(2)), 0, sqrt(1.5) div 2.0],
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25],
      [sqrt(3) div 4.0, 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), 0.25]], [
      [- 0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, - 0.25],
      [- (sqrt(3) div 4.0), 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [- 0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, 0.25]], [
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25]], [
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25]], [
      [- 0.25, - (sqrt(3) div 4.0), - (sqrt(3) div 4.0), - 0.25],
      [sqrt(3) div 4.0, 0.25, - 0.25, - (sqrt(3) div 4.0)],
      [sqrt(3) div 4.0, - 0.25, - 0.25, sqrt(3) div 4.0],
      [- 0.25, sqrt(3) div 4.0, - (sqrt(3) div 4.0), 0.25]], [
      [0.25, sqrt(3) div 4.0, sqrt(3) div 4.0, 0.25],
      [- (sqrt(3) div 4.0), - 0.25, 0.25, sqrt(3) div 4.0],
      [- (sqrt(3) div 4.0), 0.25, 0.25, - (sqrt(3) div 4.0)],
      [0.25, - (sqrt(3) div 4.0), sqrt(3) div 4.0, - 0.25]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      sqrt(1.5) div 2.0, sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2))], [sqrt(1.5) div 2.0,
      1 div (2.0 * sqrt(2)), - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2))), - (1 div (2.0 * sqrt(2))),
      sqrt(1.5) div 2.0], [1 div (2.0 * sqrt(2)), - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0,
                        - (1 div (2.0 * sqrt(2)))]], [[0, 0, 0, 1 div sqrt(2)],
      [0, 0, - (1 div sqrt(2)), 0], [0, - (1 div sqrt(2)), 0, 0], [1 div sqrt(2), 0, 0, 0]], [
      [- (1 div (2.0 * sqrt(2))), 0, sqrt(1.5) div 2.0, 0],
      [0, - (1 div (2.0 * sqrt(2))), 0, - (sqrt(1.5) div 2.0)],
      [sqrt(1.5) div 2.0, 0, 1 div (2.0 * sqrt(2)), 0],
      [0, - (sqrt(1.5) div 2.0), 0, 1 div (2.0 * sqrt(2))]], [[1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0), sqrt(1.5) div 2.0, - (1 div (2.0 * sqrt(2)))], [
      - (sqrt(1.5) div 2.0), 1 div (2.0 * sqrt(2)), 1 div (2.0 * sqrt(2)),
      - (sqrt(1.5) div 2.0)], [sqrt(1.5) div 2.0, 1 div (2.0 * sqrt(2)),
                           - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0)], [
      - (1 div (2.0 * sqrt(2))), - (sqrt(1.5) div 2.0), - (sqrt(1.5) div 2.0),
      - (1 div (2.0 * sqrt(2)))]]]
  var mat: Array2dO[complex[cdouble]]
  mat.resize(dim(), dim())
  var i: cint = 1
  while i <= dim():
    var j: cint = 1
    while j <= dim():
      mat(i, j) = complex[cdouble](double(mats_re[elem - 1][i - 1][j - 1]),
                                double(mats_im[elem - 1][i - 1][j - 1]))
      inc(j)
    inc(i)
  return mat

## ----------------------------------------------------------------------------------
##  Single cover cubic group irreps with G-parity

type
  A1PRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A1PRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A1PRep): cint {.noSideEffect.} =
  return + 1

proc group*(this: A1PRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A1PRep): string {.noSideEffect.} =
  return "A1"

type
  A2PRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A2PRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A2PRep): cint {.noSideEffect.} =
  return + 1

proc group*(this: A2PRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A2PRep): string {.noSideEffect.} =
  return "A2"

type
  T1PRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T1PRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T1PRep): cint {.noSideEffect.} =
  return + 1

proc group*(this: T1PRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T1PRep): string {.noSideEffect.} =
  return "T1"

type
  T2PRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T2PRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T2PRep): cint {.noSideEffect.} =
  return + 1

proc group*(this: T2PRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T2PRep): string {.noSideEffect.} =
  return "T2"

type
  EPRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: EPRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: EPRep): cint {.noSideEffect.} =
  return + 1

proc group*(this: EPRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: EPRep): string {.noSideEffect.} =
  return "E"

## ----------------------------------------------------------------------------------
##  Single cover cubic group irreps with G-parity

type
  A1MRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A1MRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A1MRep): cint {.noSideEffect.} =
  return - 1

proc group*(this: A1MRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A1MRep): string {.noSideEffect.} =
  return "A1"

type
  A2MRep* = object of CubicRep
  

const
  Size_t* = 1

proc dim*(this: A2MRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: A2MRep): cint {.noSideEffect.} =
  return - 1

proc group*(this: A2MRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: A2MRep): string {.noSideEffect.} =
  return "A2"

type
  T1MRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T1MRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T1MRep): cint {.noSideEffect.} =
  return - 1

proc group*(this: T1MRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T1MRep): string {.noSideEffect.} =
  return "T1"

type
  T2MRep* = object of CubicRep
  

const
  Size_t* = 3

proc dim*(this: T2MRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: T2MRep): cint {.noSideEffect.} =
  return - 1

proc group*(this: T2MRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: T2MRep): string {.noSideEffect.} =
  return "T2"

type
  EMRep* = object of CubicRep
  

const
  Size_t* = 2

proc dim*(this: EMRep): cint {.noSideEffect.} =
  return Size_t

proc G*(this: EMRep): cint {.noSideEffect.} =
  return - 1

proc group*(this: EMRep): string {.noSideEffect.} =
  return "Oh"

proc rep*(this: EMRep): string {.noSideEffect.} =
  return "E"

##  namespace Hadron
