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
- The documentation for PyMTL is quite sparse
- we need to be explicit about using builtins (instead of using `def` blocks).
- We can also use `Wire` in synchronous clock
- PyMTL has not been updated since half years ago

2. PyRTL
- PyRTL is currently actively developed
- PyRTL has visualization for trace (e.g. used WaveDrom for waveform in jupyternotebook)

# Grammar

# Infrastructure

# Synthesizablility
1. PyMTL

2. PyRTL

# Verilog Model
- Both support import from / export to verilog

## Import
- PyRTL requires blif format to import
- PyMTL requires special wrapper and certain naming convention

## Export
- PyMTL generated code is close to Python Code (with comment etc). PyMTL utilizes python syntax tree to generate verilog code
- PyRTL generated code includes temporary variables etc.
- PyRTL does not has support for hierachical model.

# Simulation
1. PyMTL
- verilator (C++) support

2. PyRTL
- Self-written simulator
- C simulation not supported by the main repo, discussion here: https://github.com/UCSBarchlab/PyRTL/issues/145

# Documentation
1. PyMTL
- PyMTL has very limited documentation, but the library is small
- PyMTL has basic tutorials, tutorials on HLS flow and ASIC flow (I have not read the HLS flow and ASIC flow)

2. PyRTL
- The PyRTL documentation seems to be more comprehensive

# Installation
1. PyMTL
- PyMTL should be installed through github

2. PyRTL ✅
- PyRTL seems to be more like a standard python package

