#
# This is the work script called by run_colorvec_*pl
#
import os, strutils
import re
import xmltree

import serializetools/serializexml
import ../../irrep_util
import unsmeared_hadron_node_distillation
import drand48


import config_JLab


type Mom_t = array[0..2,cint]    ## shorthand


#------------------------------------------------------------------------------
proc readListT0*(list: string): int =
  ## Read/modify the next t0 in the list
  result = -1


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



#------------------------------------------------------------------------
# Copy a lustre file to scratch
proc copy_lustre_file*(orig_file: string, use_cp: bool): string =
  if use_cp:
    var filename = extractFilename(orig_file)

    # scratch
    let scratch_dir = getScratchPath()

    # Copy files
    if not fileExists(orig_file):
      quit("Lustre file not found: " & orig_file)

    echo "In function find_file:   copy_lustre_file ", orig_file

#    if execShellCmd("cache_cp " & orig_file & " " & scratch_dir) != 0:
#      quit("Some problem copying with copying " & orig_file)
#    if execShellCmd("/bin/cp " & orig_file & " " & scratch_dir) != 0:
#      quit("Some problem copying with copying " & orig_file)

    result = scratch_dir & "/" & filename
  else:
    result = orig_file


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
  # Clean out characters and set the rng with the traj number as an int
  var traj = parseInt(trajj.replace(re"[a-zA-Z]"))
  srand48(traj)
  
  # Clean out rngs
  for i in 1..20:
    discard drand48()

  # Origin is in the interval [0,Lt-1)
  result = int(float(Lt)*drand48())



#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
## Various constructions useful for distillation
import fermbc, fermstate
import inverter
import clover_fermact
import link_smearing


proc newStandardStoutLinkSmear*(): XmlNode =
  ## Standard link smearing we use for in distillation
  newStoutLinkSmearing(0.1, 10, 3)

#------------------------------------------------------------------------------
proc splitSeq*(t0s: seq[int], max_t0: int): seq[seq[int]] =
  ## Split array of seqs into chunks of seqs
  result = @[]

  var cnt = 0
  while cnt < t0s.len():
    var to_do: seq[int] = @[]

    for cc in 1 .. max_t0:
      if cnt == t0s.len(): continue
      to_do.add(t0s[cnt])
      cnt += 1

    if to_do.len() > 0:
      result.add(to_do)


#------------------------------------------------------------------------------
proc flipMom(mom: Mom_t): Mom_t =
  ## flip momenta
  result = [-mom[0], -mom[1], -mom[2]]

proc newMaxMomDispGammaMom*(gammas: seq[cint]; mom2_min, mom2_max: cint): seq[DispGammaMom_t] =
  ## Generate canonical momenta. In this version, no displacements
  result.setLen(0)
  let canon_mom = generateCanonMoms(mom2_min, mom2_max)
  # loop over mom
  for gamma in items(gammas):
    for mom in items(canon_mom):
      if norm2(mom) == 0:
        result.add(DispGammaMom_t(gamma: gamma, mom: mom))
      else:
        # add both moms
        result.add(DispGammaMom_t(gamma: gamma, mom: mom))
        result.add(DispGammaMom_t(gamma: gamma, mom: flipMom(mom)))


#------------------------------------------------------------------------------
proc newAnisoParams*(): AnisoParam_t =
  ## Anisotropic clover params for light and strange quarks
  AnisoParam_t(anisoP: true, xi_0: 4.3, nu: 1.265, t_dir: 3)

proc newAnisoCharmParams*(): AnisoParam_t =
  ## Anisotropic clover params for light and strange quarks
  AnisoParam_t(anisoP: true, xi_0: 4.3, nu: 1.078, t_dir: 3)

proc newSFBC*(): XmlNode =
  ## Simple anti-periodic fermion bc
  newSimpleFermBC(@[1,1,1,-1])

proc newAnisoCloverParams*(mass: float): CloverParams_t =
  ## QUDA used this for clover parameters
  CloverParams_t(Mass: mass, clovCoeffR: 1.589327, clovCoeffT: 0.902784, AnisoParam: newAnisoParams())

