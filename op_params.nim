## Some layout functions
## 

## ----------------------------------------------------------------------------
## ! Lattice layout

type
  Layout_t* = object
    lattSize*: array[4,int]  ## !< Total lattice size
    decayDir*: cint          ## !< The decay direction within the lattice
  

