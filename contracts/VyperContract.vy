a: public(address)
b: public(bool)
c: public(uint256)


@external
def __init__(
    _a: address,
):
    self.a = _a
    self.c = block.timestamp + 2


@external
def set_b_true():
    self.b = True