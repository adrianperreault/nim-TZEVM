import types
import interpreter, contract, operation

proc EVM_NewEVM*(evm: ptr EVM; blockCtx: BlockContext; txCtx: TxContext;
                vmConfig: Config) =
  evm.context = blockCtx
  evm.tx = txCtx
  evm.vmConfig = vmConfig
  Interpreter_NewInterpreter(addr(evm.interpreter), evm, vmConfig)

proc initEVM*(blockCtx: BlockContext, txCtx: TxContext): EVM =
  result          = EVM()
  result.context  = blockCtx
  result.tx       = txCtx
  result.vmConfig = Config(jumpTable: initJumpTable())

proc EVM_Reset*(evm: ptr EVM; txCtx: TxContext) =
  evm.tx = txCtx

proc EVM_Cancel*(evm: ptr EVM) =
  evm.abort = 1

proc EVM_Cancelled*(evm: ptr EVM): bool =
  return evm.abort == 1

proc EVM_Interpreter*(evm: ptr EVM): Interpreter =
  return evm.interpreter

proc EVM_Run*(evm: ptr EVM; contract: ptr Contract; input: ptr byte; readOnly: bool): Result =
  return Interpreter_Run(addr(evm.interpreter), contract, input, readOnly)

proc EVM_Call*(evm: ptr EVM; caller: ContractRef; `addr`: Address; code: ptr byte;
              codehash: Hash; input: ptr byte; value: uint256_t): Result =
  var res: Result
  if evm.depth > 1024:
    res.ret = nil
    res.err = "ErrDepth"
    return res
  if code == nil:
    res.ret = nil
    res.err = nil
    return res
  else:
    var addrCopy: Address = `addr`
    var cr: ContractRef
    cr.`addr` = addrCopy
    var contract: ptr Contract = cast[ptr Contract](alloc(sizeof(Contract)))
    Contract_NewContract(contract, caller, cr, value)
    Contract_SetCallCode(contract, addr(addrCopy), codehash, code)
    res = EVM_Run(evm, contract, input, false)
    return res

proc EVM_CallCode*(evm: ptr EVM; caller: ContractRef; `addr`: Address; code: ptr byte;
                  codehash: Hash; input: ptr byte; value: uint256_t): Result =
  var res: Result
  if evm.depth > 1024:
    res.ret = nil
    res.err = "ErrDepth"
    return res
  var addrCopy: Address = `addr`
  var cr: ContractRef
  cr.`addr` = caller.`addr`
  var contract: ptr Contract = cast[ptr Contract](alloc(sizeof(Contract)))
  Contract_NewContract(contract, caller, cr, value)
  Contract_SetCallCode(contract, addr(addrCopy), codehash, code)
  res = EVM_Run(evm, contract, input, false)
  return res

## Result EVM_DelegateCall(EVM* evm, ContractRef caller, Address addr, byte* code, Hash codehash, byte* input, uint64_t gas);
## Result EVM_StaticCall(EVM* evm, ContractRef caller, Address addr, byte* code, Hash codehash, byte* input, uint64_t gas);
