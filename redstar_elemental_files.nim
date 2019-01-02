## Generate elemental file names for redstar

import run/chroma/colorvec_work

#
type
  RedstarElementalFiles_t* = object
    prop_dbs*:                  seq[string]     ## The dbs that contains propagator bits
    glue_dbs*:                  seq[string]     ## The db that contains glueball colorvector contractions
    meson_dbs*:                 seq[string]     ## The db that contains meson colorvector contractions
    baryon_dbs*:                seq[string]     ## The db that contains baryon colorvector contractions
    tetra_dbs*:                 seq[string]     ## The db that contains tetraquark colorvector contractions
    unsmeared_meson_dbs*:       seq[string]     ## The db that contains unsmeared meson elementals


#----------------------------------------------------------------------------------------------
proc redstar_elemental_files*(stem: string,
                              t_sources: seq[int],
                              cache_dir: string,
                              seqno: string,
                              use_cp: bool): RedstarElementalFiles_t =
  ## Generate elemental file names for redstar
  let nn = ".n10"
  for quark_type in ["light", "strange"]:
    result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db_diagt0/" & stem & ".prop" & nn & "." & quark_type & ".diag_t0.sdb" & seqno, use_cp))

    for tt in t_sources:
      result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db/" & stem & ".prop" & nn & "." & quark_type & ".t0_" & $tt & ".sdb" & seqno, use_cp))

  result.meson_dbs = @[]
  
  # derivs
  let meson_path = cache_dir & "/" & stem & "/meson_db_deriv/" & stem & ".meson.deriv" & nn
  result.meson_dbs.add(copy_lustre_file(meson_path & ".d_0_1_2_3.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_3.sdb" & seqno, use_cp))
  result.meson_dbs.add(copy_lustre_file(meson_path & ".mom_4.sdb" & seqno, use_cp))

  let unsmeared_meson_path = cache_dir & "/" & stem & "/genprop/" & stem & ".genprop" & nn
  result.unsmeared_meson_dbs.add(copy_lustre_file(unsmeared_meson_path & ".light.t0_0_6.sdb" & seqno, use_cp))

  result.baryon_dbs = @[]


  

  
