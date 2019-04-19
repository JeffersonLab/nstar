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
  #/cache/Spectrum/Clover/NF2+1/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/prop_db_diagt0/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per.prop.light.diag_t0.sdb1360 -> pending
  #/lustre/cache/Spectrum/Clover/NF2+1/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/prop_db/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per.prop.strange.t0_0-124_inc4.sdb1000
  #/lustre/cache/Spectrum/Clover/NF2+1/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/prop_db/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per.prop.t0_0-124_inc4.sdb1000
  #/lustre/cache/Spectrum/Clover/NF2+1/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per/genprop/szscl21_16_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per.genprop.n64.light.t0_0_32.sdb1000 keys
  result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db_diagt0/" & stem & ".prop.light.diag_t0.sdb" & seqno, use_cp))
  result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db_diagt0/" & stem & ".prop.strange.diag_t0.sdb" & seqno, use_cp))

  result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db/" & stem & ".prop.t0_0-124_inc4" & ".sdb" & seqno, use_cp))
  result.prop_dbs.add(copy_lustre_file(cache_dir & "/" & stem & "/prop_db/" & stem & ".prop.strange.t0_0-124_inc4" & ".sdb" & seqno, use_cp))

  result.meson_dbs = @[]
  
  # derivs
  let nn = ".n64"
  let meson_path = cache_dir & "/" & stem & "/meson_db_deriv/" & stem & ".meson.deriv"
  result.meson_dbs.add(copy_lustre_file(meson_path & nn & ".mom.sdb" & seqno, use_cp))

  let unsmeared_meson_path = cache_dir & "/" & stem & "/genprop/" & stem & ".genprop" & nn
  result.unsmeared_meson_dbs.add(copy_lustre_file(unsmeared_meson_path & ".light.t0_0_24.sdb" & seqno, true))
  result.unsmeared_meson_dbs.add(copy_lustre_file(unsmeared_meson_path & ".light.t0_0_32.sdb" & seqno, true))
# result.unsmeared_meson_dbs.add(copy_lustre_file(unsmeared_meson_path & ".strange.t0_0_24.sdb" & seqno, true))
# result.unsmeared_meson_dbs.add(copy_lustre_file(unsmeared_meson_path & ".strange.t0_0_32.sdb" & seqno, use_cp))

  result.baryon_dbs = @[]


  

  
