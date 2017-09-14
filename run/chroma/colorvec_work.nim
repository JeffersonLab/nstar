#
# This is the work script called by run_colorvec_*pl
#
import os, ospaths, osproc, strutils
import re
import config

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
proc extractLattSize*(data: string): array[0..3,int] =
  ## Determine the lattice size
  # Yuk, do some file name surgery
  var stem = data.replace(re"\..*$")
  stem = stem.replace(re"per\..*$")
  stem = stem.replace(re"non\..*$")
  stem = stem.replace(re"dir\..*$")

  let F  = stem.split('_')
  let Ls = parseInt(F[1])
  let Lt = parseInt(F[2])
  result = @[Ls, Ls, Ls, Lt]



#------------------------------------------------------------------------
proc getTimeOrigin*(Lt: int, trajj: string): int =
  ## Displace the origin of the time slices using the trajectory as a seed to a RNG
  var traj = trajj.replace(re"[a-zA-Z]")

  # Seed the rng with the traj number
  let (outp, errC) = execCmdEx("t_origin.pl " & $Lt & " " & traj)

  result = parseInt(outp)



#------------------------------------------------------------------------
proc print_header_xml*(input: string)  =
  ## Header
  writeFile(input, """
<?xml version="1.0"?>

<chroma>
<Param> 
  <InlineMeasurements>
""")



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
proc print_harom_header_xml*(input: string) =
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
proc print_harom_trailer_xml*(input: string, lattSize: seq[int]) = 
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
