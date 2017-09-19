#
# This is the work script called by run_colorvec_*pl
#
import os, ospaths, osproc, strutils
import re
import config
import serializetools/serializexml, niledb
import xmltree

#------------------------------------------------------------------------
# Find a local path to a file, or cache_cp it
proc find_file*(orig_file: string): string =
  var filename = extractFilename(orig_file)

  # scratch
  let scratch_dir = getScratchPath()

  # Copy files
  if not fileExists(orig_file):
    echo "In function find_file:   cache_cp ", orig_file

    if execShellCmd("cache_cp " & orig_file & " " & scratch_dir) != 0:
      quit("Some problem copying with copying " & orig_file)

    result = scratch_dir & "/" & filename
  else:
    result = orig_file



#[
#------------------------------------------------------------------------
# Copy a lustre file to scratch
proc copy_lustre_file*($orig_file: string) =
  var filename = extractFilename(orig_file)

  # scratch
  #my $scr = ($scratch_dir ne "") ? $scratch_dir : "/scratch"
  my scr = ""

  # Copy files
  if (! -f $orig_file)
  {
    print "Lustre file not found: $orig_file\n"
    exit(1)
  }

  printf "In function find_file:   copy_lustre_file $orig_file\n"

  my $err = 0xffff & system("cp ${orig_file} $scr")
  if ($err > 0x00)
  {
    print "Some problem copying lustre file $orig_file\n"
    exit(1)
  }
  my $local_file = "$scr/$filename"

  return $local_file
]#


#[
#------------------------------------------------------------------------
# Find a local path to eig files, or cache_cp them
proc find_eig_files*
{
  local($orig_path, $stem, $seqno) = @_

  my $basedir = "$orig_path/$seqno"

  # scratch
  my $scr = ($scratch_dir ne "") ? $scratch_dir : "/scratch"

  # Copy files
  my $local_path
  if (! -f "$basedir/${stem}.eigs_vec0.lime")
  {
    printf "In function find_eig_files:   cache_cp -r $basedir\n"

    my $err = 0xffff & system("cache_cp -r $basedir $scr")
    if ($err > 0x00)
    {
      print "Some problem with copying $basedir\n"
      exit(1)
    }
    $local_path = "$scr/$seqno"
  }
  else
  {
    $local_path = "$basedir"
  }

  return $local_path
}
]#


#------------------------------------------------------------------------
proc copy_back*(output_dir, input_file: string) = 
  ## Copy files back to disk
  if execShellCmd("cache_cp " & input_file & " " & output_dir) != 0:
    quit("Some problem copying with copying " & input_file)


#------------------------------------------------------------------------
proc copy_back_rcp*(output_dir, input_file: string) = 
  ## Copy files back to disk
  copy_back(output_dir,input_file)


#------------------------------------------------------------------------
proc copy_back_lustre*(output_dir, input_file: string) =
  ## Copy files back to disk
  if execShellCmd("/bin/mv -f $input_file $output_dir") > 0:
    quit("Some problem copying file $input_file\n")


#------------------------------------------------------------------------
proc copy_back_scp*(output_dir, input_file: string) = 
  ## Copy files back to disk
  copy_back_lustre(output_dir, input_file)

#------------------------------------------------------------------------
proc test_xml*(file: string): bool =
  ## Test an xml file
  if execShellCmd("xmllint " & file & " > /dev/null") > 0:
    quit("Some error running xmllint on " & file)
  else:
    return true

#------------------------------------------------------------------------
proc flag_xml*(file: string): bool =
  ## Test an xml file
  if execShellCmd("xmllint " & file & " > /dev/null") > 0:
    return false
  else:
    return true

#------------------------------------------------------------------------
proc test_sdb*(file: string): bool =
  ## Test a sdb file
  if execShellCmd("dbkeys " & file & " keys > /dev/null") > 0:
    quit("Some error running dbkeys on $file")
  else:
    return true


