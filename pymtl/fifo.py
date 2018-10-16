from __future__ import print_function
from __future__ import division

import pymtl
from pclib.rtl import Reg, RegEnRst, Adder

class _RAM(pymtl.Model):
    '''
    RAM module used inside FIFO
    '''

    def __init__(s, num_entries, data_nbits, reset_value = 0):
        s.addr_nbits = pymtl.clog2(num_entries)
        s.reset_value = reset_value
        s.num_entries = num_entries
        s.data_nbits  = data_nbits

        # Control
        s.wen    = pymtl.InPort  (1)              # Write enable
        s.ren    = pymtl.InPort  (1)              # Read enable
        s.waddr  = pymtl.InPort  (s.addr_nbits)   # Address
        s.raddr  = pymtl.InPort  (s.addr_nbits)   # Address
        s.wdata  = pymtl.InPort  (s.data_nbits)   # Write data
        s.rdata  = pymtl.OutPort (s.data_nbits)   # Read  data

        # Memory
        s.mem = [ pymtl.Wire(s.data_nbits) for _ in xrange(s.num_entries) ]

    def elaborate_logic(s):
        @s.combinational
        def comb_logic():
            s.rdata.value = s.mem[ s.raddr ]

        @s.posedge_clk
        def seq_logic():
            if s.reset:
                for i in xrange(s.num_entries):
                    s.mem[i].next = s.reset_value
            elif s.wen:
                s.mem[s.waddr].next = s.wdata

class FIFO(pymtl.Model):
    '''
    A FIFO unit using PyMTL
    '''

    def __init__(s, depth_width=32, data_width=32):
        # constants
        aw = depth_width
        dw = data_width

        s.wr_data_i = pymtl.InPort(data_width)
        s.wr_en_i   = pymtl.InPort(1)
        s.rd_data_o = pymtl.OutPort(data_width)
        s.rd_en_i   = pymtl.InPort(1)
        s.full_o    = pymtl.OutPort(1)
        s.empty_o   = pymtl.OutPort(1)
        s.one_left  = pymtl.OutPort(1)

        s.write_pointer = pymtl.Wire(aw + 1)
        s.read_pointer  = RegEnRst(aw + 1, 0)

        s.read_plus_1 = Adder(aw + 1)
        s.connect_pairs(
            s.read_plus_1.in0, 1,
            s.read_plus_1.in1, s.read_pointer.out,
            s.read_pointer.en, s.rd_en_i,
            s.read_pointer.in_, s.read_plus_1.out
        )

        s.empty_int     = pymtl.Wire(1)
        s.full_or_empty = pymtl.Wire(1)

        s.mem_data_out  = pymtl.Wire(data_width)


        s.mem = m = _RAM(num_entries=1 << aw, data_nbits=data_width)
        s.connect_dict({
            m.wen:   s.wr_en_i,
            m.ren:   s.rd_en_i,
            m.raddr:  s.read_pointer.out[0:aw],
            m.waddr:  s.write_pointer[0:aw],
            m.wdata: s.wr_data_i,
            m.rdata: s.mem_data_out
        })

        # wire assigment
        @s.combinational
        def block_comb():
            s.empty_int.value     = s.write_pointer[aw] == s.read_pointer.out[aw]
            s.full_or_empty.value = s.write_pointer[:aw] == s.read_pointer.out[:aw]
            s.full_o.value        = s.full_or_empty & ~s.empty_int
            s.empty_o.value       = s.full_or_empty & s.empty_int
            s.one_left.value      = (s.read_pointer.out + 1) == s.write_pointer
            s.rd_data_o.value     = s.mem_data_out if s.rd_en_i else 0

        # read write pointer logic
        @s.tick_rtl
        def block_sync():
            if s.reset:
                s.write_pointer.next = 0
            if s.wr_en_i:
                s.write_pointer.next = s.write_pointer + 1
