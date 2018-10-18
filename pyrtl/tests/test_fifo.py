import pyrtl
import fifo

def test_initial_empty():
    pyrtl.reset_working_block()
    model = fifo.FIFO(depth_width=4)
    tracer = pyrtl.SimulationTrace()
    sim = pyrtl.Simulation(tracer=tracer)
    sim.step({
        'wr_data_i': 0,
        'wr_en_i':   0,
        'rd_en_i':   0,
        'reset'  :   1,
        })
    sim.step({
        'wr_data_i': 0,
        'wr_en_i':   0,
        'rd_en_i':   0,
        'reset'  :   0,
        })

    assert tracer.trace['empty_o'][-1] == 1, 'FIFO should be empty after reset'
    assert tracer.trace['full_o'][-1]  == 0, 'FIFO should not be full after reset'

def test_fifo_can_read_write():
    pyrtl.reset_working_block()
    model = fifo.FIFO(depth_width=1)
    tracer = pyrtl.SimulationTrace()
    sim = pyrtl.Simulation(tracer=tracer)
    sim.step({
        'wr_data_i': 0,
        'wr_en_i':   0,
        'rd_en_i':   0,
        'reset'  :   1,
        })
    for i in xrange(2):
        sim.step({
            'wr_data_i': i + 2,
            'wr_en_i':   1,
            'rd_en_i':   0,
            'reset'  :   0,
            })
    for wait_cycle in xrange(10):
        sim.step({
            'wr_data_i': 0x3,
            'wr_en_i':   0,
            'rd_en_i':   0,
            'reset'  :   0,
            })
        if tracer.trace['empty_o'][-1] == 0:
            break

    assert tracer.trace['empty_o'][-1] == 0, 'FIFO empty_o should not be empty after write'
    assert tracer.trace['full_o'][-1] == 1, 'FIFO should be full'

    sim.step({
        'wr_data_i': 0x0,
        'wr_en_i': 0,
        'rd_en_i': 1,
        'reset'  : 0
        })

    assert tracer.trace['empty_o'][-1] == 0, 'FIFO empty_o should not be empty after write'
    assert tracer.trace['full_o'][-1] == 1, 'FIFO should not be full after a read'
    assert tracer.trace['rd_data_o'][-1] == 2, 'FIFO should read the correct value'

    sim.step({
        'wr_data_i': 0x0,
        'wr_en_i': 0,
        'rd_en_i': 1,
        'reset'  : 0
        })

    assert tracer.trace['empty_o'][-1] == 0, 'FIFO empty_o should only be true in the next cycle'
    assert tracer.trace['full_o'][-1] == 0, 'FIFO should not be full after a read'
    assert tracer.trace['rd_data_o'][-1] == 3, 'FIFO should read the correct value'

    sim.step({
        'wr_data_i': 0x0,
        'wr_en_i': 0,
        'rd_en_i': 0,
        'reset'  : 0
        })

    assert tracer.trace['empty_o'][-1] == 1, 'FIFO empty_o should be true'
