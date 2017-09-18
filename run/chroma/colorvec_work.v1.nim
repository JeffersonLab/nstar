#
# This is the work script called by run_colorvec_*pl
#
import os, ospaths
import config

#------------------------------------------------------------------------
# Find a local path to a file, or cache_cp it
proc find_file(orig_file: string): string =
  var (basedir, filename, ext) = splitFile(orig_file)

  # scratch
  let scratch_dir = getScratchPath()

  # Copy files
  if not fileExists(orig_file):
    echo "In function find_file:   cache_cp ", orig_file

    if execCmd("cache_cp " & orig_file & scr) != 0:
      quit("Some problem copying with copying " & orig_file)

    result = $scr & "/" & filename
  else:
    result = orig_file



#[
#------------------------------------------------------------------------
# Copy a lustre file to scratch
proc copy_lustre_file($orig_file: string) =
  var (basedir, filename, ext) = splitFile(orig_file)

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
proc find_eig_files
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
# Copy files back to disk
proc copy_back
{
  local($output_dir,$input_file) = @_

  use File::Basename
  my $basedir  = dirname($input_file)
  my $filename = basename($input_file)

  # Copy files back to disk
  my $err = 0xffff & system("cache_cp ${input_file} $output_dir")
  if ($err > 0x00)
  {
    print "Some problem copying with copying $filename\n"
    exit(1)
  }
}


#------------------------------------------------------------------------
proc copy_back_rcp(output_dir, input_file: string) = 
  ## Copy files back to disk
  copy_back(output_dir,input_file)


#------------------------------------------------------------------------
proc copy_back_lustre(output_dir, input_file: string): bool =
  ## Copy files back to disk
  if execCmd("/bin/mv -f $input_file $output_dir") > 0:
    quit("Some problem copying file $input_file\n")
  else:
    return true


#------------------------------------------------------------------------
proc copy_back_scp(output_dir, input_file: string) = 
  ## Copy files back to disk
  copy_back_lustre(output_dir, input_file)

#------------------------------------------------------------------------
proc test_xml(file: string): bool =
  ## Test an xml file
  if execCmd("xmllint $file > /dev/null") > 0:
    quit("Some error running xmllint on $file")
  else:
    return true

#------------------------------------------------------------------------
proc flag_xml(file: string): bool =
  ## Test an xml file
  if execCmd("xmllint " & file & " > /dev/null") > 0:
    return false
  else:
    return true

#------------------------------------------------------------------------
proc test_sdb(file: string): bool =
   ## Test a sdb file
  if execCmd("dbkeys " & file " keys > /dev/null") > 0:
    quit("Some error running dbkeys on $file")
  else:
    return true


#------------------------------------------------------------------------
proc test_mod(file: string): bool =
  ## Test a mod file
  if execCmd("modkeys " & file " & > /dev/null") > 0:
    quit("Some error running modkeys on $file")
  else:
    return true


#------------------------------------------------------------------------
proc gzip(file: string): string =
  ## Zip a file
  if execCmd("gzip -f9 $file"):
    quit("Some error gzip $file")

  return file & ".gz"


#[
#------------------------------------------------------------------------
proc extract_params(data: string): seq[int] =
  ## Determine the lattice size and other stuff
  var stem = data
  $stem =~ s/\..*$//
  $stem =~ s/per\..*$/per/
  $stem =~ s/non\..*$/non/
  $stem =~ s/dir\..*$/dir/

  # Yuk, do some file name surgery
  my @F = split('_', $stem)
  my $Ls = $F[1]
  my $Lt = $F[2]
  my @nrow = ($Ls, $Ls, $Ls, $Lt)

  my $beta = $stem
  $beta =~ s/^.*_b//
  $beta =~ s/_.*$//
  $beta =~ s/p/./
    
  my $xi_0 = $stem
  $xi_0 =~ s/^.*_x//
  $xi_0 =~ s/_.*$//
  $xi_0 =~ s/p/./
    
  my $nu = $stem
  $nu =~ s/_non.*$//
  $nu =~ s/^.*_n//
  $nu =~ s/_.*$//
  $nu =~ s/p/./
    
  my $m_0 = $stem
  $m_0 =~ s/^.*_u//
  $m_0 =~ s/_.*$//
  $m_0 =~ s/p/./
  $m_0 =~ s/m/-/
    
  return @nrow
}
]#


#[
#------------------------------------------------------------------------
# Setup the rng in my desired way (using the trajectory number)
#
proc setup_rng
  local($traj) = @_

  # Seed the rng with the traj number
  srand($traj)

  # Call a few to clear out junk
  foreach $i (1 .. 20)
  {
    rand(1.0)
  }

  # Displace the origin of the time slices
  $HMCParam::origin = int(rand($HMCParam::nrow[3]))
]#



