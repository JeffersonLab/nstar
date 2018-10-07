## Cubic group helicity

import
  irreps_cubic

## ----------------------------------------------------------------------------------
##  Single cover little group irreps
##  Dic_4

type
  H0D4A1Rep* = object of CubicHelicityRep


proc twoHelicity*(this: H0D4A1Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D4A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D4A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D4A1Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H0D4A1Rep): string {.noSideEffect.} =
  return "D4A1"

proc helicityRep*(this: H0D4A1Rep): string {.noSideEffect.} =
  return "H0D4A1"


type
  H0D4A2Rep* = object of CubicHelicityRep

proc twoHelicity*(this: H0D4A2Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D4A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D4A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D4A2Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H0D4A2Rep): string {.noSideEffect.} =
  return "D4A2"

proc helicityRep*(this: H0D4A2Rep): string {.noSideEffect.} =
  return "H0D4A2"

type
  H1o2D4E1Rep* = object of CubicHelicityRep
  
proc twoHelicity*(this: H1o2D4E1Rep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H1o2D4E1Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1o2D4E1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1o2D4E1Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H1o2D4E1Rep): string {.noSideEffect.} =
  return "D4E1"

proc helicityRep*(this: H1o2D4E1Rep): string {.noSideEffect.} =
  return "H1o2D4E1"

type
  H1D4E2Rep* = object of CubicHelicityRep
  
proc twoHelicity*(this: H1D4E2Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1D4E2Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1D4E2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1D4E2Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H1D4E2Rep): string {.noSideEffect.} =
  return "D4E2"

proc helicityRep*(this: H1D4E2Rep): string {.noSideEffect.} =
  return "H1D4E2"

type
  H3o2D4E3Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2D4E3Rep): cint {.noSideEffect.} =
  return 3

proc dim*(this: H3o2D4E3Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H3o2D4E3Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3o2D4E3Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H3o2D4E3Rep): string {.noSideEffect.} =
  return "D4E3"

proc helicityRep*(this: H3o2D4E3Rep): string {.noSideEffect.} =
  return "H3o2D4E3"

type
  H2D4B1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2D4B1Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2D4B1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2D4B1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2D4B1Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H2D4B1Rep): string {.noSideEffect.} =
  return "D4B1"

proc helicityRep*(this: H2D4B1Rep): string {.noSideEffect.} =
  return "H2D4B1"

type
  H2D4B2Rep* = object of CubicHelicityRep
  
proc twoHelicity*(this: H2D4B2Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2D4B2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2D4B2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2D4B2Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H2D4B2Rep): string {.noSideEffect.} =
  return "D4B2"

proc helicityRep*(this: H2D4B2Rep): string {.noSideEffect.} =
  return "H2D4B2"

type
  H5o2D4E3Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H5o2D4E3Rep): cint {.noSideEffect.} =
  return 5

proc dim*(this: H5o2D4E3Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H5o2D4E3Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H5o2D4E3Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H5o2D4E3Rep): string {.noSideEffect.} =
  return "D4E3"

proc helicityRep*(this: H5o2D4E3Rep): string {.noSideEffect.} =
  return "H5o2D4E3"

type
  H3D4E2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3D4E2Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3D4E2Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H3D4E2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3D4E2Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H3D4E2Rep): string {.noSideEffect.} =
  return "D4E2"

proc helicityRep*(this: H3D4E2Rep): string {.noSideEffect.} =
  return "H3D4E2"

type
  H7o2D4E1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H7o2D4E1Rep): cint {.noSideEffect.} =
  return 7

proc dim*(this: H7o2D4E1Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H7o2D4E1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H7o2D4E1Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H7o2D4E1Rep): string {.noSideEffect.} =
  return "D4E1"

proc helicityRep*(this: H7o2D4E1Rep): string {.noSideEffect.} =
  return "H7o2D4E1"

type
  H4D4A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4D4A1Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4D4A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4D4A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4D4A1Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H4D4A1Rep): string {.noSideEffect.} =
  return "D4A1"

proc helicityRep*(this: H4D4A1Rep): string {.noSideEffect.} =
  return "H4D4A1"

type
  H4D4A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4D4A2Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4D4A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4D4A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4D4A2Rep): string {.noSideEffect.} =
  return "D4"

