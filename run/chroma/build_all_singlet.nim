#

import os, strutils, ospaths, serializetools/serializexml, xmltree
import build_t0_list
import config

proc symLink(src: string) =
  ## Simple wrapper for symlinks
  echo "SymLink: src= ", src
  if not fileExists(src):
    quit("file does not exist: src= " & src)
  let dest = extractFilename(src)
  if fileExists(dest): return
  createSymLink(src, dest)


#[
        <Job>
                <name>testJob1</name>
                <checkNodes>1</checkNodes>
                <nodes>1</nodes>
                <checkWallTime>00:10:00</checkWallTime>
                <wallTime>00:10:00</wallTime>
                <executionCommand>serial /mnt/c/Users/danie/titanManager/examples/testJob.bash 'Successful!' /mnt/c/Users/danie/titanManager/examples/testJob1.out</executionCommand>
                <checkOutputCommand>serial /mnt/c/Users/danie/titanManager/examples/checkTestJob.bash /mnt/c/Users/danie/titanManager/examples/testJob1.out /mnt/c/Users/danie/titanManager/examples/testJob1Check.out</checkOutputCommand>
                <checkOutputScript>grep 'Successful' /mnt/c/Users/danie/titanManager/examples/testJob1Check.out</checkOutputScript>
                <campaign>Test</campaign>
                <inputFiles>
                        <elem><name>testJob.bash</name><fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir></elem><elem><name>checkTestJob.bash</name><fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir></elem>
                </inputFiles>
                <outputFiles>
                        <elem><name>testJob1.out</name><fileDir>/mnt/c/Users/danie/titanManager/examples</fileDir></elem>
                </outputFiles>
        </Job>
]#

type
  InputFile_t = object
    name:    string
    fileDir: string

  OutputFile_t = object
    name:    string
    fileDir: string

  JobType_t = object
    name:           string
    checkNodes:     int
    nodes:          int
    checkWallTime:  string
    wallTime:       string
    executionCommand:   string
    checkOutputCommand: string
    checkOutputScript:  string
    campaign:       string
    inputFiles:     seq[InputFile_t]
    outputFiles:    seq[OutputFile_t]
    

proc buildAllSinglet*(quark: string, seqnos: seq[string]) =
  ## Build all the directories for a list of configs
  # Hack - set the scratch dir
  let scratch_dir = getScratchPath()
  putEnv("SCRATCH", scratch_dir)

  #let (basedir, filename, ext) = splitFile(paramStr(0))
  #echo "basedir= ", basedir

  const bw_dir = strip(staticExec("pwd"))
  echo "bw_dir= ", bw_dir

  var stem = getStem()
  echo "stem= ", stem

  let ini_file = bw_dir & "/run_distillation_prop_tmanager_allt.ini.nim"
  let arch     = "NERSC_QPHIX"

  # Loop over each configuration, find the number of t0-s, generate their input, and add them to the queue
  for seqno in items(seqnos):
    let dir = "prop." & quark & ".singlet." & seqno
    echo dir

    discard existsOrCreateDir(dir)
    #discard existsOrCreateDir(home & "/scratch/${stem}/rge_temp/prop.${quark}")

    setCurrentDir(dir)
    writeFile("list", $seqno)
    writeFile("quark_mass", "strange")

    #symLink(home & "/arch/wraprun/bin/serial", ".")

    #symLink(bw_dir & "/run.nersc.csh", ".")
    symLink(bw_dir & "/build_t0_list")
    buildT0List()

    let list = readFile($stem & ".list")

    # Loop over all the t0-s and construct the input file
    for t0 in splitLines(list):
      if t0.len == 0: continue
      runDistillationPropTManagerAllt(ini_file, arch, seqno, t0)

      #let output = stem & ".t0_" & t0 & ".prop.ini.xml" & seqno
      let sdb = "fred.sdb" & seqno

      var job: JobType_t
      job.name = quark & ".t0_" & t0
      job.checkNodes = 0
      job.nodes = 1
      job.checkWallTime = ""
      job.executionCommand = "04:30:00"
      job.checkOutputCommand = "serial prop_check 0.5 " & sdb
      job.checkOutputScript = ""
      job.campaign = stem
      job.inputFiles = @[]
      job.outputFiles = @[]

      let xml = serializeXML(job)
      echo "xml= ", $xml

      # On to the next config
      setCurrentDir("..")


when isMainModule:
  if paramCount() < 2:
    quit(paramStr(0) & " <quark> <seqno1> [<seqno2> ...]")

  let quark = paramStr(1)
  var seqnos = newSeq[string](0)

  for n in 2..paramCount():
    let seqno = paramStr(n)
    seqnos.add(seqno)

  buildAllSinglet(quark, seqnos)

