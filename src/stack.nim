import types
import uint256

proc Stack_newStack*(s: ptr Stack; maxElements: cint): ptr Stack =
  s.arr = cast[ptr uint256_t](alloc(sizeof(cast[uint256_t](maxElements))))
  s.capacity = maxElements
  s.stackTop = EmptyTOS
  return s

## Stack* returnStack(Stack* s);

proc Stack_Data*(s: ptr Stack): ptr uint256_t =
  return s.arr

proc Stack_push*(s: ptr Stack; e: uint256_t) =
  if s.stackTop != s.capacity - 1:
    inc(s.stackTop)
    copy256(cast[ptr uint256_t](cast[int](s.arr) + s.stackTop), unsafeaddr(e))

## void Stack_pushN(Stack* s, elementType* e);

proc Stack_pop*(s: ptr Stack): uint256_t =
  var e: uint256_t
  copy256(addr(e), cast[ptr uint256_t](cast[int](s.arr) + s.stackTop))
  clear256(cast[ptr uint256_t](cast[int](s.arr) + s.stackTop))
  dec(s.stackTop)
  return e

proc Stack_len*(s: ptr Stack): cint =
  return s.stackTop + 1

proc Stack_swap*(s: ptr Stack; n: cint) =
  if s.stackTop != EmptyTOS:
    var len: cint = s.stackTop + 1
    if n <= len and n > 2:
      var m: cint = if (n mod 2 == 0): n div 2 else: n div 2 + 1
      var e: uint256_t
      var i: cint = n
      while i > m:
        copy256(addr(e), cast[ptr uint256_t](cast[int](s.arr) + len - n))

        copy256(cast[ptr uint256_t](cast[int](s.arr) + len - n), cast[ptr uint256_t]( cast[int](s.arr) + len - n + i - 1))
        copy256(cast[ptr uint256_t](cast[int](s.arr) + len - n + i - 1), addr(e))
        dec(i)
    else:
      echo("N is not fit!\n")
  else:
    echo("Stack is empty!\n")

proc Stack_dup*(s: ptr Stack; n: cint) =
  var i: cint = n
  while i > 0:
    Stack_push(s, cast[ptr uint256_t]( cast[int](s.arr) + s.stackTop - n + 1)[])
    dec(i)

proc Stack_peek*(s: ptr Stack): ptr uint256_t =
  return cast[ptr uint256_t](cast [int](s.arr) + s.stackTop)

proc Stack_Back*(s: ptr Stack; n: cint): ptr uint256_t =
  return cast[ptr uint256_t]( cast[int](s.arr) + s.stackTop - n - 1)

proc Stack_Print*(s: ptr Stack) =
  var outLength: uint32 = 256
  var `out`: cstring = cast[cstring](alloc(sizeof(char) * outLength.int))
  echo("### stack ###\n")
  var len: cint = s.stackTop + 1
  if len > 0:
    var i: cint = 0
    while i < len:
      var base: uint32 = 16
      if tostring256(cast [ptr uint256_t](cast[int](s.arr) + i), base, `out`, outLength):
        echo("%-3d %s\n", i, `out`)
      inc(i)
  else:
    echo("-- empty --\n")
  echo("#############\n")
