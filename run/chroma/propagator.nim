## Propagator support

#import serializetools/serializexml
import xmltree

type
  Propagator_t* = object
    version*:         int
    quarkSpinType*:   string
    obsvP*:           bool
    numRetries*:      int
    FermionAction*:   XmlNode
    InvertParam*:     XmlNode


proc newPropagator*(FermionAction: XmlNode, InvertParam: XmlNode): Propagator_t =
  ## Return a new propagator
  return Propagator_t(version: 10, quarkSpinType: "FULL", obsvP: false, numRetries: 1, FermionAction: FermionAction, InvertParam: InvertParam)

#[
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
]#




