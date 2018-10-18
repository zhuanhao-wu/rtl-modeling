# rtl-modeling
This project illustrate the differences among:
- PyRTL 
- PyMTL
- (Mamba)

## Software Prerequisite

- Python 2.7, we use python 2.7 as some essential frameworks do not support python 3+.

## What we need

- Generating Verilog hardware code 
- The simulation process should be fast enough
- Easy to integrate testing frameworks for validation
- It should be easy to add other basic structures, for example MUXes
- It should be synthesis-friendly for FPGAs

## Methodology

Our test includes 2 types of modules:
1. A simple FIFO module to evaluate the usability
2. A recursive module

We have verilog code for these modules. 
The first step we take is to convert these modules back to Python models.
We then evaluate these python modules.

The metrics we are using are not clear at this point.

---

I will record how these 2 frameworks feel when I am developing the modules

# Comparison
1. PyMTL
- PyMTL has not been updated since half a year ago

2. PyRTL
- PyRTL is being _actively_ updated
- PyRTL has visualization for trace (e.g. used WaveDrom for waveform in jupyternotebook)


# Syntax
1. PyMTL

wires:

```
@s.combinational
def block():
  a.value = n
```

clocked block:
```
@s.posedge_clk
def block():
  a.next = n
```

Modules are organized in class

2. PyRTL
wires:

```
a <<= n
```

clocked block:

```
with pyrtl.conditional_assignment:
  state.next |= STATE_NAME
```

All wires etc are organized in a namespace that pyrtl manages (no clear concept of module)

# Infrastructure
1. PyMTL 
- latency insensitive port bundle
- The documentation for PyMTL is quite sparse
- RTL libraries

2. PyRTL
- RTL libraries

# Synthesizablility
Both framework can generate synthsizable code.

1. PyMTL
- Support RTL model with tutorial for ASIC and HLS flow

2. PyRTL
- Support area/timing estimation in Python (ASIC). But we should rely on the FPGA toolchain anyway.
- Support synthesis to simpler nets etc, provide some degrees of optimization.
- Proven ability to be used with Zynq board (with [paper](https://www.cs.ucsb.edu/~sherwood/pubs/FPL-17-pyrtl.pdf))

# Verilog Model
- Both library support import from / export to verilog

## Import
1. PyMTL requires special wrapper and certain naming convention in verilog code

2. PyRTL requires blif format to import (the output of yosys)

## Export
1. PyMTL
- PyMTL generated code is close to Python Code (with comment etc). PyMTL utilizes python syntax tree to generate verilog code
- PyMTL generated verilog code is more readable (can be mapped from python code).

2. PyRTL
- PyRTL generated code includes many temporary variables etc
- PyRTL generated code might be less relevant to python code

- PyRTL/PyMTL does not has support for hierachical model (i.e. one output file including all the modules)

# Simulation and Validation (Testing)
1. PyMTL ✅
- verilator (C++) support
- provides helper functions for testing

2. PyRTL
- Self-written simulator
- C simulation not supported by the main repo, discussion here: https://github.com/UCSBarchlab/PyRTL/issues/145
- Provide JIT fast simulation
- Only simulators and some simple functions are provided

# Documentation
1. PyMTL
- PyMTL has very limited documentation, but the library is small
- PyMTL has basic tutorials, tutorials on HLS flow and ASIC flow (I have not read the HLS flow and ASIC flow)

2. PyRTL 
- The PyRTL documentation seems to be more comprehensive and formal

# Installation
1. PyMTL
- PyMTL should be installed through github

2. PyRTL ✅
- PyRTL seems to be more like a standard python package

