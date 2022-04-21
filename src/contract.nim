import types

proc Contract_NewContract*(c: ptr Contract; caller: ContractRef;
                          `object`: ContractRef; value: uint256_t) =
  c.CallerAddress = caller.`addr`
  c.caller = caller
  c.self = `object`
  c.value = value

proc Contract_validJumpdest*(c: ptr Contract; dest: uint256_t): bool =
  var overflow: bool = true
  if UPPER(LOWER(dest)) == 0 and LOWER(UPPER(dest)) == 0 and UPPER(UPPER(dest)) == 0:
    overflow = false
  var udest: uint64 = LOWER(LOWER(dest))
  if overflow or udest >= cast[uint64](len(cast[cstring](c.Code))):
    return false
  if not (cast[ptr char](cast[int](c.Code) + (2 * udest.int)*sizeof(byte))[] == '5' and cast[ptr[char]]( cast[int](c.Code) + (2 * udest.int + 1)*sizeof(byte) )[]== 'b'):
    return false
  return true

## bool Contract_isCode(Contract* c, uint64 udest);
## Contract* Contract_AsDelegate(Contract* c);
# template indexCode(offset: untyped)
proc Contract_GetByte*(c: ptr Contract; n: uint64): byte =
  # if c.Code[2 * n] != nil and c.Code[2 * n + 1] != nil:
  #   var res: uint8_t = 0
  #   if c.Code[2 * n] >= '0' and c.Code[2 * n] <= '9':
  #     inc(res, (c.Code[2 * n] - '0') * 16)
  #   else:
  #     inc(res, (c.Code[2 * n] - 'a' + 10) * 16)
  #   if c.Code[2 * n + 1] >= '0' and c.Code[2 * n + 1] <= '9':
  #     inc(res, c.Code[2 * n + 1] - '0')
  #   else:
  #     inc(res, c.Code[2 * n + 1] - 'a' + 10)
  #   return res
  return 0

proc Contract_GetOp*(c: ptr Contract; n: uint64): OpCode =
  return cast[OpCode](Contract_GetByte(c, n))

proc Contract_GetInputByte*(c: ptr Contract; n: uint64): byte =
  # if c.Input[2 * n] != nil and c.Input[2 * n + 1] != nil:
  #   var res: uint8_t = 0
  #   if c.Input[2 * n] >= '0' and c.Input[2 * n] <= '9':
  #     inc(res, (c.Input[2 * n] - '0') * 16)
  #   else:
  #     inc(res, (c.Input[2 * n] - 'a' + 10) * 16)
  #   if c.Input[2 * n + 1] >= '0' and c.Input[2 * n + 1] <= '9':
  #     inc(res, c.Input[2 * n + 1] - '0')
  #   else:
  #     inc(res, c.Input[2 * n + 1] - 'a' + 10)
  #   return res
  return 0

proc Contract_GetInput*(c: ptr Contract; n: uint64): OpCode =
  return cast[OpCode](Contract_GetInputByte(c, n))

proc Contract_Caller*(c: ptr Contract): Address =
  return c.CallerAddress

proc Contract_Address*(c: ptr Contract): Address =
  return c.self.`addr`

proc Contract_Value*(c: ptr Contract): uint256_t =
  return c.value

proc Contract_SetCallCode*(c: ptr Contract; `addr`: ptr Address; hash: Hash;
                          code: ptr byte) =
  c.Code = code
  c.CodeHash = hash
  c.CodeAddr = `addr`

## void Contract_SetCodeOptionalHash(Contract* c, Address* addr, CodeAndHash);
