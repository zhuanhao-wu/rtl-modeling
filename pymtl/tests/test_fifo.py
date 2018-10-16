import pymtl
import pclib
import fifo

def test_initial_empty():
    model = fifo.FIFO(depth_width=4)
    model.elaborate()

    sim = pymtl.SimulationTool(model)
    sim.reset()

    sim.cycle()

    assert model.empty_o.value == 1, 'FIFO should be empty after reset'
    assert model.full_o.value == 0, 'FIFO should not be full after reset'

def test_fifo_can_write():
    # what does this depth width mean
    model = fifo.FIFO(depth_width=1) # highset bit
    model.elaborate()

    sim = pymtl.SimulationTool(model)
    sim.reset()

    sim.cycle()

    model.wr_data_i.value = 0x3
    model.wr_en_i.value = 1
    sim.cycle()
    sim.cycle()

    model.wr_en_i.value = 0
    for wait_cycle in xrange(10):
        if model.empty_o.value == 0:
            break;
        else:
            sim.cycle()

    assert model.empty_o.value == 0, 'FIFO empty_o should not be empty after write'
    assert model.full_o.value == 1, 'FIFO full_o should be full after write to a 1 element FIFO'
