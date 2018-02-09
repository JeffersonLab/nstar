## Generate a DOI and lime file listing from a list of dataset paths

import strutils, os, streams, times, algorithm, re
from htmlgen import nil  # the htmlgen docs suggests limiting scope
  
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
type
  IsoDataParams_t = tuple
    nrow:   array[4,int]  # lattice size
    beta:   string        # coupling
    ml:     string        # light quark mass
    ms:     string        # strange quark mass


proc extractIsoParams*(data: string): IsoDataParams_t =
  ## Extract parameters from an isotropic dataset
  # Yuk, do some file name surgery
  var stem = data.replace(re"\..*$")
  stem = stem.replace(re"per\..*$")
  stem = stem.replace(re"non\..*$")
  stem = stem.replace(re"dir\..*$")
  stem = stem.replace(re"-.*$")

  # example of iso filename   cl21_64_128_b6p3_m0p2424_m0p2050
  let F     = stem.split('_')
  let Ls    = parseInt(F[1])
  let Lt    = parseInt(F[2])
  let nrow  = [Ls, Ls, Ls, Lt]
  result.nrow = nrow

  # could instead use F[3], but want to try a different method
  var beta  = stem.replace(re"^.*_b")
  beta      = beta.replace(re"_.*$")
  beta      = beta.replace(re"p", ".")
  result.beta = beta

  var ml    = F[4]
  ml        = ml.replace(re"p", ".")
  ml        = ml.replace(re"m", "-")
  result.ml = ml

  var ms    = F[5]
  ms        = ms.replace(re"p", ".")
  ms        = ms.replace(re"m", "-")
  result.ms = ms


#------------------------------------------------------------------------
type
  AnisoDataParams_t = tuple
    nrow:   array[4,int]  # lattice size
    beta:   string        # coupling
    ml:     string        # light quark mass
    ms:     string        # strange quark mass
    xi_0:   string        # bare gauge anisotropy
    nu:     string        # bare fermion speed-of-light


proc extractAnisoParams*(data: string): AnisoDataParams_t =
  ## Extract parameters from an anisotropic dataset
  # Yuk, do some file name surgery
  var stem = data.replace(re"\..*$")
  stem = stem.replace(re"per\..*$")
  stem = stem.replace(re"non\..*$")
  stem = stem.replace(re"dir\..*$")
  stem = stem.replace(re"-.*$")

  # examples of aniso filename
  #   szscl21_32_256_b1p50_t_x4p300_um0p0860_sm0p0743_n1p265
  #   szscl3_20_256_b1p50_t_x4p300_um0p0840_n1p265_per
  let F     = stem.split('_')
  let Ls    = parseInt(F[1])
  let Lt    = parseInt(F[2])
  let nrow  = [Ls, Ls, Ls, Lt]
  result.nrow = nrow

  # could instead use F[3], but want to try a different method
  var beta  = stem.replace(re"^.*_b")
  beta      = beta.replace(re"_.*$")
  beta      = beta.replace(re"p", ".")
  result.beta = beta

  var xi_0  = stem.replace(re"^.*_x")
  xi_0      = xi_0.replace(re"_.*$")
  xi_0      = xi_0.replace(re"p", ".")
  result.xi_0 = xi_0

  var nu    = stem.replace(re"^.*_n")
  nu        = nu.replace(re"_.*$")
  nu        = nu.replace(re"p", ".")
  result.nu = nu

  var ml    = stem.replace(re"^.*_u")
  ml        = ml.replace(re"_.*$")
  ml        = ml.replace(re"p", ".")
  ml        = ml.replace(re"m", "-")
  result.ml = ml

  var ms    = stem.replace(re"^.*_s")
  ms        = ms.replace(re"_.*$")
  ms        = ms.replace(re"p", ".")
  ms        = ms.replace(re"m", "-")
  result.ms = ms


#------------------------------------------------------------------------
# Types and data support DOI-s
type
  Creator_t = tuple   ## Creator 
    first:          string
    middle:         string
    last:           string
    email:          string         ## email
    affil:          string         ## affiliation
    orcid:          string         ## Orchid ID


  DOI_t = tuple   ## Document Object Indicator type
    number:         string         ## The DOI itself
    dataset:        string         ## The dataset identifier
    title:          string         ## The dataset name
    description:    string         ## Some description
    ctime:          string         ## Creation time

    publisher:      string         ## Publisher
    ptime:          string         ## Publication time
    file_listing:   string         ## relative path to file listing
    language:       string         ## en

    dataset_type:   string         ## Something that classifies the dataset
    subjects:       string         ## Basic info
    keywords:       seq[string]    ## Keywords
    product_nos:    string         ## Not sure what this is
    software:       string         ## How do you read it

    project_id:     string         ## Use this as the allocation ID
    other_id_nos:   string         ## Some other ids
    origin_orgs:    string         ## This is the facility where the data is created (who gave the allocation)
    sponsor_orgs:   string         ## DOE/NP/ASCR
    contrib_orgs:   string         ## We use this as JLab, etc
    contract_nos:   string         ## First will be facility contract num
    ocontract_nos:  string         ## JLab/whatever contract
    relid_nos:      string         ## Can link to other DOIs

    authors:        seq[Creator_t] ## Will stick with some generic authors


