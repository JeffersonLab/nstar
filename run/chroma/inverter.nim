## Clover inverters

import clover_fermact


#---------------------------------------------------------------------
type
  CloverParams_t* = object
    Mass*:          float
    clovCoeffR*:    float
    clovCoeffT*:    float
    AnisoParam*:    AnisoParam_t

#---------------------------------------------------------------------
type
  CGInverter_t* = object        ## Vanilla clover inverter
    invType*:          string   ## CG_INVERTER
    RsdCG*:            float
    MaxCG*:            int


#---------------------------------------------------------------------
type
  QOPCloverMultigridInverter_t* = object   ## QOP_CLOVER_MULTIGRID_INVERTER
    invType*:          string  
    Mass*:             float
    Clover*:           float
    CloverT*:          float
    AnisoXi*:          float
    AnisoNu*:          float
    MaxIter*:          int
    Residual*:         float
    Verbose*:          int
    Levels*:           int
    Blocking*:         seq[seq[int]]

    NumNullVecs*:      seq[int]
    NumExtraVecs*:     seq[int]

    NullResidual*:     seq[float]
    NullMaxIter*:      seq[int]
    NullConvergence*:  seq[float]

    Underrelax*:       seq[float]
    NumPreHits*:       seq[int]
    NumPostHits*:      seq[int]
    CoarseMaxIter*:    seq[int]
    CoarseResidual*:   seq[float]

#[
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
]#



#---------------------------------------------------------------------
type
  MULTIGRIDParams_t* = object          ## Parameters within QUDA AMG
    Verbosity*:                  bool
    Precision*:                  string
    Reconstruct*:                string
    Blocking*:                   seq[seq[int]]
    CoarseSolverType*:           seq[string]
    CoarseResidual*:             seq[float]
    MaxCoarseIterations*:        seq[int]
    RelaxationOmegaMG*:          seq[float]
    SmootherType*:               seq[string]
    SmootherTol*:                seq[float]
    NullVectors*:                seq[int]
    PreSmootherApplications*:    seq[int]
    PostSmootherApplications*:   seq[int]
    SubspaceSolver*:             seq[string]
    RsdTargetSubspaceCreate*:    seq[float]
    MaxIterSubspaceCreate*:      seq[int]
    MaxIterSubspaceRefresh*:     seq[int]
    OuterGCRNKrylov*:            int
    PrecondGCRNKrylov*:          int
    GenerateNullspace*:          bool
    CheckMultigridSetup*:        bool
    GenerateAllLevels*:          bool
    CycleType*:                  string
    SchwarzType*:                string
    RelaxationOmegaOuter*:       float
    SetupOnGPU*:                 seq[int]



  QUDA_MULTIGRID_CLOVER_INVERTER_t* =  object
    invType*:               string      # QUDA_MULTIGRID_CLOVER_INVERTER
    CloverParams*:          CloverParams_t
    RsdTarget*:             float
    MULTIGRIDParams*:       MULTIGRIDParams_t    
    Delta*:                 float
    Pipeline*:              int
    MaxIter*:               int
    RsdToleranceFactor*:    int
    SilentFail*:            bool
    AntiPeriodicT*:         bool
    SolverType*:            string
    Verbose*:               bool
    AsymmetricLinop*:       bool
    CudaReconstruct*:       string
    CudaSloppyPrecision*:   string
    CudaSloppyReconstruct*: string
    AxialGaugeFix*:         bool
    AutotuneDslash*:        bool
    SubspaceID*:            string


#[
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

            <RsdTarget>{HMCParam::RsdCG}</RsdTarget>
            <CloverParams>
              <Mass>{m_q}</Mass>
              <clovCoeffR>{c_s}</clovCoeffR>
              <clovCoeffT>{c_t}</clovCoeffT>
              <AnisoParam>
                <anisoP>true</anisoP>
                <t_dir>3</t_dir>
                <xi_0>{HMCParam::xi_0}</xi_0>
                <nu>{HMCParam::nu}</nu>
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
]#


#---------------------------------------------------------------------
type
  QPhiXCloverIterRefineBICGstabInverter_t* = object  ## QPHIX_CLOVER_ITER_REFINE_BICGSTAB_INVERTER
    invType*:               string      
    SolverType*:            string
    MaxIter*:               int
    RsdTarget*:             float
    Delta*:                 float
    CloverParams*:          CloverParams_t
    AntiPeriodicT*:         bool
    Verbose*:               bool
    RsdToleranceFactor*:    int

#[
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

]#



