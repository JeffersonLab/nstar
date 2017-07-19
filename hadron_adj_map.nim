import
  hadron_diagram_time, hadron_vertex, hashes, tables

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# Target of adjacancy map: [had -> [slot -> {target had,target slot}]]
type
  HadronAdjMapTarget_t* = object
    vertex_num*: cint ## Target vertex 
    slot_num*:   cint ## Slot on the target 
    conj*:       bool ## Is quark conjugated on the target? 
    flavor*:     char ## Quark flavor, something like  d,u,s,c,... 
  

proc newHadronAdjMapTarget_t*(): HadronAdjMapTarget_t =
  ## Empty constructor
  result.vertex_num = 0
  result.slot_num   = 0
  result.conj       = false
  result.flavor     = '\0'

proc newHadronAdjMapTarget_t*(v: cint, s: cint, c: bool, f: char): HadronAdjMapTarget_t =
  ## A constructor from bits
  result.vertex_num = v
  result.slot_num   = s
  result.conj       = c
  result.flavor     = f


proc hash*(x: HadronAdjMapTarget_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for xAtom in x.fields:
    # Mix the atom with the partial hash.
    h = h !& hash(xAtom)
  # Finish the hash.
  result = !$h



# Adjacancy map
type
  HadronGraphAdjMap_t* = OrderedTable[cint, OrderedTable[cint, HadronAdjMapTarget_t]] ## Adjacancy map: [vertex_num -> [slot -> {target vertex,target slot}]]


#[
proc hash*(x: Table[cint, HadronAdjMapTarget_t]): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for k,v in pairs(x):
    # Mix the atom with the partial hash.
    h = h !& hash(k)
    h = h !& hash(v)
  # Finish the hash.
  result = !$h

proc hash*(x: HadronGraphAdjMap_t): Hash =
  ## Computes a Hash from `x`.
  var h: Hash = 0
  # Iterate over parts of `x`.
  for k,v in pairs(x):
    # Mix the atom with the partial hash.
    h = h !& hash(k)
    h = h !& hash(v)
  # Finish the hash.
  result = !$h
]#
