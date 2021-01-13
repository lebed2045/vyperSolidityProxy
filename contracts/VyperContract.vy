a: public(address)
b: public(bool)
c: public(uint256)

@external
def __init__(_a: address,):
    self.a = _a
    self.c = block.timestamp + 2

@external
def set_b_true():
    self.b = True

@external
def set_a_dai():
    self.a = 0xC1c3015E10BB7dED5bA72ED0F5948Ca08715407d

@external
def set_c_big():
    self.c = 100500