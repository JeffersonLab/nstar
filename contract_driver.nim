## Driver for contractions using redstar

import
  os, ospaths, times

proc contractDriver*(stem, run_script, arch, particle, mom, seqno: string) =
  ## Script driver for redstar
  setCurrentDir("/scratch")

  if existsEnv("SLURM_SUBMIT_HOST"):
    echo "SLURM_JOBID = ", getEnv("SLURM_JOB_ID")
    echo "SLURM_JOBNAME = ", getEnv("SLURM_JOB_NAME")
    echo "SLURM_WORKDIR = ", getEnv("SLURM_SUBMIT_DIR")
    echo "SLURM_NODEFILE", $readFile(getEnv("SLURM_JOB_NODELIST"))

  let source_stuff = "source /dist/intel/parallel_studio_xe_2016.3.067/psxevars.csh intel64"
  
  if not existsDir("/volatile/Spectrum"):
    quit("Lustre is not present")

  let poodoo = "/lustre/volatile/Spectrum/Clover/NF2+1/" & stem & "/rge_temp/" & particle & "/" & mom
  discard existsOrCreateDir(poodoo)
  let curd = getCurrentDir()
  setCurrentDir(poodoo)
  setCurrentDir(curd)
  let outfile = poodoo & stem & ".out" & seqno
  var outd: File
  if not open(outd, outfile, fmWrite):
    quit("Error opening out file = " & outfile)

  discard tryRemoveFile(outfile)
  discard tryRemoveFile(outfile & ".gz")

  echo "Cfg = ", seqno
  write(outd, "Cfg = " & seqno)

  if existsEnv("SLURM_SUBMIT_HOST"):
    write(outd, "SLURM_JOBID = " & getEnv("SLURM_JOB_ID"))
    write(outd, "SLURM_JOBNAME = " & getEnv("SLURM_JOB_NAME"))
    write(outd, "SLURM_WORKDIR = " & getEnv("SLURM_SUBMIT_DIR"))
    write(outd, "SLURM_NODEFILE\n" & $readFile(getEnv("SLURM_JOB_NODELIST")))

  echo "Starting chroma script at time= " & $now()
  write(outd, "Starting chroma script at time= " & $now())
  write(outd, run_script)
  if execShellCmd(run_script & " " & param_file & " " & arch & " " & seqno) != 0:
      quit("Some error in run of " & outfile)

  echo "Ending chroma script at time= " & $now()
  write(outd, "Ending chroma script at time= " & $now())

  discard execShellCmd("gzip -f9 " & outfile)
