##
## rannyu
##
##     This is rannyu dating to 9/26/85.
##        It is linear congruential with modulus m = 2**48, increment c = 1,
##        and multiplier a = (2**36)*m1 + (2**24)*m2 + (2**12)*m3 + m4. 
##        The multiplier is stored in common (see subroutine setrn)
##      and is set to a = 31167285 (recommended by Knuth, vol. 2,
##      2nd ed., p. 102).
##
##
##
##     Multiplier is 31167285 = (2**24) + 3513*(2**12) + 821.
##        Recommended by Knuth, vol. 2, 2nd ed., p. 102.
##     (Generator is linear congruential with odd increment
##        and maximal period, so seed is unrestricted: it can be
##        either even or odd.)

# The multiplier
const
  m1 = 0
  m2 = 1
  m3 = 3513
  m4 = 821
  twom12 = 1.0/4096.0

# The seed
var
  l1 = 0
  l2 = 0
  l3 = 0
  l4 = 11


proc rannyu*(): float =
  ## Return a random number in the interval [0,1)
  var i1 = l1*m4 + l2*m3 + l3*m2 + l4*m1
  var i2 = l2*m4 + l3*m3 + l4*m2
  var i3 = l3*m4 + l4*m3
  var i4 = l4*m4 + 1
  l4 = i4 and 4095
  i3 = i3 + (i4 shr 12)
  l3 = i3 and 4095
  i2 = i2 + (i3 shr 12)
  l2 = i2 and 4095
  l1 = (i1 + (i2 shr 12)) and 4095
  result = twom12*(float(l1)+
                   twom12*(float(l2)+
                           twom12*(float(l3)+
                                   twom12*(float(l4)))))


proc setrn*(iseed: array[4,int]) = 
  ## Set the seed. Can be even or odd
  l1 = iseed[0]
  l2 = iseed[1]
  l3 = iseed[2]
  l4 = iseed[3]


proc savern*(): array[4,int] =
  ## Return the seed
  result = [l1, l2, l3, l4]


#------------------------------------------------------------------------
when isMainModule:
  var seed = [0,0,0,11]
  echo "initial seed= ", repr(seed)
  setrn(seed)
  for n in 1..10:
    echo "ran[", n, "]= ", rannyu()

  seed = savern()
  echo "final seed= ", repr(seed)