#------------------------------------------------------------------------
proc test_mod*(file: string): bool =
  ## Test a mod file
  if execShellCmd("modkeys " & file & " > /dev/null") > 0:
    quit("Some error running modkeys on $file")
  else:
    return true


#------------------------------------------------------------------------
proc gzip*(file: string): string =
  ## Zip a file
  if execShellCmd("gzip -f9 " & file) != 0:
    quit("Some error gzip $file")

  return file & ".gz"


#------------------------------------------------------------------------
proc extractLattSize*(data: string): array[4,int] =
  ## Determine the lattice size
  # Yuk, do some file name surgery
  var stem = data.replace(re"\..*$")
  stem = stem.replace(re"per\..*$")
  stem = stem.replace(re"non\..*$")
  stem = stem.replace(re"dir\..*$")

  let F  = stem.split('_')
  let Ls = parseInt(F[1])
  let Lt = parseInt(F[2])
  result = [Ls, Ls, Ls, Lt]



#------------------------------------------------------------------------
proc getTimeOrigin*(Lt: int, trajj: string): int =
  ## Displace the origin of the time slices using the trajectory as a seed to a RNG
  var traj = trajj.replace(re"[a-zA-Z]")

  # Seed the rng with the traj number
  let (outp, errC) = execCmdEx("t_origin.pl " & $Lt & " " & traj)
  if errC != 0:
    quit("Error running t_origin.pl")

  result = parseInt(outp)



#------------------------------------------------------------------------
type
  InlineMeasurements_t* = object   
    ## All inline measurements
    meas:    seq[string]   # measurements


#------------------------------------------------------------------------
type
  ChromaParam_t* = object   
    ## All inline measurements
    InlineMeasurements*:  InlineMeasurements_t      ## Yup, the inline measurements
    nrow*:                array[4,int]              ## lattice size


#------------------------------------------------------------------------
type
  Cfg_t* = object   
    ## Configuration params
    cfg_type*:      string              ## Type
    cfg_file*:      string              ## File name, if it exists
    parallel_io*:   bool                ## Whether we can use parallel io


#------------------------------------------------------------------------
type
  Chroma_t* = object   
    ## All parameters for chroma
    Param*:         ChromaParam_t       ## Type
    Cfg*:           Cfg_t               ## File name, if it exists



#------------------------------------------------------------------------
proc print_header_xml*(): string  =
  ## Header
  return """<?xml version="1.0"?>"""


#------------------------------------------------------------------------
#
proc print_trailer_xml*(gauge_type, gauge_cfg, input: string, lattSize: seq[int]) = 
  ## Trailer
  var file: FILE
  if not open(file, input, fmAppend):
    quit("error opening file= " & input)
  write(file, """
  </InlineMeasurements>
  <nrow>""" & $lattSize & """</nrow>
  </Param>
  <Cfg>
    <cfg_type>""" & gauge_type & """</cfg_type>
    <cfg_file>""" & gauge_cfg & """</cfg_file>
    <parallel_io>true</parallel_io>
  </Cfg>
</chroma>
""")
  close(file)


#------------------------------------------------------------------------
#
proc print_harom_header_xml*(input: string): string =
  ## Header
  writeFile(input, """
<?xml version="1.0"?>

<harom>
<Param> 
  <InlineMeasurements>
""")


#------------------------------------------------------------------------
# Trailer
#
proc print_harom_trailer_xml*(input: string, lattSize: seq[int]): string =
  ## Trailer
  var file: FILE
  if not open(file, input, fmAppend):
    quit("error opening file= " & input)
  write(file, """
  </InlineMeasurements>
  <nrow>""" & $lattSize & """</nrow>
</Param> 
</harom>
""")


#[

#------------------------------------------------------------------------------
proc print_prop_distillation_cpu(local_src_file, local_prop_file, m_q, t0_val, input): string =
# Print propagator and matelem driver for a cpu

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3];

