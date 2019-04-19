## Sequence numbers/strings

import os, parseutils, strutils

proc nextSeqno*(seqno_file: string): string =
  ## Get next seqno from a list file
  assert(fileExists(seqno_file))
  var seqnos = readFile(seqno_file)
  let cnt = parseUntil(seqnos, result, "\n")
  #echo "newseqno= ", result, "  cnt= ", cnt
  delete(seqnos, 0, cnt)
  writeFile(seqno_file, seqnos)

proc emptyList*(seqno_file: string): bool =
  ## Is the seqno file empty?
  result = getFileSize(seqno_file) == 0


#----------------------------------------------------------------------------
when isMainModule:
  echo nextSeqno("test.list")
