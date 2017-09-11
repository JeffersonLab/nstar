## Basic constructions for an ensemble

#import strutils, os, ospaths

proc getStem*(): string = return "szscl21_24_256_b1p50_t_x4p300_um0p0850_sm0p0743_n1p265"

proc getEnsemblePath*(): string = return "/Users/edwards/Documents/qcd/data/colorvec"

proc getNumVecs*(): int = 162

proc getScratchPath*(): string = return "/Users/edwards/Documents/qcd/data/colorvec/tmp.allt"


