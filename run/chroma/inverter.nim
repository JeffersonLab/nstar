## Clover inverters

import clover_fermact
import serializetools/serializexml
import xmltree

type
  CGInverter_t* = object
    invType*:          string   ## CG_INVERTER
    RsdCG*:            float
    MaxCG*:            int


type
  QOPCloverMultigridInverter_t* = object
    invType*:          string   ## QOP_CLOVER_MULTIGRID_INVERTER
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



type
  CloverParams_t* = object
    Mass*:         float
    clovCoeffR*:   float
    clovCoeffT*:   float
    AnisoParam*:   AnisoParam_t


  MULTIGRIDParams_t* = object
    Residual*:              float
    CycleType*:             string
    RelaxationOmegaMG*:     float
    RelaxationOmegaOuter*:  float
    MaxIterations*:         int
    SmootherType*:          string
    Verbosity*:             bool
    Precision*:             string
    Reconstruct*:           string
    NullVectors*:           seq[int]
    GenerateNullspace*:     bool
    GenerateAllLevels*:     bool
    PreSmootherApplications*:   seq[int]
    PostSmootherApplications*:  seq[int]
    SchwarzType*:           string
    Blocking*:              seq[seq[int]]


  QUDA_MULTIGRID_CLOVER_INVERTER_t* =  object
    invType*:               string      # <invType>QUDA_MULTIGRID_CLOVER_INVERTER</invType>
    MULTIGRIDParams*:       MULTIGRIDParams_t    
    CloverParams*:          CloverParams_t
    RsdTarget*:             float
    Delta*:                 float
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
    SubspaceID*:            string


  