#---------------------------------------------------------------------
type
  QPhiXCloverMGInverter_t* = object  ## MG_PROTO_QPHIX_EO_CLOVER_INVERTER
    invType*:                        string      
    CloverParams*:                   CloverParams_t
    AntiPeriodicT*:                  bool
    MGLevels*:                       int
    Blocking*:                       seq[seq[int]]
    NullVecs*:                       seq[int]
    NullSolverMaxIters*:             seq[int]
    NullSolverRsdTarget*:            seq[float]
    NullSolverVerboseP*:             seq[int]
    OuterSolverNKrylov*:             int
    OuterSolverRsdTarget*:           float
    OuterSolverMaxIters*:            int
    OuterSolverVerboseP*:            bool
    VCyclePreSmootherMaxIters*:      seq[int]
    VCyclePreSmootherRsdTarget*:     seq[float]
    VCyclePreSmootherRelaxOmega*:    seq[float]
    VCyclePreSmootherVerboseP*:      seq[int]
    VCyclePostSmootherMaxIters*:     seq[int]
    VCyclePostSmootherRsdTarget*:    seq[float]
    VCyclePostSmootherRelaxOmega*:   seq[float]
    VCyclePostSmootherVerboseP*:     seq[int]
    VCycleBottomSolverMaxIters*:     seq[int]
    VCycleBottomSolverRsdTarget*:    seq[float]
    VCycleBottomSolverNKrylov*:      seq[int]
    VCycleBottomSolverVerboseP*:     seq[int]
    VCycleMaxIters*:                 seq[int]
    VCycleRsdTarget*:                seq[float]
    VCycleVerboseP*:                 seq[int]
    SubspaceId*:                     string


#[
        <InvertParam>
	<invType>MG_PROTO_QPHIX_EO_CLOVER_INVERTER</invType>
	<CloverParams>
              <Mass>-0.0856</Mass>
              <clovCoeffR>1.589327</clovCoeffR>
              <clovCoeffT>0.902784</clovCoeffT>
              <AnisoParam>
                <anisoP>true</anisoP>
                <t_dir>3</t_dir>
                <xi_0>4.3</xi_0>
                <nu>1.265</nu>
              </AnisoParam>
	</CloverParams>

	<AntiPeriodicT>true</AntiPeriodicT>

	<MGLevels>3</MGLevels>
	<Blocking>
	  <elem>3 3 3 4</elem>
	  <elem>2 2 2 2</elem>
	</Blocking>

	<NullVecs>24 32</NullVecs>
	<NullSolverMaxIters>100 100</NullSolverMaxIters>
	<NullSolverRsdTarget>5e-6 5e-6</NullSolverRsdTarget>
	<NullSolverVerboseP>0 0</NullSolverVerboseP>

	<OuterSolverNKrylov>8</OuterSolverNKrylov>
	<OuterSolverRsdTarget>1.0e-8</OuterSolverRsdTarget>
	<OuterSolverMaxIters>100</OuterSolverMaxIters>
	<OuterSolverVerboseP>true</OuterSolverVerboseP>
	
	<VCyclePreSmootherMaxIters>0 0</VCyclePreSmootherMaxIters>
	<VCyclePreSmootherRsdTarget>0.1 0.1</VCyclePreSmootherRsdTarget>
	<VCyclePreSmootherRelaxOmega>1.1 1.1</VCyclePreSmootherRelaxOmega>
	<VCyclePreSmootherVerboseP>0 0</VCyclePreSmootherVerboseP>


	<VCyclePostSmootherMaxIters>8 8</VCyclePostSmootherMaxIters>
	<VCyclePostSmootherRsdTarget>0.1 0.1</VCyclePostSmootherRsdTarget>
	<VCyclePostSmootherRelaxOmega>1.1 1.1</VCyclePostSmootherRelaxOmega>
	<VCyclePostSmootherVerboseP>0 0</VCyclePostSmootherVerboseP>

	<VCycleBottomSolverMaxIters>8 24</VCycleBottomSolverMaxIters>
	<VCycleBottomSolverRsdTarget>0.1 0.1</VCycleBottomSolverRsdTarget>
	<VCycleBottomSolverNKrylov>8 8</VCycleBottomSolverNKrylov>
	<VCycleBottomSolverVerboseP>0 0</VCycleBottomSolverVerboseP>
	
	<VCycleMaxIters>1 1</VCycleMaxIters>
	<VCycleRsdTarget>0.1 0.1</VCycleRsdTarget>
	<VCycleVerboseP>0 0</VCycleVerboseP>

	<SubspaceId>foo_eo</SubspaceId>

        </InvertParam>
]#