proc newAnisoCharmParams*(mass: float): CloverParams_t =
  ## QUDA used this for clover parameters
  CloverParams_t(Mass: mass, clovCoeffR: 1.35438320085927, clovCoeffT: 0.793917288535831, AnisoParam: newAnisoCharmParams())

proc newAnisoStoutFermState*(): XmlNode = 
  ## Create an anisotropic stout ferm state
  newStoutFermState(0.14, 2, 3, newSFBC())

#proc newAnisoClover*(FermAct: string, mass: float): XmlNode =
#  ## Anisotropic clover fermion action
#  let params = newAnisoCloverParams(mass)
#  result = newCloverFermionAction(FermAct, mass, params.clovCoeffR, params.clovCoeffT, params.AnisoParam, newAnisoStoutFermState())

proc newAnisoCloverFermAct*(FermAct: string, clov: CloverParams_t): XmlNode =
  ## Anisotropic clover fermion action
  newCloverFermionAction(FermAct, clov.Mass, clov.clovCoeffR, clov.clovCoeffT, clov.AnisoParam, newAnisoStoutFermState())

proc newAnisoCloverFermAct*(clov: CloverParams_t): XmlNode =
  ## Anisotropic clover fermion action
  newAnisoCloverFermAct("CLOVER", clov)

proc newAnisoSEOPrecCloverFermAct*(clov: CloverParams_t): XmlNode =
  ## Anisotropic clover fermion action
  newAnisoCloverFermAct("SEOPREC_CLOVER", clov)

#proc newAnisoUnprecCloverFermAct*(clov: CloverParams_t): XmlNode =
#  ## Anisotropic clover fermion action
#  newAnisoCloverFermAct("UNPRECONDITIONED_CLOVER", clov)

#proc newIsoCloverFermAct*(clov: CloverParams_t): XmlNode =
#  ## Isotropic clover fermion action
#  let state  = newSimpleFermState(newSFBC())
#  serializeXML(IsoCloverFermionAction_t(FermAct: "CLOVER", Mass: mass, clovCoeff: 1.0, FermState: state), "FermState")


#------------------------------------------------------------------------------
# Yeah, loads of funky/nutty/wacky inverters

proc newVanillaCG*(Rsd: float, MaxIter: int): XmlNode =
  ## Vanilla CG
  serializeXML(CGInverter_t(invType: "CG_INVERTER",
                            RsdCG: Rsd,
                            MaxCG: MaxIter), "InvertParam")

                                            
proc newQOPAMG24x256*(mass: float, Rsd: float, MaxIter: int): XmlNode =
  ## QOP MG inverter on 24^3x256
  serializeXML(QOPCloverMultigridInverter_t(invType: "QOP_CLOVER_MULTIGRID_INVERTER",
                                            Mass: mass, 
                                            Clover: 1.589327, 
                                            CloverT: 0.902784,
                                            AnisoXi: 4.3,
                                            AnisoNu: 1.265,
                                            MaxIter: MaxIter,
                                            Residual: Rsd,
                                            Verbose: 0,
                                            Levels: 2,
                                            Blocking: @[@[4,4,4,4], @[2,2,2,2]],
                                            NumNullVecs: @[24, 32],
                                            NumExtraVecs: @[0, 0],
                                            NullResidual: @[0.4, 0.4],
                                            NullMaxIter: @[100, 100],
                                            NullConvergence: @[0.5, 0.5],
                                            Underrelax: @[1.0, 1.0],
                                            NumPreHits: @[0, 0],
                                            NumPostHits: @[4, 1],
                                            CoarseMaxIter: @[12, 12],
                                            CoarseResidual: @[0.2, 0.3]), "InvertParam")
                                            

