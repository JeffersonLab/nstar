## Extract projected operator coefficients

import hadron_sun_npart_irrep, streams, osproc, serializetools/serializexml, tables, xmlparser, xmltree, strutils

#die "$0 <output xml file>  <t0> <tZ> <opslistfile> <state num> <opname pattern> [<secondary op xml>...]\n" unless $#ARGV >= 6;

proc readOpsMapFiles(opsMapFiles: seq[string]): Table[string, KeyHadronSUNNPartIrrep_t] =
  ## Read in several ops map files and return one table holding them all
  result = initTable[string, KeyHadronSUNNPartIrrep_t]()

  # Loop over each opsmap file and add it to the main table
  for f in items(opsMapFiles):
    # Read source ops xml and make a map (source_opsmap)
    echo "Read file= ", f
    let xml: XmlNode = loadXml(f)

    # Deserialize this table
    let ops = deserializeXML[Table[string, KeyHadronSUNNPartIrrep_t]](xml)
  
    # Loop over its entries and add to the main table
    for k, v in pairs(ops):
      result.add(k,v)

proc extractProjectOpWeights*(state, t0, tZ: int; opsListFile: string; opsMapFiles: seq[string]): Table[KeyHadronSUNNPartIrrep_t,float64] =
  ## Extract projected operator weights for state `state` at a fixed `t0` and `tZ`
  ## Return a table holding the operators and their weights (float64) - the "optimal" operator that projects onto this level.
  #
  echo "Extract weights for projected state = ", state
#  let cwd = getCurrentDir()

  # Uber ops map
  let opsMap = readOpsMapFiles(opsMapFiles)

  # Output table starts empty
  result = initTable[KeyHadronSUNNPartIrrep_t,float64]()

  # The ensemble (mass) file we will use
  let massfile = "t0" & $t0 & "/MassJackFiles/mass_t0_" & $t0 & "_reorder_state" & $state & ".jack"
                                                                                            
  # Slurp in the entire contents of the ops_phases file
  let opsList = newStringStream(readFile(opsListFile))
  
  # Loop over the operators for this state
  var line = readLine(opsList)

  while line != "":
    echo "parse line= ", line
    let ll = splitWhiteSpace(line)
    let ii = parseInt(ll[0])
    let subOpName = ll[1]

    if not opsMap.hasKey(subOpName):
      echo "Key=  ", subopName, "  not in map of operator xml"
      assert false

    # V_t file
    let file = "t0" & $t0 & "/V_tJackFiles/V_t0_" & $t0 & "_reordered_state" & $state & "_op" & $ii & ".jack"
                    
    let command = "calcbc \" sqrt( 2 * " & massfile & " ) * exp ( - " & massfile & " * " & $t0 & " / 2 ) * extract ( " & file & " , " & $tZ & " ) \" | awk '{print $2}' "
    let valstr = quoteShell(command)
    let val = parseFloat(valstr)
    echo "OpName: ", subopName, " ", subopName, " ", val

    # Here is the struct
    let op = opsMap[subopName]

    # add it into the table
    result.add(op, val)






