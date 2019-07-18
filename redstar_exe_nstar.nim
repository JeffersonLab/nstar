## Redstar executables for my nstar laptop

import redstar_exes

proc redstar_exe*(): RedstarExes_t =
  ## Return executables for nstar
  result.redstar_gen_graph     = "/Users/edwards/Documents/qcd/git/devel/redstar/build/src/redstar_gen_graph"
  result.redstar_npt           = "/Users/edwards/Documents/qcd/git/devel/redstar/build/src/redstar_npt"
  result.smeared_hadron_node   = "/Users/edwards/Documents/qcd/git/devel/colorvec/build/src/hadron_node"
  result.unsmeared_hadron_node = "/Users/edwards/Documents/qcd/git/devel/colorvec/build/src/unsmeared_hadron_node"

