import pyrtl
import pyrtl.rtllib.adders

# only using clog2 utilies from pymtl
from pymtl import clog2

class _RAM(object):
    '''
    RAM module used inside FIFO
    '''
    def __init__(self, num_entries, data_nbits, reset_value=0, name=u''):
        self.addr_nbits = clog2(num_entries)
        self.reset_value = reset_value
        self.num_entries = num_entries
        self.data_nbits = data_nbits

        self.mem = pyrtl.MemBlock(bitwidth=data_nbits, 
                                  addrwidth=self.addr_nbits, 
                                  name='_RAM_'+name,
                                  asynchronous=False)

        self.wen   = pyrtl.WireVector (1, 'wen')
        self.ren   = pyrtl.WireVector (1, 'ren')
        self.waddr = pyrtl.WireVector (self.addr_nbits, 'waddr')
        self.raddr = pyrtl.WireVector (self.addr_nbits, 'raddr')
        self.wdata = pyrtl.WireVector (self.data_nbits, 'wdata')
        self.rdata = pyrtl.WireVector (self.data_nbits, 'rdata')

        self.rdata <<= pyrtl.select(self.ren, 
                                    truecase=self.mem[self.raddr], 
                                    falsecase=pyrtl.Const(0, 32))
        self.mem[self.waddr] <<= pyrtl.MemBlock.EnabledWrite(self.wdata, self.wen)

class FIFO(object):
    '''
    A FIFO unit using PyRTL
    '''

    def __init__(self, depth_width=2, data_width=32):
        aw = depth_width
        dw = data_width

        self.wr_data_i = pyrtl.Input(dw, 'wr_data_i')
        self.wr_en_i   = pyrtl.Input(1, 'wr_en_i')
        self.rd_data_o = pyrtl.Output(dw, 'rd_data_o')
        self.rd_en_i   = pyrtl.Input(1, 'rd_en_i')
        self.full_o    = pyrtl.Output(1, 'full_o')
        self.empty_o   = pyrtl.Output(1, 'empty_o')
        self.one_left  = pyrtl.Output(1, 'one_left')

        self.reset     = pyrtl.Input(1, 'reset')

        self.write_pointer = pyrtl.Register(aw + 1, 'write_pointer')
        self.read_pointer  = pyrtl.Register(aw + 1, 'read_pointer')

        self.read_plus_1 = pyrtl.rtllib.adders.kogge_stone(pyrtl.Const(1, 1), self.read_pointer)
        self.read_pointer.next <<= pyrtl.select(self.rd_en_i, 
                                          truecase=self.read_plus_1,
                                          falsecase=self.read_pointer)

        self.write_pointer.next  <<= pyrtl.select(self.reset,
                                                  truecase=pyrtl.Const(0, aw + 1),
                                                  falsecase=
                                                    pyrtl.select(self.wr_en_i,
                                                                 truecase=self.write_pointer + 1,
                                                                 falsecase=self.write_pointer))

        self.empty_int     = pyrtl.WireVector(1, 'empty_int')
        self.full_or_empty = pyrtl.WireVector(1, 'full_or_empty')

        self.empty_int <<= self.write_pointer[aw] == self.read_pointer[aw]
        self.full_or_empty <<= self.write_pointer[0:aw] == self.read_pointer[0:aw]
        self.full_o <<= self.full_or_empty & ~self.empty_int
        self.empty_o <<= self.full_or_empty & self.empty_int
        self.one_left <<= (self.read_pointer + 1) == self.write_pointer

        self.mem = m = _RAM(num_entries=1 << aw, data_nbits=dw, name='FIFOStorage')
        m.wen <<= self.wr_en_i
        m.ren <<= self.rd_en_i
        m.raddr <<= self.read_pointer[0:aw]
        m.waddr <<= self.write_pointer[0:aw]
        m.wdata <<= self.wr_data_i
        self.rd_data_o <<= pyrtl.select(self.rd_en_i,
                                  truecase=m.rdata,
                                  falsecase=pyrtl.Const(0, dw))