proc rep*(this: H4D4A2Rep): string {.noSideEffect.} =
  return "D4A2"

proc helicityRep*(this: H4D4A2Rep): string {.noSideEffect.} =
  return "H4D4A2"

##  Dic_3

type
  H0D3A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0D3A1Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D3A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D3A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D3A1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H0D3A1Rep): string {.noSideEffect.} =
  return "D3A1"

proc helicityRep*(this: H0D3A1Rep): string {.noSideEffect.} =
  return "H0D3A1"

type
  H0D3A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0D3A2Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D3A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D3A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D3A2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H0D3A2Rep): string {.noSideEffect.} =
  return "D3A2"

proc helicityRep*(this: H0D3A2Rep): string {.noSideEffect.} =
  return "H0D3A2"

type
  H1o2D3E1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1o2D3E1Rep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H1o2D3E1Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1o2D3E1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1o2D3E1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H1o2D3E1Rep): string {.noSideEffect.} =
  return "D4E1"

proc helicityRep*(this: H1o2D3E1Rep): string {.noSideEffect.} =
  return "H1o2D4E1"

type
  H1D3E2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1D3E2Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1D3E2Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1D3E2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1D3E2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H1D3E2Rep): string {.noSideEffect.} =
  return "D3E2"

proc helicityRep*(this: H1D3E2Rep): string {.noSideEffect.} =
  return "H1D3E2"

type
  H3o2D3B1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2D3B1Rep): cint {.noSideEffect.} =
  return 3

proc dim*(this: H3o2D3B1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3o2D3B1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3o2D3B1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H3o2D3B1Rep): string {.noSideEffect.} =
  return "D3B1"

proc helicityRep*(this: H3o2D3B1Rep): string {.noSideEffect.} =
  return "H3o2D3B1"

type
  H3o2D3B2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2D3B2Rep): cint {.noSideEffect.} =
  return 3

proc dim*(this: H3o2D3B2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3o2D3B2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3o2D3B2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H3o2D3B2Rep): string {.noSideEffect.} =
  return "D3B2"

proc helicityRep*(this: H3o2D3B2Rep): string {.noSideEffect.} =
  return "H3o2D3B2"

type
  H2D3E2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2D3E2Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2D3E2Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H2D3E2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2D3E2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H2D3E2Rep): string {.noSideEffect.} =
  return "D3E2"

proc helicityRep*(this: H2D3E2Rep): string {.noSideEffect.} =
  return "H2D3E2"

type
  H5o2D3E1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H5o2D3E1Rep): cint {.noSideEffect.} =
  return 5

proc dim*(this: H5o2D3E1Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H5o2D3E1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H5o2D3E1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H5o2D3E1Rep): string {.noSideEffect.} =
  return "D3E1"

proc helicityRep*(this: H5o2D3E1Rep): string {.noSideEffect.} =
  return "H5o2D3E1"

type
  H3D3A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3D3A1Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3D3A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3D3A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3D3A1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H3D3A1Rep): string {.noSideEffect.} =
  return "D3A1"

proc helicityRep*(this: H3D3A1Rep): string {.noSideEffect.} =
  return "H3D3A1"

type
  H3D3A2Rep* = object of CubicHelicityRep
  
proc twoHelicity*(this: H3D3A2Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3D3A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3D3A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3D3A2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H3D3A2Rep): string {.noSideEffect.} =
  return "D3A2"

proc helicityRep*(this: H3D3A2Rep): string {.noSideEffect.} =
  return "H3D3A2"

type
  H7o2D3E1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H7o2D3E1Rep): cint {.noSideEffect.} =
  return 7

proc dim*(this: H7o2D3E1Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H7o2D3E1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H7o2D3E1Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H7o2D3E1Rep): string {.noSideEffect.} =
  return "D3E1"

proc helicityRep*(this: H7o2D3E1Rep): string {.noSideEffect.} =
  return "H7o2D3E1"

type
  H4D3E2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4D3E2Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4D3E2Rep): cint {.noSideEffect.} =
  return 2

proc G*(this: H4D3E2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4D3E2Rep): string {.noSideEffect.} =
  return "D3"

proc rep*(this: H4D3E2Rep): string {.noSideEffect.} =
  return "D3E2"

proc helicityRep*(this: H4D3E2Rep): string {.noSideEffect.} =
  return "H4D3E2"

