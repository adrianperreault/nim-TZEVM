import types

var HEXDIGITS*: cstring = cstring"0123456789abcdef"

## Forward Decls
proc add128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t)

proc readUint64BE*(buffer: ptr uint8): uint64 =
  var buffer = cast[ptr array[8, uint8]](buffer)[]
  return ((cast[uint64](buffer[0])) shl 56) or
      ((cast[uint64](buffer[1])) shl 48) or
      ((cast[uint64](buffer[2])) shl 40) or
      ((cast[uint64](buffer[3])) shl 32) or
      ((cast[uint64](buffer[4])) shl 24) or
      ((cast[uint64](buffer[5])) shl 16) or ((cast[uint64](buffer[6])) shl 8) or
      ((cast[uint64](buffer[7])))

proc readu128BE*(buffer: ptr uint8; target: ptr uint128_t) =
  UPPER_P(target) = readUint64BE(buffer)
  LOWER_P(target) = readUint64BE(cast[ptr uint8]((cast[int](buffer) + 8)))

proc readu256BE*(buffer: ptr uint8; target: ptr uint256_t) =
  readu128BE(buffer, addr(UPPER_P(target)))
  readu128BE(cast[ptr uint8]((cast[int](buffer) + 16)),  addr(LOWER_P(target)))

proc zero128*(number: ptr uint128_t): bool =
  return (LOWER_P(number) == 0) and (UPPER_P(number) == 0)

proc zero256*(number: ptr uint256_t): bool =
  return zero128(addr(LOWER_P(number))) and zero128(addr(UPPER_P(number)))

proc copy128*(target: ptr uint128_t; number: ptr uint128_t) =
  UPPER_P(target) = UPPER_P(number)
  LOWER_P(target) = LOWER_P(number)

proc copy256*(target: ptr uint256_t; number: ptr uint256_t) =
  copy128(addr(UPPER_P(target)), addr(UPPER_P(number)))
  copy128(addr(LOWER_P(target)), addr(LOWER_P(number)))

proc clear128*(target: ptr uint128_t) =
  UPPER_P(target) = 0
  LOWER_P(target) = 0

proc clear256*(target: ptr uint256_t) =
  clear128(addr(UPPER_P(target)))
  clear128(addr(LOWER_P(target)))

proc shiftl128*(number: ptr uint128_t; value: uint32; target: ptr uint128_t) =
  if value >= 128:
    clear128(target)
  elif value == 64:
    UPPER_P(target) = LOWER_P(number)
    LOWER_P(target) = 0
  elif value == 0:
    copy128(target, number)
  elif value < 64:
    UPPER_P(target) = (UPPER_P(number) shl value) +
        (LOWER_P(number) shr (64 - value))
    LOWER_P(target) = (LOWER_P(number) shl value)
  elif (128 > value) and (value > 64):
    UPPER_P(target) = LOWER_P(number) shl (value - 64)
    LOWER_P(target) = 0
  else:
    clear128(target)

proc shiftr128*(number: ptr uint128_t; value: uint32; target: ptr uint128_t) =
  if value >= 128:
    clear128(target)
  elif value == 64:
    UPPER_P(target) = 0
    LOWER_P(target) = UPPER_P(number)
  elif value == 0:
    copy128(target, number)
  elif value < 64:
    var result: uint128_t
    UPPER(result) = UPPER_P(number) shr value
    LOWER(result) = (UPPER_P(number) shl (64 - value)) + (LOWER_P(number) shr value)
    copy128(target, addr(result))
  elif (128 > value) and (value > 64):
    LOWER_P(target) = UPPER_P(number) shr (value - 64)
    UPPER_P(target) = 0
  else:
    clear128(target)

proc shiftr256*(number: ptr uint256_t; value: uint32; target: ptr uint256_t) =
  if value >= 256:
    clear256(target)
  elif value == 128:
    copy128(addr(LOWER_P(target)), addr(UPPER_P(number)))
    clear128(addr(UPPER_P(target)))
  elif value == 0:
    copy256(target, number)
  elif value < 128:
    var tmp1: uint128_t
    var tmp2: uint128_t
    var result: uint256_t
    shiftr128(addr(UPPER_P(number)), value, addr(UPPER(result)))
    shiftr128(addr(LOWER_P(number)), value, addr(tmp1))
    shiftl128(addr(UPPER_P(number)), (128 - value), addr(tmp2))
    add128(addr(tmp1), addr(tmp2), addr(LOWER(result)))
    copy256(target, addr(result))
  elif (256 > value) and (value > 128):
    shiftr128(addr(UPPER_P(number)), (value - 128), addr(LOWER_P(target)))
    clear128(addr(UPPER_P(target)))
  else:
    clear256(target)


