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

# Documenttation
1. PyMTL
- The documentation for PyMTL is quite sparse
- we need to be explicit about using builtins (instead of using `def` blocks).
- We can also use `Wire` in synchronous clock
- PyMTL has not been updated since half years ago

2. PyRTL
- PyRTL is currently actively developed