# Print for a single mass
  open(INPUT, ">> $input");
  print INPUT <<EOF;
    <elem>
      <Name>PROP_DISTILLATION</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
          <decay_dir>3</decay_dir>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>CLOVER</FermAct>
            <Mass>${m_q}</Mass>
            <clovCoeffR>${c_s}</clovCoeffR>
            <clovCoeffT>${c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>${HMCParam::anisoP}</anisoP>
              <t_dir>${HMCParam::t_dir}</t_dir>
              <xi_0>${HMCParam::xi_0}</xi_0>
              <nu>${HMCParam::nu}</nu>
            </AnisoParam>
            <FermState>
              <Name>STOUT_FERM_STATE</Name>
              <rho>${HMCParam::rho}</rho>
              <n_smear>${HMCParam::n_smear}</n_smear>
	      <orthog_dir>${HMCParam::orthog_dir}</orthog_dir>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
          </FermionAction>
          <InvertParam>
            <invType>${HMCParam::SolverType}</invType>
            <MaxBiCGStab>${HMCParam::MaxCG}</MaxBiCGStab>
            <RsdBiCGStab>${HMCParam::RsdCG}</RsdBiCGStab>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <save_solnP>true</save_solnP>
        <gauge_id>default_gauge_field</gauge_id>
        <distillution_id>dist_obj</distillution_id>
        <src_file>${local_src_file}</src_file>
        <soln_file>${local_prop_file}</soln_file>
      </NamedObject>
    </elem>

EOF
close(INPUT);
}

#------------------------------------------------------------------------------
# Print propagator and matelem driver for a cpu
#
sub print_prop_distillation_cpu_mg
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_;

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3];

# Print for a single mass
  open(INPUT, ">> $input");
  print INPUT <<EOF;
    <elem>
      <Name>PROP_AND_MATELEM_DISTILLATION</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
          <decay_dir>3</decay_dir>
          <num_tries>${HMCParam::num_tries}</num_tries>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>UNPRECONDITIONED_CLOVER</FermAct>
            <Mass>${m_q}</Mass>
            <clovCoeffR>${c_s}</clovCoeffR>
            <clovCoeffT>${c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>${HMCParam::anisoP}</anisoP>
              <xi_0>${HMCParam::xi_0}</xi_0>
              <nu>${HMCParam::nu}</nu>
              <t_dir>${HMCParam::t_dir}</t_dir>
            </AnisoParam>
            <FermState>
              <Name>STOUT_FERM_STATE</Name>
              <rho>${HMCParam::rho}</rho>
              <n_smear>${HMCParam::n_smear}</n_smear>
	      <orthog_dir>${HMCParam::orthog_dir}</orthog_dir>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
          </FermionAction>
          <InvertParam>
            <invType>QOP_CLOVER_MULTIGRID_INVERTER</invType>
            <Mass>${m_q}</Mass>
            <Clover>${c_s}</Clover>
            <CloverT>${c_t}</CloverT>
            <AnisoXi>${HMCParam::xi_0}</AnisoXi>
            <AnisoNu>${HMCParam::nu}</AnisoNu>
            <MaxIter>200</MaxIter>
            <Residual>${HMCParam::RsdCG}</Residual>
            <Verbose>0</Verbose>
            <Levels>2</Levels>
            <Blocking>
              <elem>3 3 3 8</elem>
              <elem>2 2 2 4</elem>
            </Blocking>

            <NumNullVecs>24 32</NumNullVecs>
            <NumExtraVecs>0 0</NumExtraVecs>

            <NullResidual>0.4 0.4</NullResidual>
            <NullMaxIter>100 100</NullMaxIter>
            <NullConvergence>0.5 0.5</NullConvergence>

            <Underrelax>1.0 1.0</Underrelax>
            <NumPreHits>0 0</NumPreHits>
            <NumPostHits>4 1</NumPostHits>
            <CoarseMaxIter>12 12</CoarseMaxIter>
            <CoarseResidual>0.2 0.3</CoarseResidual>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_files>${local_eig_file}</colorvec_files>
        <prop_op_file>${local_prop_file}</prop_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT);
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
sub print_prop_distillation_gpu_mg
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_;

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3];

