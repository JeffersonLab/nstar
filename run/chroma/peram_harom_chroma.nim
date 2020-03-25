## Prop and matelem distillation

import propagator
import serializetools/serializexml
import xmltree
import inline_meas


#------------------------------------------------------------------------------
type
  NamedObject_t* = object
    fifo*:         seq[string]

  HaromPeramDistillationParams_t* = object
    Name*:            string
    NamedObject*:     NamedObject_t



proc newHaromPeramDistillation*(NamedObject: NamedObject_t): XmlNode =
  ## Return a new peram
  return serializeXML(HaromPeramDistillationParams_t(Name: "PERAM_DISTILLATION_CHROMA", 
                                                     Frequency: 1, 
                                                     NamedObject: NamedObject))



#[
#------------------------------------------------------------------------------
#
<?xml version="1.0"?>
<harom>
<Param> 
  <InlineMeasurements>

    <elem>
      <Name>PERAM_DISTILLATION_CHROMA</Name>
      <Frequency>1</Frequency>
      <NamedObject>
        <fifo>/tmp/harom-cmd1</fifo>
      </NamedObject>
    </elem>


  </InlineMeasurements>
  <nrow>32 32 32 256</nrow>
</Param>

</harom>

]#



