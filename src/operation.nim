import types
import stack, instructions

proc maxStack*(pop: cint; push: cint): cint =
  return 1024 + pop - push

proc minStack*(pops: cint; push: cint): cint =
  return pops

proc minDupStack*(n: cint): cint =
  return minStack(n, n + 1)

proc maxDupStack*(n: cint): cint =
  return maxStack(n, n + 1)

proc calcMemSize64WithUint*(off: ptr uint256_t; length64: uint64): MemRes =
  var mr: MemRes
  if length64 == 0:
    mr.val = 0
    mr.err = false
    return mr
  var offset64: uint64 = LOWER(LOWER_P(off))
  var overflow: bool = false
  if UPPER(UPPER_P(off)) != 0 or UPPER(LOWER_P(off)) != 0 or LOWER(UPPER_P(off)) != 0:
    overflow = true
  if overflow:
    mr.val = 0
    mr.err = true
    return mr
  mr.val = offset64 + length64
  mr.err = mr.val < offset64
  return mr

proc calcMemSize64*(off: ptr uint256_t; l: ptr uint256_t): MemRes =
  var mr: MemRes
  if UPPER(UPPER_P(l)) != 0 or UPPER(LOWER_P(l)) != 0 or LOWER(UPPER_P(l)) != 0:
    mr.val = 0
    mr.err = true
    return mr
  return calcMemSize64WithUint(off, LOWER(LOWER_P(l)))

proc memoryMLoad*(s: ptr Stack): MemRes =
  var l: uint256_t = uint256_t(elements: [uint128_t(elements:[0.uint64, 0]),uint128_t(elements:[0.uint64, 32])])
  return calcMemSize64(Stack_Back(s, 0), addr(l))

proc memoryMStore*(s: ptr Stack): MemRes =
  return calcMemSize64WithUint(Stack_Back(s, 0), 32)

proc memoryMStore8*(s: ptr Stack): MemRes =
  return calcMemSize64WithUint(Stack_Back(s, 0), 1)

proc memoryReturn*(s: ptr Stack): MemRes =
  return calcMemSize64(Stack_Back(s, 0), Stack_Back(s, 1))

proc memoryRevert*(s: ptr Stack): MemRes =
  return calcMemSize64(Stack_Back(s, 0), Stack_Back(s, 1))

