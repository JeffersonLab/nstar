## Hadron N-point correlators

import
  hadron_sun_npart_irrep, serializetools/array1d, hashes

#----------------------------------------------------------------------------
# Key for HadronSUN NPt correlator
type
  KeyHadronSUNNPartNPtCorr_t*  = object
    NPoint*:    Array1dO[NPoint_t]        ## Each time-slice of an n-point function 
  
  NPoint_t* = object
    t_slice*:   cint                      ## This time-slice. If negative, then varies 
    Irrep*:     KeyHadronSUNNPartIrrep_t  ## Holds each of the operators projected into irreps 


proc hash*(x: NPoint_T|KeyHadronSUNNPartNPtCorr_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h