proc shiftl256*(number: ptr uint256_t; value: uint32; target: ptr uint256_t) =
  if value >= 256:
    clear256(target)
  elif value == 128:
    copy128(addr(UPPER_P(target)), addr(LOWER_P(number)))
    clear128(addr(LOWER_P(target)))
  elif value == 0:
    copy256(target, number)
  elif value < 128:
    var tmp1: uint128_t
    var tmp2: uint128_t
    var result: uint256_t
    shiftl128(addr(UPPER_P(number)), value, addr(tmp1))
    shiftr128(addr(LOWER_P(number)), (128 - value), addr(tmp2))
    add128(addr(tmp1), addr(tmp2), addr(UPPER(result)))
    shiftl128(addr(LOWER_P(number)), value, addr(LOWER(result)))
    copy256(target, addr(result))
  elif (256 > value) and (value > 128):
    shiftl128(addr(LOWER_P(number)), (value - 128), addr(UPPER_P(target)))
    clear128(addr(LOWER_P(target)))
  else:
    clear256(target)


proc bits128*(number: ptr uint128_t): uint32 =
  var result: uint32 = 0
  if UPPER_P(number) > 0:
    result = 64
    var up: uint64 = UPPER_P(number)
    while up > 0:
      up = up shr 1
      inc(result)
  else:
    var low: uint64 = LOWER_P(number)
    while low > 0:
      low = low shr 1
      inc(result)
  return result

proc bits256*(number: ptr uint256_t): uint32 =
  var result: uint32 = 0
  if not zero128(addr(UPPER_P(number))):
    result = 128
    var up: uint128_t
    copy128(addr(up), addr(UPPER_P(number)))
    while not zero128(addr(up)):
      shiftr128(addr(up), 1, addr(up))
      inc(result)
  else:
    var low: uint128_t
    copy128(addr(low), addr(LOWER_P(number)))
    while not zero128(addr(low)):
      shiftr128(addr(low), 1, addr(low))
      inc(result)
  return result

proc equal128*(number1: ptr uint128_t; number2: ptr uint128_t): bool =
  return (UPPER_P(number1) == UPPER_P(number2)) and
      (LOWER_P(number1) == LOWER_P(number2))

proc equal256*(number1: ptr uint256_t; number2: ptr uint256_t): bool =
  return equal128(addr(UPPER_P(number1)), addr(UPPER_P(number2))) and
      equal128(addr(LOWER_P(number1)), addr(LOWER_P(number2)))

proc gt128*(number1: ptr uint128_t; number2: ptr uint128_t): bool =
  if UPPER_P(number1) == UPPER_P(number2):
    return LOWER_P(number1) > LOWER_P(number2)
  return UPPER_P(number1) > UPPER_P(number2)

proc gt256*(number1: ptr uint256_t; number2: ptr uint256_t): bool =
  if equal128(addr(UPPER_P(number1)), addr(UPPER_P(number2))):
    return gt128(addr(LOWER_P(number1)), addr(LOWER_P(number2)))
  return gt128(addr(UPPER_P(number1)), addr(UPPER_P(number2)))

proc gte128*(number1: ptr uint128_t; number2: ptr uint128_t): bool =
  return gt128(number1, number2) or equal128(number1, number2)

proc gte256*(number1: ptr uint256_t; number2: ptr uint256_t): bool =
  return gt256(number1, number2) or equal256(number1, number2)

proc add128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  var tmp = if (LOWER_P(number1) + LOWER_P(number2)) < LOWER_P(number1): 1.uint64 else: 0.uint64
  UPPER_P(target) = UPPER_P(number1) + UPPER_P(number2) + tmp
  LOWER_P(target) = LOWER_P(number1) + LOWER_P(number2)

proc add256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  var tmp: uint128_t
  add128(addr(UPPER_P(number1)), addr(UPPER_P(number2)), addr(UPPER_P(target)))
  add128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(tmp))
  if gt128(addr(LOWER_P(number1)), addr(tmp)):
    var one: uint128_t
    UPPER(one) = 0
    LOWER(one) = 1
    add128(addr(UPPER_P(target)), addr(one), addr(UPPER_P(target)))
  add128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(LOWER_P(target)))

