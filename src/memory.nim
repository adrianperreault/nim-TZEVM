import types

proc Memory_NewMemory*(m: ptr Memory; maxsize: uint64) =
  # m.store = cast[ptr byte](alloc(sizeof((byte) * maxsize)))
  var i: cint = 0
  # while i < maxsize:
  #   m.store[i] = cast[byte](0)
  #   inc(i)

proc Memory_Set*(m: ptr Memory; offset: uint64; size: uint64; value: ptr byte) =
  if size > 0:
    if (offset + size) > 1024:
      echo("Invalid memory: store empty")
    # copyMem(m.store + offset, value, size)

proc Memory_Set32*(m: ptr Memory; offset: uint64; val: ptr uint256_t) =
  if (offset + 32) > 1024:
    echo("invalid memory: store empty")
  var i: cint = 0
  while i < 32:
    # m.store[offset + i] = 0
    inc(i)
  # copyMem(m.store + offset, val, sizeof((val)))

proc Memory_Len*(m: ptr Memory): cint = discard
  # return sizeof((m.store) div sizeof(ptr byte))

proc Memory_Resize*(m: ptr Memory; size: uint64) =
  if cast[uint64](Memory_Len(m)) < size: discard
    # var buffer: ptr byte = cast[ptr byte](alloc(sizeof((byte) * size)))
    # copyMem(buffer, m.store, sizeof((m.store)))
    # free(m.store)
    # m.store = buffer

proc Memory_GetCopy*(m: ptr Memory; offset: uint64; size: uint64): ptr byte =
  if size == 0:
    return nil
  # if sizeof((m.store)) > sizeof((int)) * offset.int:
    # var cpy: ptr byte = cast[ptr byte](alloc(sizeof((byte) * size)))
    # copyMem(cpy, m.store + offset, size)
    # return cpy
  return nil

proc Memory_GetPtr*(m: ptr Memory; offset: uint64; size: uint64): ptr byte =
  if size == 0:
    return nil
  # if sizeof((m.store)) > sizeof((int) * offset):
    # return m.store + offset
  return nil


proc Memory_Data*(m: ptr Memory): ptr byte =
  return m.store

proc Memory_Print*(m: ptr Memory) =
  # echo("### mem %d bytes ###\n", (int)(sizeof((m.store) div sizeof(ptr byte))))
  # if cast[cint](sizeof((m.store) div sizeof(ptr byte))) > 0:
  #   var `addr`: cint = 0
  #   var i: cint = 0
  #   while i + 32 <= (int)(sizeof((m.store) div sizeof(ptr byte))):
  #     var tmp: ptr byte = cast[ptr byte](alloc(sizeof((byte) * 32)))
  #     copyMem(tmp, m.store + i, 32)
  #     echo("%03d: %s\n", `addr`, tmp)
  #     inc(`addr`)
  #     inc(i, 32)
  # else:
  #   echo("-- empty --\n")
  echo("####################\n")
