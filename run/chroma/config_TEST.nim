## Basic constructions for an ensemble

#import strutils, os, ospaths

proc getBase(): string = return "/Users/edwards/Documents/qcd/data/redstar/test/genprop"
proc getStem*(): string = return "test_4_16_b1p50_m05"
proc getNumVecs*(): int = 4

proc getEnsemblePath*(): string = return getBase() & "/" & getStem()

proc getScratchPath*(): string = return getBase() & "/" & getStem() & "/tmp.allt"
#proc getScratchPath*(): string = return getBase()


