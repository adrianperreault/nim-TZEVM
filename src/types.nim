type
  uint128_t* {.bycopy.} = object
    elements*: array[2, uint64]

  uint256_t* {.bycopy.} = object
    elements*: array[2, uint128_t]

  Result* {.bycopy.} = object
    ret*: ptr byte
    err*: cstring

  MemRes* {.bycopy.} = object
    val*: uint64
    err*: bool
  
  Stack* {.bycopy.} = object
    capacity* : cint
    stackTop* : cint
    arr*      : ptr uint256_t

  ScopeContext* {.bycopy.} = object
    m*: ptr Memory
    s*: ptr Stack
    c*: ptr Contract

  Operation* {.bycopy.} = ref object
    execute*     : proc (pc: ptr uint64; i: ptr Interpreter; s: ptr ScopeContext): Result
    constantGas* : uint64
    memorySize*  : proc (s : ptr Stack): MemRes
    minS*        : cint
    maxS*        : cint
    halts*       : bool
    jumps*       : bool
    writes*      : bool
    reverts*     : bool
    returns*     : bool

  OpCode* = uint64

  Memory* {.bycopy.} = object
    store*: ptr byte            ## uint64 lastGasCost;
  
  JumpTable* = array[256, Operation]
  
  Config* {.bycopy.} = object
    jumpTable*       : JumpTable
    JumpTable*       : ptr Operation   ## bool Debug;
                                ## tracer;
                                ## bool NoRecursion;
                                ## bool EnablePreimageRecording;
    EWASMInterpreter*: cstring
    EVMInterpreter*  : cstring
    ExtraEips*       : ptr cint

  Interpreter* {.bycopy.} = object
    evm*        : ptr EVM
    cfg*        : Config
    readOnly*   : bool
    returnData* : ptr byte

  Hash* {.bycopy.} = object
    hash*: ptr byte

  Address* {.bycopy.} = object
    addy*   : cstring
    `addr`* : cstring

  ContractRef* {.bycopy.} = object
    addy*: Address
    `addr`*: Address

  Contract* {.bycopy.} = object
    CallerAddress*: Address
    caller*       : ContractRef
    self*         : ContractRef         ## byte* jumpdests;
                      ## byte* analysis;
    Code*         : ptr byte
    CodeHash*     : Hash
    CodeAddr*     : ptr Address
    Input*        : ptr byte
    value*        : uint256_t

  BlockContext* {.bycopy.} = object
    coinbase*    : Address
    gasLimit*    : uint64
    blockNumber* : uint256_t
    time*        : uint256_t
    difficulty*  : uint256_t

  TxContext* {.bycopy.} = object
    origin*   : Address
    gasPrice* : uint256_t

  EVM* {.bycopy.} = ref object
    context*      : BlockContext
    tx*           : TxContext
    depth*        : cint
    vmConfig*     : Config
    interpreters* : ptr Interpreter
    interpreter*  : Interpreter
    abort*        : int32
    callGasTemp*  : uint64

const
  EmptyTOS* = -1

include helpers