proc initJumpTable*(): JumpTable = 
  for i in 0..255: result[i] = Operation()
  result[0].execute      = opStop
  result[0].minS         = minStack(0, 0)
  result[0].maxS         = maxStack(0, 0)
  result[0].halts        = true
  result[0].jumps        = false
  result[0].writes       = false
  result[0].reverts      = false
  result[0].returns      = false
  result[1].execute      = opAdd
  result[1].minS         = minStack(2, 1)
  result[1].maxS         = maxStack(2, 1)
  result[1].halts        = false
  result[1].jumps        = false
  result[1].writes       = false
  result[1].reverts      = false
  result[1].returns      = false
  result[2].execute      = opMul
  result[2].minS         = minStack(2, 1)
  result[2].maxS         = maxStack(2, 1)
  result[2].halts        = false
  result[2].jumps        = false
  result[2].writes       = false
  result[2].reverts      = false
  result[2].returns      = false
  result[3].execute      = opSub
  result[3].minS         = minStack(2, 1)
  result[3].maxS         = maxStack(2, 1)
  result[3].halts        = false
  result[3].jumps        = false
  result[3].writes       = false
  result[3].reverts      = false
  result[3].returns      = false
  result[4].execute      = opDiv
  result[4].minS         = minStack(2, 1)
  result[4].maxS         = maxStack(2, 1)
  result[4].halts        = false
  result[4].jumps        = false
  result[4].writes       = false
  result[4].reverts      = false
  result[4].returns      = false
  result[5].execute      = opSdiv
  result[5].minS         = minStack(2, 1)
  result[5].maxS         = maxStack(2, 1)
  result[5].halts        = false
  result[5].jumps        = false
  result[5].writes       = false
  result[5].reverts      = false
  result[5].returns      = false
  result[6].execute      = opMod
  result[6].minS         = minStack(2, 1)
  result[6].maxS         = maxStack(2, 1)
  result[6].halts        = false
  result[6].jumps        = false
  result[6].writes       = false
  result[6].reverts      = false
  result[6].returns      = false
  result[7].execute      = opSmod
  result[7].minS         = minStack(2, 1)
  result[7].maxS         = maxStack(2, 1)
  result[7].halts        = false
  result[7].jumps        = false
  result[7].writes       = false
  result[7].reverts      = false
  result[7].returns      = false
  result[8].execute      = opAddmod
  result[8].minS         = minStack(3, 1)
  result[8].maxS         = maxStack(3, 1)
  result[8].halts        = false
  result[8].jumps        = false
  result[8].writes       = false
  result[8].reverts      = false
  result[8].returns      = false
  result[9].execute      = opMulmod
  result[9].minS         = minStack(3, 1)
  result[9].maxS         = maxStack(3, 1)
  result[9].halts        = false
  result[9].jumps        = false
  result[9].writes       = false
  result[9].reverts      = false
  result[9].returns      = false
  result[16].execute     = opLt
  result[16].minS        = minStack(2, 1)
  result[16].maxS        = maxStack(2, 1)
  result[16].halts       = false
  result[16].jumps       = false
  result[16].writes      = false
  result[16].reverts     = false
  result[16].returns     = false
  result[17].execute     = opGt
  result[17].minS        = minStack(2, 1)
  result[17].maxS        = maxStack(2, 1)
  result[17].halts       = false
  result[17].jumps       = false
  result[17].writes      = false
  result[17].reverts     = false
  result[17].returns     = false
  result[18].execute     = opSlt
  result[18].minS        = minStack(2, 1)
  result[18].maxS        = maxStack(2, 1)
  result[18].halts       = false
  result[18].jumps       = false
  result[18].writes      = false
  result[18].reverts     = false
  result[18].returns     = false
  result[19].execute     = opSgt
  result[19].minS        = minStack(2, 1)
  result[19].maxS        = maxStack(2, 1)
  result[19].halts       = false
  result[19].jumps       = false
  result[19].writes      = false
  result[19].reverts     = false
  result[19].returns     = false
  result[20].execute     = opEq
  result[20].minS        = minStack(2, 1)
  result[20].maxS        = maxStack(2, 1)
  result[20].halts       = false
  result[20].jumps       = false
  result[20].writes      = false
  result[20].reverts     = false
  result[20].returns     = false
  result[21].execute     = opIszero
  result[21].minS        = minStack(1, 1)
  result[21].maxS        = maxStack(1, 1)
  result[21].halts       = false
  result[21].jumps       = false
  result[21].writes      = false
  result[21].reverts     = false
  result[21].returns     = false
  result[22].execute     = opAnd
  result[22].minS        = minStack(2, 1)
  result[22].maxS        = maxStack(2, 1)
  result[22].halts       = false
  result[22].jumps       = false
  result[22].writes      = false
  result[22].reverts     = false
  result[22].returns     = false
  result[23].execute     = opXor
  result[23].minS        = minStack(2, 1)
  result[23].maxS        = maxStack(2, 1)
  result[23].halts       = false
  result[23].jumps       = false
  result[23].writes      = false
  result[23].reverts     = false
  result[23].returns     = false
  result[24].execute     = opOr
  result[24].minS        = minStack(2, 1)
  result[24].maxS        = maxStack(2, 1)
  result[24].halts       = false
  result[24].jumps       = false
  result[24].writes      = false
  result[24].reverts     = false
  result[24].returns     = false
  result[25].execute     = opNot
  result[25].minS        = minStack(1, 1)
  result[25].maxS        = maxStack(1, 1)
  result[25].halts       = false
  result[25].jumps       = false
  result[25].writes      = false
  result[25].reverts     = false
  result[25].returns     = false
  result[48].execute     = opAddress
  result[48].minS        = minStack(0, 1)
  result[48].maxS        = maxStack(0, 1)
  result[48].halts       = false
  result[48].jumps       = false
  result[48].writes      = false
  result[48].reverts     = false
  result[48].returns     = false
  result[53].execute     = opCallDataLoad
  result[53].minS        = minStack(1, 1)
  result[53].maxS        = maxStack(1, 1)
  result[53].halts       = false
  result[53].jumps       = false
  result[53].writes      = false
  result[53].reverts     = false
  result[53].returns     = false
  result[54].execute     = opCallDataSize
  result[54].minS        = minStack(0, 1)
  result[54].maxS        = maxStack(0, 1)
  result[54].halts       = false
  result[54].jumps       = false
  result[54].writes      = false
  result[54].reverts     = false
  result[54].returns     = false
  result[80].execute     = opPop
  result[80].minS        = minStack(1, 0)
  result[80].maxS        = maxStack(1, 0)
  result[80].halts       = false
  result[80].jumps       = false
  result[80].writes      = false
  result[80].reverts     = false
  result[80].returns     = false
  result[81].execute     = opMload
  result[81].minS        = minStack(1, 1)
  result[81].maxS        = maxStack(1, 1)
  result[81].memorySize  = memoryMLoad
  result[81].halts       = false
  result[81].jumps       = false
  result[81].writes      = false
  result[81].reverts     = false
  result[81].returns     = false
  result[82].execute     = opMstore
  result[82].minS        = minStack(2, 0)
  result[82].maxS        = maxStack(2, 0)
  result[82].memorySize  = memoryMStore
  result[82].halts       = false
  result[82].jumps       = false
  result[82].writes      = false
  result[82].reverts     = false
  result[82].returns     = false
  result[83].execute     = opMstore8
  result[83].minS        = minStack(2, 0)
  result[83].maxS        = maxStack(2, 0)
  result[83].memorySize  = memoryMStore8
  result[83].halts       = false
  result[83].jumps       = false
  result[83].writes      = false
  result[83].reverts     = false
  result[83].returns     = false
  result[84].execute     = opSload
  result[84].minS        = minStack(1, 1)
  result[84].maxS        = maxStack(1, 1)
  result[84].halts       = false
  result[84].jumps       = false
  result[84].writes      = false
  result[84].reverts     = false
  result[84].returns     = false
  result[85].execute     = opSstore
  result[85].minS        = minStack(2, 0)
  result[85].maxS        = maxStack(2, 0)
  result[85].writes      = true
  result[85].halts       = false
  result[85].jumps       = false
  result[85].reverts     = false
  result[85].returns     = false
  result[86].execute     = opJump
  result[86].minS        = minStack(1, 0)
  result[86].maxS        = maxStack(1, 0)
  result[86].jumps       = true
  result[86].halts       = false
  result[86].writes      = false
  result[86].reverts     = false
  result[86].returns     = false
  result[87].execute     = opJumpi
  result[87].minS        = minStack(2, 0)
  result[87].maxS        = maxStack(2, 0)
  result[87].jumps       = true
  result[87].halts       = false
  result[87].writes      = false
  result[87].reverts     = false
  result[87].returns     = false
  result[88].execute     = opPc
  result[88].minS        = minStack(0, 1)
  result[88].maxS        = maxStack(0, 1)
  result[88].halts       = false
  result[88].jumps       = false
  result[88].writes      = false
  result[88].reverts     = false
  result[88].returns     = false
  result[89].execute     = opMsize
  result[89].minS        = minStack(0, 1)
  result[89].maxS        = maxStack(0, 1)
  result[89].halts       = false
  result[89].jumps       = false
  result[89].writes      = false
  result[89].reverts     = false
  result[89].returns     = false
  result[90].execute     = opGas
  result[90].minS        = minStack(0, 1)
  result[90].maxS        = maxStack(0, 1)
  result[90].halts       = false
  result[90].jumps       = false
  result[90].writes      = false
  result[90].reverts     = false
  result[90].returns     = false
  result[91].execute     = opJumpdest
  result[91].minS        = minStack(0, 0)
  result[91].maxS        = maxStack(0, 0)
  result[91].halts       = false
  result[91].jumps       = false
  result[91].writes      = false
  result[91].reverts     = false
  result[91].returns     = false
  result[96].execute     = opPush1
  result[96].minS        = minStack(0, 1)
  result[96].maxS        = maxStack(0, 1)
  result[96].halts       = false
  result[96].jumps       = false
  result[96].writes      = false
  result[96].reverts     = false
  result[96].returns     = false
  result[97].execute     = opPush2
  result[97].minS        = minStack(0, 1)
  result[97].maxS        = maxStack(0, 1)
  result[97].halts       = false
  result[97].jumps       = false
  result[97].writes      = false
  result[97].reverts     = false
  result[97].returns     = false
  result[98].execute     = opPush3
  result[98].minS        = minStack(0, 1)
  result[98].maxS        = maxStack(0, 1)
  result[98].halts       = false
  result[98].jumps       = false
  result[98].writes      = false
  result[98].reverts     = false
  result[98].returns     = false
  result[99].execute     = opPush4
  result[99].minS        = minStack(0, 1)
  result[99].maxS        = maxStack(0, 1)
  result[99].halts       = false
  result[99].jumps       = false
  result[99].writes      = false
  result[99].reverts     = false
  result[99].returns     = false
  result[128].execute    = opDup1
  result[128].minS       = minDupStack(1)
  result[128].maxS       = maxDupStack(1)
  result[128].halts      = false
  result[128].jumps      = false
  result[128].writes     = false
  result[128].reverts    = false
  result[128].returns    = false
  result[243].execute    = opReturn
  result[243].minS       = minStack(2, 0)
  result[243].maxS       = maxStack(2, 0)
  result[243].memorySize = memoryReturn
  result[243].halts      = true
  result[243].jumps      = false
  result[243].writes     = false
  result[243].reverts    = false
  result[243].returns    = false
  result[253].execute    = opRevert
  result[243].minS       = minStack(2, 0)
  result[243].maxS       = maxStack(2, 0)
  result[243].memorySize = memoryRevert
  result[243].halts      = true
  result[243].jumps      = false
  result[243].writes     = false
  result[243].reverts    = true
  result[243].returns    = true
  
