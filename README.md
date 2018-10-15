# rtl-modeling
This project illustrate the differences between PyRTL and PyMTL in terms of modeling

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

The metrics we are using are not clear at this point.
