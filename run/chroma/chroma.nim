## Main driver for chroma

import xmltree

#------------------------------------------------------------------------
type
  Param_t* = object   
    ## All inline measurements
    InlineMeasurements*:  seq[XmlNode]  ## Yup, the inline measurements
    nrow*:                array[4,int]  ## lattice size


#------------------------------------------------------------------------
type
  Cfg_t* = object   
    ## Configuration params
    cfg_type*:      string              ## Type
    cfg_file*:      string              ## File name, if it exists
    parallel_io*:   bool                ## Whether we can use parallel io


#------------------------------------------------------------------------
type
  Chroma_t* = object   
    ## All parameters for chroma
    Param*:         Param_t             ## Type
    Cfg*:           Cfg_t               ## File name, if it exists


#------------------------------------------------------------------------
type
  Harom_t* = object   
    ## All parameters for harom
    Param*:         Param_t             ## Type