proc Operation_JumpTable*(): array[256,Operation]=
  var JumpTable: array[256, Operation] 
  for i in 0..255:
    JumpTable[i] = Operation()

  JumpTable[0].execute = opStop
  JumpTable[0].minS = minStack(0, 0)
  JumpTable[0].maxS = maxStack(0, 0)
  JumpTable[0].halts = true
  JumpTable[0].jumps = false
  JumpTable[0].writes = false
  JumpTable[0].reverts = false
  JumpTable[0].returns = false
  JumpTable[1].execute = opAdd
  JumpTable[1].minS = minStack(2, 1)
  JumpTable[1].maxS = maxStack(2, 1)
  JumpTable[1].halts = false
  JumpTable[1].jumps = false
  JumpTable[1].writes = false
  JumpTable[1].reverts = false
  JumpTable[1].returns = false
  JumpTable[2].execute = opMul
  JumpTable[2].minS = minStack(2, 1)
  JumpTable[2].maxS = maxStack(2, 1)
  JumpTable[2].halts = false
  JumpTable[2].jumps = false
  JumpTable[2].writes = false
  JumpTable[2].reverts = false
  JumpTable[2].returns = false
  JumpTable[3].execute = opSub
  JumpTable[3].minS = minStack(2, 1)
  JumpTable[3].maxS = maxStack(2, 1)
  JumpTable[3].halts = false
  JumpTable[3].jumps = false
  JumpTable[3].writes = false
  JumpTable[3].reverts = false
  JumpTable[3].returns = false
  JumpTable[4].execute = opDiv
  JumpTable[4].minS = minStack(2, 1)
  JumpTable[4].maxS = maxStack(2, 1)
  JumpTable[4].halts = false
  JumpTable[4].jumps = false
  JumpTable[4].writes = false
  JumpTable[4].reverts = false
  JumpTable[4].returns = false
  JumpTable[5].execute = opSdiv
  JumpTable[5].minS = minStack(2, 1)
  JumpTable[5].maxS = maxStack(2, 1)
  JumpTable[5].halts = false
  JumpTable[5].jumps = false
  JumpTable[5].writes = false
  JumpTable[5].reverts = false
  JumpTable[5].returns = false
  JumpTable[6].execute = opMod
  JumpTable[6].minS = minStack(2, 1)
  JumpTable[6].maxS = maxStack(2, 1)
  JumpTable[6].halts = false
  JumpTable[6].jumps = false
  JumpTable[6].writes = false
  JumpTable[6].reverts = false
  JumpTable[6].returns = false
  JumpTable[7].execute = opSmod
  JumpTable[7].minS = minStack(2, 1)
  JumpTable[7].maxS = maxStack(2, 1)
  JumpTable[7].halts = false
  JumpTable[7].jumps = false
  JumpTable[7].writes = false
  JumpTable[7].reverts = false
  JumpTable[7].returns = false
  JumpTable[8].execute = opAddmod
  JumpTable[8].minS = minStack(3, 1)
  JumpTable[8].maxS = maxStack(3, 1)
  JumpTable[8].halts = false
  JumpTable[8].jumps = false
  JumpTable[8].writes = false
  JumpTable[8].reverts = false
  JumpTable[8].returns = false
  JumpTable[9].execute = opMulmod
  JumpTable[9].minS = minStack(3, 1)
  JumpTable[9].maxS = maxStack(3, 1)
  JumpTable[9].halts = false
  JumpTable[9].jumps = false
  JumpTable[9].writes = false
  JumpTable[9].reverts = false
  JumpTable[9].returns = false
  JumpTable[16].execute = opLt
  JumpTable[16].minS = minStack(2, 1)
  JumpTable[16].maxS = maxStack(2, 1)
  JumpTable[16].halts = false
  JumpTable[16].jumps = false
  JumpTable[16].writes = false
  JumpTable[16].reverts = false
  JumpTable[16].returns = false
  JumpTable[17].execute = opGt
  JumpTable[17].minS = minStack(2, 1)
  JumpTable[17].maxS = maxStack(2, 1)
  JumpTable[17].halts = false
  JumpTable[17].jumps = false
  JumpTable[17].writes = false
  JumpTable[17].reverts = false
  JumpTable[17].returns = false
  JumpTable[18].execute = opSlt
  JumpTable[18].minS = minStack(2, 1)
  JumpTable[18].maxS = maxStack(2, 1)
  JumpTable[18].halts = false
  JumpTable[18].jumps = false
  JumpTable[18].writes = false
  JumpTable[18].reverts = false
  JumpTable[18].returns = false
  JumpTable[19].execute = opSgt
  JumpTable[19].minS = minStack(2, 1)
  JumpTable[19].maxS = maxStack(2, 1)
  JumpTable[19].halts = false
  JumpTable[19].jumps = false
  JumpTable[19].writes = false
  JumpTable[19].reverts = false
  JumpTable[19].returns = false
  JumpTable[20].execute = opEq
  JumpTable[20].minS = minStack(2, 1)
  JumpTable[20].maxS = maxStack(2, 1)
  JumpTable[20].halts = false
  JumpTable[20].jumps = false
  JumpTable[20].writes = false
  JumpTable[20].reverts = false
  JumpTable[20].returns = false
  JumpTable[21].execute = opIszero
  JumpTable[21].minS = minStack(1, 1)
  JumpTable[21].maxS = maxStack(1, 1)
  JumpTable[21].halts = false
  JumpTable[21].jumps = false
  JumpTable[21].writes = false
  JumpTable[21].reverts = false
  JumpTable[21].returns = false
  JumpTable[22].execute = opAnd
  JumpTable[22].minS = minStack(2, 1)
  JumpTable[22].maxS = maxStack(2, 1)
  JumpTable[22].halts = false
  JumpTable[22].jumps = false
  JumpTable[22].writes = false
  JumpTable[22].reverts = false
  JumpTable[22].returns = false
  JumpTable[23].execute = opXor
  JumpTable[23].minS = minStack(2, 1)
  JumpTable[23].maxS = maxStack(2, 1)
  JumpTable[23].halts = false
  JumpTable[23].jumps = false
  JumpTable[23].writes = false
  JumpTable[23].reverts = false
  JumpTable[23].returns = false
  JumpTable[24].execute = opOr
  JumpTable[24].minS = minStack(2, 1)
  JumpTable[24].maxS = maxStack(2, 1)
  JumpTable[24].halts = false
  JumpTable[24].jumps = false
  JumpTable[24].writes = false
  JumpTable[24].reverts = false
  JumpTable[24].returns = false
  JumpTable[25].execute = opNot
  JumpTable[25].minS = minStack(1, 1)
  JumpTable[25].maxS = maxStack(1, 1)
  JumpTable[25].halts = false
  JumpTable[25].jumps = false
  JumpTable[25].writes = false
  JumpTable[25].reverts = false
  JumpTable[25].returns = false
  JumpTable[48].execute = opAddress
  JumpTable[48].minS = minStack(0, 1)
  JumpTable[48].maxS = maxStack(0, 1)
  JumpTable[48].halts = false
  JumpTable[48].jumps = false
  JumpTable[48].writes = false
  JumpTable[48].reverts = false
  JumpTable[48].returns = false
  JumpTable[53].execute = opCallDataLoad
  JumpTable[53].minS = minStack(1, 1)
  JumpTable[53].maxS = maxStack(1, 1)
  JumpTable[53].halts = false
  JumpTable[53].jumps = false
  JumpTable[53].writes = false
  JumpTable[53].reverts = false
  JumpTable[53].returns = false
  JumpTable[54].execute = opCallDataSize
  JumpTable[54].minS = minStack(0, 1)
  JumpTable[54].maxS = maxStack(0, 1)
  JumpTable[54].halts = false
  JumpTable[54].jumps = false
  JumpTable[54].writes = false
  JumpTable[54].reverts = false
  JumpTable[54].returns = false
  JumpTable[80].execute = opPop
  JumpTable[80].minS = minStack(1, 0)
  JumpTable[80].maxS = maxStack(1, 0)
  JumpTable[80].halts = false
  JumpTable[80].jumps = false
  JumpTable[80].writes = false
  JumpTable[80].reverts = false
  JumpTable[80].returns = false
  JumpTable[81].execute = opMload
  JumpTable[81].minS = minStack(1, 1)
  JumpTable[81].maxS = maxStack(1, 1)
  JumpTable[81].memorySize = memoryMLoad
  JumpTable[81].halts = false
  JumpTable[81].jumps = false
  JumpTable[81].writes = false
  JumpTable[81].reverts = false
  JumpTable[81].returns = false
  JumpTable[82].execute = opMstore
  JumpTable[82].minS = minStack(2, 0)
  JumpTable[82].maxS = maxStack(2, 0)
  JumpTable[82].memorySize = memoryMStore
  JumpTable[82].halts = false
  JumpTable[82].jumps = false
  JumpTable[82].writes = false
  JumpTable[82].reverts = false
  JumpTable[82].returns = false
  JumpTable[83].execute = opMstore8
  JumpTable[83].minS = minStack(2, 0)
  JumpTable[83].maxS = maxStack(2, 0)
  JumpTable[83].memorySize = memoryMStore8
  JumpTable[83].halts = false
  JumpTable[83].jumps = false
  JumpTable[83].writes = false
  JumpTable[83].reverts = false
  JumpTable[83].returns = false
  JumpTable[84].execute = opSload
  JumpTable[84].minS = minStack(1, 1)
  JumpTable[84].maxS = maxStack(1, 1)
  JumpTable[84].halts = false
  JumpTable[84].jumps = false
  JumpTable[84].writes = false
  JumpTable[84].reverts = false
  JumpTable[84].returns = false
  JumpTable[85].execute = opSstore
  JumpTable[85].minS = minStack(2, 0)
  JumpTable[85].maxS = maxStack(2, 0)
  JumpTable[85].writes = true
  JumpTable[85].halts = false
  JumpTable[85].jumps = false
  JumpTable[85].reverts = false
  JumpTable[85].returns = false
  JumpTable[86].execute = opJump
  JumpTable[86].minS = minStack(1, 0)
  JumpTable[86].maxS = maxStack(1, 0)
  JumpTable[86].jumps = true
  JumpTable[86].halts = false
  JumpTable[86].writes = false
  JumpTable[86].reverts = false
  JumpTable[86].returns = false
  JumpTable[87].execute = opJumpi
  JumpTable[87].minS = minStack(2, 0)
  JumpTable[87].maxS = maxStack(2, 0)
  JumpTable[87].jumps = true
  JumpTable[87].halts = false
  JumpTable[87].writes = false
  JumpTable[87].reverts = false
  JumpTable[87].returns = false
  JumpTable[88].execute = opPc
  JumpTable[88].minS = minStack(0, 1)
  JumpTable[88].maxS = maxStack(0, 1)
  JumpTable[88].halts = false
  JumpTable[88].jumps = false
  JumpTable[88].writes = false
  JumpTable[88].reverts = false
  JumpTable[88].returns = false
  JumpTable[89].execute = opMsize
  JumpTable[89].minS = minStack(0, 1)
  JumpTable[89].maxS = maxStack(0, 1)
  JumpTable[89].halts = false
  JumpTable[89].jumps = false
  JumpTable[89].writes = false
  JumpTable[89].reverts = false
  JumpTable[89].returns = false
  JumpTable[90].execute = opGas
  JumpTable[90].minS = minStack(0, 1)
  JumpTable[90].maxS = maxStack(0, 1)
  JumpTable[90].halts = false
  JumpTable[90].jumps = false
  JumpTable[90].writes = false
  JumpTable[90].reverts = false
  JumpTable[90].returns = false
  JumpTable[91].execute = opJumpdest
  JumpTable[91].minS = minStack(0, 0)
  JumpTable[91].maxS = maxStack(0, 0)
  JumpTable[91].halts = false
  JumpTable[91].jumps = false
  JumpTable[91].writes = false
  JumpTable[91].reverts = false
  JumpTable[91].returns = false
  JumpTable[96].execute = opPush1
  JumpTable[96].minS = minStack(0, 1)
  JumpTable[96].maxS = maxStack(0, 1)
  JumpTable[96].halts = false
  JumpTable[96].jumps = false
  JumpTable[96].writes = false
  JumpTable[96].reverts = false
  JumpTable[96].returns = false
  JumpTable[97].execute = opPush2
  JumpTable[97].minS = minStack(0, 1)
  JumpTable[97].maxS = maxStack(0, 1)
  JumpTable[97].halts = false
  JumpTable[97].jumps = false
  JumpTable[97].writes = false
  JumpTable[97].reverts = false
  JumpTable[97].returns = false
  JumpTable[98].execute = opPush3
  JumpTable[98].minS = minStack(0, 1)
  JumpTable[98].maxS = maxStack(0, 1)
  JumpTable[98].halts = false
  JumpTable[98].jumps = false
  JumpTable[98].writes = false
  JumpTable[98].reverts = false
  JumpTable[98].returns = false
  JumpTable[99].execute = opPush4
  JumpTable[99].minS = minStack(0, 1)
  JumpTable[99].maxS = maxStack(0, 1)
  JumpTable[99].halts = false
  JumpTable[99].jumps = false
  JumpTable[99].writes = false
  JumpTable[99].reverts = false
  JumpTable[99].returns = false
  JumpTable[128].execute = opDup1
  JumpTable[128].minS = minDupStack(1)
  JumpTable[128].maxS = maxDupStack(1)
  JumpTable[128].halts = false
  JumpTable[128].jumps = false
  JumpTable[128].writes = false
  JumpTable[128].reverts = false
  JumpTable[128].returns = false
  JumpTable[243].execute = opReturn
  JumpTable[243].minS = minStack(2, 0)
  JumpTable[243].maxS = maxStack(2, 0)
  JumpTable[243].memorySize = memoryReturn
  JumpTable[243].halts = true
  JumpTable[243].jumps = false
  JumpTable[243].writes = false
  JumpTable[243].reverts = false
  JumpTable[243].returns = false
  JumpTable[253].execute = opRevert
  JumpTable[243].minS = minStack(2, 0)
  JumpTable[243].maxS = maxStack(2, 0)
  JumpTable[243].memorySize = memoryRevert
  JumpTable[243].halts = true
  JumpTable[243].jumps = false
  JumpTable[243].writes = false
  JumpTable[243].reverts = true
  JumpTable[243].returns = true
  return JumpTable
