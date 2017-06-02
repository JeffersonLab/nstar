import
  hadron_diagram_time, hadron_vertex

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# Target of adjacancy map: [had -> [slot -> {target had,target slot}]]
type
  HadronAdjMapTarget_t* = object
    vertex_num*: cint ## Target vertex 
    slot_num*:   cint ## Slot on the target 
    conj*:       bool ## Is quark conjugated on the target? 
    flavor*:     char ## Quark flavor, something like  d,u,s,c,... 
  

proc hash*(x: HadronAdjMapTarget_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h


#proc constructHadronAdjMapTarget_t*(): HadronAdjMapTarget_t {.constructor,
#    importcpp: "Hadron::HadronAdjMapTarget_t(@)", header: "hadron_adj_map.h".}
#proc constructHadronAdjMapTarget_t*(v: cint; s: cint; c: bool; f: char): HadronAdjMapTarget_t {.
#    constructor, importcpp: "Hadron::HadronAdjMapTarget_t(@)",
#    header: "hadron_adj_map.h".}


# Adjacancy map: [vertex_num -> [slot -> {target vertex,target slot}]]
type
  HadronGraphAdjMap_t* = map[cint, map[cint, HadronAdjMapTarget_t]]
