## Generate prop jobs

import os, xmltree, strutils, tables

import colorvec_work, serializetools/serializexml

import irrep_util
import chroma
import genprop_opt as genprop
#import fermbc, fermstate
import inverter
import propagator


const basedir = strip(staticExec("pwd"))
echo "basedir= ", basedir

#------------------------------------------------------------------------------
const platform = "TEST"
#const platform = "OLCF"
#const platform = "NERSC"
#const platform = "TACC"

when platform == "OLCF":
  include config_OLCF
elif platform == "NERSC":
  include config_NERSC
elif platform == "TACC":
  include config_TACC
elif platform == "TEST":
  include config_TEST
else:
  quit("unknown platform")


#------------------------------------------------------------------------------
type
  PathFile_t* = object
    name*:               string
    fileDir*:            string

#type Mom_t = array[0..2,cint]    ## shorthand


#------------------------------------------------------------------------------
proc genPath*(file: PathFile_t): string =
  ## Convenience to generate a path
  result = file.fileDir & "/" & file.name

proc genPath*(files: seq[PathFile_t]): seq[string] =
  ## Convenience to generate a path
  result = newSeq[string](0)
  for f in items(files):
    result.add(genPath(f))


#------------------------------------------------------------------------------
# Mass params - need to fix this stuff up to have the datasets and their masses
let mass_s = 0.02
let mass_l = 0.01

type
  QuarkMass_t* = object
    mass*:         float
    mass_label*:   string

proc quarkMass*(stem: string, quark: string): QuarkMass_t =
  ## Pull out the mass and label
  case quark:
    of "strange":
      result.mass = mass_s
      
    of "light":
      result.mass = mass_l

    else:
      quit("Unknown quark = " & quark)

  result.mass_label  = "U" & formatFloat(result.mass, ffDecimal, 4)




#------------------------------------------------------------------------------
# Time ranges
#
type
  TimeRanges_t* = object
    Nt_forward*:  int
    t_snks*:      seq[int]
    t_start*:     int
  

proc getTimeRanges*(): TimeRanges_t =
  ## Generate time ranges
  when platform == "TEST":
    result.t_start    = 0
    result.Nt_forward = 6
  else:
    result.t_start    = 0
    result.Nt_forward = 32

  result.t_snks  = @[result.t_start + result.Nt_forward]


proc wrapLt*(t0, t_origin, Lt: int): int =
  ## Wrap time around the lattice
  return (t0 + t_origin + Lt) mod Lt

 


#------------------------------------------------------------------------------
# Paths to all the various files
type
  RunPaths_t* = object    ## Paths used for running
    stem*:               string
    cache*:              string
    scratch*:            string
    dataDir*:            string
    workDir*:            string
    seqName*:            string
    seqDir*:             string
    cfg_file*:           PathFile_t
    colorvec_files*:     seq[PathFile_t]
    quark*:              string
    mm*:                 QuarkMass_t
    time_ranges*:        TimeRanges_t
    seqno*:              string
    num_vecs*:           int
    prefix*:             string
    genprop_op_tmp*:     PathFile_t
    input_file*:         PathFile_t
    output_file*:        PathFile_t
    out_file*:           PathFile_t
    genprop_op_file*:    PathFile_t
    