##  Dic_2

type
  H0D2A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0D2A1Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D2A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D2A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D2A1Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H0D2A1Rep): string {.noSideEffect.} =
  return "D2A1"

proc helicityRep*(this: H0D2A1Rep): string {.noSideEffect.} =
  return "H0D2A1"

type
  H0D2A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0D2A2Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0D2A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0D2A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0D2A2Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H0D2A2Rep): string {.noSideEffect.} =
  return "D2A2"

proc helicityRep*(this: H0D2A2Rep): string {.noSideEffect.} =
  return "H0D2A2"

type
  H1o2D2ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1o2D2ERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H1o2D2ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1o2D2ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1o2D2ERep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H1o2D2ERep): string {.noSideEffect.} =
  return "D2E"

proc helicityRep*(this: H1o2D2ERep): string {.noSideEffect.} =
  return "H1o2D2E"

type
  H1D2B1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1D2B1Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1D2B1Rep): cint {.noSideEffect.} =
  return 1
  
proc G*(this: H1D2B1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1D2B1Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H1D2B1Rep): string {.noSideEffect.} =
  return "D2B1"

proc helicityRep*(this: H1D2B1Rep): string {.noSideEffect.} =
  return "H1D2B1"

type
  H1D2B2Rep* = object of CubicHelicityRep
  
proc twoHelicity*(this: H1D2B2Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1D2B2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H1D2B2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1D2B2Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H1D2B2Rep): string {.noSideEffect.} =
  return "D2B2"

proc helicityRep*(this: H1D2B2Rep): string {.noSideEffect.} =
  return "H1D2B2"

type
  H3o2D2ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2D2ERep): cint {.noSideEffect.} =
  return 3

proc dim*(this: H3o2D2ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H3o2D2ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3o2D2ERep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H3o2D2ERep): string {.noSideEffect.} =
  return "D2E"

proc helicityRep*(this: H3o2D2ERep): string {.noSideEffect.} =
  return "H3o2D2E"

type
  H2D2A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2D2A1Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2D2A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2D2A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2D2A1Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H2D2A1Rep): string {.noSideEffect.} =
  return "D2A1"

proc helicityRep*(this: H2D2A1Rep): string {.noSideEffect.} =
  return "H2D2A1"

type
  H2D2A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2D2A2Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2D2A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2D2A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2D2A2Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H2D2A2Rep): string {.noSideEffect.} =
  return "D2A2"

proc helicityRep*(this: H2D2A2Rep): string {.noSideEffect.} =
  return "H2D2A2"

type
  H5o2D2ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H5o2D2ERep): cint {.noSideEffect.} =
  return 5

proc dim*(this: H5o2D2ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H5o2D2ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H5o2D2ERep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H5o2D2ERep): string {.noSideEffect.} =
  return "D2E"

proc helicityRep*(this: H5o2D2ERep): string {.noSideEffect.} =
  return "H5o2D2E"

type
  H3D2B1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3D2B1Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3D2B1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3D2B1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3D2B1Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H3D2B1Rep): string {.noSideEffect.} =
  return "D2B1"

proc helicityRep*(this: H3D2B1Rep): string {.noSideEffect.} =
  return "H3D2B1"

type
  H3D2B2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3D2B2Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3D2B2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3D2B2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3D2B2Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H3D2B2Rep): string {.noSideEffect.} =
  return "D2B2"

proc helicityRep*(this: H3D2B2Rep): string {.noSideEffect.} =
  return "H3D2B2"

type
  H7o2D2ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H7o2D2ERep): cint {.noSideEffect.} =
  return 7

proc dim*(this: H7o2D2ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H7o2D2ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H7o2D2ERep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H7o2D2ERep): string {.noSideEffect.} =
  return "D2E"

proc helicityRep*(this: H7o2D2ERep): string {.noSideEffect.} =
  return "H7o2D2E"

type
  H4D2A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4D2A1Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4D2A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4D2A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4D2A1Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H4D2A1Rep): string {.noSideEffect.} =
  return "D2A1"

proc helicityRep*(this: H4D2A1Rep): string {.noSideEffect.} =
  return "H4D2A1"

type
  H4D2A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4D2A2Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4D2A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4D2A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4D2A2Rep): string {.noSideEffect.} =
  return "D2"