#            <invType>QUDA_MULTIGRID_CLOVER_INVERTER</invType>
#             <RsdTargetSubspaceCreate>5e-06 5e-06</RsdTargetSubspaceCreate>
#             <MaxIterSubspaceCreate>500 500</MaxIterSubspaceCreate>
#              <MaxIterSubspaceRefresh>500 500</MaxIterSubspaceRefresh>
#              <OuterGCRNKrylov>20</OuterGCRNKrylov>
#              <PrecondGCRNKrylov>10</PrecondGCRNKrylov>
#              <GenerateNullspace>true</GenerateNullspace>
#              <CheckMultigridSetup>false</CheckMultigridSetup>
#              <GenerateAllLevels>true</GenerateAllLevels>
#              <CycleType>MG_RECURSIVE</CycleType>
#              <SchwarzType>ADDITIVE_SCHWARZ</SchwarzType>
#              <RelaxationOmegaOuter>1.0</RelaxationOmegaOuter>
#              <SetupOnGPU>1 1</SetupOnGPU>

proc newQUDAMGParams20x256*(): MULTIGRIDParams_t =
  ## QUDA MG params to run small sizes
  MULTIGRIDParams_t(Verbosity: true,
                    Precision: "HALF",
                    Reconstruct: "RECONS_12",
                    Blocking: @[@[5,5,5,4], @[2,2,2,2]],
                    CoarseSolverType: @["GCR", "CA_GCR"],
                    CoarseResidual: @[0.1, 0.1, 0.1],
                    MaxCoarseIterations: @[12, 12, 8],
                    RelaxationOmegaMG: @[1.0, 1.0, 1.0],
                    SmootherType: @["CA_GCR", "CA_GCR", "CA_GCR"],
                    SmootherTol: @[0.25, 0.25, 0.25],
                    NullVectors: @[24, 32],
                    PreSmootherApplications: @[0, 0],
                    PostSmootherApplications: @[8, 8],
                    SubspaceSolver: @["CG", "CG"],
                    RsdTargetSubspaceCreate: @[5.0e-06, 5.0e-06],
                    MaxIterSubspaceCreate: @[500, 500],
                    MaxIterSubspaceRefresh: @[500, 500],
                    OuterGCRNKrylov: 20,
                    PrecondGCRNKrylov: 10,
                    GenerateNullspace: true,
                    CheckMultigridSetup: false,
                    GenerateAllLevels: true, 
                    CycleType: "MG_RECURSIVE",
                    SchwarzType: "ADDITIVE_SCHWARZ",
                    RelaxationOmegaOuter: 1.0,
                    SetupOnGPU: @[1, 1])


proc newQUDAMGParams24x256*(): MULTIGRIDParams_t =
  ## QUDA MG params to run small sizes
  MULTIGRIDParams_t(Verbosity: true,
                    Precision: "HALF",
                    Reconstruct: "RECONS_12",
                    Blocking: @[@[3,3,3,2], @[2,2,2,2]],
                    CoarseSolverType: @["GCR", "CA_GCR"],
                    CoarseResidual: @[0.1, 0.1, 0.1],
                    MaxCoarseIterations: @[12, 12, 8],
                    RelaxationOmegaMG: @[1.0, 1.0, 1.0],
                    SmootherType: @["CA_GCR", "CA_GCR", "CA_GCR"],
                    SmootherTol: @[0.25, 0.25, 0.25],
                    NullVectors: @[24, 32],
                    PreSmootherApplications: @[0, 0],
                    PostSmootherApplications: @[8, 8],
                    SubspaceSolver: @["CG", "CG"],
                    RsdTargetSubspaceCreate: @[5.0e-06, 5.0e-06],
                    MaxIterSubspaceCreate: @[500, 500],
                    MaxIterSubspaceRefresh: @[500, 500],
                    OuterGCRNKrylov: 20,
                    PrecondGCRNKrylov: 10,
                    GenerateNullspace: true,
                    CheckMultigridSetup: false,
                    GenerateAllLevels: true, 
                    CycleType: "MG_RECURSIVE",
                    SchwarzType: "ADDITIVE_SCHWARZ",
                    RelaxationOmegaOuter: 1.0,
                    SetupOnGPU: @[1, 1])



