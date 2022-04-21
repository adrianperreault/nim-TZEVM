import
  opcode

var 

  ##  0x0 range - arithmetic ops.
  
  STOP*          : OpCode = 0x00000000
  ADD*           : OpCode = 0x00000001
  MUL*           : OpCode = 0x00000002
  SUB*           : OpCode = 0x00000003
  DIV*           : OpCode = 0x00000004
  SDIV*          : OpCode = 0x00000005
  MOD*           : OpCode = 0x00000006
  SMOD*          : OpCode = 0x00000007
  ADDMOD*        : OpCode = 0x00000008
  MULMOD*        : OpCode = 0x00000009
  EXP*           : OpCode = 0x0000000A
  SIGNEXTEND*    : OpCode = 0x0000000B

  ##  0x10 range - comparison ops.

  LT*            : OpCode = 0x00000010
  GT*            : OpCode = 0x00000011
  SLT*           : OpCode = 0x00000012
  SGT*           : OpCode = 0x00000013
  EQ*            : OpCode = 0x00000014
  ISZERO*        : OpCode = 0x00000015
  AND*           : OpCode = 0x00000016
  OR*            : OpCode = 0x00000017
  XOR*           : OpCode = 0x00000018
  NOT*           : OpCode = 0x00000019
  BYTE*          : OpCode = 0x0000001A
  SHL*           : OpCode = 0x0000001B
  SHR*           : OpCode = 0x0000001C
  SAR*           : OpCode = 0x0000001D
  SHA3*          : OpCode = 0x00000020

  ##  0x30 range - closure state.

  ADDRESS*       : OpCode = 0x00000030
  BALANCE*       : OpCode = 0x00000031
  ORIGIN*        : OpCode = 0x00000032
  CALLER*        : OpCode = 0x00000033
  CALLVALUE*     : OpCode = 0x00000034
  CALLDATALOAD*  : OpCode = 0x00000035
  CALLDATASIZE*  : OpCode = 0x00000036
  CALLDATACOPY*  : OpCode = 0x00000037
  CODESIZE*      : OpCode = 0x00000038
  CODECOPY*      : OpCode = 0x00000039
  GASPRICE*      : OpCode = 0x0000003A
  EXTCODESIZE*   : OpCode = 0x0000003B
  EXTCODECOPY*   : OpCode = 0x0000003C
  RETURNDATASIZE*: OpCode = 0x0000003D
  RETURNDATACOPY*: OpCode = 0x0000003E
  EXTCODEHASH*   : OpCode = 0x0000003F

  ##  0x40 range - block operations.

  BLOCKHASH*     : OpCode = 0x00000040
  COINBASE*      : OpCode = 0x00000041
  TIMESTAMP*     : OpCode = 0x00000042
  NUMBER*        : OpCode = 0x00000043
  DIFFICULTY*    : OpCode = 0x00000044
  GASLIMIT*      : OpCode = 0x00000045
  CHAINID*       : OpCode = 0x00000046
  SELFBALANCE*   : OpCode = 0x00000047

  ##  0x50 range - 'storage' and execution.

  POP*           : OpCode = 0x00000050
  MLOAD*         : OpCode = 0x00000051
  MSTORE*        : OpCode = 0x00000052
  MSTORE8*       : OpCode = 0x00000053
  SLOAD*         : OpCode = 0x00000054
  SSTORE*        : OpCode = 0x00000055
  JUMP*          : OpCode = 0x00000056
  JUMPI*         : OpCode = 0x00000057
  PC*            : OpCode = 0x00000058
  MSIZE*         : OpCode = 0x00000059
  GAS*           : OpCode = 0x0000005A
  JUMPDEST*      : OpCode = 0x0000005B

  ##  0x60 range.

  PUSH1*         : OpCode = 0x00000060
  PUSH2*         : OpCode = 0x00000061
  PUSH3*         : OpCode = 0x00000062
  PUSH4*         : OpCode = 0x00000063
  PUSH5*         : OpCode = 0x00000064
  PUSH6*         : OpCode = 0x00000065
  PUSH7*         : OpCode = 0x00000066
  PUSH8*         : OpCode = 0x00000067
  PUSH9*         : OpCode = 0x00000068
  PUSH10*        : OpCode = 0x00000069
  PUSH11*        : OpCode = 0x0000006A
  PUSH12*        : OpCode = 0x0000006B
  PUSH13*        : OpCode = 0x0000006C
  PUSH14*        : OpCode = 0x0000006D
  PUSH15*        : OpCode = 0x0000006E
  PUSH16*        : OpCode = 0x0000006F
  PUSH17*        : OpCode = 0x00000070
  PUSH18*        : OpCode = 0x00000071
  PUSH19*        : OpCode = 0x00000072
  PUSH20*        : OpCode = 0x00000073
  PUSH21*        : OpCode = 0x00000074
  PUSH22*        : OpCode = 0x00000075
  PUSH23*        : OpCode = 0x00000076
  PUSH24*        : OpCode = 0x00000077
  PUSH25*        : OpCode = 0x00000078
  PUSH26*        : OpCode = 0x00000079
  PUSH27*        : OpCode = 0x0000007A
  PUSH28*        : OpCode = 0x0000007B
  PUSH29*        : OpCode = 0x0000007C
  PUSH30*        : OpCode = 0x0000007D
  PUSH31*        : OpCode = 0x0000007E
  PUSH32*        : OpCode = 0x0000007F
  DUP1*          : OpCode = 0x00000080
  DUP2*          : OpCode = 0x00000081
  DUP3*          : OpCode = 0x00000082
  DUP4*          : OpCode = 0x00000083
  DUP5*          : OpCode = 0x00000084
  DUP6*          : OpCode = 0x00000085
  DUP7*          : OpCode = 0x00000086
  DUP8*          : OpCode = 0x00000087
  DUP9*          : OpCode = 0x00000088
  DUP10*         : OpCode = 0x00000089
  DUP11*         : OpCode = 0x0000008A
  DUP12*         : OpCode = 0x0000008B
  DUP13*         : OpCode = 0x0000008C
  DUP14*         : OpCode = 0x0000008D
  DUP15*         : OpCode = 0x0000008E
  DUP16*         : OpCode = 0x0000008F
  SWAP1*         : OpCode = 0x00000090
  SWAP2*         : OpCode = 0x00000091
  SWAP3*         : OpCode = 0x00000092
  SWAP4*         : OpCode = 0x00000093
  SWAP5*         : OpCode = 0x00000094
  SWAP6*         : OpCode = 0x00000095
  SWAP7*         : OpCode = 0x00000096
  SWAP8*         : OpCode = 0x00000097
  SWAP9*         : OpCode = 0x00000098
  SWAP10*        : OpCode = 0x00000099
  SWAP11*        : OpCode = 0x0000009A
  SWAP12*        : OpCode = 0x0000009B
  SWAP13*        : OpCode = 0x0000009C
  SWAP14*        : OpCode = 0x0000009D
  SWAP15*        : OpCode = 0x0000009E
  SWAP16*        : OpCode = 0x0000009F

  ##  0xa0 range - logging ops.

  LOG0*          : OpCode = 0x000000A0
  LOG1*          : OpCode = 0x000000A1
  LOG2*          : OpCode = 0x000000A2
  LOG3*          : OpCode = 0x000000A3
  LOG4*          : OpCode = 0x000000A4

  ##  unofficial opcodes used for parsing.

  PUSH*          : OpCode = 0x000000B0
  DUP*           : OpCode = 0x000000B1
  SWAP*          : OpCode = 0x000000B2

  ##  0xf0 range - closures.

  CREATE*        : OpCode = 0x000000F0
  CALL*          : OpCode = 0x000000F1
  CALLCODE*      : OpCode = 0x000000F2
  RETURN*        : OpCode = 0x000000F3
  DELEGATECALL*  : OpCode = 0x000000F4
  CREATE2*       : OpCode = 0x000000F5
  STATICCALL*    : OpCode = 0x000000FA
  REVERT*        : OpCode = 0x000000FD
  SELFDESTRUCT*  : OpCode = 0x000000FF

