## Fermion BC-s

import serializetools/serializexml
import xmltree

type
  NoneLinkSmearing_t* = object
    LinkSmearingType*:   string

  StoutLinkSmearing_t* = object
    LinkSmearingType*:   string
    link_smear_fact*:    float
    link_smear_num*:     int   
    no_smear_dir*:       int   

proc newNoneLinkSmearing*(fact: float, num: int, dir: int): XmlNode =
  ## Return a new StoutLinkSmear
  return serializeXML(NoneLinkSmearing_t(LinkSmearingType: "NONE"), "LinkSmearing")


proc newStoutLinkSmearing*(fact: float, num: int, dir: int): XmlNode =
  ## Return a new StoutLinkSmear
  return serializeXML(StoutLinkSmearing_t(LinkSmearingType: "STOUT_SMEAR",
                                          link_smear_fact: fact,
                                          link_smear_num: num,
                                          no_smear_dir: dir), "LinkSmearing")


when isMainModule:
  let link = newStoutLinkSmearing(0.1, 10, 3)
  echo "xml= ", $link
