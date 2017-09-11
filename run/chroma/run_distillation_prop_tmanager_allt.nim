## Generate input files for propagators

import "colorvec_work"
import "param_file"


proc runDistillationPropTManagerAllt*(param_file, arch, seqno: string, t0: int) =
  ## Generate input files for propagators

  if not fileExists(param_file):
    quit("Input parameter file= " & param_file & "  does not exist")

  params(arch, seqno, t0)

  print "nrow= ", HMCParam.nrow
  let t_origin = setup_rng(seqno)

  print "Origin= ", t_origin

  var scratch_dir = getScratchPath() & "/" & HMCParam.stem & "/tmp.allt/" & seqno & "." & HMCParam.quark_mass & ".allt"
  execShellCmd("mkdir -p " & scratch_dir)

  # Diags
  echo "Number of sources= ", t_sources.len

  # Sanity checks
  if not dirExists(HMCParam.sdb_dir):
    quit("Output mod dir  " & HMCParam.sdb_dir & "   not writable")

  run_quark_mass_allt_cuda(seqno, t0)

  # Cleanup
  ##system("/bin/rm -r $scratch_dir")


#------------------------------------------------------------------------------
proc run_quark_mass_allt_cuda(seqno: string, t0: int) =
  ## Set global values
  echo "seqno= ", seqno, "  t0= ", t0

  let stem = getStem("stem")
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
  }

  print_trailer_xml(HMCParam.gauge_type, HMCParam.gauge_file, input_chroma)
}


when isMainModule:
  if paramCount() != 4:
    quit(paramStr(0) & " <ini_file> <arch> <seqno> <t0>")

  let t0 = parseInt(paramStr(4))

  rundistillationproptmanagerallt(paramStr(1), paramStr(2), paramStr(3), t0)