# Print for a single mass
  open(INPUT, ">> $input");
  print INPUT <<EOF;
    <elem>
      <Name>PROP_AND_MATELEM_DISTILLATION</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
          <decay_dir>3</decay_dir>
          <num_tries>${HMCParam::num_tries}</num_tries>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>CLOVER</FermAct>
            <Mass>${m_q}</Mass>
            <clovCoeffR>${c_s}</clovCoeffR>
            <clovCoeffT>${c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>${HMCParam::anisoP}</anisoP>
              <xi_0>${HMCParam::xi_0}</xi_0>
              <nu>${HMCParam::nu}</nu>
              <t_dir>${HMCParam::t_dir}</t_dir>
            </AnisoParam>
            <FermState>
              <Name>STOUT_FERM_STATE</Name>
              <rho>${HMCParam::rho}</rho>
              <n_smear>${HMCParam::n_smear}</n_smear>
	      <orthog_dir>${HMCParam::orthog_dir}</orthog_dir>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
          </FermionAction>

          <InvertParam>
            <invType>QUDA_MULTIGRID_CLOVER_INVERTER</invType>

            <MULTIGRIDParams>
              <Residual>2.5e-1</Residual>
              <CycleType>MG_RECURSIVE</CycleType>
              <RelaxationOmegaMG>1.0</RelaxationOmegaMG>
              <RelaxationOmegaOuter>1.0</RelaxationOmegaOuter>
              <MaxIterations>10</MaxIterations> 
              <SmootherType>MR</SmootherType>
              <Verbosity>false</Verbosity>
              <Precision>HALF</Precision>
              <Reconstruct>RECONS_8</Reconstruct>
              <NullVectors>24 32</NullVectors>
              <GenerateNullspace>true</GenerateNullspace>
              <GenerateAllLevels>true</GenerateAllLevels>
              <Pre-SmootherApplications>4 4</Pre-SmootherApplications>
              <Post-SmootherApplications>4 4</Post-SmootherApplications>
              <SchwarzType>ADDITIVE_SCHWARZ</SchwarzType>
              <Blocking>
                <elem>3 3 3 4</elem>
                <elem>2 2 2 2</elem>
              </Blocking>
            </MULTIGRIDParams>

            <RsdTarget>${HMCParam::RsdCG}</RsdTarget>
            <CloverParams>
              <Mass>${m_q}</Mass>
              <clovCoeffR>${c_s}</clovCoeffR>
              <clovCoeffT>${c_t}</clovCoeffT>
              <AnisoParam>
                <anisoP>true</anisoP>
                <t_dir>3</t_dir>
                <xi_0>${HMCParam::xi_0}</xi_0>
                <nu>${HMCParam::nu}</nu>
              </AnisoParam>
            </CloverParams>
            <Delta>1.0e-4</Delta>
            <MaxIter>200</MaxIter>
            <RsdToleranceFactor>100</RsdToleranceFactor>
            <SilentFail>true</SilentFail>
            <AntiPeriodicT>true</AntiPeriodicT>
            <SolverType>GCR</SolverType>
            <Verbose>true</Verbose>
            <AsymmetricLinop>false</AsymmetricLinop>
            <CudaReconstruct>RECONS_12</CudaReconstruct>
            <CudaSloppyPrecision>SINGLE</CudaSloppyPrecision>
            <CudaSloppyReconstruct>RECONS_8</CudaSloppyReconstruct>
            <AxialGaugeFix>false</AxialGaugeFix>
            <AutotuneDslash>false</AutotuneDslash>
            <SubspaceID>foo</SubspaceID>
          </InvertParam>

         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_files>${local_eig_file}</colorvec_files>
        <prop_op_file>${local_prop_file}</prop_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT);
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a avx
#
sub print_prop_distillation_avx
{
  local($local_src_file, $local_prop_file, $m_q, $t0_val, $input) = @_;

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3];