proc rep*(this: H4D2A2Rep): string {.noSideEffect.} =
  return "D2A2"

proc helicityRep*(this: H4D2A2Rep): string {.noSideEffect.} =
  return "H4D2A2"

##  C_4 (nm0)

type
  H0C4nm0A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0C4nm0A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H0C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0A1"

proc helicityRep*(this: H0C4nm0A1Rep): string {.noSideEffect.} =
  return "H0C4nm0A1"

type
  H0C4nm0A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0C4nm0A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H0C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0A2"

proc helicityRep*(this: H0C4nm0A2Rep): string {.noSideEffect.} =
  return "H0C4nm0A2"

type
  H1o2C4nm0ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1o2C4nm0ERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H1o2C4nm0ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1o2C4nm0ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H1o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0E"

proc helicityRep*(this: H1o2C4nm0ERep): string {.noSideEffect.} =
  return "H1o2C4nm0E"

type
  H1C4nm0A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1C4nm0A1Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1C4nm0A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H1C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H1C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0A1"

proc helicityRep*(this: H1C4nm0A1Rep): string {.noSideEffect.} =
  return "H1C4nm0A1"

type
  H1C4nm0A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1C4nm0A2Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1C4nm0A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H1C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H1C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0A2"

proc helicityRep*(this: H1C4nm0A2Rep): string {.noSideEffect.} =
  return "H1C4nm0A2"

type
  H3o2C4nm0ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2C4nm0ERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H3o2C4nm0ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H3o2C4nm0ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H3o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0E"

proc helicityRep*(this: H3o2C4nm0ERep): string {.noSideEffect.} =
  return "H3o2C4nm0E"

type
  H2C4nm0A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2C4nm0A1Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2C4nm0A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H2C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0A1"

proc helicityRep*(this: H2C4nm0A1Rep): string {.noSideEffect.} =
  return "H2C4nm0A1"

type
  H2C4nm0A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2C4nm0A2Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2C4nm0A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H2C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0A2"

proc helicityRep*(this: H2C4nm0A2Rep): string {.noSideEffect.} =
  return "H2C4nm0A2"

type
  H5o2C4nm0ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H5o2C4nm0ERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H5o2C4nm0ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H5o2C4nm0ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H5o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H5o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0E"

proc helicityRep*(this: H5o2C4nm0ERep): string {.noSideEffect.} =
  return "H5o2C4nm0E"

type
  H3C4nm0A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3C4nm0A1Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3C4nm0A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H3C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0A1"

proc helicityRep*(this: H3C4nm0A1Rep): string {.noSideEffect.} =
  return "H3C4nm0A1"

type
  H3C4nm0A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3C4nm0A2Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3C4nm0A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H3C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0A2"

proc helicityRep*(this: H3C4nm0A2Rep): string {.noSideEffect.} =
  return "H3C4nm0A2"

type
  H7o2C4nm0ERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H7o2C4nm0ERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H7o2C4nm0ERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H7o2C4nm0ERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H7o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H7o2C4nm0ERep): string {.noSideEffect.} =
  return "C4nm0E"

proc helicityRep*(this: H7o2C4nm0ERep): string {.noSideEffect.} =
  return "H7o2C4nm0E"

type
  H4C4nm0A1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4C4nm0A1Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4C4nm0A1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4C4nm0A1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H4C4nm0A1Rep): string {.noSideEffect.} =
  return "C4nm0A1"

proc helicityRep*(this: H4C4nm0A1Rep): string {.noSideEffect.} =
  return "H4C4nm0A1"

type
  H4C4nm0A2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4C4nm0A2Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4C4nm0A2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4C4nm0A2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0"

proc rep*(this: H4C4nm0A2Rep): string {.noSideEffect.} =
  return "C4nm0A2"

proc helicityRep*(this: H4C4nm0A2Rep): string {.noSideEffect.} =
  return "H4C4nm0A2"

##  C_4 (nnm)

type
  H0C4nnmA1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0C4nnmA1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H0C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnmA1"

proc helicityRep*(this: H0C4nnmA1Rep): string {.noSideEffect.} =
  return "H0C4nnmA1"

