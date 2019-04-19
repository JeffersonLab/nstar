## Redstar executables for my nstar laptop

import redstar_exes

proc redstar_exe*(): RedstarExes_t =
  ## Return executables for 12s
  result.redstar_gen_graph     = "/home/edwards/bin/x86_64-linux/redstar_gen_graph.devel-graph-mkl.oct_3_2017"
  result.redstar_npt           = "/home/edwards/bin/x86_64-linux/redstar_npt.devel-graph-mkl.oct_3_2017"
  result.smeared_hadron_node   = "/home/edwards/bin/x86_64-linux/hadron_node.devel-mkl.oct_3_2017"
  result.unsmeared_hadron_node = "/home/edwards/bin/x86_64-linux/unsmeared_hadron_node.devel-mkl.jan_3_2019"

#  $meson_exe     = "/home/edwards/bin/x86_64-linux/hadron_node.devel-mkl.oct_3_2017";
#  $gen_graph_exe = "/home/edwards/bin/x86_64-linux/redstar_gen_graph.devel-graph-mkl.oct_3_2017";
#  $npt_exe       = "/home/edwards/bin/x86_64-linux/redstar_npt.devel-graph-mkl.oct_3_2017";

