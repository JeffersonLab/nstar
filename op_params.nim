## Some layout functions
## 

## ----------------------------------------------------------------------------
## ! Lattice layout

type
  Layout_t* = object
    latt_size*: array[4,int]  ## !< Total lattice size
    decay_dir*: cint          ## !< The decay direction within the lattice
  

