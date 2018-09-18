## Cubic group irreps
## 

import
  complex, irrep_util, serializetools/array1d

## ----------------------------------------------------------------------------------
## Cubic group base class
type
  CubicRep* = object of RootObj
  

#proc dim*(this: CubicRep): cint
#proc G*(this: CubicRep): cint
#proc group*(this: CubicRep): string
#proc rep*(this: CubicRep): string
#proc repChar*(this: CubicRep; elem: cint): Complex =
#  ## Character for group element
#  quit("ERROR: havenot implemented repChar in CubicRep " & rep(this))

#proc repMatrix*(this: CubicRep; elem: cint): Array2dO[Complex] =
#  ## Representation matrix for group element
#  quit("ERROR: have not implemented repMatrix in CubicRep " & rep(this))

## ----------------------------------------------------------------------------------
##  LG irreps have some more structure
type
  CubicLGRep* = object of CubicRep
  
#proc dim*(this: CubicLGRep): cint
#proc G*(this: CubicLGRep): cint
#proc group*(this: CubicLGRep): string
#proc rep*(this: CubicLGRep): string


## ----------------------------------------------------------------------------------
##  Helicity irreps also have a helicity label
type
  CubicHelicityRep* = object of CubicLGRep

#proc dim*(this: CubicHelicityRep): cint
#proc G*(this: CubicHelicityRep): cint
#proc group*(this: CubicHelicityRep): string
#proc rep*(this: CubicHelicityRep): string
#proc twoHelicity*(this: CubicHelicityRep): cint
#proc helicityRep*(this: CubicHelicityRep): string