proc OpCode_IsPush*(op: OpCode): bool =
  var iop: cint = op - 0x00000000
  if iop >= 96 and iop <= 127:
    return true
  else:
    return false

proc OpCode_IsStaticJump*(op: OpCode): bool =
  return op == JUMP

proc OpCode_String*(op: OpCode): cstring =
  case op - 0x00000000
  of 0:
    return "STOP"
  of 1:
    return "ADD"
  of 2:
    return "MUL"
  of 3:
    return "SUB"
  of 4:
    return "DIV"
  of 5:
    return "SDIV"
  of 6:
    return "MOD"
  of 7:
    return "SMOD"
  of 8:
    return "ADDMOD"
  of 9:
    return "MULMOD"
  of 10:
    return "EXP"
  of 11:
    return "SIGNEXTEND"
  of 16:
    return "LT"
  of 17:
    return "GT"
  of 18:
    return "SLT"
  of 19:
    return "SGT"
  of 20:
    return "EQ"
  of 21:
    return "ISZERO"
  of 22:
    return "AND"
  of 23:
    return "OR"
  of 24:
    return "XOR"
  of 25:
    return "NOT"
  of 26:
    return "BYTE"
  of 27:
    return "SHL"
  of 28:
    return "SHR"
  of 29:
    return "SAR"
  of 32:
    return "SHA3"
  of 48:
    return "ADDRESS"
  of 49:
    return "BALANCE"
  of 50:
    return "ORIGIN"
  of 51:
    return "CALLER"
  of 52:
    return "CALLVALUE"
  of 53:
    return "CALLDATALOAD"
  of 54:
    return "CALLDATASIZE"
  of 55:
    return "CALLDATACOPY"
  of 56:
    return "CODESIZE"
  of 57:
    return "CODECOPY"
  of 58:
    return "GASPRICE"
  of 59:
    return "EXTCODESIZE"
  of 60:
    return "EXTCODECOPY"
  of 61:
    return "RETURNDATASIZE"
  of 62:
    return "RETURNDATACOPY"
  of 63:
    return "EXTCODEHASH"
  of 64:
    return "BLOCKHASH"
  of 65:
    return "COINBASE"
  of 66:
    return "TIMESTAMP"
  of 67:
    return "NUMBER"
  of 68:
    return "DIFFICULTY"
  of 69:
    return "GASLIMIT"
  of 70:
    return "CHAINID"
  of 71:
    return "SELFBALANCE"
  of 80:
    return "POP"
  of 81:
    return "MLOAD"
  of 82:
    return "MSTORE"
  of 83:
    return "MSTORE8"
  of 84:
    return "SLOAD"
  of 85:
    return "SSTORE"
  of 86:
    return "JUMP"
  of 87:
    return "JUMPI"
  of 88:
    return "PC"
  of 89:
    return "MSIZE"
  of 90:
    return "GAS"
  of 91:
    return "JUMPDEST"
  of 96:
    return "PUSH1"
  of 97:
    return "PUSH2"
  of 98:
    return "PUSH3"
  of 99:
    return "PUSH4"
  of 100:
    return "PUSH5"
  of 101:
    return "PUSH6"
  of 102:
    return "PUSH7"
  of 103:
    return "PUSH8"
  of 104:
    return "PUSH9"
  of 105:
    return "PUSH10"
  of 106:
    return "PUSH11"
  of 107:
    return "PUSH12"
  of 108:
    return "PUSH13"
  of 109:
    return "PUSH14"
  of 110:
    return "PUSH15"
  of 111:
    return "PUSH16"
  of 112:
    return "PUSH17"
  of 113:
    return "PUSH18"
  of 114:
    return "PUSH19"
  of 115:
    return "PUSH20"
  of 116:
    return "PUSH21"
  of 117:
    return "PUSH22"
  of 118:
    return "PUSH23"
  of 119:
    return "PUSH24"
  of 120:
    return "PUSH25"
  of 121:
    return "PUSH26"
  of 122:
    return "PUSH27"
  of 123:
    return "PUSH28"
  of 124:
    return "PUSH29"
  of 125:
    return "PUSH30"
  of 126:
    return "PUSH31"
  of 127:
    return "PUSH32"
  of 128:
    return "DUP1"
  of 129:
    return "DUP2"
  of 130:
    return "DUP3"
  of 131:
    return "DUP4"
  of 132:
    return "DUP5"
  of 133:
    return "DUP6"
  of 134:
    return "DUP7"
  of 135:
    return "DUP8"
  of 136:
    return "DUP9"
  of 137:
    return "DUP10"
  of 138:
    return "DUP11"
  of 139:
    return "DUP12"
  of 140:
    return "DUP13"
  of 141:
    return "DUP14"
  of 142:
    return "DUP15"
  of 143:
    return "DUP16"
  of 144:
    return "SWAP1"
  of 145:
    return "SWAP2"
  of 146:
    return "SWAP3"
  of 147:
    return "SWAP4"
  of 148:
    return "SWAP5"
  of 149:
    return "SWAP6"
  of 150:
    return "SWAP7"
  of 151:
    return "SWAP8"
  of 152:
    return "SWAP9"
  of 153:
    return "SWAP10"
  of 154:
    return "SWAP11"
  of 155:
    return "SWAP12"
  of 156:
    return "SWAP13"
  of 157:
    return "SWAP14"
  of 158:
    return "SWAP15"
  of 159:
    return "SWAP16"
  of 160:
    return "LOG0"
  of 161:
    return "LOG1"
  of 162:
    return "LOG2"
  of 163:
    return "LOG3"
  of 164:
    return "LOG4"
  of 176:
    return "PUSH"
  of 177:
    return "DUP"
  of 178:
    return "SWAP"
  of 240:
    return "CREATE"
  of 241:
    return "CALL"
  of 242:
    return "CALLCODE"
  of 243:
    return "RETURN"
  of 244:
    return "DELEGATECALL"
  of 245:
    return "CREATE2"
  of 250:
    return "STATICCALL"
  of 253:
    return "REVERT"
  of 255:
    return "SELFDESTRUCT"
  else:
    return "Opcode not defined"