#------------------------------------------------------------------------------
proc constructPathNames*(quark: string, seqno: string, time_ranges: TimeRanges_t): RunPaths_t =
  ## Construct the names for all the various paths
  result.stem        = getStem()
  result.cache       = getEnsemblePath()
  result.num_vecs    = getNumVecs()
  result.scratch     = getScratchPath()
  result.time_ranges = time_ranges
  result.seqno       = seqno

  # Pull out the mass and label
  result.quark      = quark
  result.mm         = quarkMass(result.stem, result.quark)

  # Main paths
  result.dataDir    = result.cache
  result.workDir    = result.scratch
  result.seqName    = result.seqno & "." & formatFloat(result.mm.mass, ffDecimal, 4) & ".allt"
  result.seqDir     = result.workdir & "/" & result.seqName

  # Files
  result.cfg_file       = PathFile_t(fileDir: result.dataDir & "/cfgs", name: result.stem & "_cfg_" & seqno & ".lime")
  # <elem>/global/homes/r/redwards/scratch/szscl21_48_512_b1p50_t_x4p300_um0p0865_sm0p0743_n1p265seo_per/eigs_mod/1820b/szscl21_48_512_b1p50_t_x4p300_um0p0865_sm0p0743_n1p265seo_per.3d.eigs.n_640.t_31.mod1820b</elem>
  result.colorvec_files = @[PathFile_t(fileDir: result.dataDir & "/eigs_mod/" & seqno, name: result.stem & ".3d.eigs.mod" & seqno)]

  result.prefix          = result.stem & ".prop.n" & $result.num_vecs & "." & result.quark & ".t_" & $time_ranges.t_start
  for t in items(time_ranges.t_snks):
    result.prefix &= "_" & $t

  result.genprop_op_tmp  = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".sdb" & seqno)
  result.input_file      = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".ini.xml" & seqno)
  result.output_file     = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out.xml" & seqno)
  result.out_file        = PathFile_t(fileDir: result.seqDir, name: result.prefix & ".out" & seqno)
  result.genprop_op_file = PathFile_t(fileDir: result.dataDir & "/genprop_db", name: result.genprop_op_tmp.name)


#------------------------------------------------------------------------------
proc generateChromaXML*(run_paths: RunPaths_t) =
  ## Generate input file and return the path to the expected output file
  # Main paths
  createDir(run_paths.workDir)
  createDir(run_paths.seqDir)

  # Help with testing
  when platform == "TEST":
    let MaxIter     = 100
    let Rsd         = 1.0e-5
  else:
    let MaxIter     = 10
    let Rsd         = 1.0e-8

  # Common stuff
  let lattSize = extractLattSize(run_paths.stem)
  let tr       = getTimeRanges()
  let Lt       = lattSize[3]
  echo "lattSize= ", lattSize, " ",tr, " ",Lt, " seqno=", run_paths.seqno
    
  let t_origin = getTimeOrigin(Lt, run_paths.seqno)
  let t0       = wrapLt(tr.t_start, t_origin, Lt)
  let mass     = run_paths.mm.mass

  var prop_sources = @[t0]
  var sink_sources = initTable[int,seq[int]]()

  for t in items(tr.t_snks):
    let te = int(wrapLt(t, t_origin, Lt))
    let fo = @[te]
    prop_sources.add(te)
    sink_sources.add(te, fo)
    echo "t= ", t, " te= ", te, " fo= ", fo, " Lt= ", Lt, "  t_origin= ", t_origin

  echo "prop_sources= ", prop_sources
  sink_sources.add(t0, prop_sources)

  let link_smearing = colorvec_work.newStandardStoutLinkSmear()

  let displacements: seq[seq[int]] = @[]
  let nodes_per_cn  = 1

  # Generate the pos/neg pairs of canonical mom
  let mom2_min = 0
