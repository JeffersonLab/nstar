## Basic constructions for an ensemble

#import strutils, os, ospaths

proc getBase(): string = return "/global/homes/r/redwards/scratch"
#proc getBase(): string = return "./"
proc getStem*(): string = return "szscl21_24_256_b1p50_t_x4p300_um0p0856_sm0p0743_n1p265"
##proc getNumVecs*(): int = 162
proc getNumVecs*(): int = 3

proc getEnsemblePath*(): string = return getBase() & "/" & getStem()

proc getScratchPath*(): string = return getBase() & "/" & getStem() & "/tmp.allt"