#            <RsdTarget>1e-08</RsdTarget>
#            <Delta>1.0e-1</Delta>
#            <Pipeline>4</Pipeline>
#            <MaxIter>1000</MaxIter>
#            <RsdToleranceFactor>8.0</RsdToleranceFactor>
#            <AntiPeriodicT>true</AntiPeriodicT>
#            <SolverType>GCR</SolverType>
#            <Verbose>true</Verbose>
#            <AsymmetricLinop>false</AsymmetricLinop>
#            <CudaReconstruct>RECONS_12</CudaReconstruct>
#            <CudaSloppyPrecision>SINGLE</CudaSloppyPrecision>
#            <CudaSloppyReconstruct>RECONS_12</CudaSloppyReconstruct>
#            <AxialGaugeFix>false</AxialGaugeFix>
#            <AutotuneDslash>true</AutotuneDslash>

proc newQUDAMGInv*(Rsd: float, MaxIter: int, clov: CloverParams_t, mg: MULTIGRIDParams_t): XmlNode =
  ## QUDA MG inverter, with some parameters hardwired
  serializeXML(QUDA_MULTIGRID_CLOVER_INVERTER_t(invType: "QUDA_MULTIGRID_CLOVER_INVERTER",
                                                RsdTarget: Rsd,
                                                MULTIGRIDParams: mg,
                                                CloverParams: clov,
                                                Delta: 1.0e-1,
                                                Pipeline: 4,
                                                MaxIter: MaxIter,
                                                RsdToleranceFactor: 10,                                                                                       SilentFail: true,
                                                AntiPeriodicT: true,
                                                SolverType: "GCR",
                                                Verbose: true,
                                                AsymmetricLinop: true,
                                                CudaReconstruct: "RECONS_12",
                                                CudaSloppyPrecision: "SINGLE",
                                                CudaSloppyReconstruct: "RECONS_12",
                                                AxialGaugeFix: false,
                                                AutotuneDslash: true,
                                                SubspaceID: "foo"), "InvertParam")


proc newQPhiXBiCGInv*(rsd: float, MaxIter: int, clov: CloverParams_t): XmlNode =
  ## QPHIX BICGstab inverter, with some parameters hardwired
  serializeXML(QPhiXCloverIterRefineBICGstabInverter_t(invType: "QPHIX_CLOVER_ITER_REFINE_BICGSTAB_INVERTER",
                                                       SolverType: "BICGSTAB",
                                                       MaxIter: MaxIter,
                                                       RsdTarget: rsd,
                                                       CloverParams: clov,
                                                       Delta: 1.0e-4, 
                                                       RsdToleranceFactor: 100,
                                                       AntiPeriodicT: true,
                                                       Verbose: true), "InvertParam")



proc newQPhiXMGParams24x256*(rsd: float, MaxIter: int, clov: CloverParams_t): XmlNode =
  ## QPHIX BICGstab inverter, with some parameters hardwired
  serializeXML(QPhiXCloverMGInverter_t(invType: "MG_PROTO_QPHIX_EO_CLOVER_INVERTER",
                                       CloverParams: clov,
                                       AntiPeriodicT: true,
                                       MGLevels: 3,
                                       Blocking: @[@[3,3,3,2], @[2,2,2,2]],
                                       NullVecs: @[24, 32],
                                       NullSolverMaxIters: @[100, 100],
                                       NullSolverRsdTarget: @[5e-6, 5e-6],
                                       NullSolverVerboseP: @[0, 0],
                                       OuterSolverNKrylov: 8,
                                       OuterSolverRsdTarget: 1.0e-8,
                                       #OuterSolverRsdTarget: 5.0e-7,
                                       OuterSolverMaxIters: 100,
                                       OuterSolverVerboseP: true,
                                       VCyclePreSmootherMaxIters: @[0, 0],
                                       VCyclePreSmootherRsdTarget: @[0.1, 0.1],
                                       VCyclePreSmootherRelaxOmega: @[1.1, 1.1],
                                       VCyclePreSmootherVerboseP: @[0, 0],
                                       VCyclePostSmootherMaxIters: @[8, 8],
                                       VCyclePostSmootherRsdTarget: @[0.1, 0.1],
                                       VCyclePostSmootherRelaxOmega: @[1.1, 1.1],
                                       VCyclePostSmootherVerboseP: @[0, 0],
                                       VCycleBottomSolverMaxIters: @[8, 24],
                                       VCycleBottomSolverRsdTarget: @[0.1, 0.1],
                                       VCycleBottomSolverNKrylov: @[8, 8],
                                       VCycleBottomSolverVerboseP: @[0, 0],
                                       VCycleMaxIters: @[1, 1],
                                       VCycleRsdTarget: @[0.1, 0.1],
                                       VCycleVerboseP: @[0, 0],
                                       SubspaceId: "foo_eo"), "InvertParam")