proc OpCode_StringToOp*(str: cstring): OpCode =
  if str == "STOP":
    return STOP
  elif str == "ADD":
    return ADD
  elif str == "MUL":
    return MUL
  elif str == "SUB":
    return SUB
  elif str == "DIV":
    return DIV
  elif str == "SDIV":
    return SDIV
  elif str == "MOD":
    return MOD
  elif str == "SMOD":
    return SMOD
  elif str == "ADDMOD":
    return ADDMOD
  elif str == "MULMOD":
    return MULMOD
  elif str == "EXP":
    return EXP
  elif str == "SIGNEXTEND":
    return SIGNEXTEND
  elif str == "LT":
    return LT
  elif str == "GT":
    return GT
  elif str == "SLT":
    return SLT
  elif str == "SGT":
    return SGT
  elif str == "EQ":
    return EQ
  elif str == "ISZERO":
    return ISZERO
  elif str == "AND":
    return AND
  elif str == "OR":
    return OR
  elif str == "XOR":
    return XOR
  elif str == "NOT":
    return NOT
  elif str == "BYTE":
    return BYTE
  elif str == "SHL":
    return SHL
  elif str == "SHR":
    return SHR
  elif str == "SAR":
    return SAR
  elif str == "SHA3":
    return SHA3
  elif str == "ADDRESS":
    return ADDRESS
  elif str == "BALANCE":
    return BALANCE
  elif str == "ORIGIN":
    return ORIGIN
  elif str == "CALLER":
    return CALLER
  elif str == "CALLVALUE":
    return CALLVALUE
  elif str == "CALLDATALOAD":
    return CALLDATALOAD
  elif str == "CALLDATASIZE":
    return CALLDATASIZE
  elif str == "CALLDATACOPY":
    return CALLDATACOPY
  elif str == "CODESIZE":
    return CODESIZE
  elif str == "CODECOPY":
    return CODECOPY
  elif str == "GASPRICE":
    return GASPRICE
  elif str == "EXTCODESIZE":
    return EXTCODESIZE
  elif str == "EXTCODECOPY":
    return EXTCODECOPY
  elif str == "RETURNDATASIZE":
    return RETURNDATASIZE
  elif str == "RETURNDATACOPY":
    return RETURNDATACOPY
  elif str == "EXTCODEHASH":
    return EXTCODEHASH
  elif str == "BLOCKHASH":
    return BLOCKHASH
  elif str == "COINBASE":
    return COINBASE
  elif str == "TIMESTAMP":
    return TIMESTAMP
  elif str == "NUMBER":
    return NUMBER
  elif str == "DIFFICULTY":
    return DIFFICULTY
  elif str == "GASLIMIT":
    return GASLIMIT
  elif str == "CHAINID":
    return CHAINID
  elif str == "SELFBALANCE":
    return SELFBALANCE
  elif str == "POP":
    return POP
  elif str == "MLOAD":
    return MLOAD
  elif str == "MSTORE":
    return MSTORE
  elif str == "MSTORE8":
    return MSTORE8
  elif str == "SLOAD":
    return SLOAD
  elif str == "SSTORE":
    return SSTORE
  elif str == "JUMP":
    return JUMP
  elif str == "JUMPI":
    return JUMPI
  elif str == "PC":
    return PC
  elif str == "MSIZE":
    return MSIZE
  elif str == "GAS":
    return GAS
  elif str == "JUMPDEST":
    return JUMPDEST
  elif str == "PUSH1":
    return PUSH1
  elif str == "PUSH2":
    return PUSH2
  elif str == "PUSH3":
    return PUSH3
  elif str == "PUSH4":
    return PUSH4
  elif str == "PUSH5":
    return PUSH5
  elif str == "PUSH6":
    return PUSH6
  elif str == "PUSH7":
    return PUSH7
  elif str == "PUSH8":
    return PUSH8
  elif str == "PUSH9":
    return PUSH9
  elif str == "PUSH10":
    return PUSH10
  elif str == "PUSH11":
    return PUSH11
  elif str == "PUSH12":
    return PUSH12
  elif str == "PUSH13":
    return PUSH13
  elif str == "PUSH14":
    return PUSH14
  elif str == "PUSH15":
    return PUSH15
  elif str == "PUSH16":
    return PUSH16
  elif str == "PUSH17":
    return PUSH17
  elif str == "PUSH18":
    return PUSH18
  elif str == "PUSH19":
    return PUSH19
  elif str == "PUSH20":
    return PUSH20
  elif str == "PUSH21":
    return PUSH21
  elif str == "PUSH22":
    return PUSH22
  elif str == "PUSH23":
    return PUSH23
  elif str == "PUSH24":
    return PUSH24
  elif str == "PUSH25":
    return PUSH25
  elif str == "PUSH26":
    return PUSH26
  elif str == "PUSH27":
    return PUSH27
  elif str == "PUSH28":
    return PUSH28
  elif str == "PUSH29":
    return PUSH29
  elif str == "PUSH30":
    return PUSH30
  elif str == "PUSH31":
    return PUSH31
  elif str == "PUSH32":
    return PUSH32
  elif str == "DUP1":
    return DUP1
  elif str == "DUP2":
    return DUP2
  elif str == "DUP3":
    return DUP3
  elif str == "DUP4":
    return DUP4
  elif str == "DUP5":
    return DUP5
  elif str == "DUP6":
    return DUP6
  elif str == "DUP7":
    return DUP7
  elif str == "DUP8":
    return DUP8
  elif str == "DUP9":
    return DUP9
  elif str == "DUP10":
    return DUP10
  elif str == "DUP11":
    return DUP11
  elif str == "DUP12":
    return DUP12
  elif str == "DUP13":
    return DUP13
  elif str == "DUP14":
    return DUP14
  elif str == "DUP15":
    return DUP15
  elif str == "DUP16":
    return DUP16
  elif str == "SWAP1":
    return SWAP1
  elif str == "SWAP2":
    return SWAP2
  elif str == "SWAP3":
    return SWAP3
  elif str == "SWAP4":
    return SWAP4
  elif str == "SWAP5":
    return SWAP5
  elif str == "SWAP6":
    return SWAP6
  elif str == "SWAP7":
    return SWAP7
  elif str == "SWAP8":
    return SWAP8
  elif str == "SWAP9":
    return SWAP9
  elif str == "SWAP10":
    return SWAP10
  elif str == "SWAP11":
    return SWAP11
  elif str == "SWAP12":
    return SWAP12
  elif str == "SWAP13":
    return SWAP13
  elif str == "SWAP14":
    return SWAP14
  elif str == "SWAP15":
    return SWAP15
  elif str == "SWAP16":
    return SWAP16
  elif str == "LOG0":
    return LOG0
  elif str == "LOG1":
    return LOG1
  elif str == "LOG2":
    return LOG2
  elif str == "LOG3":
    return LOG3
  elif str == "LOG4":
    return LOG4
  elif str == "PUSH":
    return PUSH
  elif str == "DUP":
    return DUP
  elif str == "SWAP":
    return SWAP
  elif str == "CREATE":
    return CREATE
  elif str == "CALL":
    return CALL
  elif str == "CALLCODE":
    return CALLCODE
  elif str == "RETURN":
    return RETURN
  elif str == "DELEGATECALL":
    return DELEGATECALL
  elif str == "CREATE2":
    return CREATE2
  elif str == "STATICCALL":
    return STATICCALL
  elif str == "REVERT":
    return REVERT
  elif str == "SELFDESTRUCT":
    return SELFDESTRUCT
  else:
    return "Opcode not defined"
