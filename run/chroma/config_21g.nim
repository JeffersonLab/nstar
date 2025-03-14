## Basic constructions for an ensemble

#import strutils, os, ospaths

proc getBase(): string = return "/lustre/cache/Spectrum/Clover/NF2+1"
proc getVolatile(): string = return "/lustre/volatile/Spectrum/Clover/NF2+1"
#proc getStem*(): string = return "szscl21_24_128_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265"
#proc getNumVecs*(): int = 162
proc getStem*(): string = return "szscl21_20_256_b1p50_t_x4p300_um0p0840_sm0p0743_n1p265_per"
proc getNumVecs*(): int = 128

proc getEnsemblePath*(): string = return getBase() & "/" & getStem()

proc getScratchPath*(): string = return getVolatile() & "/" & getStem() & "/tmp.allt"