#------------------------------------------------------------------------------
proc newLinkSmearing*(gammas: seq[cint]; mom2_min, mom2_max: cint): XmlNode =
  ## Generate canonical momenta. In this version, no displacements



#[
#------------------------------------------------------------------------------
when isMainModule:
  let input_file = "fred.xml"

#  const ensemble = "test"
  const ensemble = "real"

  # Basic parameters
  when ensemble == "real":
    let stem  = "szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265"
    let seqno = "1000a"

    let lustre_dir = "/lustre/atlas/proj-shared/nph103"
    let cfg_file   =  lustre_dir & "/" & stem & "/cfgs/" & stem & "_" & seqno & ".lime"
    let colorvec_files = @[lustre_dir & "/" & stem & "/eigs_mod/" & stem & ".3d.eigs." & seqno]
    let sdb = "prop_op_file"
    let mass        = -0.0856
    let mass_label  = "U" & formatFloat(mass, ffDecimal, 4)
    echo "mass_label= ", mass_label
    let num_vecs    = 1
    let t_source    = 1

  elif ensemble == "test":
    let stem  = "test_4_16_b10p0"
    let seqno = "1"
    let cfg_file =  stem & ".lime1"
    let colorvec_files = @[stem & ".3d.eigs.mod" & seqno]
    let sdb = "data/prop_op_file.sdb1"

    let mass        = 0.05
    let mass_label  = "U" & formatFloat(mass, ffDecimal, 2)
    echo "mass_label= ", mass_label
    let num_vecs    = 1
    let t_source    = 1

  else:
    quit("Unknown")


  # Common stuff
  let Rsd         = 1.0e-4
  let MaxIter     = 1000

  let lattSize = extractLattSize(stem)
  let Lt = lattSize[3]
  let t_origin = getTimeOrigin(Lt,seqno)
  echo "Lt= ", Lt, "   t_origin= ", t_origin

  var (Nt_forward, Nt_backward) = if t_source mod 32 == 0: (48, 0) else: (1, 0)

  # Used by distillation input
  let contract = matelem.Contractions_t(mass_label: mass_label,
                                        num_vecs: num_vecs,
                                        t_sources: @[t_source + t_origin],
                                        Nt_forward: Nt_forward,
                                        Nt_backward: Nt_backward,
                                        decay_dir: 3,
                                        num_tries: 1)
 

  # Fermion action and inverters
  when ensemble == "real":
    let mg   = newQUDAMGParams24x256()
    let inv  = newQUDAMGInv(Rsd, MaxIter, clov, mg)
    let fermact = newAnisoCloverFermAct(clov)

  elif ensemble == "test":
    let inv  = newVanillaCG(Rsd, MaxIter)
    let fermact = newIsoCloverFermAct(clov)

  else:
    quit("Unknown")


  # Inline measurement
  let mat_named_obj = matelem.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: colorvec_files,
                                            prop_op_file: sdb)
  let mat_prop      = newPropagator(fermact, inv)
  let mat_param     = matelem.DistParams_t(Contractions: contract, Propagator: mat_prop)
  let inline_dist   = matelem.newPropAndMatelemDistillation(mat_param, mat_named_obj)

  var chromaParam = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  #echo "Param:\n", xmlToStr(serializeXML(chromaParam, "chroma"))

  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: cfg_file, parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chromaParam, Cfg: cfg)
  echo "Chroma:\n", xmlToStr(serializeXML(chroma_xml, "chroma"))

  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml))
  writeFile(input_file, input)

]#

