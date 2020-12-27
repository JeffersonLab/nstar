## Prop and matelem distillation

import propagator
import serializetools/serializexml
import tables
import xmltree

#------------------------------------------------------------------------------
type Mom_t = array[0..2,int]    ## shorthand

type
  Contractions_t* = object
    num_vecs*:            int          ## yup
    mass_label*:          string       ## mass label
    decay_dir*:           int
    displacement_length*: int
    t_start*:             int          ## start time for all genprops
    Nt_forward*:          int          ## number steps forward, so  t_source + Nt_forward-1 is the last tslice
    num_tries*:           int
    ts_per_node*:         int
    nodes_per_cn*:        int

  GenPropParam_t* = object
    LinkSmearing*:    XmlNode
    PropSources*:     seq[int]
    SinkSources*:     Table[int,seq[int]]
    Displacements*:   seq[seq[int]]
    Moms*:            seq[Mom_t]
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


proc newGenPropOptDistillation*(Param: GenPropParam_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(GenPropOpt2DistillationParams_t(Name: "UNSMEARED_HADRON_NODE_DISTILLATION_HAROM_OPT3", 
                                                      Frequency: 1, 
                                                      Param: Param, 
                                                      NamedObject: NamedObject))



