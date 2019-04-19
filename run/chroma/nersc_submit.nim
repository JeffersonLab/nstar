## Submit jobs

import os, strutils
import config, colorvec_work
import nersc_run

when isMainModule:

  # The t0 list filename is always the same for each config
  let stem = getStem()
  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]

  # This vesion assumes the arguments are the pre-existing directories
  for dir in commandLineParams():
    # Each seqno
    echo dir
    let cwd = getCurrentDir()
    setCurrentDir(dir)

    # Loop over t0 and must submit
    #for t0 in 0 .. Lt-1:
    for t0 in 104 .. Lt-1:
      #if (t0 mod 16) != 0: continue
      #if (t0 mod 16) == 0: continue
      let run_paths = constructPathNames(t0)
      let outputFile = genPath(run_paths.prop_op_file)
      echo outputFile

      # If the outputFile does not exist, do the thang!
      if existsFile(outputFile):
        # Empty files are bad
        if getFileSize(outputFile) == 0:
          discard tryRemoveFile(outputFile)
        else:
          continue

      # Either is not or empty, so submit
      let f = run_paths.seqDir & "/nersc.t0_" & $t0 & ".sh"

      if execShellCmd("sbatch " & f) != 0:
        quit("Some error submitting " & f)

    # popd
    setCurrentDir(cwd)

