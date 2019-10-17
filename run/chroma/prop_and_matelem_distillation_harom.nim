## Prop and matelem distillation

import propagator
import serializetools/serializexml
import xmltree
import inline_meas


#------------------------------------------------------------------------------
type
  Contractions_t* = object
    mass_label*:    string       ## mass label
    num_vecs*:      int          ## yup
    t_sources*:     seq[int]     ## these are the true time sources
    Nt_forward*:    int          ## number steps forward, so  t_source + Nt_forward
    Nt_backward*:   int
    decay_dir*:     int
    num_tries*:     int
    fifo*:          seq[string]

  DistParams_t* = object
    Contractions*:    Contractions_t
    Propagator*:      Propagator_t

  NamedObject_t* = object
    gauge_id*:        string
    colorvec_files*:  seq[string]
    prop_op_file*:    string

  PropAndMatelemDistillationHaromParams_t* = object
    Name*:            string
    Frequency*:       int
    Param*:           DistParams_t
    NamedObject*:     NamedObject_t



proc newPropAndMatelemDistillationHarom*(Param: DistParams_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(PropAndMatelemDistillationHaromParams_t(Name: "PROP_AND_MATELEM_DISTILLATION_HAROM", 
                                                         Frequency: 1, 
                                                         Param: Param, 
                                                         NamedObject: NamedObject))



