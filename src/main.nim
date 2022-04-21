import types
import operation, evm

const
  COINBASE_ADDY     = "0x64902116fc387b1f9885a535f28a235367dd8926"
  CONTRACT_REF_ADDY = "0x53F73d5519C002eF422B7eFC41c023AaF4889159"
  BYTECODE_STR      = cstring "608060405260043610603f576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680631003e2d2146044575b600080fd5b348015604f57600080fd5b50606c600480360381019080803590602001909291905050506082565b6040518082815260200191505060405180910390f35b60009190505600a165627a7a72305820b2d984d9228e0cfe2950fb67580e382f88e808e7bf9be677c79da28426a4de940029"

proc main*(): cint =
    var blockCtx          = BlockContext(coinBase: COINBASE_ADDY)
    var txCtx             = TxContext(origin:COINBASE_ADDY)
    var evm               = initEVM(blockCtx, txCtx)
    var caller            = ContractRef(addy: CONTRACT_REF_ADDY )
    var addy              = Address(`addr`: "0x64902116fc387b1f9885a535f28a235367dd8926")
    var codeCStr          = BYTECODE_STR
    var code: ptr byte    = cast[ptr byte](addr codeCStr[0])
    var hashCStr          = cstring"0xce9b0e08f1a1877e27c8276fce184a576874e59dcf6390c9fdeaa2f90a04fa24"
    var codehash          = Hash(hash: cast[ptr byte](addr hashCStr[0]))
    var inp               = cstring"1003e2d20000000000000000000000000000000000000000000000000000000000000001"
    var input: ptr byte   = cast[ptr byte](addr inp[0])
    var value: uint256_t  = [0.uint64, 0, 0, 0]
    # echo EVM_Call(evm, caller, addy, code, codehash, input, value)
    return 0
