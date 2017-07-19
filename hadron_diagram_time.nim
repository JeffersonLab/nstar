## Diagram time-slice info

import serializetools/array1d, hashes

#----------------------------------------------------------------------------
# Active time slices for a correlator
type
  HadronDiagramTimeSlices_t* = object
    Nt_corr*:          cint           ## Length of correlator 
    t_start*:          cint           ## Starting time-slice value. Beware of wrap-around. 
    t_end*:            cint           ## Ending time-slice value. Beware of wrap-around. 
    neg_slice_npt*:    cint           ## The N-pt value with the negative time-slice 
    source_slice_npt*: cint           ## Reference N-pt value that will be the source 
    t_slices*:         Array1dO[cint] ## The fixed time-slices for all the graph   [npt -> t_slice] 
  

proc newHadronDiagramTimeSlices_t*(): HadronDiagramTimeSlices_t =
  result.Nt_corr          = 0
  result.t_start          = -1
  result.t_end            = -1
  result.neg_slice_npt    = -1
  result.source_slice_npt = -1


proc hash*(x: HadronDiagramTimeSlices_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h