const
  JLab     = "Jefferson Lab"
  Edwards:  Creator_t  = ("Robert", "G", "Edwards", "edwards@jlab.org", JLab, "0000-0002-5667-291X")
  Winter:   Creator_t  = ("Frank", "T.", "Winter", "fwinter@jlab.org", JLab, "0000-0002-3573-6726")
  Joo:      Creator_t  = ("Balint", "", "Joo", "bjoo@jlab.org", JLab, "0000-0002-4229-7960")
  Richards: Creator_t  = ("David", "G.", "Richards", "dgr@jlab.org", JLab, "0000-0001-6971-873X")
  Orginos:  Creator_t  = ("Konstantinos", "N.", "Orginos", "kostas@wm.edu", "Dept. of Physics, College of William and Mary", "0000-0002-3535-7865")


#------------------------------------------------------------------------
proc constructBaseDOI(fff: string): DOI_t =
  ## Construct a template of a clover DOI
  let abspath = expandFilename(fff)  # the absolute path
  let dataset = splitFile(abspath)  # this returns  (path_to_dir, file, extension)
  echo "abspath.name= ", dataset.name

  # Build id
  result.number        = "XYZT"
  result.dataset       = dataset.name
  result.title         = " Lattice QCD gauge ensemble: " & dataset.name
  result.ctime         = getDateStr() & ", " & getClockStr()

  result.publisher     = "US Lattice Quantum Chromodynamics Collaboration (USQCD)"
  result.ptime         = "Later than dark thirty"
  result.language      = "en"

  result.description   = ""
  result.file_listing  = "./" & dataset.name & ".listing.html"

  result.dataset_type  = "Numeric Data"
  result.subjects      = "72 Physics Of Elementary Particles and Fields"
  
  result.keywords      = @["Lattice", "Quantum Chromodynamics", "QCD", "gauge field"]
  result.product_nos   = ""
  result.software      = "QMP, QIO, Lime"

  result.project_id    = "LGT003"
  result.other_id_nos  = ""
  result.origin_orgs   = "Thomas Jefferson National Accelerator Facility (TJNAF), Newport News, VA (United States); Oak Ridge National Laboratory (ORNL), Oak Ridge, TN (United States)"
  result.sponsor_orgs  = "Office of Nuclear Physics (ONP); Advanced Scientific Computing Research (ASCR)"
  result.contrib_orgs  = ""
  result.contract_nos  = "AC05-06OR23177 (TJNAF); AC05-00OR22725 (ORNL)"
  result.ocontract_nos = ""
  result.relid_nos     = ""

  result.authors       = @[]


#------------------------------------------------------------------------
proc constructIsoDOI*(fff: string): DOI_t =
  ## Construct an isotropic dataset DOI type
  result = constructBaseDOI(fff)
  let params  = extractIsoParams(result.dataset)  # get parameters
  echo "params= ", params

  result.description   = "Isotropic Clover QCD SU(3) gauge ensemble with 2 light and 1 dynamical strange quark: lattice size = " & $params.nrow & ",  beta= " & params.beta & ",  m_l= " & params.ml & ",  m_s= " & params.ms
  result.authors       = @[Joo, Edwards, Orginos, Richards, Winter]


#------------------------------------------------------------------------
proc constructAnisoDOI*(fff: string): DOI_t =
  ## Construct an anisotropic dataset DOI type
  result = constructBaseDOI(fff)
  let params  = extractAnisoParams(result.title)  # get parameters
  echo "params= ", params

  result.description   = "Anisotropic Clover QCD SU(3) gauge ensemble with 2 light and 1 dynamical strange quark: lattice size = " & $params.nrow & ",  beta= " & params.beta & ",  m_l= " & params.ml & ",  m_s= " & params.ms & ", xi_0= " & params.xi_0 & ", nu= " & params.nu
  result.authors       = @[Joo, Edwards]