#  let mom2_max = 4
  let mom2_max = 2
  let canon_moms = irrep_util.generateCanonMoms(cint(mom2_min), cint(mom2_max))
  var moms = newSeq[array[3,int]]()

  for p in items(canon_moms):
    echo "p= ", p
    moms.add([int(p[2]),int(p[1]),int(p[0])])
    if norm2(p) > 0:
      moms.add([-int(p[2]),-int(p[1]),int(p[0])])

  # Need paths for the fifos
  var fifo = newSeq[string]()
  for n in 1 .. nodes_per_cn:
    fifo.add("/tmp/harom-cmd" & $n)

  # That should be enough
  let contract = genprop.Contractions_t(mass_label: run_paths.mm.mass_label,
                                        num_vecs: run_paths.num_vecs,
                                        t_start: t0,
                                        Nt_forward: run_paths.time_ranges.Nt_forward,
                                        displacement_length: 1,
                                        fifo: fifo,
                                        decay_dir: 3,
                                        num_tries: 1,
                                        nodes_per_cn: nodes_per_cn)
 
  # Fermion action and inverters
  when platform == "OLCF":
    let mg  = newQUDAMGParams24x256()
    let inv = newQUDAMGInv(mass, Rsd, MaxIter, mg)
    let fermact = newAnisoPrecCloverFermAct(mass)
  elif platform == "NERSC":
    let inv = newQPhiXMGParams24x256(mass, Rsd, MaxIter)
    let fermact = newAnisoCloverFermAct(mass)
  elif platform == "TEST":
    let inv = serializeXML(CGInverter_t(invType: "CG_INVERTER", RsdCG: Rsd, MaxCG: MaxIter))
    let fermact = newAnisoCloverFermAct(mass)
  else:
    quit("not allowed")


  # Inline measurement
  let mat_prop      = propagator.newPropagator(fermact, inv)
  let mat_param     = genprop.GenPropParam_t(LinkSmearing: link_smearing,
                                             PropSources: prop_sources,
                                             SinkSources: sink_sources,
                                             Displacements: displacements,
                                             Moms: moms,
                                             Contractions: contract,
                                             Propagator: mat_prop)
  let mat_named_obj = genprop.NamedObject_t(gauge_id: "default_gauge_field",
                                            colorvec_files: genPath(run_paths.colorvec_files),
                                            dist_op_file: genPath(run_paths.genprop_op_tmp))
  let inline_dist   = genprop.newGenPropOptDistillation(mat_param, mat_named_obj)

  var chroma_param = chroma.Param_t(nrow: lattSize, InlineMeasurements: @[inline_dist])
  let cfg = chroma.Cfg_t(cfg_type: "SCIDAC", cfg_file: genPath(run_paths.cfg_file), reunit: true, parallel_io: true)

  let chroma_xml = chroma.Chroma_t(Param: chroma_param, Cfg: cfg)
  let input = xmlHeader & xmlToStr(serializeXML(chroma_xml, "chroma"))
  writeFile(genPath(run_paths.input_file), input)


#-----------------------------------------------------------------------------
# Types need for submitter
type
  PandaJob_t* = object
    nodes*:            int
    walltime*:         string
    queuename*:        string
    outputFile*:       string
    command*:          string

  PandaSubmitter_t* = object
    campaign*:         string
    jobs*:             seq[PandaJob_t]


