## Some tests

import strutils, posix, os

# Types need for submitter
type
  Jobtemplate_t* = object
    nodes:            int
    walltime:         string
    queuename:        string
    outputFile:       string
    command:          string

  PandaSubmitter_t* = object
    campaign:         string
    jobtemplate:      Jobtemplate_t

  
#-----------------------------------------------------------------------------
when isMainModule:
  import os, marshal

  # Get params for this class of jobs
  echo "paramCount = ", paramCount()
  if paramCount() != 4:
    quit("Usage: " & getAppFilename() & " <arch> <stem> <chan> <irrep>")
    
  # Grab basic params and thus grab the output filename
  echo paramStr(0), paramStr(1), paramStr(2), paramStr(3)
  let p = redstar_setup(paramStr(0), paramStr(1), paramStr(2), paramStr(3), "<iter>")

  # Can build panda job
  var panda: PandaSubmitter_t
  panda.campaign = p.stem & "/" & p.chan & "/" & p.irrep
  panda.jobtemplate.nodes = 1
  panda.jobtemplate.walltime = "00:30:00"
  panda.jobtemplate.queuename = "ANALY_TJLAB_LQCD"
  panda.jobtemplate.outputFile = p.output_dir & "/" & p.output_db
  panda.jobtemplate.command = """
#!/bin/tcsh
cd /scratch
echo "nim c -r -o:/var/tmp/redstar.<iter> redstar_chain.nim <iter>"
exit 0
"""

  echo "Generate some JSON"
  echo $$panda
  let script_file = "/var/tmp/" & p.stem & "." & p.chan & "." & p.irrep & "." & p.arch
  writeFile(script_file, $$panda)