#------------------------------------------------------------------------
proc print_header_xml(input: string  =
  ## Header
  writeFile(input, """
  removeFile(input)
  open(INPUT, "> $input")

print INPUT <<EOF
<?xml version="1.0"?>

<chroma>
<Param> 
  <InlineMeasurements>
EOF
close(INPUT)



#------------------------------------------------------------------------
# Trailer
#
proc print_trailer_xml
{
  local($gage_type, $gage_cfg, $input) = @_

  open(INPUT, ">> $input")
  print INPUT <<EOF
  </InlineMeasurements>
  <nrow>@{HMCParam::nrow}</nrow>
  </Param>
  <Cfg>
    <cfg_type>${gage_type}</cfg_type>
    <cfg_file>${gage_cfg}</cfg_file>
    <parallel_io>true</parallel_io>
  </Cfg>
</chroma>
EOF
close(INPUT)
}


#------------------------------------------------------------------------
# Header
#
proc print_harom_header_xml
{
  local($input) = @_

  system("/bin/rm -f  $input")
  open(INPUT, "> $input")

print INPUT <<EOF
<?xml version="1.0"?>

<harom>
<Param> 
  <InlineMeasurements>
EOF
close(INPUT)
}


#------------------------------------------------------------------------
# Trailer
#
proc print_harom_trailer_xml
{
  local($input) = @_

  open(INPUT, ">> $input")
  print INPUT <<EOF
  </InlineMeasurements>
  <nrow>@{HMCParam::nrow}</nrow>
</Param> 
</harom>
EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print read colorvec eigeninfo
#
proc print_read_colorvec
{
  local($input) = @_

  # 
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>EIGENINFO_BIN_COLORVEC_READ_NAMED_OBJECT</Name>
      <File>
        <file_names>
EOF

  foreach $i (0 .. $HMCParam::num_vecs-1)
  {
    $stt = sprintf("S%04d", $i)
    open(INPUT, ">> $input")
    print INPUT <<EOF
          <elem>/scratch/${stt}.sev</elem>
EOF
  }

  open(INPUT, ">> $input")
  print INPUT <<EOF
        </file_names>
      </File>
      <NamedObject>
        <object_id>eigeninfo_0</object_id>
      </NamedObject>
    </elem>
EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print read colorvec eigeninfo
#
proc print_read_lime_colorvec
{
  local($local_path,$stem,$input) = @_

  # 
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>EIGENINFO_LIME_COLORVEC_READ_NAMED_OBJECT</Name>
      <File>
        <file_names>
EOF

  foreach $i (0 .. $HMCParam::num_vecs-1)
  {
    open(INPUT, ">> $input")
    print INPUT <<EOF
          <elem>${local_path}/${stem}.eigs_vec${i}.lime</elem>
EOF
  }

  open(INPUT, ">> $input")
  print INPUT <<EOF
        </file_names>
      </File>
      <NamedObject>
        <object_id>eigeninfo_0</object_id>
      </NamedObject>
    </elem>
EOF
close(INPUT)
}



#------------------------------------------------------------------------------
# Print distillution noise
#
proc print_dist_noise
{
  local($local_stem,$local_seqno,$input) = @_

  # 
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <annotation>
        Distillution noise
      </annotation>
      <Name>DISTILLUTION_NOISE</Name>
      <Frequency>1</Frequency>
      <Param>
        <ensemble>${local_stem}</ensemble>
        <sequence>${local_seqno}</sequence>
        <decay_dir>3</decay_dir>
      </Param>
      <NamedObject>
        <distillution_id>dist_obj</distillution_id>
      </NamedObject>
    </elem>
EOF
close(INPUT)
}

#------------------------------------------------------------------------------
# Print read colorvec eigeninfo
#
proc print_read_single_lime_colorvec
{
  local($local_path,$input) = @_

  # 
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>QIO_READ_NAMED_OBJECT</Name>
      <Frequency>1</Frequency>
      <NamedObject>
        <object_id>eigeninfo_0</object_id>
        <object_type>SubsetVectorsLatticeColorVector</object_type>
        <MapObject>
          <MapObjType>MAP_OBJECT_MEMORY</MapObjType>
        </MapObject>
      </NamedObject>
      <File>
        <file_name>${local_path}</file_name>
      </File>
    </elem>
EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print read single colorvec eigeninfo
#
proc print_read_subset_vectors
{
  local($single_file,$input) = @_

  # 
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>READ_SUBSET_VECTORS</Name>
      <File>
        <file_name>${single_file}</file_name>
      </File>
      <NamedObject>
        <object_id>eigeninfo_0</object_id>
      </NamedObject>
    </elem>
EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator driver
#
proc print_prop_colorvec
{
  local($m_q, $t_source, $input) = @_

  # Displace the origin
  my $t_src_shift = ($t_source + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t_src_shift}</t_sources>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
            <invType>EIG_CG_INVERTER</invType>
            <RsdCG>${HMCParam::RsdCG}</RsdCG>
            <RsdCGRestart>${HMCParam::RsdCGRestart}</RsdCGRestart>
            <MaxCG>${HMCParam::MaxCG}</MaxCG>
            <Nmax>60</Nmax>
            <Neig>8</Neig>
            <Neig_max>${HMCParam::Neig_max}</Neig_max>
            <updateRestartTol>0</updateRestartTol>
            <PrintLevel>1</PrintLevel>
            <eigen_id>linop_evs.${m_q}</eigen_id>
            <cleanUpEvecs>false</cleanUpEvecs>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_MEMORY</MapObjType>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}

#------------------------------------------------------------------------------
# Print propagator driver
#
proc print_prop_bicg_colorvec
{
  local($m_q, $t_source, $input) = @_

  # Displace the origin
  my $t_src_shift = ($t_source + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t_src_shift}</t_sources>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
            <invType>BICGSTAB_INVERTER</invType>
            <RsdBiCGStab>${HMCParam::RsdCG}</RsdBiCGStab>
            <MaxBiCGStab>${HMCParam::MaxCG}</MaxBiCGStab>
          </InvertParam>
        </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_MEMORY</MapObjType>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator driver for a gpu
#
proc print_prop_gpu_colorvec
{
  local($m_q, $t_source, $seqno, $tmp_file, $input) = @_

  # Displace the origin
  my $t_src_shift = ($t_source + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t_src_shift}</t_sources>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>5.0e-7</RsdTarget>
          <Delta>0.1</Delta>
          <MaxIter>10000</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>BICGSTAB</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <CudaSloppyPrecision>HALF</CudaSloppyPrecision>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_DISK</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator driver for a gpu
#
proc print_prop_gpu_colorvec_no_disk
{
  local($m_q, $t_source, $seqno, $tmp_file, $input) = @_

  # Displace the origin
  my $t_src_shift = ($t_source + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t_src_shift}</t_sources>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>5.0e-7</RsdTarget>
          <Delta>0.1</Delta>
          <MaxIter>10000</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>BICGSTAB</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <CudaSloppyPrecision>HALF</CudaSloppyPrecision>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_MEMORY</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_gpu_and_matelem_colorvec
{
  local($db_file, $m_q, $t_source, $input) = @_

  # Displace the origin
  my $t_src_shift = ($t_source + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_AND_MATELEM_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t_src_shift}</t_sources>
          <decay_dir>3</decay_dir>
          <mass_label>U${m_q}</mass_label>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>5.0e-8</RsdTarget>
          <Delta>0.1</Delta>
          <MaxIter>10000</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>BICGSTAB</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <CudaSloppyPrecision>HALF</CudaSloppyPrecision>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <prop_op_file>${db_file}</prop_op_file>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_NULL</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_distillation_gpu
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>${HMCParam::RsdTarget}</RsdTarget>
          <RsdToleranceFactor>${HMCParam::RsdToleranceFactor}</RsdToleranceFactor>
          <SilentFailP>false</SilentFailP>
          <MaxIter>${HMCParam::MaxIter}</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>${HMCParam::SolverType}</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <!-- CudaSloppyPrecision>SINGLE</CudaSloppyPrecision -->
          <!-- Delta>0.001</Delta -->
          <CudaSloppyPrecision>${HMCParam::CudaSloppyPrecision}</CudaSloppyPrecision>
          <Delta>${HMCParam::Delta}</Delta>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
<AutotuneDslash>true</AutotuneDslash>
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
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_distillation_qphix
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
          <!-- invType>QPHIX_CLOVER_INVERTER</invType -->
          <invType>QPHIX_CLOVER_ITER_REFINE_BICGSTAB_INVERTER</invType>
          <SolverType>BICGSTAB</SolverType>
          <MaxIter>${HMCParam::MaxIter}</MaxIter>
          <RsdTarget>${HMCParam::RsdTarget}</RsdTarget>
          <Delta>${HMCParam::Delta}</Delta>
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
          <AntiPeriodicT>true</AntiPeriodicT>
          <Verbose>false</Verbose>
          <RsdToleranceFactor>${HMCParam::RsdToleranceFactor}</RsdToleranceFactor>
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
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_and_matelem_distillation_gpu
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>${HMCParam::RsdTarget}</RsdTarget>
          <RsdToleranceFactor>${HMCParam::RsdToleranceFactor}</RsdToleranceFactor>
          <SilentFailP>false</SilentFailP>
          <MaxIter>${HMCParam::MaxIter}</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>${HMCParam::SolverType}</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <!-- CudaSloppyPrecision>SINGLE</CudaSloppyPrecision -->
          <!-- Delta>0.001</Delta -->
          <CudaSloppyPrecision>${HMCParam::CudaSloppyPrecision}</CudaSloppyPrecision>
          <Delta>${HMCParam::Delta}</Delta>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
<AutotuneDslash>true</AutotuneDslash>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_file>${local_eig_file}</colorvec_file>
        <prop_op_file>${local_prop_file}</prop_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_distillation_gpu_list
{
  local($local_src_file, $local_prop_file, $m_q, $input) = @_

  my $t0_string
  foreach my $t0t (@{HMCParam::t_sources})
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>${HMCParam::RsdTarget}</RsdTarget>
          <RsdToleranceFactor>${HMCParam::RsdToleranceFactor}</RsdToleranceFactor>
          <SilentFailP>false</SilentFailP>
          <MaxIter>${HMCParam::MaxIter}</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>${HMCParam::SolverType}</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <!-- CudaSloppyPrecision>SINGLE</CudaSloppyPrecision -->
          <!-- Delta>0.001</Delta -->
          <CudaSloppyPrecision>${HMCParam::CudaSloppyPrecision}</CudaSloppyPrecision>
          <Delta>${HMCParam::Delta}</Delta>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
<AutotuneDslash>true</AutotuneDslash>
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
close(INPUT)
}

#------------------------------------------------------------------------------
# Print propagator and matelem driver for a cpu
#
proc print_prop_distillation_cpu
{
  local($local_src_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
close(INPUT)
}

#------------------------------------------------------------------------------
# Print propagator and matelem driver for a cpu
#
proc print_prop_distillation_cpu_mg
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_distillation_gpu_mg
{
  local($local_eig_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
            <invType>QUDA_MULTIGRID_CLOVER_INVERTER</invType>
            <MULTIGRIDParams>
	      <CycleType>MG_RECURSIVE</CycleType>
              <Residual>0.2</Residual>
	      <RelaxationOmegaMG>1.0</RelaxationOmegaMG>
	      <RelaxationOmegaOuter>1.0</RelaxationOmegaOuter>
              <MaxIterations>12</MaxIterations>
              <SmootherType>MR</SmootherType>
              <Verbosity>true</Verbosity>
              <Precision>SINGLE</Precision>
              <Reconstruct>RECONS_NONE</Reconstruct>
              <NullVectors>24</NullVectors>
              <GenerateNullspace>true</GenerateNullspace>
	      <GenerateAllLevels>true</GenerateAllLevels>
              <Pre-SmootherApplications>0</Pre-SmootherApplications>
              <Post-SmootherApplications>4</Post-SmootherApplications>
              <SchwarzType>ADDITIVE_SCHWARZ</SchwarzType>
              <Blocking>
                <elem>3 3 3 8</elem>
                <elem>2 2 2 4</elem>
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
            <RsdToleranceFactor>50</RsdToleranceFactor>
            <SilentFail>true</SilentFail>
            <AntiPeriodicT>true</AntiPeriodicT>
            <SolverType>GCR</SolverType>
            <Verbose>false</Verbose>
            <AsymmetricLinop>false</AsymmetricLinop>
            <CudaReconstruct>RECONS_12</CudaReconstruct>
            <CudaSloppyPrecision>SINGLE</CudaSloppyPrecision>
            <CudaSloppyReconstruct>RECONS_8</CudaSloppyReconstruct>
            <AxialGaugeFix>false</AxialGaugeFix>
            <AutotuneDslash>true</AutotuneDslash>
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
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a avx
#
proc print_prop_distillation_avx
{
  local($local_src_file, $local_prop_file, $m_q, $t0_val, $input) = @_

  # Displace the origin
  my $t0_string = ($t0_val + $HMCParam::origin) % $HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
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
close(INPUT)
}




#------------------------------------------------------------------------------
# Print make_src_dist input
#
proc print_make_src_distillation
{
  local($local_colorvec_file, $local_src_file, $m_q, $input) = @_

  my $t0_string
  foreach my $t0t (@{HMCParam::t_sources})
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MAKE_SOURCE_DISTILLATION</Name>
      <Frequency>1</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
        </Contractions>
      </Param>
      <NamedObject>
        <colorvec_file>${local_colorvec_file}</colorvec_file>
        <src_file>${local_src_file}</src_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print peram_dist input
#
proc print_peram_distillation
{
  local($local_colorvec_file, $local_soln_file, $local_peram_file, $m_q, $input) = @_

  my $t0_string
  foreach my $t0t (@{HMCParam::t_sources})
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PERAM_DISTILLATION</Name>
      <Frequency>1</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
        </Contractions>
      </Param>
      <NamedObject>
        <distillution_id>dist_obj</distillution_id>
        <colorvec_file>${local_colorvec_file}</colorvec_file>
        <soln_file>${local_soln_file}</soln_file>
        <peram_file>${local_peram_file}</peram_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print peram_dist input
#
proc print_peram_distillation_diag_opt
{
  local($local_colorvec_file, $tmpp, $local_peram_file, $m_q, $input) = @_

  my @local_soln_files = @{$tmpp}

  my $t0_string
  foreach my $t0t (@HMCParam::t_sources)
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PERAM_DISTILLATION_OPT</Name>
      <Frequency>1</Frequency>
      <Param>
        <Contractions>
          <mass_label>U${m_q}</mass_label>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <Nt_forward>${HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>${HMCParam::Nt_backward}</Nt_backward>
        </Contractions>
      </Param>
      <NamedObject>
        <colorvec_file>${local_colorvec_file}</colorvec_file>
        <soln_files>
EOF
  close(INPUT)

  foreach my $i (@local_soln_files)
  {
    open(INPUT, ">> $input")
    print INPUT <<EOF
          <elem>${i}</elem>
EOF
    close(INPUT)
  }

  open(INPUT, ">> $input")
  print INPUT <<EOF
        </soln_files>
        <peram_file>${local_peram_file}</peram_file>
      </NamedObject>
    </elem>

EOF
  close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_gpu_and_matelem_colorvec_list
{
  local($db_file, $m_q, $input, @t_sources) = @_

  local $t0t
  local $t0_string
  foreach $t0t (@t_sources)
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_AND_MATELEM_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <decay_dir>3</decay_dir>
          <mass_label>U${m_q}</mass_label>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>CLOVER</FermAct>
            <Mass>${m_q}</Mass>
            <clovCoeff>${c_s}</clovCoeff>
            <FermState>
              <Name>SIMPLE_FERM_STATE</Name>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
<annotation>
            <clovCoeffR>${c_s}</clovCoeffR>
            <clovCoeffT>${c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
</annotation>
          </FermionAction>
          <InvertParam>
          <invType>QUDA_CLOVER_INVERTER</invType>
          <CloverParams>
               <Mass>${m_q}</Mass>
               <clovCoeff>${c_s}</clovCoeff>
<annotation>
               <clovCoeffR>${c_s}</clovCoeffR>
               <clovCoeffT>${c_t}</clovCoeffT>
               <AnisoParam>
                 <anisoP>true</anisoP>
                 <t_dir>3</t_dir>
                 <xi_0>${HMCParam::xi_0}</xi_0>
                 <nu>${HMCParam::nu}</nu>
               </AnisoParam>
</annotation>
          </CloverParams>
          <RsdTarget>5.0e-7</RsdTarget>
          <RsdToleranceFactor>15</RsdToleranceFactor>
          <SilentFailP>false</SilentFailP>
          <Delta>0.1</Delta>
          <MaxIter>10000</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>BICGSTAB</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <CudaSloppyPrecision>HALF</CudaSloppyPrecision>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
<AutotuneDslash>true</AutotuneDslash>
<CacheAutotuningResults>true</CacheAutotuningResults>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <prop_op_file>${db_file}</prop_op_file>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_NULL</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver for a gpu
#
proc print_prop_gpu_and_matelem_colorvec_list_cg
{
  local($db_file, $m_q, $input, @t_sources) = @_

  local $t0t
  local $t0_string
  foreach $t0t (@t_sources)
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_AND_MATELEM_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <decay_dir>3</decay_dir>
          <mass_label>U${m_q}</mass_label>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
          <invType>QUDA_CLOVER_INVERTER</invType>
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
          <RsdTarget>5.0e-7</RsdTarget>
          <RsdToleranceFactor>10</RsdToleranceFactor>
          <SilentFailP>false</SilentFailP>
          <Delta>0.1</Delta>
          <MaxIter>10000</MaxIter>
          <AntiPeriodicT>true</AntiPeriodicT>
          <SolverType>CG</SolverType>
          <Verbose>false</Verbose>
          <AsymmetricLinop>false</AsymmetricLinop>
          <CudaReconstruct>RECONS_12</CudaReconstruct>
          <CudaSloppyPrecision>HALF</CudaSloppyPrecision>
          <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
          <AxialGaugeFix>false</AxialGaugeFix>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <prop_op_file>${db_file}</prop_op_file>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_NULL</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator and matelem driver
#
proc print_prop_and_matelem_colorvec_list
{
  local($db_file, $m_q, $input, @t_sources) = @_

  local $t0t
  local $t0_string
  foreach $t0t (@t_sources)
  {
    # Displace the origin
    my $t_src_shift = ($t0t + $HMCParam::origin) % $HMCParam::nrow[3]
    $t0_string = $t0_string . " $t_src_shift"
  }

# Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_AND_MATELEM_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>${t0_string}</t_sources>
          <decay_dir>3</decay_dir>
          <mass_label>U${m_q}</mass_label>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
            <invType>BICGSTAB_INVERTER</invType>
            <RsdBiCGStab>${HMCParam::RsdCG}</RsdBiCGStab>
            <MaxBiCGStab>${HMCParam::MaxCG}</MaxBiCGStab>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <prop_op_file>${db_file}</prop_op_file>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_NULL</MapObjType>
          <FileName>$tmp_file</FileName>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print propagator driver
#
proc print_prop_colorvec_list
{
  local($m_q, $input, @t_slices) = @_

  # Displace the origin
  my @t_slices_shift, $tt
  foreach $tt (@t_slices)
  {
    push(@t_slices_shift, ($tt + $HMCParam::origin) % $HMCParam::nrow[3])
  }

  # Print for a single mass
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_COLORVEC</Name>
      <Frequency>${HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <num_vecs>${HMCParam::num_vecs}</num_vecs>
          <t_sources>@{t_slices_shift}</t_sources>
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
              <anisoP>true</anisoP>
              <t_dir>3</t_dir>
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
            <invType>EIG_CG_INVERTER</invType>
            <RsdCG>${HMCParam::RsdCG}</RsdCG>
            <RsdCGRestart>${HMCParam::RsdCGRestart}</RsdCGRestart>
            <MaxCG>${HMCParam::MaxCG}</MaxCG>
            <Nmax>60</Nmax>
            <Neig>8</Neig>
            <Neig_max>${HMCParam::Neig_max}</Neig_max>
            <updateRestartTol>0</updateRestartTol>
            <PrintLevel>1</PrintLevel>
            <eigen_id>linop_evs.${m_q}</eigen_id>
            <cleanUpEvecs>false</cleanUpEvecs>
          </InvertParam>
         </Propagator>
      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <prop_id>prop_colorvec.${m_q}</prop_id>
        <PropMapObject>
          <MapObjType>MAP_OBJECT_MEMORY</MapObjType>
        </PropMapObject>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print meson colorvec matrix elements
#
proc print_meson_colorvec
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MESON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>0</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <orthog_basis>false</orthog_basis>

        <!-- List of displacement arrays -->
        <displacement_list>
          <elem>0</elem>
          <elem>1</elem>
          <elem>-1</elem>
          <elem>2</elem>
          <elem>-2</elem>
          <elem>3</elem>
          <elem>-3</elem>
          <elem>1 1</elem>
          <elem>-1 -1</elem>
          <elem>2 2</elem>
          <elem>-2 -2</elem>
          <elem>3 3</elem>
          <elem>-3 -3</elem>
          <elem>1 2</elem>
          <elem>-1 2</elem>
          <elem>1 -2</elem>
          <elem>-1 -2</elem>
          <elem>1 3</elem>
          <elem>-1 3</elem>
          <elem>1 -3</elem>
          <elem>-1 -3</elem>
          <elem>2 1</elem>
          <elem>-2 1</elem>
          <elem>2 -1</elem>
          <elem>-2 -1</elem>
          <elem>2 3</elem>
          <elem>-2 3</elem>
          <elem>2 -3</elem>
          <elem>-2 -3</elem>
          <elem>3 1</elem>
          <elem>-3 1</elem>
          <elem>3 -1</elem>
          <elem>-3 -1</elem>
          <elem>3 2</elem>
          <elem>-3 2</elem>
          <elem>3 -2</elem>
          <elem>-3 -2</elem>
          <elem>-3 -3 -3</elem>
          <elem>-3 -3 -2</elem>
          <elem>-3 -3 -1</elem>
          <elem>-3 -3 1</elem>
          <elem>-3 -3 2</elem>
          <elem>-3 -2 -3</elem>
          <elem>-3 -2 -2</elem>
          <elem>-3 -2 -1</elem>
          <elem>-3 -2 1</elem>
          <elem>-3 -2 3</elem>
          <elem>-3 -1 -3</elem>
          <elem>-3 -1 -2</elem>
          <elem>-3 -1 -1</elem>
          <elem>-3 -1 2</elem>
          <elem>-3 -1 3</elem>
          <elem>-3 1 -3</elem>
          <elem>-3 1 -2</elem>
          <elem>-3 1 1</elem>
          <elem>-3 1 2</elem>
          <elem>-3 1 3</elem>
          <elem>-3 2 -3</elem>
          <elem>-3 2 -1</elem>
          <elem>-3 2 1</elem>
          <elem>-3 2 2</elem>
          <elem>-3 2 3</elem>
          <elem>-2 -3 -3</elem>
          <elem>-2 -3 -2</elem>
          <elem>-2 -3 -1</elem>
          <elem>-2 -3 1</elem>
          <elem>-2 -3 2</elem>
          <elem>-2 -2 -3</elem>
          <elem>-2 -2 -2</elem>
          <elem>-2 -2 -1</elem>
          <elem>-2 -2 1</elem>
          <elem>-2 -2 3</elem>
          <elem>-2 -1 -3</elem>
          <elem>-2 -1 -2</elem>
          <elem>-2 -1 -1</elem>
          <elem>-2 -1 2</elem>
          <elem>-2 -1 3</elem>
          <elem>-2 1 -3</elem>
          <elem>-2 1 -2</elem>
          <elem>-2 1 1</elem>
          <elem>-2 1 2</elem>
          <elem>-2 1 3</elem>
          <elem>-2 3 -2</elem>
          <elem>-2 3 -1</elem>
          <elem>-2 3 1</elem>
          <elem>-2 3 2</elem>
          <elem>-2 3 3</elem>
          <elem>-1 -3 -3</elem>
          <elem>-1 -3 -2</elem>
          <elem>-1 -3 -1</elem>
          <elem>-1 -3 1</elem>
          <elem>-1 -3 2</elem>
          <elem>-1 -2 -3</elem>
          <elem>-1 -2 -2</elem>
          <elem>-1 -2 -1</elem>
          <elem>-1 -2 1</elem>
          <elem>-1 -2 3</elem>
          <elem>-1 -1 -3</elem>
          <elem>-1 -1 -2</elem>
          <elem>-1 -1 -1</elem>
          <elem>-1 -1 2</elem>
          <elem>-1 -1 3</elem>
          <elem>-1 2 -3</elem>
          <elem>-1 2 -1</elem>
          <elem>-1 2 1</elem>
          <elem>-1 2 2</elem>
          <elem>-1 2 3</elem>
          <elem>-1 3 -2</elem>
          <elem>-1 3 -1</elem>
          <elem>-1 3 1</elem>
          <elem>-1 3 2</elem>
          <elem>-1 3 3</elem>
          <elem>1 -3 -3</elem>
          <elem>1 -3 -2</elem>
          <elem>1 -3 -1</elem>
          <elem>1 -3 1</elem>
          <elem>1 -3 2</elem>
          <elem>1 -2 -3</elem>
          <elem>1 -2 -2</elem>
          <elem>1 -2 -1</elem>
          <elem>1 -2 1</elem>
          <elem>1 -2 3</elem>
          <elem>1 1 -3</elem>
          <elem>1 1 -2</elem>
          <elem>1 1 1</elem>
          <elem>1 1 2</elem>
          <elem>1 1 3</elem>
          <elem>1 2 -3</elem>
          <elem>1 2 -1</elem>
          <elem>1 2 1</elem>
          <elem>1 2 2</elem>
          <elem>1 2 3</elem>
          <elem>1 3 -2</elem>
          <elem>1 3 -1</elem>
          <elem>1 3 1</elem>
          <elem>1 3 2</elem>
          <elem>1 3 3</elem>
          <elem>2 -3 -3</elem>
          <elem>2 -3 -2</elem>
          <elem>2 -3 -1</elem>
          <elem>2 -3 1</elem>
          <elem>2 -3 2</elem>
          <elem>2 -1 -3</elem>
          <elem>2 -1 -2</elem>
          <elem>2 -1 -1</elem>
          <elem>2 -1 2</elem>
          <elem>2 -1 3</elem>
          <elem>2 1 -3</elem>
          <elem>2 1 -2</elem>
          <elem>2 1 1</elem>
          <elem>2 1 2</elem>
          <elem>2 1 3</elem>
          <elem>2 2 -3</elem>
          <elem>2 2 -1</elem>
          <elem>2 2 1</elem>
          <elem>2 2 2</elem>
          <elem>2 2 3</elem>
          <elem>2 3 -2</elem>
          <elem>2 3 -1</elem>
          <elem>2 3 1</elem>
          <elem>2 3 2</elem>
          <elem>2 3 3</elem>
          <elem>3 -2 -3</elem>
          <elem>3 -2 -2</elem>
          <elem>3 -2 -1</elem>
          <elem>3 -2 1</elem>
          <elem>3 -2 3</elem>
          <elem>3 -1 -3</elem>
          <elem>3 -1 -2</elem>
          <elem>3 -1 -1</elem>
          <elem>3 -1 2</elem>
          <elem>3 -1 3</elem>
          <elem>3 1 -3</elem>
          <elem>3 1 -2</elem>
          <elem>3 1 1</elem>
          <elem>3 1 2</elem>
          <elem>3 1 3</elem>
          <elem>3 2 -3</elem>
          <elem>3 2 -1</elem>
          <elem>3 2 1</elem>
          <elem>3 2 2</elem>
          <elem>3 2 3</elem>
          <elem>3 3 -2</elem>
          <elem>3 3 -1</elem>
          <elem>3 3 1</elem>
          <elem>3 3 2</elem>
          <elem>3 3 3</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <meson_op_file>${db_file}</meson_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print meson colorvec matrix elements
#
proc print_meson_colorvec_mom
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MESON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <orthog_basis>false</orthog_basis>

        <!-- List of displacement arrays -->
        <displacement_list>
          <elem>0</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <meson_op_file>${db_file}</meson_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
proc print_meson_colorvec_mom_disp1
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MESON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>2</version>
        <mom2_min>${HMCParam::mom2_min}</mom2_min>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <orthog_basis>false</orthog_basis>

        <!-- List of displacement arrays -->
        <displacement_list>
          <elem>0</elem>
          <elem>1</elem>
          <elem>-1</elem>
          <elem>2</elem>
          <elem>-2</elem>
          <elem>3</elem>
          <elem>-3</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <meson_op_file>${db_file}</meson_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


proc print_meson_colorvec_mom_disp2
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MESON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>2</version>
        <mom2_min>${HMCParam::mom2_min}</mom2_min>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <orthog_basis>false</orthog_basis>

        <!-- List of displacement arrays -->
        <displacement_list>
          <elem>0</elem>
          <elem>1</elem>
          <elem>-1</elem>
          <elem>2</elem>
          <elem>-2</elem>
          <elem>3</elem>
          <elem>-3</elem>
          <elem>1 1</elem>
          <elem>-1 -1</elem>
          <elem>2 2</elem>
          <elem>-2 -2</elem>
          <elem>3 3</elem>
          <elem>-3 -3</elem>
          <elem>1 2</elem>
          <elem>-1 2</elem>
          <elem>1 -2</elem>
          <elem>-1 -2</elem>
          <elem>1 3</elem>
          <elem>-1 3</elem>
          <elem>1 -3</elem>
          <elem>-1 -3</elem>
          <elem>2 1</elem>
          <elem>-2 1</elem>
          <elem>2 -1</elem>
          <elem>-2 -1</elem>
          <elem>2 3</elem>
          <elem>-2 3</elem>
          <elem>2 -3</elem>
          <elem>-2 -3</elem>
          <elem>3 1</elem>
          <elem>-3 1</elem>
          <elem>3 -1</elem>
          <elem>-3 -1</elem>
          <elem>3 2</elem>
          <elem>-3 2</elem>
          <elem>3 -2</elem>
          <elem>-3 -2</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <meson_op_file>${db_file}</meson_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print meson colorvec matrix elements
# -- nonzero momentum and ONLY two displacements
#
proc print_meson_colorvec_mom_disp2only
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>MESON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>2</version>
        <mom2_min>${HMCParam::mom2_min}</mom2_min>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <orthog_basis>false</orthog_basis>

        <!-- List of displacement arrays -->
        <displacement_list>
          <elem>1 1</elem>
          <elem>-1 -1</elem>
          <elem>2 2</elem>
          <elem>-2 -2</elem>
          <elem>3 3</elem>
          <elem>-3 -3</elem>
          <elem>1 2</elem>
          <elem>-1 2</elem>
          <elem>1 -2</elem>
          <elem>-1 -2</elem>
          <elem>1 3</elem>
          <elem>-1 3</elem>
          <elem>1 -3</elem>
          <elem>-1 -3</elem>
          <elem>2 1</elem>
          <elem>-2 1</elem>
          <elem>2 -1</elem>
          <elem>-2 -1</elem>
          <elem>2 3</elem>
          <elem>-2 3</elem>
          <elem>2 -3</elem>
          <elem>-2 -3</elem>
          <elem>3 1</elem>
          <elem>-3 1</elem>
          <elem>3 -1</elem>
          <elem>-3 -1</elem>
          <elem>3 2</elem>
          <elem>-3 2</elem>
          <elem>3 -2</elem>
          <elem>-3 -2</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <meson_op_file>${db_file}</meson_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print baryon colorvec matrix elements
#
proc print_harom_baryon_colorvec
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>BARYON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>2</version>
        <use_derivP>true</use_derivP>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <site_orthog_basis>false</site_orthog_basis>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem><left>0</left><middle>0</middle><right>0</right></elem>
          <elem><left>0</left><middle>0</middle><right>1</right></elem>
          <elem><left>0</left><middle>0</middle><right>2</right></elem>
          <elem><left>0</left><middle>0</middle><right>3</right></elem>
          <elem><left>0</left><middle>0</middle><right>1 1</right></elem>
          <elem><left>0</left><middle>0</middle><right>1 2</right></elem>
          <elem><left>0</left><middle>0</middle><right>1 3</right></elem>
          <elem><left>0</left><middle>0</middle><right>2 1</right></elem>
          <elem><left>0</left><middle>0</middle><right>2 2</right></elem>
          <elem><left>0</left><middle>0</middle><right>2 3</right></elem>
          <elem><left>0</left><middle>0</middle><right>3 1</right></elem>
          <elem><left>0</left><middle>0</middle><right>3 2</right></elem>
          <elem><left>0</left><middle>0</middle><right>3 3</right></elem>
          <elem><left>0</left><middle>1</middle><right>1</right></elem>
          <elem><left>0</left><middle>1</middle><right>2</right></elem>
          <elem><left>0</left><middle>1</middle><right>3</right></elem>
          <elem><left>0</left><middle>2</middle><right>2</right></elem>
          <elem><left>0</left><middle>2</middle><right>3</right></elem>
          <elem><left>0</left><middle>3</middle><right>3</right></elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <baryon_op_file>${db_file}</baryon_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print baryon colorvec matrix elements
#
proc print_harom_baryon_colorvec_no_deriv
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>BARYON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>3</version>
        <use_derivP>true</use_derivP>
        <mom_list></mom_list>
        <mom2_min>${HMCParam::mom2_min}</mom2_min>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem><left>0</left><middle>0</middle><right>0</right></elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_file>${HMCParam::gauge_file}</gauge_file>
        <colorvec_file>${HMCParam::eig_file}</colorvec_file>
        <baryon_op_file>${db_file}</baryon_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print baryon colorvec matrix elements with mom
#
proc print_baryon_colorvec_mom
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>BARYON_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>2</version>
        <use_derivP>true</use_derivP>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <site_orthog_basis>false</site_orthog_basis>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem><left>0</left><middle>0</middle><right>0</right></elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <baryon_op_file>${db_file}</baryon_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print glueball colorvec matrix elements
#
proc print_glue_mag_colorvec
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>GLUEBALL_OPS</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem></elem>
          <elem>1</elem>
          <elem>2</elem>
          <elem>3</elem>
          <elem>1 1</elem>
          <elem>1 2</elem>
          <elem>1 3</elem>
          <elem>2 1</elem>
          <elem>2 2</elem>
          <elem>2 3</elem>
          <elem>3 1</elem>
          <elem>3 2</elem>
          <elem>3 3</elem>
          <elem>1 1 1</elem>
          <elem>1 1 2</elem>
          <elem>1 1 3</elem>
          <elem>1 2 1</elem>
          <elem>1 2 2</elem>
          <elem>1 2 3</elem>
          <elem>1 3 1</elem>
          <elem>1 3 2</elem>
          <elem>1 3 3</elem>
          <elem>2 1 1</elem>
          <elem>2 1 2</elem>
          <elem>2 1 3</elem>
          <elem>2 2 1</elem>
          <elem>2 2 2</elem>
          <elem>2 2 3</elem>
          <elem>2 3 1</elem>
          <elem>2 3 2</elem>
          <elem>2 3 3</elem>
          <elem>3 1 1</elem>
          <elem>3 1 2</elem>
          <elem>3 1 3</elem>
          <elem>3 2 1</elem>
          <elem>3 2 2</elem>
          <elem>3 2 3</elem>
          <elem>3 3 1</elem>
          <elem>3 3 2</elem>
          <elem>3 3 3</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <glue_op_file>${db_file}</glue_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print glueball colorvec matrix elements
#
proc print_glue_dist_colorvec
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>GLUEBALL_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <site_orthog_basis>false</site_orthog_basis>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem></elem>
          <elem>1</elem>
          <elem>2</elem>
          <elem>3</elem>
          <elem>1 1</elem>
          <elem>1 2</elem>
          <elem>1 3</elem>
          <elem>2 1</elem>
          <elem>2 2</elem>
          <elem>2 3</elem>
          <elem>3 1</elem>
          <elem>3 2</elem>
          <elem>3 3</elem>
          <elem>1 1 1</elem>
          <elem>1 1 2</elem>
          <elem>1 1 3</elem>
          <elem>1 2 1</elem>
          <elem>1 2 2</elem>
          <elem>1 2 3</elem>
          <elem>1 3 1</elem>
          <elem>1 3 2</elem>
          <elem>1 3 3</elem>
          <elem>2 1 1</elem>
          <elem>2 1 2</elem>
          <elem>2 1 3</elem>
          <elem>2 2 1</elem>
          <elem>2 2 2</elem>
          <elem>2 2 3</elem>
          <elem>2 3 1</elem>
          <elem>2 3 2</elem>
          <elem>2 3 3</elem>
          <elem>3 1 1</elem>
          <elem>3 1 2</elem>
          <elem>3 1 3</elem>
          <elem>3 2 1</elem>
          <elem>3 2 2</elem>
          <elem>3 2 3</elem>
          <elem>3 3 1</elem>
          <elem>3 3 2</elem>
          <elem>3 3 3</elem>
          <elem>1 1 1 1</elem>
          <elem>1 1 1 2</elem>
          <elem>1 1 1 3</elem>
          <elem>1 1 2 1</elem>
          <elem>1 1 2 2</elem>
          <elem>1 1 2 3</elem>
          <elem>1 1 3 1</elem>
          <elem>1 1 3 2</elem>
          <elem>1 1 3 3</elem>
          <elem>1 2 1 1</elem>
          <elem>1 2 1 2</elem>
          <elem>1 2 1 3</elem>
          <elem>1 2 2 1</elem>
          <elem>1 2 2 2</elem>
          <elem>1 2 2 3</elem>
          <elem>1 2 3 1</elem>
          <elem>1 2 3 2</elem>
          <elem>1 2 3 3</elem>
          <elem>1 3 1 1</elem>
          <elem>1 3 1 2</elem>
          <elem>1 3 1 3</elem>
          <elem>1 3 2 1</elem>
          <elem>1 3 2 2</elem>
          <elem>1 3 2 3</elem>
          <elem>1 3 3 1</elem>
          <elem>1 3 3 2</elem>
          <elem>1 3 3 3</elem>
          <elem>2 1 1 1</elem>
          <elem>2 1 1 2</elem>
          <elem>2 1 1 3</elem>
          <elem>2 1 2 1</elem>
          <elem>2 1 2 2</elem>
          <elem>2 1 2 3</elem>
          <elem>2 1 3 1</elem>
          <elem>2 1 3 2</elem>
          <elem>2 1 3 3</elem>
          <elem>2 2 1 1</elem>
          <elem>2 2 1 2</elem>
          <elem>2 2 1 3</elem>
          <elem>2 2 2 1</elem>
          <elem>2 2 2 2</elem>
          <elem>2 2 2 3</elem>
          <elem>2 2 3 1</elem>
          <elem>2 2 3 2</elem>
          <elem>2 2 3 3</elem>
          <elem>2 3 1 1</elem>
          <elem>2 3 1 2</elem>
          <elem>2 3 1 3</elem>
          <elem>2 3 2 1</elem>
          <elem>2 3 2 2</elem>
          <elem>2 3 2 3</elem>
          <elem>2 3 3 1</elem>
          <elem>2 3 3 2</elem>
          <elem>2 3 3 3</elem>
          <elem>3 1 1 1</elem>
          <elem>3 1 1 2</elem>
          <elem>3 1 1 3</elem>
          <elem>3 1 2 1</elem>
          <elem>3 1 2 2</elem>
          <elem>3 1 2 3</elem>
          <elem>3 1 3 1</elem>
          <elem>3 1 3 2</elem>
          <elem>3 1 3 3</elem>
          <elem>3 2 1 1</elem>
          <elem>3 2 1 2</elem>
          <elem>3 2 1 3</elem>
          <elem>3 2 2 1</elem>
          <elem>3 2 2 2</elem>
          <elem>3 2 2 3</elem>
          <elem>3 2 3 1</elem>
          <elem>3 2 3 2</elem>
          <elem>3 2 3 3</elem>
          <elem>3 3 1 1</elem>
          <elem>3 3 1 2</elem>
          <elem>3 3 1 3</elem>
          <elem>3 3 2 1</elem>
          <elem>3 3 2 2</elem>
          <elem>3 3 2 3</elem>
          <elem>3 3 3 1</elem>
          <elem>3 3 3 2</elem>
          <elem>3 3 3 3</elem>
          <elem>1 1 1 1 1</elem>
          <elem>1 1 1 1 2</elem>
          <elem>1 1 1 1 3</elem>
          <elem>1 1 1 2 1</elem>
          <elem>1 1 1 2 2</elem>
          <elem>1 1 1 2 3</elem>
          <elem>1 1 1 3 1</elem>
          <elem>1 1 1 3 2</elem>
          <elem>1 1 1 3 3</elem>
          <elem>1 1 2 1 1</elem>
          <elem>1 1 2 1 2</elem>
          <elem>1 1 2 1 3</elem>
          <elem>1 1 2 2 1</elem>
          <elem>1 1 2 2 2</elem>
          <elem>1 1 2 2 3</elem>
          <elem>1 1 2 3 1</elem>
          <elem>1 1 2 3 2</elem>
          <elem>1 1 2 3 3</elem>
          <elem>1 1 3 1 1</elem>
          <elem>1 1 3 1 2</elem>
          <elem>1 1 3 1 3</elem>
          <elem>1 1 3 2 1</elem>
          <elem>1 1 3 2 2</elem>
          <elem>1 1 3 2 3</elem>
          <elem>1 1 3 3 1</elem>
          <elem>1 1 3 3 2</elem>
          <elem>1 1 3 3 3</elem>
          <elem>1 2 1 1 1</elem>
          <elem>1 2 1 1 2</elem>
          <elem>1 2 1 1 3</elem>
          <elem>1 2 1 2 1</elem>
          <elem>1 2 1 2 2</elem>
          <elem>1 2 1 2 3</elem>
          <elem>1 2 1 3 1</elem>
          <elem>1 2 1 3 2</elem>
          <elem>1 2 1 3 3</elem>
          <elem>1 2 2 1 1</elem>
          <elem>1 2 2 1 2</elem>
          <elem>1 2 2 1 3</elem>
          <elem>1 2 2 2 1</elem>
          <elem>1 2 2 2 2</elem>
          <elem>1 2 2 2 3</elem>
          <elem>1 2 2 3 1</elem>
          <elem>1 2 2 3 2</elem>
          <elem>1 2 2 3 3</elem>
          <elem>1 2 3 1 1</elem>
          <elem>1 2 3 1 2</elem>
          <elem>1 2 3 1 3</elem>
          <elem>1 2 3 2 1</elem>
          <elem>1 2 3 2 2</elem>
          <elem>1 2 3 2 3</elem>
          <elem>1 2 3 3 1</elem>
          <elem>1 2 3 3 2</elem>
          <elem>1 2 3 3 3</elem>
          <elem>1 3 1 1 1</elem>
          <elem>1 3 1 1 2</elem>
          <elem>1 3 1 1 3</elem>
          <elem>1 3 1 2 1</elem>
          <elem>1 3 1 2 2</elem>
          <elem>1 3 1 2 3</elem>
          <elem>1 3 1 3 1</elem>
          <elem>1 3 1 3 2</elem>
          <elem>1 3 1 3 3</elem>
          <elem>1 3 2 1 1</elem>
          <elem>1 3 2 1 2</elem>
          <elem>1 3 2 1 3</elem>
          <elem>1 3 2 2 1</elem>
          <elem>1 3 2 2 2</elem>
          <elem>1 3 2 2 3</elem>
          <elem>1 3 2 3 1</elem>
          <elem>1 3 2 3 2</elem>
          <elem>1 3 2 3 3</elem>
          <elem>1 3 3 1 1</elem>
          <elem>1 3 3 1 2</elem>
          <elem>1 3 3 1 3</elem>
          <elem>1 3 3 2 1</elem>
          <elem>1 3 3 2 2</elem>
          <elem>1 3 3 2 3</elem>
          <elem>1 3 3 3 1</elem>
          <elem>1 3 3 3 2</elem>
          <elem>1 3 3 3 3</elem>
          <elem>2 1 1 1 1</elem>
          <elem>2 1 1 1 2</elem>
          <elem>2 1 1 1 3</elem>
          <elem>2 1 1 2 1</elem>
          <elem>2 1 1 2 2</elem>
          <elem>2 1 1 2 3</elem>
          <elem>2 1 1 3 1</elem>
          <elem>2 1 1 3 2</elem>
          <elem>2 1 1 3 3</elem>
          <elem>2 1 2 1 1</elem>
          <elem>2 1 2 1 2</elem>
          <elem>2 1 2 1 3</elem>
          <elem>2 1 2 2 1</elem>
          <elem>2 1 2 2 2</elem>
          <elem>2 1 2 2 3</elem>
          <elem>2 1 2 3 1</elem>
          <elem>2 1 2 3 2</elem>
          <elem>2 1 2 3 3</elem>
          <elem>2 1 3 1 1</elem>
          <elem>2 1 3 1 2</elem>
          <elem>2 1 3 1 3</elem>
          <elem>2 1 3 2 1</elem>
          <elem>2 1 3 2 2</elem>
          <elem>2 1 3 2 3</elem>
          <elem>2 1 3 3 1</elem>
          <elem>2 1 3 3 2</elem>
          <elem>2 1 3 3 3</elem>
          <elem>2 2 1 1 1</elem>
          <elem>2 2 1 1 2</elem>
          <elem>2 2 1 1 3</elem>
          <elem>2 2 1 2 1</elem>
          <elem>2 2 1 2 2</elem>
          <elem>2 2 1 2 3</elem>
          <elem>2 2 1 3 1</elem>
          <elem>2 2 1 3 2</elem>
          <elem>2 2 1 3 3</elem>
          <elem>2 2 2 1 1</elem>
          <elem>2 2 2 1 2</elem>
          <elem>2 2 2 1 3</elem>
          <elem>2 2 2 2 1</elem>
          <elem>2 2 2 2 2</elem>
          <elem>2 2 2 2 3</elem>
          <elem>2 2 2 3 1</elem>
          <elem>2 2 2 3 2</elem>
          <elem>2 2 2 3 3</elem>
          <elem>2 2 3 1 1</elem>
          <elem>2 2 3 1 2</elem>
          <elem>2 2 3 1 3</elem>
          <elem>2 2 3 2 1</elem>
          <elem>2 2 3 2 2</elem>
          <elem>2 2 3 2 3</elem>
          <elem>2 2 3 3 1</elem>
          <elem>2 2 3 3 2</elem>
          <elem>2 2 3 3 3</elem>
          <elem>2 3 1 1 1</elem>
          <elem>2 3 1 1 2</elem>
          <elem>2 3 1 1 3</elem>
          <elem>2 3 1 2 1</elem>
          <elem>2 3 1 2 2</elem>
          <elem>2 3 1 2 3</elem>
          <elem>2 3 1 3 1</elem>
          <elem>2 3 1 3 2</elem>
          <elem>2 3 1 3 3</elem>
          <elem>2 3 2 1 1</elem>
          <elem>2 3 2 1 2</elem>
          <elem>2 3 2 1 3</elem>
          <elem>2 3 2 2 1</elem>
          <elem>2 3 2 2 2</elem>
          <elem>2 3 2 2 3</elem>
          <elem>2 3 2 3 1</elem>
          <elem>2 3 2 3 2</elem>
          <elem>2 3 2 3 3</elem>
          <elem>2 3 3 1 1</elem>
          <elem>2 3 3 1 2</elem>
          <elem>2 3 3 1 3</elem>
          <elem>2 3 3 2 1</elem>
          <elem>2 3 3 2 2</elem>
          <elem>2 3 3 2 3</elem>
          <elem>2 3 3 3 1</elem>
          <elem>2 3 3 3 2</elem>
          <elem>2 3 3 3 3</elem>
          <elem>3 1 1 1 1</elem>
          <elem>3 1 1 1 2</elem>
          <elem>3 1 1 1 3</elem>
          <elem>3 1 1 2 1</elem>
          <elem>3 1 1 2 2</elem>
          <elem>3 1 1 2 3</elem>
          <elem>3 1 1 3 1</elem>
          <elem>3 1 1 3 2</elem>
          <elem>3 1 1 3 3</elem>
          <elem>3 1 2 1 1</elem>
          <elem>3 1 2 1 2</elem>
          <elem>3 1 2 1 3</elem>
          <elem>3 1 2 2 1</elem>
          <elem>3 1 2 2 2</elem>
          <elem>3 1 2 2 3</elem>
          <elem>3 1 2 3 1</elem>
          <elem>3 1 2 3 2</elem>
          <elem>3 1 2 3 3</elem>
          <elem>3 1 3 1 1</elem>
          <elem>3 1 3 1 2</elem>
          <elem>3 1 3 1 3</elem>
          <elem>3 1 3 2 1</elem>
          <elem>3 1 3 2 2</elem>
          <elem>3 1 3 2 3</elem>
          <elem>3 1 3 3 1</elem>
          <elem>3 1 3 3 2</elem>
          <elem>3 1 3 3 3</elem>
          <elem>3 2 1 1 1</elem>
          <elem>3 2 1 1 2</elem>
          <elem>3 2 1 1 3</elem>
          <elem>3 2 1 2 1</elem>
          <elem>3 2 1 2 2</elem>
          <elem>3 2 1 2 3</elem>
          <elem>3 2 1 3 1</elem>
          <elem>3 2 1 3 2</elem>
          <elem>3 2 1 3 3</elem>
          <elem>3 2 2 1 1</elem>
          <elem>3 2 2 1 2</elem>
          <elem>3 2 2 1 3</elem>
          <elem>3 2 2 2 1</elem>
          <elem>3 2 2 2 2</elem>
          <elem>3 2 2 2 3</elem>
          <elem>3 2 2 3 1</elem>
          <elem>3 2 2 3 2</elem>
          <elem>3 2 2 3 3</elem>
          <elem>3 2 3 1 1</elem>
          <elem>3 2 3 1 2</elem>
          <elem>3 2 3 1 3</elem>
          <elem>3 2 3 2 1</elem>
          <elem>3 2 3 2 2</elem>
          <elem>3 2 3 2 3</elem>
          <elem>3 2 3 3 1</elem>
          <elem>3 2 3 3 2</elem>
          <elem>3 2 3 3 3</elem>
          <elem>3 3 1 1 1</elem>
          <elem>3 3 1 1 2</elem>
          <elem>3 3 1 1 3</elem>
          <elem>3 3 1 2 1</elem>
          <elem>3 3 1 2 2</elem>
          <elem>3 3 1 2 3</elem>
          <elem>3 3 1 3 1</elem>
          <elem>3 3 1 3 2</elem>
          <elem>3 3 1 3 3</elem>
          <elem>3 3 2 1 1</elem>
          <elem>3 3 2 1 2</elem>
          <elem>3 3 2 1 3</elem>
          <elem>3 3 2 2 1</elem>
          <elem>3 3 2 2 2</elem>
          <elem>3 3 2 2 3</elem>
          <elem>3 3 2 3 1</elem>
          <elem>3 3 2 3 2</elem>
          <elem>3 3 2 3 3</elem>
          <elem>3 3 3 1 1</elem>
          <elem>3 3 3 1 2</elem>
          <elem>3 3 3 1 3</elem>
          <elem>3 3 3 2 1</elem>
          <elem>3 3 3 2 2</elem>
          <elem>3 3 3 2 3</elem>
          <elem>3 3 3 3 1</elem>
          <elem>3 3 3 3 2</elem>
          <elem>3 3 3 3 3</elem>
<annotation>
          <elem>1 1 1 1 1 1</elem>
          <elem>1 1 1 1 1 2</elem>
          <elem>1 1 1 1 1 3</elem>
          <elem>1 1 1 1 2 1</elem>
          <elem>1 1 1 1 2 2</elem>
          <elem>1 1 1 1 2 3</elem>
          <elem>1 1 1 1 3 1</elem>
          <elem>1 1 1 1 3 2</elem>
          <elem>1 1 1 1 3 3</elem>
          <elem>1 1 1 2 1 1</elem>
          <elem>1 1 1 2 1 2</elem>
          <elem>1 1 1 2 1 3</elem>
          <elem>1 1 1 2 2 1</elem>
          <elem>1 1 1 2 2 2</elem>
          <elem>1 1 1 2 2 3</elem>
          <elem>1 1 1 2 3 1</elem>
          <elem>1 1 1 2 3 2</elem>
          <elem>1 1 1 2 3 3</elem>
          <elem>1 1 1 3 1 1</elem>
          <elem>1 1 1 3 1 2</elem>
          <elem>1 1 1 3 1 3</elem>
          <elem>1 1 1 3 2 1</elem>
          <elem>1 1 1 3 2 2</elem>
          <elem>1 1 1 3 2 3</elem>
          <elem>1 1 1 3 3 1</elem>
          <elem>1 1 1 3 3 2</elem>
          <elem>1 1 1 3 3 3</elem>
          <elem>1 1 2 1 1 1</elem>
          <elem>1 1 2 1 1 2</elem>
          <elem>1 1 2 1 1 3</elem>
          <elem>1 1 2 1 2 1</elem>
          <elem>1 1 2 1 2 2</elem>
          <elem>1 1 2 1 2 3</elem>
          <elem>1 1 2 1 3 1</elem>
          <elem>1 1 2 1 3 2</elem>
          <elem>1 1 2 1 3 3</elem>
          <elem>1 1 2 2 1 1</elem>
          <elem>1 1 2 2 1 2</elem>
          <elem>1 1 2 2 1 3</elem>
          <elem>1 1 2 2 2 1</elem>
          <elem>1 1 2 2 2 2</elem>
          <elem>1 1 2 2 2 3</elem>
          <elem>1 1 2 2 3 1</elem>
          <elem>1 1 2 2 3 2</elem>
          <elem>1 1 2 2 3 3</elem>
          <elem>1 1 2 3 1 1</elem>
          <elem>1 1 2 3 1 2</elem>
          <elem>1 1 2 3 1 3</elem>
          <elem>1 1 2 3 2 1</elem>
          <elem>1 1 2 3 2 2</elem>
          <elem>1 1 2 3 2 3</elem>
          <elem>1 1 2 3 3 1</elem>
          <elem>1 1 2 3 3 2</elem>
          <elem>1 1 2 3 3 3</elem>
          <elem>1 1 3 1 1 1</elem>
          <elem>1 1 3 1 1 2</elem>
          <elem>1 1 3 1 1 3</elem>
          <elem>1 1 3 1 2 1</elem>
          <elem>1 1 3 1 2 2</elem>
          <elem>1 1 3 1 2 3</elem>
          <elem>1 1 3 1 3 1</elem>
          <elem>1 1 3 1 3 2</elem>
          <elem>1 1 3 1 3 3</elem>
          <elem>1 1 3 2 1 1</elem>
          <elem>1 1 3 2 1 2</elem>
          <elem>1 1 3 2 1 3</elem>
          <elem>1 1 3 2 2 1</elem>
          <elem>1 1 3 2 2 2</elem>
          <elem>1 1 3 2 2 3</elem>
          <elem>1 1 3 2 3 1</elem>
          <elem>1 1 3 2 3 2</elem>
          <elem>1 1 3 2 3 3</elem>
          <elem>1 1 3 3 1 1</elem>
          <elem>1 1 3 3 1 2</elem>
          <elem>1 1 3 3 1 3</elem>
          <elem>1 1 3 3 2 1</elem>
          <elem>1 1 3 3 2 2</elem>
          <elem>1 1 3 3 2 3</elem>
          <elem>1 1 3 3 3 1</elem>
          <elem>1 1 3 3 3 2</elem>
          <elem>1 1 3 3 3 3</elem>
          <elem>1 2 1 1 1 1</elem>
          <elem>1 2 1 1 1 2</elem>
          <elem>1 2 1 1 1 3</elem>
          <elem>1 2 1 1 2 1</elem>
          <elem>1 2 1 1 2 2</elem>
          <elem>1 2 1 1 2 3</elem>
          <elem>1 2 1 1 3 1</elem>
          <elem>1 2 1 1 3 2</elem>
          <elem>1 2 1 1 3 3</elem>
          <elem>1 2 1 2 1 1</elem>
          <elem>1 2 1 2 1 2</elem>
          <elem>1 2 1 2 1 3</elem>
          <elem>1 2 1 2 2 1</elem>
          <elem>1 2 1 2 2 2</elem>
          <elem>1 2 1 2 2 3</elem>
          <elem>1 2 1 2 3 1</elem>
          <elem>1 2 1 2 3 2</elem>
          <elem>1 2 1 2 3 3</elem>
          <elem>1 2 1 3 1 1</elem>
          <elem>1 2 1 3 1 2</elem>
          <elem>1 2 1 3 1 3</elem>
          <elem>1 2 1 3 2 1</elem>
          <elem>1 2 1 3 2 2</elem>
          <elem>1 2 1 3 2 3</elem>
          <elem>1 2 1 3 3 1</elem>
          <elem>1 2 1 3 3 2</elem>
          <elem>1 2 1 3 3 3</elem>
          <elem>1 2 2 1 1 1</elem>
          <elem>1 2 2 1 1 2</elem>
          <elem>1 2 2 1 1 3</elem>
          <elem>1 2 2 1 2 1</elem>
          <elem>1 2 2 1 2 2</elem>
          <elem>1 2 2 1 2 3</elem>
          <elem>1 2 2 1 3 1</elem>
          <elem>1 2 2 1 3 2</elem>
          <elem>1 2 2 1 3 3</elem>
          <elem>1 2 2 2 1 1</elem>
          <elem>1 2 2 2 1 2</elem>
          <elem>1 2 2 2 1 3</elem>
          <elem>1 2 2 2 2 1</elem>
          <elem>1 2 2 2 2 2</elem>
          <elem>1 2 2 2 2 3</elem>
          <elem>1 2 2 2 3 1</elem>
          <elem>1 2 2 2 3 2</elem>
          <elem>1 2 2 2 3 3</elem>
          <elem>1 2 2 3 1 1</elem>
          <elem>1 2 2 3 1 2</elem>
          <elem>1 2 2 3 1 3</elem>
          <elem>1 2 2 3 2 1</elem>
          <elem>1 2 2 3 2 2</elem>
          <elem>1 2 2 3 2 3</elem>
          <elem>1 2 2 3 3 1</elem>
          <elem>1 2 2 3 3 2</elem>
          <elem>1 2 2 3 3 3</elem>
          <elem>1 2 3 1 1 1</elem>
          <elem>1 2 3 1 1 2</elem>
          <elem>1 2 3 1 1 3</elem>
          <elem>1 2 3 1 2 1</elem>
          <elem>1 2 3 1 2 2</elem>
          <elem>1 2 3 1 2 3</elem>
          <elem>1 2 3 1 3 1</elem>
          <elem>1 2 3 1 3 2</elem>
          <elem>1 2 3 1 3 3</elem>
          <elem>1 2 3 2 1 1</elem>
          <elem>1 2 3 2 1 2</elem>
          <elem>1 2 3 2 1 3</elem>
          <elem>1 2 3 2 2 1</elem>
          <elem>1 2 3 2 2 2</elem>
          <elem>1 2 3 2 2 3</elem>
          <elem>1 2 3 2 3 1</elem>
          <elem>1 2 3 2 3 2</elem>
          <elem>1 2 3 2 3 3</elem>
          <elem>1 2 3 3 1 1</elem>
          <elem>1 2 3 3 1 2</elem>
          <elem>1 2 3 3 1 3</elem>
          <elem>1 2 3 3 2 1</elem>
          <elem>1 2 3 3 2 2</elem>
          <elem>1 2 3 3 2 3</elem>
          <elem>1 2 3 3 3 1</elem>
          <elem>1 2 3 3 3 2</elem>
          <elem>1 2 3 3 3 3</elem>
          <elem>1 3 1 1 1 1</elem>
          <elem>1 3 1 1 1 2</elem>
          <elem>1 3 1 1 1 3</elem>
          <elem>1 3 1 1 2 1</elem>
          <elem>1 3 1 1 2 2</elem>
          <elem>1 3 1 1 2 3</elem>
          <elem>1 3 1 1 3 1</elem>
          <elem>1 3 1 1 3 2</elem>
          <elem>1 3 1 1 3 3</elem>
          <elem>1 3 1 2 1 1</elem>
          <elem>1 3 1 2 1 2</elem>
          <elem>1 3 1 2 1 3</elem>
          <elem>1 3 1 2 2 1</elem>
          <elem>1 3 1 2 2 2</elem>
          <elem>1 3 1 2 2 3</elem>
          <elem>1 3 1 2 3 1</elem>
          <elem>1 3 1 2 3 2</elem>
          <elem>1 3 1 2 3 3</elem>
          <elem>1 3 1 3 1 1</elem>
          <elem>1 3 1 3 1 2</elem>
          <elem>1 3 1 3 1 3</elem>
          <elem>1 3 1 3 2 1</elem>
          <elem>1 3 1 3 2 2</elem>
          <elem>1 3 1 3 2 3</elem>
          <elem>1 3 1 3 3 1</elem>
          <elem>1 3 1 3 3 2</elem>
          <elem>1 3 1 3 3 3</elem>
          <elem>1 3 2 1 1 1</elem>
          <elem>1 3 2 1 1 2</elem>
          <elem>1 3 2 1 1 3</elem>
          <elem>1 3 2 1 2 1</elem>
          <elem>1 3 2 1 2 2</elem>
          <elem>1 3 2 1 2 3</elem>
          <elem>1 3 2 1 3 1</elem>
          <elem>1 3 2 1 3 2</elem>
          <elem>1 3 2 1 3 3</elem>
          <elem>1 3 2 2 1 1</elem>
          <elem>1 3 2 2 1 2</elem>
          <elem>1 3 2 2 1 3</elem>
          <elem>1 3 2 2 2 1</elem>
          <elem>1 3 2 2 2 2</elem>
          <elem>1 3 2 2 2 3</elem>
          <elem>1 3 2 2 3 1</elem>
          <elem>1 3 2 2 3 2</elem>
          <elem>1 3 2 2 3 3</elem>
          <elem>1 3 2 3 1 1</elem>
          <elem>1 3 2 3 1 2</elem>
          <elem>1 3 2 3 1 3</elem>
          <elem>1 3 2 3 2 1</elem>
          <elem>1 3 2 3 2 2</elem>
          <elem>1 3 2 3 2 3</elem>
          <elem>1 3 2 3 3 1</elem>
          <elem>1 3 2 3 3 2</elem>
          <elem>1 3 2 3 3 3</elem>
          <elem>1 3 3 1 1 1</elem>
          <elem>1 3 3 1 1 2</elem>
          <elem>1 3 3 1 1 3</elem>
          <elem>1 3 3 1 2 1</elem>
          <elem>1 3 3 1 2 2</elem>
          <elem>1 3 3 1 2 3</elem>
          <elem>1 3 3 1 3 1</elem>
          <elem>1 3 3 1 3 2</elem>
          <elem>1 3 3 1 3 3</elem>
          <elem>1 3 3 2 1 1</elem>
          <elem>1 3 3 2 1 2</elem>
          <elem>1 3 3 2 1 3</elem>
          <elem>1 3 3 2 2 1</elem>
          <elem>1 3 3 2 2 2</elem>
          <elem>1 3 3 2 2 3</elem>
          <elem>1 3 3 2 3 1</elem>
          <elem>1 3 3 2 3 2</elem>
          <elem>1 3 3 2 3 3</elem>
          <elem>1 3 3 3 1 1</elem>
          <elem>1 3 3 3 1 2</elem>
          <elem>1 3 3 3 1 3</elem>
          <elem>1 3 3 3 2 1</elem>
          <elem>1 3 3 3 2 2</elem>
          <elem>1 3 3 3 2 3</elem>
          <elem>1 3 3 3 3 1</elem>
          <elem>1 3 3 3 3 2</elem>
          <elem>1 3 3 3 3 3</elem>
          <elem>2 1 1 1 1 1</elem>
          <elem>2 1 1 1 1 2</elem>
          <elem>2 1 1 1 1 3</elem>
          <elem>2 1 1 1 2 1</elem>
          <elem>2 1 1 1 2 2</elem>
          <elem>2 1 1 1 2 3</elem>
          <elem>2 1 1 1 3 1</elem>
          <elem>2 1 1 1 3 2</elem>
          <elem>2 1 1 1 3 3</elem>
          <elem>2 1 1 2 1 1</elem>
          <elem>2 1 1 2 1 2</elem>
          <elem>2 1 1 2 1 3</elem>
          <elem>2 1 1 2 2 1</elem>
          <elem>2 1 1 2 2 2</elem>
          <elem>2 1 1 2 2 3</elem>
          <elem>2 1 1 2 3 1</elem>
          <elem>2 1 1 2 3 2</elem>
          <elem>2 1 1 2 3 3</elem>
          <elem>2 1 1 3 1 1</elem>
          <elem>2 1 1 3 1 2</elem>
          <elem>2 1 1 3 1 3</elem>
          <elem>2 1 1 3 2 1</elem>
          <elem>2 1 1 3 2 2</elem>
          <elem>2 1 1 3 2 3</elem>
          <elem>2 1 1 3 3 1</elem>
          <elem>2 1 1 3 3 2</elem>
          <elem>2 1 1 3 3 3</elem>
          <elem>2 1 2 1 1 1</elem>
          <elem>2 1 2 1 1 2</elem>
          <elem>2 1 2 1 1 3</elem>
          <elem>2 1 2 1 2 1</elem>
          <elem>2 1 2 1 2 2</elem>
          <elem>2 1 2 1 2 3</elem>
          <elem>2 1 2 1 3 1</elem>
          <elem>2 1 2 1 3 2</elem>
          <elem>2 1 2 1 3 3</elem>
          <elem>2 1 2 2 1 1</elem>
          <elem>2 1 2 2 1 2</elem>
          <elem>2 1 2 2 1 3</elem>
          <elem>2 1 2 2 2 1</elem>
          <elem>2 1 2 2 2 2</elem>
          <elem>2 1 2 2 2 3</elem>
          <elem>2 1 2 2 3 1</elem>
          <elem>2 1 2 2 3 2</elem>
          <elem>2 1 2 2 3 3</elem>
          <elem>2 1 2 3 1 1</elem>
          <elem>2 1 2 3 1 2</elem>
          <elem>2 1 2 3 1 3</elem>
          <elem>2 1 2 3 2 1</elem>
          <elem>2 1 2 3 2 2</elem>
          <elem>2 1 2 3 2 3</elem>
          <elem>2 1 2 3 3 1</elem>
          <elem>2 1 2 3 3 2</elem>
          <elem>2 1 2 3 3 3</elem>
          <elem>2 1 3 1 1 1</elem>
          <elem>2 1 3 1 1 2</elem>
          <elem>2 1 3 1 1 3</elem>
          <elem>2 1 3 1 2 1</elem>
          <elem>2 1 3 1 2 2</elem>
          <elem>2 1 3 1 2 3</elem>
          <elem>2 1 3 1 3 1</elem>
          <elem>2 1 3 1 3 2</elem>
          <elem>2 1 3 1 3 3</elem>
          <elem>2 1 3 2 1 1</elem>
          <elem>2 1 3 2 1 2</elem>
          <elem>2 1 3 2 1 3</elem>
          <elem>2 1 3 2 2 1</elem>
          <elem>2 1 3 2 2 2</elem>
          <elem>2 1 3 2 2 3</elem>
          <elem>2 1 3 2 3 1</elem>
          <elem>2 1 3 2 3 2</elem>
          <elem>2 1 3 2 3 3</elem>
          <elem>2 1 3 3 1 1</elem>
          <elem>2 1 3 3 1 2</elem>
          <elem>2 1 3 3 1 3</elem>
          <elem>2 1 3 3 2 1</elem>
          <elem>2 1 3 3 2 2</elem>
          <elem>2 1 3 3 2 3</elem>
          <elem>2 1 3 3 3 1</elem>
          <elem>2 1 3 3 3 2</elem>
          <elem>2 1 3 3 3 3</elem>
          <elem>2 2 1 1 1 1</elem>
          <elem>2 2 1 1 1 2</elem>
          <elem>2 2 1 1 1 3</elem>
          <elem>2 2 1 1 2 1</elem>
          <elem>2 2 1 1 2 2</elem>
          <elem>2 2 1 1 2 3</elem>
          <elem>2 2 1 1 3 1</elem>
          <elem>2 2 1 1 3 2</elem>
          <elem>2 2 1 1 3 3</elem>
          <elem>2 2 1 2 1 1</elem>
          <elem>2 2 1 2 1 2</elem>
          <elem>2 2 1 2 1 3</elem>
          <elem>2 2 1 2 2 1</elem>
          <elem>2 2 1 2 2 2</elem>
          <elem>2 2 1 2 2 3</elem>
          <elem>2 2 1 2 3 1</elem>
          <elem>2 2 1 2 3 2</elem>
          <elem>2 2 1 2 3 3</elem>
          <elem>2 2 1 3 1 1</elem>
          <elem>2 2 1 3 1 2</elem>
          <elem>2 2 1 3 1 3</elem>
          <elem>2 2 1 3 2 1</elem>
          <elem>2 2 1 3 2 2</elem>
          <elem>2 2 1 3 2 3</elem>
          <elem>2 2 1 3 3 1</elem>
          <elem>2 2 1 3 3 2</elem>
          <elem>2 2 1 3 3 3</elem>
          <elem>2 2 2 1 1 1</elem>
          <elem>2 2 2 1 1 2</elem>
          <elem>2 2 2 1 1 3</elem>
          <elem>2 2 2 1 2 1</elem>
          <elem>2 2 2 1 2 2</elem>
          <elem>2 2 2 1 2 3</elem>
          <elem>2 2 2 1 3 1</elem>
          <elem>2 2 2 1 3 2</elem>
          <elem>2 2 2 1 3 3</elem>
          <elem>2 2 2 2 1 1</elem>
          <elem>2 2 2 2 1 2</elem>
          <elem>2 2 2 2 1 3</elem>
          <elem>2 2 2 2 2 1</elem>
          <elem>2 2 2 2 2 2</elem>
          <elem>2 2 2 2 2 3</elem>
          <elem>2 2 2 2 3 1</elem>
          <elem>2 2 2 2 3 2</elem>
          <elem>2 2 2 2 3 3</elem>
          <elem>2 2 2 3 1 1</elem>
          <elem>2 2 2 3 1 2</elem>
          <elem>2 2 2 3 1 3</elem>
          <elem>2 2 2 3 2 1</elem>
          <elem>2 2 2 3 2 2</elem>
          <elem>2 2 2 3 2 3</elem>
          <elem>2 2 2 3 3 1</elem>
          <elem>2 2 2 3 3 2</elem>
          <elem>2 2 2 3 3 3</elem>
          <elem>2 2 3 1 1 1</elem>
          <elem>2 2 3 1 1 2</elem>
          <elem>2 2 3 1 1 3</elem>
          <elem>2 2 3 1 2 1</elem>
          <elem>2 2 3 1 2 2</elem>
          <elem>2 2 3 1 2 3</elem>
          <elem>2 2 3 1 3 1</elem>
          <elem>2 2 3 1 3 2</elem>
          <elem>2 2 3 1 3 3</elem>
          <elem>2 2 3 2 1 1</elem>
          <elem>2 2 3 2 1 2</elem>
          <elem>2 2 3 2 1 3</elem>
          <elem>2 2 3 2 2 1</elem>
          <elem>2 2 3 2 2 2</elem>
          <elem>2 2 3 2 2 3</elem>
          <elem>2 2 3 2 3 1</elem>
          <elem>2 2 3 2 3 2</elem>
          <elem>2 2 3 2 3 3</elem>
          <elem>2 2 3 3 1 1</elem>
          <elem>2 2 3 3 1 2</elem>
          <elem>2 2 3 3 1 3</elem>
          <elem>2 2 3 3 2 1</elem>
          <elem>2 2 3 3 2 2</elem>
          <elem>2 2 3 3 2 3</elem>
          <elem>2 2 3 3 3 1</elem>
          <elem>2 2 3 3 3 2</elem>
          <elem>2 2 3 3 3 3</elem>
          <elem>2 3 1 1 1 1</elem>
          <elem>2 3 1 1 1 2</elem>
          <elem>2 3 1 1 1 3</elem>
          <elem>2 3 1 1 2 1</elem>
          <elem>2 3 1 1 2 2</elem>
          <elem>2 3 1 1 2 3</elem>
          <elem>2 3 1 1 3 1</elem>
          <elem>2 3 1 1 3 2</elem>
          <elem>2 3 1 1 3 3</elem>
          <elem>2 3 1 2 1 1</elem>
          <elem>2 3 1 2 1 2</elem>
          <elem>2 3 1 2 1 3</elem>
          <elem>2 3 1 2 2 1</elem>
          <elem>2 3 1 2 2 2</elem>
          <elem>2 3 1 2 2 3</elem>
          <elem>2 3 1 2 3 1</elem>
          <elem>2 3 1 2 3 2</elem>
          <elem>2 3 1 2 3 3</elem>
          <elem>2 3 1 3 1 1</elem>
          <elem>2 3 1 3 1 2</elem>
          <elem>2 3 1 3 1 3</elem>
          <elem>2 3 1 3 2 1</elem>
          <elem>2 3 1 3 2 2</elem>
          <elem>2 3 1 3 2 3</elem>
          <elem>2 3 1 3 3 1</elem>
          <elem>2 3 1 3 3 2</elem>
          <elem>2 3 1 3 3 3</elem>
          <elem>2 3 2 1 1 1</elem>
          <elem>2 3 2 1 1 2</elem>
          <elem>2 3 2 1 1 3</elem>
          <elem>2 3 2 1 2 1</elem>
          <elem>2 3 2 1 2 2</elem>
          <elem>2 3 2 1 2 3</elem>
          <elem>2 3 2 1 3 1</elem>
          <elem>2 3 2 1 3 2</elem>
          <elem>2 3 2 1 3 3</elem>
          <elem>2 3 2 2 1 1</elem>
          <elem>2 3 2 2 1 2</elem>
          <elem>2 3 2 2 1 3</elem>
          <elem>2 3 2 2 2 1</elem>
          <elem>2 3 2 2 2 2</elem>
          <elem>2 3 2 2 2 3</elem>
          <elem>2 3 2 2 3 1</elem>
          <elem>2 3 2 2 3 2</elem>
          <elem>2 3 2 2 3 3</elem>
          <elem>2 3 2 3 1 1</elem>
          <elem>2 3 2 3 1 2</elem>
          <elem>2 3 2 3 1 3</elem>
          <elem>2 3 2 3 2 1</elem>
          <elem>2 3 2 3 2 2</elem>
          <elem>2 3 2 3 2 3</elem>
          <elem>2 3 2 3 3 1</elem>
          <elem>2 3 2 3 3 2</elem>
          <elem>2 3 2 3 3 3</elem>
          <elem>2 3 3 1 1 1</elem>
          <elem>2 3 3 1 1 2</elem>
          <elem>2 3 3 1 1 3</elem>
          <elem>2 3 3 1 2 1</elem>
          <elem>2 3 3 1 2 2</elem>
          <elem>2 3 3 1 2 3</elem>
          <elem>2 3 3 1 3 1</elem>
          <elem>2 3 3 1 3 2</elem>
          <elem>2 3 3 1 3 3</elem>
          <elem>2 3 3 2 1 1</elem>
          <elem>2 3 3 2 1 2</elem>
          <elem>2 3 3 2 1 3</elem>
          <elem>2 3 3 2 2 1</elem>
          <elem>2 3 3 2 2 2</elem>
          <elem>2 3 3 2 2 3</elem>
          <elem>2 3 3 2 3 1</elem>
          <elem>2 3 3 2 3 2</elem>
          <elem>2 3 3 2 3 3</elem>
          <elem>2 3 3 3 1 1</elem>
          <elem>2 3 3 3 1 2</elem>
          <elem>2 3 3 3 1 3</elem>
          <elem>2 3 3 3 2 1</elem>
          <elem>2 3 3 3 2 2</elem>
          <elem>2 3 3 3 2 3</elem>
          <elem>2 3 3 3 3 1</elem>
          <elem>2 3 3 3 3 2</elem>
          <elem>2 3 3 3 3 3</elem>
          <elem>3 1 1 1 1 1</elem>
          <elem>3 1 1 1 1 2</elem>
          <elem>3 1 1 1 1 3</elem>
          <elem>3 1 1 1 2 1</elem>
          <elem>3 1 1 1 2 2</elem>
          <elem>3 1 1 1 2 3</elem>
          <elem>3 1 1 1 3 1</elem>
          <elem>3 1 1 1 3 2</elem>
          <elem>3 1 1 1 3 3</elem>
          <elem>3 1 1 2 1 1</elem>
          <elem>3 1 1 2 1 2</elem>
          <elem>3 1 1 2 1 3</elem>
          <elem>3 1 1 2 2 1</elem>
          <elem>3 1 1 2 2 2</elem>
          <elem>3 1 1 2 2 3</elem>
          <elem>3 1 1 2 3 1</elem>
          <elem>3 1 1 2 3 2</elem>
          <elem>3 1 1 2 3 3</elem>
          <elem>3 1 1 3 1 1</elem>
          <elem>3 1 1 3 1 2</elem>
          <elem>3 1 1 3 1 3</elem>
          <elem>3 1 1 3 2 1</elem>
          <elem>3 1 1 3 2 2</elem>
          <elem>3 1 1 3 2 3</elem>
          <elem>3 1 1 3 3 1</elem>
          <elem>3 1 1 3 3 2</elem>
          <elem>3 1 1 3 3 3</elem>
          <elem>3 1 2 1 1 1</elem>
          <elem>3 1 2 1 1 2</elem>
          <elem>3 1 2 1 1 3</elem>
          <elem>3 1 2 1 2 1</elem>
          <elem>3 1 2 1 2 2</elem>
          <elem>3 1 2 1 2 3</elem>
          <elem>3 1 2 1 3 1</elem>
          <elem>3 1 2 1 3 2</elem>
          <elem>3 1 2 1 3 3</elem>
          <elem>3 1 2 2 1 1</elem>
          <elem>3 1 2 2 1 2</elem>
          <elem>3 1 2 2 1 3</elem>
          <elem>3 1 2 2 2 1</elem>
          <elem>3 1 2 2 2 2</elem>
          <elem>3 1 2 2 2 3</elem>
          <elem>3 1 2 2 3 1</elem>
          <elem>3 1 2 2 3 2</elem>
          <elem>3 1 2 2 3 3</elem>
          <elem>3 1 2 3 1 1</elem>
          <elem>3 1 2 3 1 2</elem>
          <elem>3 1 2 3 1 3</elem>
          <elem>3 1 2 3 2 1</elem>
          <elem>3 1 2 3 2 2</elem>
          <elem>3 1 2 3 2 3</elem>
          <elem>3 1 2 3 3 1</elem>
          <elem>3 1 2 3 3 2</elem>
          <elem>3 1 2 3 3 3</elem>
          <elem>3 1 3 1 1 1</elem>
          <elem>3 1 3 1 1 2</elem>
          <elem>3 1 3 1 1 3</elem>
          <elem>3 1 3 1 2 1</elem>
          <elem>3 1 3 1 2 2</elem>
          <elem>3 1 3 1 2 3</elem>
          <elem>3 1 3 1 3 1</elem>
          <elem>3 1 3 1 3 2</elem>
          <elem>3 1 3 1 3 3</elem>
          <elem>3 1 3 2 1 1</elem>
          <elem>3 1 3 2 1 2</elem>
          <elem>3 1 3 2 1 3</elem>
          <elem>3 1 3 2 2 1</elem>
          <elem>3 1 3 2 2 2</elem>
          <elem>3 1 3 2 2 3</elem>
          <elem>3 1 3 2 3 1</elem>
          <elem>3 1 3 2 3 2</elem>
          <elem>3 1 3 2 3 3</elem>
          <elem>3 1 3 3 1 1</elem>
          <elem>3 1 3 3 1 2</elem>
          <elem>3 1 3 3 1 3</elem>
          <elem>3 1 3 3 2 1</elem>
          <elem>3 1 3 3 2 2</elem>
          <elem>3 1 3 3 2 3</elem>
          <elem>3 1 3 3 3 1</elem>
          <elem>3 1 3 3 3 2</elem>
          <elem>3 1 3 3 3 3</elem>
          <elem>3 2 1 1 1 1</elem>
          <elem>3 2 1 1 1 2</elem>
          <elem>3 2 1 1 1 3</elem>
          <elem>3 2 1 1 2 1</elem>
          <elem>3 2 1 1 2 2</elem>
          <elem>3 2 1 1 2 3</elem>
          <elem>3 2 1 1 3 1</elem>
          <elem>3 2 1 1 3 2</elem>
          <elem>3 2 1 1 3 3</elem>
          <elem>3 2 1 2 1 1</elem>
          <elem>3 2 1 2 1 2</elem>
          <elem>3 2 1 2 1 3</elem>
          <elem>3 2 1 2 2 1</elem>
          <elem>3 2 1 2 2 2</elem>
          <elem>3 2 1 2 2 3</elem>
          <elem>3 2 1 2 3 1</elem>
          <elem>3 2 1 2 3 2</elem>
          <elem>3 2 1 2 3 3</elem>
          <elem>3 2 1 3 1 1</elem>
          <elem>3 2 1 3 1 2</elem>
          <elem>3 2 1 3 1 3</elem>
          <elem>3 2 1 3 2 1</elem>
          <elem>3 2 1 3 2 2</elem>
          <elem>3 2 1 3 2 3</elem>
          <elem>3 2 1 3 3 1</elem>
          <elem>3 2 1 3 3 2</elem>
          <elem>3 2 1 3 3 3</elem>
          <elem>3 2 2 1 1 1</elem>
          <elem>3 2 2 1 1 2</elem>
          <elem>3 2 2 1 1 3</elem>
          <elem>3 2 2 1 2 1</elem>
          <elem>3 2 2 1 2 2</elem>
          <elem>3 2 2 1 2 3</elem>
          <elem>3 2 2 1 3 1</elem>
          <elem>3 2 2 1 3 2</elem>
          <elem>3 2 2 1 3 3</elem>
          <elem>3 2 2 2 1 1</elem>
          <elem>3 2 2 2 1 2</elem>
          <elem>3 2 2 2 1 3</elem>
          <elem>3 2 2 2 2 1</elem>
          <elem>3 2 2 2 2 2</elem>
          <elem>3 2 2 2 2 3</elem>
          <elem>3 2 2 2 3 1</elem>
          <elem>3 2 2 2 3 2</elem>
          <elem>3 2 2 2 3 3</elem>
          <elem>3 2 2 3 1 1</elem>
          <elem>3 2 2 3 1 2</elem>
          <elem>3 2 2 3 1 3</elem>
          <elem>3 2 2 3 2 1</elem>
          <elem>3 2 2 3 2 2</elem>
          <elem>3 2 2 3 2 3</elem>
          <elem>3 2 2 3 3 1</elem>
          <elem>3 2 2 3 3 2</elem>
          <elem>3 2 2 3 3 3</elem>
          <elem>3 2 3 1 1 1</elem>
          <elem>3 2 3 1 1 2</elem>
          <elem>3 2 3 1 1 3</elem>
          <elem>3 2 3 1 2 1</elem>
          <elem>3 2 3 1 2 2</elem>
          <elem>3 2 3 1 2 3</elem>
          <elem>3 2 3 1 3 1</elem>
          <elem>3 2 3 1 3 2</elem>
          <elem>3 2 3 1 3 3</elem>
          <elem>3 2 3 2 1 1</elem>
          <elem>3 2 3 2 1 2</elem>
          <elem>3 2 3 2 1 3</elem>
          <elem>3 2 3 2 2 1</elem>
          <elem>3 2 3 2 2 2</elem>
          <elem>3 2 3 2 2 3</elem>
          <elem>3 2 3 2 3 1</elem>
          <elem>3 2 3 2 3 2</elem>
          <elem>3 2 3 2 3 3</elem>
          <elem>3 2 3 3 1 1</elem>
          <elem>3 2 3 3 1 2</elem>
          <elem>3 2 3 3 1 3</elem>
          <elem>3 2 3 3 2 1</elem>
          <elem>3 2 3 3 2 2</elem>
          <elem>3 2 3 3 2 3</elem>
          <elem>3 2 3 3 3 1</elem>
          <elem>3 2 3 3 3 2</elem>
          <elem>3 2 3 3 3 3</elem>
          <elem>3 3 1 1 1 1</elem>
          <elem>3 3 1 1 1 2</elem>
          <elem>3 3 1 1 1 3</elem>
          <elem>3 3 1 1 2 1</elem>
          <elem>3 3 1 1 2 2</elem>
          <elem>3 3 1 1 2 3</elem>
          <elem>3 3 1 1 3 1</elem>
          <elem>3 3 1 1 3 2</elem>
          <elem>3 3 1 1 3 3</elem>
          <elem>3 3 1 2 1 1</elem>
          <elem>3 3 1 2 1 2</elem>
          <elem>3 3 1 2 1 3</elem>
          <elem>3 3 1 2 2 1</elem>
          <elem>3 3 1 2 2 2</elem>
          <elem>3 3 1 2 2 3</elem>
          <elem>3 3 1 2 3 1</elem>
          <elem>3 3 1 2 3 2</elem>
          <elem>3 3 1 2 3 3</elem>
          <elem>3 3 1 3 1 1</elem>
          <elem>3 3 1 3 1 2</elem>
          <elem>3 3 1 3 1 3</elem>
          <elem>3 3 1 3 2 1</elem>
          <elem>3 3 1 3 2 2</elem>
          <elem>3 3 1 3 2 3</elem>
          <elem>3 3 1 3 3 1</elem>
          <elem>3 3 1 3 3 2</elem>
          <elem>3 3 1 3 3 3</elem>
          <elem>3 3 2 1 1 1</elem>
          <elem>3 3 2 1 1 2</elem>
          <elem>3 3 2 1 1 3</elem>
          <elem>3 3 2 1 2 1</elem>
          <elem>3 3 2 1 2 2</elem>
          <elem>3 3 2 1 2 3</elem>
          <elem>3 3 2 1 3 1</elem>
          <elem>3 3 2 1 3 2</elem>
          <elem>3 3 2 1 3 3</elem>
          <elem>3 3 2 2 1 1</elem>
          <elem>3 3 2 2 1 2</elem>
          <elem>3 3 2 2 1 3</elem>
          <elem>3 3 2 2 2 1</elem>
          <elem>3 3 2 2 2 2</elem>
          <elem>3 3 2 2 2 3</elem>
          <elem>3 3 2 2 3 1</elem>
          <elem>3 3 2 2 3 2</elem>
          <elem>3 3 2 2 3 3</elem>
          <elem>3 3 2 3 1 1</elem>
          <elem>3 3 2 3 1 2</elem>
          <elem>3 3 2 3 1 3</elem>
          <elem>3 3 2 3 2 1</elem>
          <elem>3 3 2 3 2 2</elem>
          <elem>3 3 2 3 2 3</elem>
          <elem>3 3 2 3 3 1</elem>
          <elem>3 3 2 3 3 2</elem>
          <elem>3 3 2 3 3 3</elem>
          <elem>3 3 3 1 1 1</elem>
          <elem>3 3 3 1 1 2</elem>
          <elem>3 3 3 1 1 3</elem>
          <elem>3 3 3 1 2 1</elem>
          <elem>3 3 3 1 2 2</elem>
          <elem>3 3 3 1 2 3</elem>
          <elem>3 3 3 1 3 1</elem>
          <elem>3 3 3 1 3 2</elem>
          <elem>3 3 3 1 3 3</elem>
          <elem>3 3 3 2 1 1</elem>
          <elem>3 3 3 2 1 2</elem>
          <elem>3 3 3 2 1 3</elem>
          <elem>3 3 3 2 2 1</elem>
          <elem>3 3 3 2 2 2</elem>
          <elem>3 3 3 2 2 3</elem>
          <elem>3 3 3 2 3 1</elem>
          <elem>3 3 3 2 3 2</elem>
          <elem>3 3 3 2 3 3</elem>
          <elem>3 3 3 3 1 1</elem>
          <elem>3 3 3 3 1 2</elem>
          <elem>3 3 3 3 1 3</elem>
          <elem>3 3 3 3 2 1</elem>
          <elem>3 3 3 3 2 2</elem>
          <elem>3 3 3 3 2 3</elem>
          <elem>3 3 3 3 3 1</elem>
          <elem>3 3 3 3 3 2</elem>
          <elem>3 3 3 3 3 3</elem>
</annotation>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <glue_op_file>${db_file}</glue_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print glueball colorvec matrix elements
#
proc print_glue_dist_colorvec_4d
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>GLUEBALL_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <site_orthog_basis>false</site_orthog_basis>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem></elem>
          <elem>1</elem>
          <elem>2</elem>
          <elem>3</elem>
          <elem>1 1</elem>
          <elem>1 2</elem>
          <elem>1 3</elem>
          <elem>2 1</elem>
          <elem>2 2</elem>
          <elem>2 3</elem>
          <elem>3 1</elem>
          <elem>3 2</elem>
          <elem>3 3</elem>
          <elem>1 1 1</elem>
          <elem>1 1 2</elem>
          <elem>1 1 3</elem>
          <elem>1 2 1</elem>
          <elem>1 2 2</elem>
          <elem>1 2 3</elem>
          <elem>1 3 1</elem>
          <elem>1 3 2</elem>
          <elem>1 3 3</elem>
          <elem>2 1 1</elem>
          <elem>2 1 2</elem>
          <elem>2 1 3</elem>
          <elem>2 2 1</elem>
          <elem>2 2 2</elem>
          <elem>2 2 3</elem>
          <elem>2 3 1</elem>
          <elem>2 3 2</elem>
          <elem>2 3 3</elem>
          <elem>3 1 1</elem>
          <elem>3 1 2</elem>
          <elem>3 1 3</elem>
          <elem>3 2 1</elem>
          <elem>3 2 2</elem>
          <elem>3 2 3</elem>
          <elem>3 3 1</elem>
          <elem>3 3 2</elem>
          <elem>3 3 3</elem>
          <elem>1 1 1 1</elem>
          <elem>1 1 1 2</elem>
          <elem>1 1 1 3</elem>
          <elem>1 1 2 1</elem>
          <elem>1 1 2 2</elem>
          <elem>1 1 2 3</elem>
          <elem>1 1 3 1</elem>
          <elem>1 1 3 2</elem>
          <elem>1 1 3 3</elem>
          <elem>1 2 1 1</elem>
          <elem>1 2 1 2</elem>
          <elem>1 2 1 3</elem>
          <elem>1 2 2 1</elem>
          <elem>1 2 2 2</elem>
          <elem>1 2 2 3</elem>
          <elem>1 2 3 1</elem>
          <elem>1 2 3 2</elem>
          <elem>1 2 3 3</elem>
          <elem>1 3 1 1</elem>
          <elem>1 3 1 2</elem>
          <elem>1 3 1 3</elem>
          <elem>1 3 2 1</elem>
          <elem>1 3 2 2</elem>
          <elem>1 3 2 3</elem>
          <elem>1 3 3 1</elem>
          <elem>1 3 3 2</elem>
          <elem>1 3 3 3</elem>
          <elem>2 1 1 1</elem>
          <elem>2 1 1 2</elem>
          <elem>2 1 1 3</elem>
          <elem>2 1 2 1</elem>
          <elem>2 1 2 2</elem>
          <elem>2 1 2 3</elem>
          <elem>2 1 3 1</elem>
          <elem>2 1 3 2</elem>
          <elem>2 1 3 3</elem>
          <elem>2 2 1 1</elem>
          <elem>2 2 1 2</elem>
          <elem>2 2 1 3</elem>
          <elem>2 2 2 1</elem>
          <elem>2 2 2 2</elem>
          <elem>2 2 2 3</elem>
          <elem>2 2 3 1</elem>
          <elem>2 2 3 2</elem>
          <elem>2 2 3 3</elem>
          <elem>2 3 1 1</elem>
          <elem>2 3 1 2</elem>
          <elem>2 3 1 3</elem>
          <elem>2 3 2 1</elem>
          <elem>2 3 2 2</elem>
          <elem>2 3 2 3</elem>
          <elem>2 3 3 1</elem>
          <elem>2 3 3 2</elem>
          <elem>2 3 3 3</elem>
          <elem>3 1 1 1</elem>
          <elem>3 1 1 2</elem>
          <elem>3 1 1 3</elem>
          <elem>3 1 2 1</elem>
          <elem>3 1 2 2</elem>
          <elem>3 1 2 3</elem>
          <elem>3 1 3 1</elem>
          <elem>3 1 3 2</elem>
          <elem>3 1 3 3</elem>
          <elem>3 2 1 1</elem>
          <elem>3 2 1 2</elem>
          <elem>3 2 1 3</elem>
          <elem>3 2 2 1</elem>
          <elem>3 2 2 2</elem>
          <elem>3 2 2 3</elem>
          <elem>3 2 3 1</elem>
          <elem>3 2 3 2</elem>
          <elem>3 2 3 3</elem>
          <elem>3 3 1 1</elem>
          <elem>3 3 1 2</elem>
          <elem>3 3 1 3</elem>
          <elem>3 3 2 1</elem>
          <elem>3 3 2 2</elem>
          <elem>3 3 2 3</elem>
          <elem>3 3 3 1</elem>
          <elem>3 3 3 2</elem>
          <elem>3 3 3 3</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <glue_op_file>${db_file}</glue_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print glueball colorvec matrix elements
#
proc print_glue_dist_colorvec_3d
{
  local($db_file, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <Name>GLUEBALL_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <displacement_length>${HMCParam::deriv_length}</displacement_length>
        <decay_dir>3</decay_dir>
        <site_orthog_basis>false</site_orthog_basis>

        <!-- List of displacement arrays --> 
        <displacement_list>
          <elem></elem>
          <elem>1</elem>
          <elem>2</elem>
          <elem>3</elem>
          <elem>1 1</elem>
          <elem>1 2</elem>
          <elem>1 3</elem>
          <elem>2 1</elem>
          <elem>2 2</elem>
          <elem>2 3</elem>
          <elem>3 1</elem>
          <elem>3 2</elem>
          <elem>3 3</elem>
          <elem>1 1 1</elem>
          <elem>1 1 2</elem>
          <elem>1 1 3</elem>
          <elem>1 2 1</elem>
          <elem>1 2 2</elem>
          <elem>1 2 3</elem>
          <elem>1 3 1</elem>
          <elem>1 3 2</elem>
          <elem>1 3 3</elem>
          <elem>2 1 1</elem>
          <elem>2 1 2</elem>
          <elem>2 1 3</elem>
          <elem>2 2 1</elem>
          <elem>2 2 2</elem>
          <elem>2 2 3</elem>
          <elem>2 3 1</elem>
          <elem>2 3 2</elem>
          <elem>2 3 3</elem>
          <elem>3 1 1</elem>
          <elem>3 1 2</elem>
          <elem>3 1 3</elem>
          <elem>3 2 1</elem>
          <elem>3 2 2</elem>
          <elem>3 2 3</elem>
          <elem>3 3 1</elem>
          <elem>3 3 2</elem>
          <elem>3 3 3</elem>
        </displacement_list>

        <LinkSmearing>
          <LinkSmearingType>${HMCParam::link_smear_type}</LinkSmearingType>
          <link_smear_fact>${HMCParam::link_smear_fact}</link_smear_fact>
          <link_smear_num>${HMCParam::link_smear_num}</link_smear_num>
          <no_smear_dir>3</no_smear_dir>
        </LinkSmearing>

      </Param>
      <NamedObject>
        <gauge_id>default_gauge_field</gauge_id>
        <colorvec_id>eigeninfo_0</colorvec_id>
        <glue_op_file>${db_file}</glue_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------------
# Print tetra colorvec matrix elements
#
proc print_tetra_colorvec
{
  local($eig_db, $tet_db, $input) = @_
  open(INPUT, ">> $input")
  print INPUT <<EOF
    <elem>
      <annotation>
        Tetraquark colorvecs
      </annotation>
      <Name>TETRAQUARK_MATELEM_COLORVEC</Name>
      <Frequency>1</Frequency>
      <Param>
        <version>1</version>
        <mom2_min>${HMCParam::mom2_min}</mom2_min>
        <mom2_max>${HMCParam::mom2_max}</mom2_max>
        <num_vecs>${HMCParam::num_vecs}</num_vecs>
        <mom_list></mom_list>
        <decay_dir>3</decay_dir>
      </Param>
      <NamedObject>
        <colorvec_file>${eig_db}</colorvec_file>
        <tetraquark_op_file>${tet_db}</tetraquark_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}


#------------------------------------------------------------------------
# Find the canonical order of displacements
proc canonical_order_disp
{
  local(@mom) = @_

  # first step: make all the components positive
  my @mom_tmp = @mom

  # Initially, the first item is considered sorted.  mu divides mom
  # into a sorted region (<mu) and an unsorted one (>=mu)
  my @mu
  foreach $mu (1 .. $#mom_tmp)
  {
    # Select the item at the beginning of the unsorted region
    my $v = $mom_tmp[$mu]
    # Work backwards, finding where v should go
    my $nu = $mu
    # If this element is less than v, move it up one
    while ($mom_tmp[$nu-1] < $v && $nu >= 1) 
    {
      $mom_tmp[$nu] = $mom_tmp[$nu-1]
      --$nu
    }
    # Stopped when mom_tmp[nu-1] >= v, so put v at postion nu
    $mom_tmp[$nu] = $v
  }

  return @mom_tmp
}


#------------------------------------------------------------------------------
# Check the prop
#
proc check_prop
{
  local($mass_labell, $num_vecs, $tol, $peram_db) = @_

  local $exee = "/home/edwards/bin/x86_64-linux/g5herm_check"

  # Run the check program
  print "Before ${exe}: ", `date`
  my $err = 0xffff & system("$exee $num_vecs $mass_labell $tol $peram_db < /dev/null")
  print "After ${exe}: ", `date`

  return $err
}

