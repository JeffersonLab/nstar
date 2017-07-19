## Hadron N-point connected graphs
## 

import hadron_adj_map
import
  hadron_vertex, hadron_diagram_time, tables, hashes

## ----------------------------------------------------------------------------
## ----------------------------------------------------------------------------
## Key for Hadron NPt connected graph
type
  PairVertexNpt_t* = object
    First*:              HadronVertex_t
    Second*:             cint

  KeyHadronNPartNPtConnGraph_t* = object
    graph*:              string                                   ## Label for the graph
    ensemble*:           string                                   ## Label for the ensemble
    AdjMap*:             HadronGraphAdjMap_t                      ## Adjacency map of vertex connections
    Vertices*:           OrderedTable[cint, PairVertexNpt_t]      ## Vertex info [vertex_num -> {vertex,npt}]
    DiagramTimeSlices*:  HadronDiagramTimeSlices_t                ## Diagram time-slice structure


#[
proc hash*(x: Table[cint, tuple[First: HadronVertex_t, Second: cint]]): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for k,v in pairs(x):
    # Mix the atom with the partial hash.
    h = h !& hash(k)
    h = h !& hash(v)
  # Finish the hash.
  result = !$h


proc hash*(x: KeyHadronNPartNPtConnGraph_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h
]#


#[
proc hash*(x: KeyHadronNPartNPtConnGraph_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  h = h !& hash(x.graph)
  h = h !& hash(x.ensemble)
  h = h !& hash(x.vertices)
  #for k,v in pairs(x.vertices):
  #  h = h !& hash(k)
  #  h = h !& hash(v)
  h = h !& hash(x.diag_time_slices)
  # Finish the hash.
  result = !$h
]#

