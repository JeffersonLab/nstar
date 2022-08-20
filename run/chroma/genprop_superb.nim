## Prop and matelem distillation

import propagator
import serializetools/serializexml
import tables
import xmltree

#------------------------------------------------------------------------------
type Mom_t = array[0..2,int]    ## shorthand


type
  DispGammaMom_t* = object
    gamma*:           int         ## The gamma matrix for this  displacement
    displacement*:    seq[int]    ## The displacement path for this gamma
    mom*:             Mom_t       ## Array of momenta to generate 

  SinkSource_t* = object
    t_sink*:          int         ## Time slice for sinks
    t_source*:        int         ## Time slice source for props
    Nt_backward*:     int         ## Backward relative to source
    Nt_forward*:      int         ## Forward relative to source


type
  Contractions_t* = object
    use_derivP*:          bool
    num_vecs*:            int          ## yup
    mass_label*:          string       ## mass label
    decay_dir*:           int
    displacement_length*: int
    t_start*:             int          ## start time for all genprops
#    Nt_forward*:          int          ## number steps forward, so  t_source + Nt_forward-1 is the last tslice
    num_tries*:           int
    max_rhs*:                         int
    max_tslices_in_contraction*:      int
    max_moms_in_contraction*:         int
    use_genprop4_format*:             bool
    use_device_for_contractions*:     bool

  GenPropParam_t* = object
    LinkSmearing*:     XmlNode
    SinkSourcePairs*:  seq[SinkSource_t]
    DispGammaMomList*: seq[DispGammaMom_t]
    Contractions*:     Contractions_t
    Propagator*:       Propagator_t

  NamedObject_t* = object
    gauge_id*:        string
    colorvec_files*:  seq[string]
    dist_op_file*:    string

  GenPropOpt2DistillationParams_t* = object
    Name*:            string
    Frequency*:       int
    Param*:           GenPropParam_t
    NamedObject*:     NamedObject_t


proc newGenPropSuperbDistillation*(Param: GenPropParam_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(GenPropOpt2DistillationParams_t(Name: "UNSMEARED_HADRON_NODE_DISTILLATION_SUPERB", 
                                                      Frequency: 1, 
                                                      Param: Param, 
                                                      NamedObject: NamedObject))