proc minus128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  var tmp = if (LOWER_P(number1) - LOWER_P(number2)) > LOWER_P(number1): 1.uint64 else: 0.uint64
  UPPER_P(target) = UPPER_P(number1) - UPPER_P(number2) - tmp
  LOWER_P(target) = LOWER_P(number1) - LOWER_P(number2)

proc minus256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  var tmp: uint128_t
  minus128(addr(UPPER_P(number1)), addr(UPPER_P(number2)), addr(UPPER_P(target)))
  minus128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(tmp))
  if gt128(addr(tmp), addr(LOWER_P(number1))):
    var one: uint128_t
    UPPER(one) = 0
    LOWER(one) = 1
    minus128(addr(UPPER_P(target)), addr(one), addr(UPPER_P(target)))
  minus128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(LOWER_P(target)))

proc or128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  UPPER_P(target) = UPPER_P(number1) or UPPER_P(number2)
  LOWER_P(target) = LOWER_P(number1) or LOWER_P(number2)

proc or256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  or128(addr(UPPER_P(number1)), addr(UPPER_P(number2)), addr(UPPER_P(target)))
  or128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(LOWER_P(target)))

proc xor128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  UPPER_P(target) = UPPER_P(number1) xor UPPER_P(number2)
  LOWER_P(target) = LOWER_P(number1) xor LOWER_P(number2)

proc xor256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  xor128(addr(UPPER_P(number1)), addr(UPPER_P(number2)), addr(UPPER_P(target)))
  xor128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(LOWER_P(target)))

proc and128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  UPPER_P(target) = UPPER_P(number1) and UPPER_P(number2)
  LOWER_P(target) = LOWER_P(number1) and LOWER_P(number2)

proc and256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  and128(addr(UPPER_P(number1)), addr(UPPER_P(number2)), addr(UPPER_P(target)))
  and128(addr(LOWER_P(number1)), addr(LOWER_P(number2)), addr(LOWER_P(target)))

proc not128*(number: ptr uint128_t; target: ptr uint128_t) =
  UPPER_P(target) = not (number.elements[0])
  LOWER_P(target) = not (number.elements[1])

proc not256*(number: ptr uint256_t; target: ptr uint256_t) =
  not128(addr(UPPER_P(number)), addr(UPPER_P(target)))
  not128(addr(LOWER_P(number)), addr(LOWER_P(target)))