#------------------------------------------------------------------------
proc buildDOI*(fff: string, doi: DOI_t) =
  ## Build and write the DOI html file for this dataset, and include a file listing
  # This better be a directory
  let abspath = expandFilename(fff)  # the absolute path
  echo "\ndir= ", abspath
  if not existsDir(abspath): quit("Not a directory: " & fff)

  let dataset = splitFile(abspath)  # this returns  (path_to_dir, file, extension)
  echo "abspath.name= ", dataset.name

  # Seq holding all the filenames
  var listing = newSeq[string]()
  var ptime: DateTime = local(getTime())
    
  # Loop over each file in dir "abspath".
  for akind, apath in walkDir(abspath):
    # Only look at subdirs named "cfgs"
    echo "kind= ", akind, "   path= ", apath
    if akind != pcDir: continue

    # Path components
    let cfgsdir = splitFile(apath)
    echo "dir= ", cfgsdir.dir, "   name= ", cfgsdir.name, "   ext= ", cfgsdir.ext
    if cfgsdir.name != "cfgs": continue

    # Found cfgs. Build a list of lime files
    ptime = local(getCreationTime(apath))
    
    for ckind, cpath in walkDir(apath):
      #echo "lime= ", cpath
      # Look for "lime" filename extensions
      let limes = splitFile(cpath)
      echo "ldir= ", limes.dir, "   lname= ", limes.name, "   lext= ", limes.ext
      if limes.ext != ".lime": continue
      listing.add(cpath)
        

  # Start the web-page for this directory
  var html = newFileStream(dataset.name & ".html", fmWrite)

  # Info
  html.writeLine(htmlgen.h2("General Information"))
  html.writeLine(htmlgen.table(htmlgen.tr(htmlgen.td("Number:"), htmlgen.td(doi.number), "\n"),
                               htmlgen.tr(htmlgen.td("Title:"), htmlgen.td(doi.title), "\n"),
                               htmlgen.tr(htmlgen.td("Description:"), htmlgen.td(doi.description), "\n"),
                               htmlgen.tr(htmlgen.td("Publisher:"), htmlgen.td(doi.publisher), "\n"),
                               htmlgen.tr(htmlgen.td("Published:"), htmlgen.td($ptime.year), "\n"),
                               htmlgen.tr(htmlgen.td("Created:"), htmlgen.td(doi.ctime), "\n")))

  # Authors
  html.writeLine(htmlgen.h2("Authors"))
  var author_list = newSeq[string]()
  for name in items(doi.authors):
    author_list.add(htmlgen.li(name.first & " " & name.last & "; " & name.email & "; " & name.affil) & "\n")
  html.writeLine(htmlgen.ul(author_list))

  # Dataset details
  html.writeLine(htmlgen.h2("Dataset Details"))
  html.writeLine(htmlgen.table(htmlgen.tr(htmlgen.td("Dataset Type:"), htmlgen.td(doi.dataset_type), "\n"),
                               htmlgen.tr(htmlgen.td("Subjects:"), htmlgen.td(doi.subjects), "\n"),
                               htmlgen.tr(htmlgen.td("Keywords:"), htmlgen.td(doi.keywords.join(", ")), "\n"),
                               htmlgen.tr(htmlgen.td("Product Nos.:"), htmlgen.td(doi.product_nos), "\n"),
                               htmlgen.tr(htmlgen.td("Software Needed:"), htmlgen.td(doi.software), "\n")))
    
  # Dataset files
  # Try to tidy up the file listing
  sort(listing, system.cmp)
  var new_listing = newSeq[string]()
  for f in items(listing):
    new_listing.add(htmlgen.li(f) & "\n")
    
  var listfile = newFileStream(doi.file_listing, fmWrite)
  listfile.writeLine(htmlgen.div("File listing on Jefferson Lab tape silo"))
  listfile.writeLine(htmlgen.ul(new_listing))
  listfile.close()

  html.writeLine(htmlgen.h2("Dataset Files"))
  html.writeLine(htmlgen.div(htmlgen.a(href=doi.file_listing, "File listing")), "\n")
    
  # References
  html.writeLine(htmlgen.h2("References"))
  html.writeLine(htmlgen.table(htmlgen.tr(htmlgen.td("Project identifier:"), htmlgen.td(doi.project_id), "\n"),
                               htmlgen.tr(htmlgen.td("Other identifying Nos.:"), htmlgen.td(doi.other_id_nos), "\n"),
                               htmlgen.tr(htmlgen.td("Originating Organizations:"), htmlgen.td(doi.origin_orgs), "\n"),
                               htmlgen.tr(htmlgen.td("Sponsoring Organizations:"), htmlgen.td(doi.sponsor_orgs), "\n"),
                               htmlgen.tr(htmlgen.td("Contributing Organizations:"), htmlgen.td(doi.contrib_orgs), "\n"),
                               htmlgen.tr(htmlgen.td("DOE Contract Nos.:"), htmlgen.td(doi.contract_nos), "\n"),
                               htmlgen.tr(htmlgen.td("Other Contract Nos.:"), htmlgen.td(doi.ocontract_nos), "\n"),
                               htmlgen.tr(htmlgen.td("Related Identifier:"), htmlgen.td(doi.relid_nos), "\n")))
    

#------------------------------------------------------------------------
when isMainModule:
  if paramCount() == 0:
    quit("Usage: exe <dir1> [<dir2> ... <dirN>]")
    
  # Loop over the directories
  for fff in commandLineParams():
    let abspath = expandFilename(fff)  # the absolute path
    echo "\ndir= ", abspath
    if not existsDir(abspath): continue

    # Build and write the DOI files
    buildDOI(fff, constructIsoDOI(abspath))
    

        




