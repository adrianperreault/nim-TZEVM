import types
import evm, contract

proc Interpreter_NewInterpreter*(i: ptr Interpreter; evm: ptr EVM; cfg: Config) =
  i.evm = evm
  i.cfg = cfg

# proc initInterpreter*(): Interpreter =

proc Interpreter_Run*(i: ptr Interpreter; contract: ptr Contract; input: ptr byte; readOnly: bool): Result =
  var res: Result
  res.ret = nil
  res.err = nil
  inc(i.evm.depth)
  i.returnData = nil
  if contract.Code == nil:
    return res
  var op: OpCode
  # var m: ptr Memory = cast[ptr Memory](alloc(sizeof(cast[Memory](1024[]))))
  # Memory_NewMemory(m, 1024)
  # var s: ptr Stack = cast[ptr Stack](alloc(sizeof(cast[Stack](1024[]))))
  # Stack_newStack(s, 1024)
  # var callContext: ScopeContext = [m, s, contract]
  # var pc: uint64_t = 0
  # ## uint64_t pcCopy;
  # contract.Input = input
  # var steps: cint = 0
  # while true:
  #   inc(steps)
  #   if steps mod 1000 == 0 and i.evm.abort != 0:
  #     break
  #   op = Contract_GetOp(contract, pc)
  #   ## i->cfg.JumpTable = Operation_JumpTable();
  #   var operation: Operation = i.cfg.JumpTable[op]
  #   if operation.execute == nil:
  #     res.err = "ErrInvalidOpCode"
  #     ## res.err = strcat("ErrInvalidOpCode{ Opcode: " + op, "}\n");
  #     return res
  #   var sLen: cint = Stack_len(s)
  #   if sLen < operation.minS:
  #     ## char* str1 = "ErrStackUnderflow{ stackLen: " + sLen;
  #     ## 			char* str2 = ", required: " + operation.minS;
  #     ## 			res.err = strcat(strcat(str1, str2), "}\n");
  #     res.err = "ErrStackUnderflow"
  #     return res
  #   elif sLen > operation.maxS:
  #     ## char* str1 = "ErrStackOverflow{ stackLen: " + sLen;
  #     ## 			char* str2 = ", limit: " + operation.maxS;
  #     ## 			res.err = strcat(strcat(str1, str2), "}\n");
  #     res.err = "ErrStackOverflow"
  #     return res
  #   if operation.memorySize == memoryMLoad or operation.memorySize == memoryMStore or
  #       operation.memorySize == memoryMStore8 or
  #       operation.memorySize == memoryReturn:
  #     var mr: MemRes
  #     mr = operation.memorySize(s)
  #     if mr.err:
  #       res.err = "ErrGasUintOverflow"
  #       return res
  #   res = operation.execute(addr(pc), i, addr(callContext))
  #   if operation.returns:
  #     i.returnData = res.ret
  #   if res.err != nil:
  #     return res
  #   if operation.reverts:
  #     res.err = "ErrExecutionReverted"
  #     return res
  #   if operation.halts:
  #     res.err = nil
  #     return res
  #   if not operation.jumps:
  #     inc(pc)
  # res.ret = nil
  res.err = nil
  return res
