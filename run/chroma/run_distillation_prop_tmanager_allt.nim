## Generate input files for propagators

import os, system

import "colorvec_work"
import "param_file"


proc runDistillationPropTManagerAllt*(params: HMCParam; arch, seqno: string; t0: int) =
  ## Generate input files for propagators

  echo "lattSize= ", HMCParam.lattSize
  let t_origin = getTimeOrigin(Lt, seqno)

  echo "Origin= ", t_origin

  let scratch_dir = getScratchPath() & "/" & HMCParam.stem & "/tmp.allt/" & seqno & "." & HMCParam.quark_mass & ".allt"
  existsOrCreateDir(scratch_dir)

  # Diags
  echo "Number of sources= ", t_sources.len

  # Sanity checks
  if not dirExists(HMCParam.sdb_dir):
    quit("Output mod dir  " & HMCParam.sdb_dir & "   not writable")

  let tt = "t0_" & $t0

  let input_src  = stem & "." & tt & ".src.ini.xml" & seqno
  let output_src = stem & "." & tt & ".src.out.xml"
  
  let eig_db   = MCParam.eig_file

  #
  # Build chroma input
  #
  let pref = stem & "." & tt
  let input_chroma  = pref & ".prop.ini.xml" & seqno
  let output_chroma = pref & ".prop.out.xml" & seqno
  let stdout_chroma = pref & ".prop.out" & seqno
  let stdout_check  = pref & ".check_prop.out" & seqno

  let soln_db  = scratch_dir & "/" & soln_file
  removeFile(soln_db)

  print_header_xml(input_chroma)

  when (arch eq "BW_CPU") or (arch eq "JLAB_QOPKNL"):
    stdout_chroma = scratch_dir & "/" & stdout_chroma
    print_prop_distillation_cpu_mg(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
  elif arch eq "JLAB_KNL":
    stdout_chroma = scratch_dir & "/" & stdout_chroma
    print_prop_distillation_qphix(eig_db, soln_db, HMCParam.quark_mass, tt, input_chroma)
  elif arch eq "NERSC_QPHIX":
    #stdout_chroma = "scratch_dir/stdout_chroma"
    print_prop_distillation_qphix(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
  elif arch eq "BW_GPU":
    print_prop_distillation_gpu(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
  elif arch eq "BW_GPU":
    print_prop_distillation_gpu(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
  elif arch eq "JLAB_KEPLER"|"JLAB_690"|"JLAB_FERMI"|"JLAB_285"
    stdout_chroma = "scratch_dir/stdout_chroma"
    ##      &print_prop_distillation_gpu(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
    print_prop_distillation_gpu_mg(eig_db, soln_db, HMCParam.quark_mass, t0, input_chroma)
  else
    quit("Unknown in gen: arch = ", arch

  print_trailer_xml(HMCParam.gauge_type, HMCParam.gauge_file, input_chroma)

  #run_quark_mass_allt_cuda(seqno, t0)

  # Cleanup
  ##system("/bin/rm -r $scratch_dir")




when isMainModule:
  if paramCount() != 4:
    quit(paramStr(0) & " <ini_file> <arch> <seqno> <t0>")

  let ini_file = paramStr(1)
  let arch     = paramStr(2)
  let seqno    = paramStr(3)
  let t0       = parseInt(paramStr(4))

#  if not fileExists(param_file):
#    quit("Input parameter file= " & param_file & "  does not exist")

  let params = getParams(arch, seqno, t0)

  runDistillationPropTManagerAllt(params, arch, seqno, t0)