proc mul128*(number1: ptr uint128_t; number2: ptr uint128_t; target: ptr uint128_t) =
  var top: array[4, uint64] = [UPPER_P(number1) shr 32,
                            UPPER_P(number1) and 0xFFFFFFFF.uint64,
                            LOWER_P(number1) shr 32,
                            LOWER_P(number1) and 0xFFFFFFFF.uint64]
  var bottom: array[4, uint64] = [UPPER_P(number2) shr 32,
                               UPPER_P(number2) and 0xFFFFFFFF.uint64,
                               LOWER_P(number2) shr 32,
                               LOWER_P(number2) and 0xFFFFFFFF.uint64]
  var products: array[4, array[4, uint64]]
  var
    tmp: uint128_t
    tmp2: uint128_t
  var y: cint = 3
  while y > -1:
    var x: cint = 3
    while x > -1:
      products[3 - x][y] = top[x] * bottom[y]
      dec(x)
    dec(y)
  var fourth32: uint64 = products[0][3] and 0xFFFFFFFF.uint64
  var third32: uint64 = (products[0][2] and 0xFFFFFFFF.uint64) + (products[0][3] shr 32)
  var second32: uint64 = (products[0][1] and 0xFFFFFFFF.uint64) + (products[0][2] shr 32)
  var first32: uint64 = (products[0][0] and 0xFFFFFFFF.uint64) + (products[0][1] shr 32)
  inc(third32,   (products[1][3] and 0xFFFFFFFF.uint64).int)
  inc(second32, ((products[1][2] and 0xFFFFFFFF.uint64) + (products[1][3] shr 32)).int)
  inc(first32, ((products[1][1] and 0xFFFFFFFF.uint64) + (products[1][2] shr 32)).int)
  inc(second32,( products[2][3] and 0xFFFFFFFF.uint64).int)
  inc(first32, ((products[2][2] and 0xFFFFFFFF.uint64) + (products[2][3] shr 32)).int)
  inc(first32, (products[3][3] and 0xFFFFFFFF.uint64).int)
  UPPER(tmp) = first32 shl 32
  LOWER(tmp) = 0
  UPPER(tmp2) = third32 shr 32
  LOWER(tmp2) = third32 shl 32
  add128(addr(tmp), addr(tmp2), target)
  UPPER(tmp) = second32
  LOWER(tmp) = 0
  add128(addr(tmp), target, addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = fourth32
  add128(addr(tmp), addr(tmp2), target)

proc mul256*(number1: ptr uint256_t; number2: ptr uint256_t; target: ptr uint256_t) =
  var top: array[4, uint128_t]
  var bottom: array[4, uint128_t]
  var products: array[4, array[4, uint128_t]]
  var
    tmp: uint128_t
    tmp2: uint128_t
    fourth64: uint128_t
    third64: uint128_t
    second64: uint128_t
    first64: uint128_t
  var
    target1: uint256_t
    target2: uint256_t
  UPPER(top[0]) = 0
  LOWER(top[0]) = UPPER(UPPER_P(number1))
  UPPER(top[1]) = 0
  LOWER(top[1]) = LOWER(UPPER_P(number1))
  UPPER(top[2]) = 0
  LOWER(top[2]) = UPPER(LOWER_P(number1))
  UPPER(top[3]) = 0
  LOWER(top[3]) = LOWER(LOWER_P(number1))
  UPPER(bottom[0]) = 0
  LOWER(bottom[0]) = UPPER(UPPER_P(number2))
  UPPER(bottom[1]) = 0
  LOWER(bottom[1]) = LOWER(UPPER_P(number2))
  UPPER(bottom[2]) = 0
  LOWER(bottom[2]) = UPPER(LOWER_P(number2))
  UPPER(bottom[3]) = 0
  LOWER(bottom[3]) = LOWER(LOWER_P(number2))
  var y: cint = 3
  while y > -1:
    var x: cint = 3
    while x > -1:
      mul128(addr(top[x]), addr(bottom[y]), addr(products[3 - x][y]))
      dec(x)
    dec(y)
  UPPER(fourth64) = 0
  LOWER(fourth64) = LOWER(products[0][3])
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[0][2])
  UPPER(tmp2) = 0
  LOWER(tmp2) = UPPER(products[0][3])
  add128(addr(tmp), addr(tmp2), addr(third64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[0][1])
  UPPER(tmp2) = 0
  LOWER(tmp2) = UPPER(products[0][2])
  add128(addr(tmp), addr(tmp2), addr(second64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[0][0])
  UPPER(tmp2) = 0
  LOWER(tmp2) = UPPER(products[0][1])
  add128(addr(tmp), addr(tmp2), addr(first64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[1][3])
  add128(addr(tmp), addr(third64), addr(tmp2))
  copy128(addr(third64), addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[1][2])
  add128(addr(tmp), addr(second64), addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = UPPER(products[1][3])
  add128(addr(tmp), addr(tmp2), addr(second64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[1][1])
  add128(addr(tmp), addr(first64), addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = UPPER(products[1][2])
  add128(addr(tmp), addr(tmp2), addr(first64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[2][3])
  add128(addr(tmp), addr(second64), addr(tmp2))
  copy128(addr(second64), addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[2][2])
  add128(addr(tmp), addr(first64), addr(tmp2))
  UPPER(tmp) = 0
  LOWER(tmp) = UPPER(products[2][3])
  add128(addr(tmp), addr(tmp2), addr(first64))
  UPPER(tmp) = 0
  LOWER(tmp) = LOWER(products[3][3])
  add128(addr(tmp), addr(first64), addr(tmp2))
  copy128(addr(first64), addr(tmp2))
  clear256(addr(target1))
  shiftl128(addr(first64), 64, addr(UPPER(target1)))
  clear256(addr(target2))
  UPPER(UPPER(target2)) = UPPER(third64)
  shiftl128(addr(third64), 64, addr(LOWER(target2)))
  add256(addr(target1), addr(target2), target)
  clear256(addr(target1))
  copy128(addr(UPPER(target1)), addr(second64))
  add256(addr(target1), target, addr(target2))
  clear256(addr(target1))
  copy128(addr(LOWER(target1)), addr(fourth64))
  add256(addr(target1), addr(target2), target)

proc divmod128*(l: ptr uint128_t; r: ptr uint128_t; retDiv: ptr uint128_t;
               retMod: ptr uint128_t) =
  var
    copyd: uint128_t
    adder: uint128_t
    resDiv: uint128_t
    resMod: uint128_t
  var one: uint128_t
  UPPER(one) = 0
  LOWER(one) = 1
  var diffBits: uint32 = bits128(l) - bits128(r)
  clear128(addr(resDiv))
  copy128(addr(resMod), l)
  if gt128(r, l):
    copy128(retMod, l)
    clear128(retDiv)
  else:
    shiftl128(r, diffBits, addr(copyd))
    shiftl128(addr(one), diffBits, addr(adder))
    if gt128(addr(copyd), addr(resMod)):
      shiftr128(addr(copyd), 1, addr(copyd))
      shiftr128(addr(adder), 1, addr(adder))
    while gte128(addr(resMod), r):
      if gte128(addr(resMod), addr(copyd)):
        minus128(addr(resMod), addr(copyd), addr(resMod))
        or128(addr(resDiv), addr(adder), addr(resDiv))
      shiftr128(addr(copyd), 1, addr(copyd))
      shiftr128(addr(adder), 1, addr(adder))
    copy128(retDiv, addr(resDiv))
    copy128(retMod, addr(resMod))

proc divmod256*(l: ptr uint256_t; r: ptr uint256_t; retDiv: ptr uint256_t;
               retMod: ptr uint256_t) =
  var
    copyd: uint256_t
    adder: uint256_t
    resDiv: uint256_t
    resMod: uint256_t
  var one: uint256_t
  clear256(addr(one))
  UPPER(LOWER(one)) = 0
  LOWER(LOWER(one)) = 1
  var diffBits: uint32 = bits256(l) - bits256(r)
  clear256(addr(resDiv))
  copy256(addr(resMod), l)
  if gt256(r, l):
    copy256(retMod, l)
    clear256(retDiv)
  else:
    shiftl256(r, diffBits, addr(copyd))
    shiftl256(addr(one), diffBits, addr(adder))
    if gt256(addr(copyd), addr(resMod)):
      shiftr256(addr(copyd), 1, addr(copyd))
      shiftr256(addr(adder), 1, addr(adder))
    while gte256(addr(resMod), r):
      if gte256(addr(resMod), addr(copyd)):
        minus256(addr(resMod), addr(copyd), addr(resMod))
        or256(addr(resDiv), addr(adder), addr(resDiv))
      shiftr256(addr(copyd), 1, addr(copyd))
      shiftr256(addr(adder), 1, addr(adder))
    copy256(retDiv, addr(resDiv))
    copy256(retMod, addr(resMod))

proc reverseString*(str: var cstring; length: uint32) =
  var
    i: uint32
    j: uint32
  i = 0
  j = length - 1
  while i < j:
    var c: uint8
    c = cast[uint8](str[i])
    str[i] = str[j]
    str[j] = cast[char](c)
    inc(i)
    dec(j)

proc tostring128*(number: ptr uint128_t; baseParam: uint32; `out`: var cstring; outLength: uint32): bool =
  var rDiv: uint128_t
  var rMod: uint128_t
  var base: uint128_t
  copy128(addr(rDiv), number)
  clear128(addr(rMod))
  clear128(addr(base))
  LOWER(base) = baseParam
  var offset: uint32 = 0
  if (baseParam < 2) or (baseParam > 16):
    return false
  while true:
    if offset > (outLength - 1): return false
    divmod128(addr(rDiv), addr(base), addr(rDiv), addr(rMod))
    inc offset
    `out`[offset] = HEXDIGITS[cast[uint8](LOWER(rMod))]
    if zero128(addr(rDiv)):
      break
  `out`[offset] = '\x00'
  reverseString(`out`, offset)
  return true

proc tostring256*(number: ptr uint256_t; baseParam: uint32; `out`: var cstring;outLength: uint32): bool =
  var rDiv: uint256_t
  var rMod: uint256_t
  var base: uint256_t
  copy256(addr(rDiv), number)
  clear256(addr(rMod))
  clear256(addr(base))
  UPPER(LOWER(base)) = 0
  LOWER(LOWER(base)) = baseParam
  var offset: uint32 = 0
  if (baseParam < 2) or (baseParam > 16):
    return false
  while true:
    if offset > (outLength - 1):
      return false
    divmod256(addr(rDiv), addr(base), addr(rDiv), addr(rMod))
    inc(offset)
    `out`[offset] = HEXDIGITS[cast[uint8](LOWER(LOWER(rMod)))]
    if not not zero256(addr(rDiv)):
      break
  `out`[offset] = '\x00'
  reverseString(`out`, offset)
  return true
