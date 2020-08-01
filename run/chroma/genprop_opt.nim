## Prop and matelem distillation

import propagator
import serializetools/serializexml
import tables
import xmltree
#import inline_meas


#------------------------------------------------------------------------------
type
  Displacements_t* = object
    mass_label*:    seq[seq[int]] 

  Contractions_t* = object
    num_vecs*:            int          ## yup
    mass_label*:          string       ## mass label
    decay_dir*:           int
    displacement_length*: int
    t_start*:             int          ## start time for all genprops
    Nt_forward*:          int          ## number steps forward, so  t_source + Nt_forward-1 is the last tslice
    num_tries*:           int
    fifo*:                seq[string]
    nodes_per_cn*:        int

  GenPropParam_t* = object
    LinkSmearing*:    XmlNode
    PropSources*:     seq[int]
    SinkSources*:     Table[int,seq[int]]
    Displacements*:   seq[seq[int]]
    Moms*:            seq[seq[int]]
    Contractions*:    Contractions_t
    Propagator*:      Propagator_t

  NamedObject_t* = object
    gauge_id*:        string
    colorvec_files*:  seq[string]
    dist_op_file*:    string

  GenPropOpt2DistillationParams_t* = object
    Name*:            string
    Frequency*:       int
    Param*:           GenPropParam_t
    NamedObject*:     NamedObject_t



proc newGenPropParams*(LinkSmearing: XmlNode, 
                       PropSources: seq[int], 
                       SinkSources: Table[int,seq[int]],
                       Displacements: seq[seq[int]],
                       Moms: seq[seq[int]],
                       Contractions: Contractions_t,
                       Propagator: Propagator_t): GenPropParam_t =
    ## Genprop params
    return GenPropParam_t(LinkSmearing: LinkSmearing,
                          PropSources: PropSources,
                          SinkSources: SinkSources,
                          Displacements: Displacements,
                          Moms: Moms,
                          Contractions: Contractions,
                          Propagator: Propagator)

proc newGenPropOptDistillation*(Param: GenPropParam_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(GenPropOpt2DistillationParams_t(Name: "UNSMEARED_HADRON_NODE_DISTILLATION_HAROM_OPT2", 
                                                      Frequency: 1, 
                                                      Param: Param, 
                                                      NamedObject: NamedObject))



