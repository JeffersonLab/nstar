##  Unsmeared meson elementals

import serializetools/serializebin, serializetools/serialstring, serializetools/array3d
import hashes, complex


## ----------------------------------------------------------------------------
## Unsmeared meson operator
type
  KeyUnsmearedMesonElementalOperator_t* = object
    t_sink*: cint              ## !< Time sink
    t_slice*: cint             ## !< Meson operator time slice
    t_source*: cint            ## !< Time source
    colorvec_src*: cint        ## !< Colorvec source component
    gamma*: cint               ## !< The "gamma" in Gamma(gamma)
    derivP*: bool              ## !< Uses derivatives
    displacement*: seq[cint]   ## !< Displacement dirs of right colorvector
    mom*: array[0..2,cint]     ## !< D-1 momentum of this operator
    mass*: SerialString        ## A mass label

  ValUnsmearedMesonElementalOperator_t* = object
    op*: Array3d[Complex64]    ## Colorvector source and spin sink

proc hash*(x: KeyUnsmearedMesonElementalOperator_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
    # Finish the hash.
    result = !$h

    
