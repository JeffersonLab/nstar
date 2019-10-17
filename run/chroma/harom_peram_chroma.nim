## Perambulators for distillation using harom and chroma combined

import serializetools/serializexml
import xmltree
import inline_meas


#------------------------------------------------------------------------------
type
  NamedObject_t* = object
    fifo*:            string

  PropAndMatelemDistillationHaromParams_t* = object
    Name*:            string
    Frequency*:       int
    NamedObject*:     NamedObject_t



proc newHaromPeramChroma*(NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(PropAndMatelemDistillationHaromParams_t(Name: "PERAM_DISTILLATION_CHROMA", 
                                                         Frequency: 1, 
                                                         NamedObject: NamedObject))