type
  H0C4nnmA2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H0C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc dim*(this: H0C4nnmA2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H0C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H0C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H0C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnmA2"

proc helicityRep*(this: H0C4nnmA2Rep): string {.noSideEffect.} =
  return "H0C4nnmA2"

type
  H1o2C4nnmERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1o2C4nnmERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H1o2C4nnmERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H1o2C4nnmERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H1o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnmE"

proc helicityRep*(this: H1o2C4nnmERep): string {.noSideEffect.} =
  return "H1o2C4nnmE"

type
  H1C4nnmA1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1C4nnmA1Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1C4nnmA1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H1C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H1C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnmA1"

proc helicityRep*(this: H1C4nnmA1Rep): string {.noSideEffect.} =
  return "H1C4nnmA1"

type
  H1C4nnmA2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H1C4nnmA2Rep): cint {.noSideEffect.} =
  return 2

proc dim*(this: H1C4nnmA2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H1C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H1C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H1C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnmA2"

proc helicityRep*(this: H1C4nnmA2Rep): string {.noSideEffect.} =
  return "H1C4nnmA2"

type
  H3o2C4nnmERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3o2C4nnmERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H3o2C4nnmERep): cint {.noSideEffect.} =
  return 2

proc group*(this: H3o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H3o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnmE"

proc helicityRep*(this: H3o2C4nnmERep): string {.noSideEffect.} =
  return "H3o2C4nnmE"

type
  H2C4nnmA1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2C4nnmA1Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2C4nnmA1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H2C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnmA1"

proc helicityRep*(this: H2C4nnmA1Rep): string {.noSideEffect.} =
  return "H2C4nnmA1"

type
  H2C4nnmA2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H2C4nnmA2Rep): cint {.noSideEffect.} =
  return 4

proc dim*(this: H2C4nnmA2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H2C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H2C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H2C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnmA2"

proc helicityRep*(this: H2C4nnmA2Rep): string {.noSideEffect.} =
  return "H2C4nnmA2"

type
  H5o2C4nnmERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H5o2C4nnmERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H5o2C4nnmERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H5o2C4nnmERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H5o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H5o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnmE"

proc helicityRep*(this: H5o2C4nnmERep): string {.noSideEffect.} =
  return "H5o2C4nnmE"

type
  H3C4nnmA1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3C4nnmA1Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3C4nnmA1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H3C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnmA1"

proc helicityRep*(this: H3C4nnmA1Rep): string {.noSideEffect.} =
  return "H3C4nnmA1"

type
  H3C4nnmA2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H3C4nnmA2Rep): cint {.noSideEffect.} =
  return 6

proc dim*(this: H3C4nnmA2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H3C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H3C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H3C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnmA2"

proc helicityRep*(this: H3C4nnmA2Rep): string {.noSideEffect.} =
  return "H3C4nnmA2"

type
  H7o2C4nnmERep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H7o2C4nnmERep): cint {.noSideEffect.} =
  return 1

proc dim*(this: H7o2C4nnmERep): cint {.noSideEffect.} =
  return 2

proc G*(this: H7o2C4nnmERep): cint {.noSideEffect.} =
  return 0

proc group*(this: H7o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H7o2C4nnmERep): string {.noSideEffect.} =
  return "C4nnmE"

proc helicityRep*(this: H7o2C4nnmERep): string {.noSideEffect.} =
  return "H7o2C4nnmE"

type
  H4C4nnmA1Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4C4nnmA1Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4C4nnmA1Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4C4nnmA1Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H4C4nnmA1Rep): string {.noSideEffect.} =
  return "C4nnmA1"

proc helicityRep*(this: H4C4nnmA1Rep): string {.noSideEffect.} =
  return "H4C4nnmA1"

type
  H4C4nnmA2Rep* = object of CubicHelicityRep
  

proc twoHelicity*(this: H4C4nnmA2Rep): cint {.noSideEffect.} =
  return 8

proc dim*(this: H4C4nnmA2Rep): cint {.noSideEffect.} =
  return 1

proc G*(this: H4C4nnmA2Rep): cint {.noSideEffect.} =
  return 0

proc group*(this: H4C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnm"

proc rep*(this: H4C4nnmA2Rep): string {.noSideEffect.} =
  return "C4nnmA2"

proc helicityRep*(this: H4C4nnmA2Rep): string {.noSideEffect.} =
  return "H4C4nnmA2"

##  namespace Hadron