#------------------------------------------------------------------------------
proc generateNERSCRunScript*(run_paths: RunPaths_t): PandaJob_t =
  ## Generate input file
  # Common stuff
  #let propCheck = "/global/homes/r/redwards/bin/x86_64/prop_check"
  let propCheck = "/global/homes/r/redwards/qcd/git/nim-play/nstar/prop_check"
  let queue    = "regular"
  #let queue    = "scavenger"
  let wallTime = "00:30:00"
  let node_cnt          = 36
  let corr_cnt_per_node = 16
 
  # This particular job
  let corr_cnt          = node_cnt * corr_cnt_per_node
  #result.nodes          = node_cnt * t0s.len
  result.nodes          = node_cnt
  result.wallTime       = wallTime
  result.queuename      = queue
  result.outputFile     = genPath(run_paths.genprop_op_file)
  let Ls                = extractLattSize(run_paths.stem)[0]


  # SBATCH --time-min 4:00:00

  result.command = """
#!/bin/bash
#SBATCH -N """ & $result.nodes & "\n" & """
#SBATCH -q """ & queue & "\n" & """
#SBATCH -t """ & result.wallTime & "\n" & """
#SBATCH -C knl,quad,cache
#SBATCH -A m2156

cd """ & run_paths.seqDir & "\n" & """

export OMP_NUM_THREADS=8
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

input="""" & genPath(run_paths.input_file) & """"
output="""" & genPath(run_paths.output_file) & """"
out="""" & genPath(run_paths.out_file) & """"
prop_tmp="""" & genPath(run_paths.genprop_op_tmp) & """"
prop_op="""" & genPath(run_paths.genprop_op_file) & """"
/bin/rm -f $prop_tmp

if [ -e $prop_op ]
then
  exit 0
fi

CHROMA_OMP=1
HAROM_OMP=1
CHROMA_PER_NODE=1
HAROM_PER_NODE=1
HAROM_LS="""" & $Ls & """"

REMOVE=/Users/edwards/Documents/qcd/data/redstar/genprop_files/remove_fifo.sh
LAUNCHER=/Users/edwards/Documents/qcd/git/devel/harom.shm/mainprogs/launcher/launcher

CHROMA=/usr/local/Cellar/chroma/parscalar-single.shmharom/bin/chroma
GENPROP=/Users/edwards/Documents/qcd/git/devel/harom.shm/lexico-scalar-Nd3/mainprogs/main/genprop

#source """ & basedir & """/env_qphix.sh

date
srun -n """ & $corr_cnt & """ -c """ & $corr_cnt_per_node & """ --cores-per-socket 256 --cpu_bind=cores $exe -i $input -o $output -geom 1 3 6 32 --qmp-alloc-map 3 2 1 0 --qmp-logic-map 3 2 1 0 -by 4 -bz 4 -c 4 -sy 1 -sz 2  > $out 2>&1
date

# Usage ./launcher [ENV MPI RANK] [ranks per node] [chroma_exe] [chroma OMP] [chroma stdout] [harom_exe] [harom OMP] [harom stdout] [harom #/node] [harom FIFO stem] [harom LS] [chroma args..] 

# Cori   srun -n 16 --ntasks-per-node=8 ${LAUNCHER} SLURM_PROCID 8 ${CHROMA} 8 out.chroma ${GENPROP} 8 out.harom 4 /tmp/harom-cmd 32 -i $INPUT -o $OUTPUT -geom 2 2 2 2 -by 4 -bz 4 -c 4 -sy 1 -sz 2


${LAUNCHER} SLURM_PROCID ${CHROMA_PER_NODE} ${CHROMA} ${CHROMA_OMP} out.chroma ${GENPROP} ${HAROM_OMP} out.harom ${HAROM_PER_NODE} /tmp/harom-cmd ${HAROM_LS} -i ${input} -o ${output} -geom 1 1 1 1 -by 4 -bz 4 -c 4 -sy 1 -sz 2

stat=$?
if [ $stat -eq 0 ]
then
  /bin/mv $prop_tmp $prop_op
fi
"""

  ##""" & propCheck & " 0.5 $genprop_tmp > " & genPath(run_paths.check_file) & """


  # Will hopefully remove writing any specific file
  let run_script = run_paths.seqDir & "/nersc.all.sh"
  writeFile(run_script, result.command)
  var perm = getFilePermissions(run_script) + {fpUserExec}
  setFilePermissions(run_script, perm)



#------------------------------------------------------------------------------
when isMainModule:
  echo "paramCount()= ", paramCount()

  # This vesion assumes the arguments are the pre-existing directories
  echo "paramCount = ", paramCount()
  if paramCount() < 2:
    quit("Usage: exe <quark> [seqno1 .. seqnoN")
    
  let quark = paramStr(1)
  echo "quark= ", quark

#  let stem   = getStem()
  let time_ranges = getTimeRanges()

  # Loop over the sdbs within a dir
  for n in 2..paramCount():
    # Has to be a sensible filename
    let seqno = paramStr(n)
    echo "seqno= ", seqno

    # All the jobs to accumulate
    var Data: PandaSubmitter_t
    Data.campaign = "nada"
    Data.jobs = @[]

    let run_paths = constructPathNames(quark, seqno, time_ranges)
    echo run_paths
    let outputFile = genPath(run_paths.genprop_op_file)

    # Empty files are bad
    if existsFile(outputFile):
      if getFileSize(outputFile) == 0:
        discard tryRemoveFile(outputFile)

    # If the outputFile does not exist, do the thang!
    if fileExists(outputFile): continue

    # build input for each directory
    let cwd = getCurrentDir()
    setCurrentDir(cwd)

    echo "Generate job for prop= ", outputFile
    generateChromaXML(run_paths)

    # Must construct
    discard generateNERSCRunScript(run_paths)

    # Either is not or empty, so submit
    let f = run_paths.seqDir & "/nersc.all.sh"

    echo "Submitting " & f
#[
    if execShellCmd("sbatch " & f) != 0:
      quit("Some error submitting " & f)
]#

    # popd
    setCurrentDir(cwd)
    
