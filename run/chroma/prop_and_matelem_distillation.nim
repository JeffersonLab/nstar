]## Prop and matelem distillation

import propagator
import serializetools/serializexml
import xmltree
import inline_meas


#------------------------------------------------------------------------------
type
  Contractions_t* = object
    mass_label*:    string       ## mass label
    num_vecs*:      int          ## yup
    t_sources*:     seq[int]     ## these are the true time sources
    Nt_forward*:    int          ## number steps forward, so  t_source + Nt_forward
    Nt_backward*:   int
    decay_dir*:     int
    num_tries*:     int

  DistParams_t* = object
    Contractions*:    Contractions_t
    Propagator*:      Propagator_t

  NamedObject_t* = object
    gauge_id*:        string
    colorvec_files*:  seq[string]
    prop_op_file*:    string

  PropAndMatelemDistillationParams_t* = object
    Name*:            string
    Frequency*:       int
    Param*:           DistParams_t
    NamedObject*:     NamedObject_t



proc newPropAndMatelemDistillation*(Param: DistParams_t, NamedObject: NamedObject_t): XmlNode =
  ## Return a new prop
  return serializeXML(PropAndMatelemDistillationParams_t(Name: "PROP_AND_MATELEM_DISTILLATION", 
                                                         Frequency: 1, 
                                                         Param: Param, 
                                                         NamedObject: NamedObject))



#[
#------------------------------------------------------------------------------
#
proc print_prop_distillation_cpu_mg(local_eig_file, local_prop_file, m_q, t0_val, input) =
  ## Print propagator and matelem driver for a cpu

  # Displace the origin
  my t0_string = (t0_val + HMCParam::origin) % HMCParam::nrow[3]

# Print for a single mass
  open(INPUT, ">> input")
  print INPUT <<EOF
    <elem>
      <Name>PROP_AND_MATELEM_DISTILLATION</Name>
      <Frequency>{HMCParam::sf_freq}</Frequency>
      <Param>
        <Contractions>
          <mass_label>U{m_q}</mass_label>
          <num_vecs>{HMCParam::num_vecs}</num_vecs>
          <t_sources>{t0_string}</t_sources>
          <Nt_forward>{HMCParam::Nt_forward}</Nt_forward>
          <Nt_backward>{HMCParam::Nt_backward}</Nt_backward>
          <decay_dir>3</decay_dir>
          <num_tries>{HMCParam::num_tries}</num_tries>
        </Contractions>
        <Propagator>
          <version>10</version>
          <quarkSpinType>FULL</quarkSpinType>
          <obsvP>false</obsvP>
          <numRetries>1</numRetries>
          <FermionAction>
            <FermAct>UNPRECONDITIONED_CLOVER</FermAct>
            <Mass>{m_q}</Mass>
            <clovCoeffR>{c_s}</clovCoeffR>
            <clovCoeffT>{c_t}</clovCoeffT>
            <AnisoParam>
              <anisoP>{HMCParam::anisoP}</anisoP>
              <xi_0>{HMCParam::xi_0}</xi_0>
              <nu>{HMCParam::nu}</nu>
              <t_dir>{HMCParam::t_dir}</t_dir>
            </AnisoParam>
            <FermState>
              <Name>STOUT_FERM_STATE</Name>
              <rho>{HMCParam::rho}</rho>
              <n_smear>{HMCParam::n_smear}</n_smear>
	      <orthog_dir>{HMCParam::orthog_dir}</orthog_dir>
              <FermionBC>
                <FermBC>SIMPLE_FERMBC</FermBC>
                <boundary>1 1 1 -1</boundary>
              </FermionBC>
            </FermState>
          </FermionAction>
          <InvertParam>
            <invType>QOP_CLOVER_MULTIGRID_INVERTER</invType>
            <Mass>{m_q}</Mass>
            <Clover>{c_s}</Clover>
            <CloverT>{c_t}</CloverT>
            <AnisoXi>{HMCParam::xi_0}</AnisoXi>
            <AnisoNu>{HMCParam::nu}</AnisoNu>
            <MaxIter>200</MaxIter>
            <Residual>{HMCParam::RsdCG}</Residual>
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
        <colorvec_files>{local_eig_file}</colorvec_files>
        <prop_op_file>{local_prop_file}</prop_op_file>
      </NamedObject>
    </elem>

EOF
close(INPUT)
}

]#