# Print for a single mass
  open(INPUT, ">> $input");
  print INPUT <<EOF;
    <elem>
      <Name>PROP_DISTILLATION</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
          <decay_dir>3</decay_dir>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>CLOVER</FermAct>
            <Mass>${m_q}</Mass>
            <clovCoeffR>${c_s}</clovCoeffR>
            <clovCoeffT>${c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>${HMCParam::anisoP}</anisoP>
              <t_dir>${HMCParam::t_dir}</t_dir>
              <xi_0>${HMCParam::xi_0}</xi_0>
              <nu>${HMCParam::nu}</nu>
            </AnisoParam>
            <FermState>
              <Name>STOUT_FERM_STATE</Name>
              <rho>${HMCParam::rho}</rho>
              <n_smear>${HMCParam::n_smear}</n_smear>
	      <orthog_dir>${HMCParam::orthog_dir}</orthog_dir>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
          </FermionAction>
         <InvertParam>
           <invType>INTEL_CLOVER_INVERTER</invType>
           <SolverType>BICGSTAB</SolverType>
           <AntiPeriodicT>true</AntiPeriodicT>
           <Compress>true</Compress>
           <Verbose>true</Verbose>
           <MaxIter>${HMCParam::MaxCG}</MaxIter>
           <RsdTarget>${HMCParam::RsdCG}</RsdTarget>
           <CloverParams>
             <Mass>${m_q}</Mass>
             <clovCoeffR>${c_s}</clovCoeffR>
             <clovCoeffT>${c_t}</clovCoeffT>
             <AnisoParam>
               <anisoP>${HMCParam::anisoP}</anisoP>
               <t_dir>${HMCParam::t_dir}</t_dir>
               <xi_0>${HMCParam::xi_0}</xi_0>
               <nu>${HMCParam::nu}</nu>
             </AnisoParam>
           </CloverParams>
           <NCores>15</NCores>
           <By>8</By>
           <Bz>8</Bz>
           <Sy>1</Sy>
           <Sz>1</Sz>
           <PadXY>1</PadXY>
           <PadXYZ>0</PadXYZ>
           <SOALEN>8</SOALEN>
           <VECLEN>16</VECLEN>
           <MinCt>2</MinCt>
           <RsdToleranceFactor>50</RsdToleranceFactor>
           <Tune>true</Tune>
         </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <save_solnP>true</save_solnP>
        <gauge_id>default_gauge_field</gauge_id>
        <distillution_id>dist_obj</distillution_id>
        <src_file>${local_src_file}</src_file>
        <soln_file>${local_prop_file}</soln_file>
      </NamedObject>
    </elem>

EOF
close(INPUT);
}




]#


#------------------------------------------------------------------------------
when isMainModule:
  let 
    foo = "hello"
    bar = "there"

  let cfg_file = "/lustre/atlas/proj-shared/nph103/szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265/cfgs/szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265_cfg_1140d.lime"

  let inline = InlineMeasurements_t(meas: @[foo, bar])
  echo "inline:\n", inline
  let xml = serializeXML(inline)
  echo "xml:\n", xml

  let stem = "szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265"
  let lattSize = extractLattSize(stem)

  var chromaParam = ChromaParam_t(nrow: lattSize, InlineMeasurements: inline)
  echo "Param:\n", $serializeXML(chromaParam)

  let cfg = Cfg_t(cfg_type: "SCIDAC", cfg_file: cfg_file, parallel_io: true)

  let Chroma = Chroma_t(Param: chromaParam, Cfg: cfg)
  echo "Chroma:\n", $serializeXML(Chroma)
