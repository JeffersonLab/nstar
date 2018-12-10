## Redstar executables

type
  Exes_t* = object
    redstar_gen_graph*:      string
    redstar_npt*:            string
    smeared_hadron_node*:    string
    unsmeared_hadron_node*:  string

#[
proc redstar_exe_nstar*(): Exes_t =
  ## Return executables for 12s
  result.redstar_gen_graph     = "/Users/edwards/Documents/qcd/git/devel/redstar/build/src/redstar_gen_graph"
  result.redstar_npt           = "/Users/edwards/Documents/qcd/git/devel/redstar/build/src/redstar_npt"
  result.smeared_hadron_node   = "/Users/edwards/Documents/qcd/git/devel/colorvec/build/src/hadron_node"
  result.unsmeared_hadron_node = "/Users/edwards/Documents/qcd/git/devel/colorvec/build/src/unsmeared_hadron_node"
    
proc redstar_exe_12s*(): Exes_t =
  ## Return executables for 12s
  quit("need to add 12s binaries")
  var run = "env"
  run = run & " OMP_NUM_THREADS=$nt"
  run = run & " OMP_PROC_BIND=true"
#  run = run & " LD_LIBRARY_PATH=/dist/gcc-4.8.2/lib64:/dist/gcc-4.8.2/lib:/dist/gcc-4.6.3/lib64:/dist/gcc-4.6.3/lib:/usr/lib64:/usr/lib:"
  run = run & " KMP_AFFINITY=scatter,granularity=fine"

  let redstar_num_threads = 2
  let nt = redstar_num_threads
  var gomp = "0"
  for tt in 1 .. nt-1:
    gomp &= " " & $tt

  ##  $run = $run . " OMP_SCHEDULE=dynamic OMP_DYNAMIC=true GOMP_CPU_AFFINITY=\'${gomp}\'";
  ##  $run = $run . " GOMP_CPU_AFFINITY=\'${gomp}\'";


#proc basic_setup(arch: string; stem, chan, irrep: string, seqno: string): RedstarRuns_t =
#  ## test
#  result.output_file_base = "fred"

proc redstar_exe_knl*(): Exes_t =
  ## Return executables for jlab knl
  quit("need to add knl binaries")

## ----------------------------------------------------------------------------
proc redstar_exe*(arch: string): Exes_t =
  ## Return executables
  case arch:
    of "nstar": result = redstar_exe_nstar()
    of "12s":   result = redstar_exe_12s()
    of "knl":   result = redstar_exe_knl()
    else: quit("Unknown arch = " & arch)
]#
