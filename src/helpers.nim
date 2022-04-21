converter toAddress*(x: cstring|string): Address = Address(addy: cstring x)
template UPPER_P*(x: untyped): untyped = x.elements[0]
template LOWER_P*(x: untyped): untyped = x.elements[1]
template UPPER*(x: untyped)  : untyped = x.elements[0]
template LOWER*(x: untyped)  : untyped = x.elements[1]
