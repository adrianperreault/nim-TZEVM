import types
import uint256, stack, contract, memory

proc opAdd*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  add256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opSub*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  minus256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opMul*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  mul256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opDiv*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  var m: uint256_t
  divmod256(y, addr(x), addr(t), addr(m))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opSdiv*(pc: ptr uint64; interpreter: ptr Interpreter;
            scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  var m: uint256_t
  divmod256(y, addr(x), addr(t), addr(m))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opMod*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  var m: uint256_t
  divmod256(y, addr(x), addr(t), addr(m))
  copy256(y, addr(m))
  r.err = nil
  r.ret = nil
  return r

proc opSmod*(pc: ptr uint64; interpreter: ptr Interpreter;
            scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  var m: uint256_t
  divmod256(y, addr(x), addr(t), addr(m))
  copy256(y, addr(m))
  r.err = nil
  r.ret = nil
  return r

##
## struct Result opExp(uint64* pc, struct Interpreter* i, struct ScopeContext* s) {
##
## }
## struct Result opSignExtend(uint64* pc, struct Interpreter* i, struct ScopeContext* s) {
##
## }
##

proc opNot*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  not256(x, addr(t))
  copy256(x, addr(t))
  r.err = nil
  r.ret = nil
  return r

converter toUint256*(x: array[4, int] | array[4, uint64]): uint256_t = 
  uint256_t(elements: [uint128_t(elements:[x[0].uint64, x[1].uint64]),uint128_t(elements:[x[2].uint64, x[3].uint64])])
# converter toUint256*(x: array[4, int]): uint256_t = 
  # uint256_t(elements: [uint128_t(elements:[x[0].uint64, x[1].uint64]),uint128_t(elements:[x[2].uint64, x[3].uint64])])


proc opLt*(pc: ptr uint64; interpreter: ptr Interpreter;
          scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t = [0, 0, 0, 1]
  if gt256(y, addr(x)):
    copy256(y, addr(tmp))
  r.err = nil
  r.ret = nil
  return r

proc opGt*(pc: ptr uint64; interpreter: ptr Interpreter;
          scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t = [0, 0, 0, 1]
  if gt256(addr(x), y):
    copy256(y, addr(tmp))
  r.err = nil
  r.ret = nil
  return r

proc opSlt*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t = [0, 0, 0, 1]
  if gt256(y, addr(x)):
    copy256(y, addr(tmp))
  r.err = nil
  r.ret = nil
  return r

proc opSgt*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t = [0, 0, 0, 1]
  if gt256(addr(x), y):
    copy256(y, addr(tmp))
  r.err = nil
  r.ret = nil
  return r

proc opEq*(pc: ptr uint64; interpreter: ptr Interpreter;
          scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t
  var t: uint256_t
  clear256(addr(tmp))
  clear256(addr(t))
  if equal256(y, addr(x)):
    not256(addr(tmp), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opIszero*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t
  var t: uint256_t
  clear256(addr(tmp))
  clear256(addr(t))
  if zero256(x):
    not256(addr(tmp), addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opAnd*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  and256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opOr*(pc: ptr uint64; interpreter: ptr Interpreter;
          scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  or256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

proc opXor*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: ptr uint256_t = Stack_peek(scopecontext.s)
  var t: uint256_t
  xor256(y, addr(x), addr(t))
  copy256(y, addr(t))
  r.err = nil
  r.ret = nil
  return r

##
## struct Result opByte(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext) {
## 	struct Result r;
## 	struct uint256_t th = Stack_pop(scopecontext->s);
## 	struct uint256_t* val = Stack_peek(scopecontext->s);
## 	struct uint256_t t;
## 	xor256(y, &x, &t);
## 	copy256(y, &t);
## 	r.err = NULL;
## 	r.ret = NULL;
## 	return r;
## }

proc opAddmod*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: uint256_t = Stack_pop(scopecontext.s)
  var z: ptr uint256_t = Stack_peek(scopecontext.s)
  if zero256(z):
    clear256(z)
  else:
    var tmp: uint256_t
    var t: uint256_t
    var m: uint256_t
    add256(addr(y), addr(x), addr(tmp))
    divmod256(addr(tmp), z, addr(t), addr(m))
    copy256(z, addr(m))
  r.err = nil
  r.ret = nil
  return r

proc opMulmod*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var r: Result
  var x: uint256_t = Stack_pop(scopecontext.s)
  var y: uint256_t = Stack_pop(scopecontext.s)
  var z: ptr uint256_t = Stack_peek(scopecontext.s)
  var tmp: uint256_t
  mul256(addr(y), addr(x), addr(tmp))
  var t: uint256_t
  var m: uint256_t
  divmod256(addr(tmp), z, addr(t), addr(m))
  copy256(z, addr(m))
  r.err = nil
  r.ret = nil
  return r

##
## struct Result opSHL(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opSHR(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opSAR(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opSha3(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
##

proc opAddress*(pc: ptr uint64; interpreter: ptr Interpreter;
               scopecontext: ptr ScopeContext): Result =
  var a: Address = scopecontext.c.CallerAddress
  var tmp1: uint64 = ((uint64)(cast[uint8](a.`addr`[19])) shl 24) or
      ((uint64)(cast[uint8](a.`addr`[18])) shl 16) or
      ((uint64)(cast[uint8](a.`addr`[17])) shl 8) or
      ((uint64)(cast[uint8](a.`addr`[16])))
  var tmp2: uint64 = ((uint64)(cast[uint8](a.`addr`[15])) shl 56) or
      ((uint64)(cast[uint8](a.`addr`[14])) shl 48) or
      ((uint64)(cast[uint8](a.`addr`[13])) shl 40) or
      ((uint64)(cast[uint8](a.`addr`[12]) shl 32)) or
      ((uint64)(cast[uint8](a.`addr`[11])) shl 24) or
      ((uint64)(cast[uint8](a.`addr`[10]) shl 16)) or
      ((uint64)(cast[uint8](a.`addr`[9]) shl 8)) or
      ((uint64)(cast[uint8](a.`addr`[8])))
  var tmp3: uint64 = ((uint64)(cast[uint8](a.`addr`[7])) shl 56) or
      ((uint64)(cast[uint8](a.`addr`[6])) shl 48) or
      ((uint64)(cast[uint8](a.`addr`[5])) shl 40) or
      ((uint64)(cast[uint8](a.`addr`[4])) shl 32) or
      ((uint64)(cast[uint8](a.`addr`[3])) shl 24) or
      ((uint64)(cast[uint8](a.`addr`[2])) shl 16) or
      ((uint64)(cast[uint8](a.`addr`[1])) shl 8) or
      ((uint64)(cast[uint8](a.`addr`[0])))
  var address: uint256_t = [0.uint64, tmp1, tmp2, tmp3]
  Stack_push(scopecontext.s, address)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

##
## struct Result opBalance(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opOrigin(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCaller(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCallValue(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCallDataCopy(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opReturnDataSize(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opReturnDataCopy(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opExtCodeSize(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCodeSize(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCodeCopy(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opExtCodeCopy(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opExtCodeHash(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opGasprice(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opBlockhash(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opCoinbase(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opTimestamp(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opNumber(uint64* pc, struct Interpreter* i, struct ScopeContext* s);
## struct Result opDifficulty(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opGasLimit(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
##

proc opCallDataLoad*(pc: ptr uint64; interpreter: ptr Interpreter;
                    scopecontext: ptr ScopeContext): Result =
  var x: ptr uint256_t = Stack_peek(scopecontext.s)
  var overflow: bool = true
  if UPPER(LOWER_P(x)) == 0 and LOWER(UPPER_P(x)) == 0 and UPPER(UPPER_P(x)) == 0:
    overflow = false
  var offset: uint64 = LOWER(LOWER_P(x))
  if not overflow:
    var buff1: array[8, uint8]
    var buff2: array[8, uint8]
    var buff3: array[8, uint8]
    var buff4: array[8, uint8]
    var i: cint = 0
  #   while i < 8:
  #     buff1[i] = cast[uint8](Contract_GetInput(scopecontext.c, offset + i))
  #     inc(i)
  #   var i: cint = 8
  #   while i < 16:
  #     buff2[i - 8] = cast[uint8](Contract_GetInput(scopecontext.c, offset + i))
  #     inc(i)
  #   var i: cint = 16
  #   while i < 24:
  #     buff3[i - 16] = cast[uint8](Contract_GetInput(scopecontext.c, offset + i))
  #     inc(i)
  #   var i: cint = 24
  #   while i < 32:
  #     buff4[i - 24] = cast[uint8](Contract_GetInput(scopecontext.c, offset + i))
  #     inc(i)
  #   var tmp: uint256_t = [readUint64BE(buff1), readUint64BE(buff2),
  #                     readUint64BE(buff3), readUint64BE(buff4)]
  #   copy256(x, addr(tmp))
  # else:
  #   clear256(x)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opCallDataSize*(pc: ptr uint64; interpreter: ptr Interpreter;
                    scopecontext: ptr ScopeContext): Result =
  var length: uint64 = (uint64)(len( cast[cstring](scopecontext.c.Input))) div 2
  var tmp: uint256_t = [0, 0, 0, length.int]
  Stack_push(scopecontext.s, tmp)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opPop*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  discard Stack_pop(scopecontext.s)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opMload*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var v: ptr uint256_t = Stack_peek(scopecontext.s)
  var offset: uint64 = uint64(LOWER(LOWER_P(v)))
  var mptr: ptr byte = Memory_GetPtr(scopecontext.m, offset, 32)
  # var l: cint = sizeof((mptr) div sizeof(ptr byte))
  var l = 0.cint
  if l > 0 and l <= 8:
    var tmp: uint64 = 0
    var i: cint = l - 1
    while i >= 0:
      # tmp = tmp or cast[uint64](mptr[i]) shl (8 * i)
      dec(i)
    var t: uint256_t = [0, 0, 0, tmp.int]
    copy256(v, addr(t))
  elif l > 8 and l <= 16:
    var tmp1: uint64 = 0
    var tmp2: uint64 = 0
    var i: cint = l - 1
    while i >= 8:
      # tmp1 = tmp1 or cast[uint64](mptr[i]) shl (8 * (i - 8))
      dec(i)
    i = 7
    while i >= 0:
      # tmp2 = tmp2 or cast[uint64](mptr[i]) shl (8 * i)
      dec(i)
    var t: uint256_t = [0.uint64, 0.uint64, tmp1.uint64, tmp2.uint64]
    copy256(v, addr(t))
  elif l > 16 and l <= 24:
    var tmp1: uint64 = 0
    var tmp2: uint64 = 0
    var tmp3: uint64 = 0
    var i: cint = l - 1
    while i >= 16:
      # tmp1 = tmp1 or cast[uint64](mptr[i]) shl (8 * (i - 16))
      dec(i)
    i = 15
    while i >= 8:
      # tmp2 = tmp2 or cast[uint64](mptr[i]) shl (8 * (i - 8))
      dec(i)
    i = 7
    while i >= 0:
      # tmp3 = tmp3 or cast[uint64](mptr[i]) shl (8 * i)
      dec(i)
    var t: uint256_t = [0.uint64, tmp1, tmp2, tmp3]
    copy256(v, addr(t))
  elif l > 24 and l <= 32:
    var tmp1: uint64 = 0
    var tmp2: uint64 = 0
    var tmp3: uint64 = 0
    var tmp4: uint64 = 0
    var i: cint = l - 1
    while i >= 24:
      # tmp1 = tmp1 or cast[uint64](mptr[i]) shl (8 * (i - 24))
      dec(i)
    i = 23
    while i >= 16:
      # tmp1 = tmp1 or cast[uint64](mptr[i]) shl (8 * (i - 16))
      dec(i)
    i = 15
    while i >= 8:
      # tmp2 = tmp2 or cast[uint64](mptr[i]) shl (8 * (i - 8))
      dec(i)
    i = 7
    while i >= 0:
      # tmp3 = tmp3 or cast[uint64](mptr[i]) shl (8 * i)
      dec(i)
    var t: uint256_t = [tmp1, tmp2, tmp3, tmp4]
    copy256(v, addr(t))
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opMstore*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  var mStart: uint256_t = Stack_pop(scopecontext.s)
  var val: uint256_t = Stack_pop(scopecontext.s)
  Memory_Set32(scopecontext.m, cast[uint64](LOWER(LOWER(mStart))), addr(val))
  return r

proc opMstore8*(pc: ptr uint64; interpreter: ptr Interpreter;
               scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opSload*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opSstore*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

## struct Result opSstore(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext) {
## 	struct uint256_t loc = Stack_pop(scopecontext->s);
## 	struct uint256_t val = Stack_pop(scopecontext->s);
## 	//wait writing...
## 	struct Result r;
## 	r.err = NULL;
## 	r.ret = NULL;
## 	return r;
## }

proc opJump*(pc: ptr uint64; interpreter: ptr Interpreter;
            scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opJumpi*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var pos: uint256_t = Stack_pop(scopecontext.s)
  var cond: uint256_t = Stack_pop(scopecontext.s)
  var r: Result
  r.err = nil
  r.ret = nil
  if not (LOWER(LOWER(cond)) == 0 and UPPER(LOWER(cond)) == 0 and
      LOWER(UPPER(cond)) == 0 and UPPER(UPPER(cond)) == 0):
    if not Contract_validJumpdest(scopecontext.c, pos):
      r.ret = nil
      r.err = "ErrInvalidJump"
    (pc[]) = LOWER(LOWER(pos))
  else:
    inc((pc[]))
  return r

proc opJumpdest*(pc: ptr uint64; interpreter: ptr Interpreter;
                scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opPc*(pc: ptr uint64; interpreter: ptr Interpreter;
          scopecontext: ptr ScopeContext): Result =
  var pcvalue: uint256_t = [0.uint64, 0.uint64, 0.uint64, pc[]]
  Stack_push(scopecontext.s, pcvalue)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opMsize*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var msize: uint256_t = [0.uint64, 0.uint64, 0.uint64, cast[uint64](Memory_Len(scopecontext.m))]
  Stack_push(scopecontext.s, msize)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opGas*(pc: ptr uint64; interpreter: ptr Interpreter;
           scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

proc opPush1*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  inc((pc[]), 1)
  var a = uint64(uint8(Contract_GetOp(scopecontext.c, pc[])))
  var code: uint256_t = [0.uint64, 0.uint64, 0.uint64, a]
  Stack_push(scopecontext.s, code)
  var r: Result
  r.err = nil
  r.ret = nil
  return r

## struct Result opCreate(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opCreate2(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opCall(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opCallCode(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opDelegateCall(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
## struct Result opStaticCall(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);

proc opReturn*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var offset: uint256_t = Stack_pop(scopecontext.s)
  var size: uint256_t = Stack_pop(scopecontext.s)
  var ret: ptr byte = Memory_GetPtr(scopecontext.m, LOWER(LOWER(offset)),
                               LOWER(LOWER(size)))
  var r: Result
  r.err = nil
  r.ret = ret
  return r

proc opRevert*(pc: ptr uint64; interpreter: ptr Interpreter;
              scopecontext: ptr ScopeContext): Result =
  var offset: uint256_t = Stack_pop(scopecontext.s)
  var size: uint256_t = Stack_pop(scopecontext.s)
  var ret: ptr byte = Memory_GetPtr(scopecontext.m, LOWER(LOWER(offset)),
                               LOWER(LOWER(size)))
  var r: Result
  r.err = nil
  r.ret = ret
  return r

proc opStop*(pc: ptr uint64; interpreter: ptr Interpreter;
            scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  return r

## struct Result opSuicide(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
##
## struct Result makeLog(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);

proc opPush2*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  var codelen: cint = cint(len(cast[cstring](scopecontext.c.Code)) div 2)
  var startMin: cint = codelen
  # if (int)((pc[]) + 1) < startMin:
    # startMin = (int)((pc[]) + 1)
  var endMin: cint = codelen
  if startMin + 2 < endMin:
    endMin = startMin + 2
  var i: cint = startMin
  while i < endMin:
    var a = Contract_GetOp(scopecontext.c, i.uint64)
    var tmp: uint256_t = [0.uint64, 0.uint64, 0.uint64, a]
    Stack_push(scopecontext.s, tmp)
    inc(i)
  inc((pc[]), 2)
  return r

proc opPush3*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  var codelen: cint = cint(len(cast[cstring](scopecontext.c.Code)) div 2)
  var startMin: cint = codelen
  # if (int)((pc[]) + 1) < startMin:
    # startMin = (int)((pc[]) + 1)
  var endMin: cint = codelen
  if startMin + 3 < endMin:
    endMin = startMin + 3
  var i: cint = startMin
  while i < endMin:
    # var tmp: uint256_t = [0, 0, 0, (uint64)(uint8),Contract_GetOp(scopecontext.c, i)]
    # Stack_push(scopecontext.s, tmp)
    inc(i)
  inc((pc[]), 3)
  return r

proc opPush4*(pc: ptr uint64; interpreter: ptr Interpreter;
             scopecontext: ptr ScopeContext): Result =
  var r: Result
  r.err = nil
  r.ret = nil
  # var codelen: cint = strlen(scopecontext.c.Code) div 2
  # var startMin: cint = codelen
  # if (int)((pc[]) + 1) < startMin:
    # startMin = (int)((pc[]) + 1)
  # var endMin: cint = codelen
  # if startMin + 4 < endMin:
    # endMin = startMin + 4
  # var i: cint = startMin
  # while i < endMin:
    # var tmp: uint256_t = [0, 0, 0, (uint64)(uint8),
                      # Contract_GetOp(scopecontext.c, i)]
    # Stack_push(scopecontext.s, tmp)
    # inc(i)
  inc((pc[]), 4)
  return r

proc opDup1*(pc: ptr uint64; interpreter: ptr Interpreter;
            scopecontext: ptr ScopeContext): Result =
  Stack_dup(scopecontext.s, 1)
  var r: Result
  r.ret = nil
  r.err = nil
  return r

## struct Result makeSwap(uint64* pc, struct Interpreter* interpreter, struct ScopeContext* scopecontext);
