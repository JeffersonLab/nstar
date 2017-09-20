## Inline measurements

import xmltree

type
  InlineMeasurement_t* = object   
    ## Inline measurements
    Name*:        string
    Frequency*:   int
    Measurement*: XmlNode

