from __future__ import print_function
from __future__ import division

import os
from argparse import ArgumentParser

import pymtl
import shutil

VERILOG_DIRECTORY='./v'
FLOWS = ('translate', 'synthesis', 'report', 'clean')

def get_arguments():
    parser = ArgumentParser(description='PyMTL FPGA Flow')
    parser.add_argument('--v_dir', type=str, default=VERILOG_DIRECTORY, 
            help='The folder for verilog code')
    parser.add_argument('--module', nargs='+', help='Indicate the modules to be involved')
    parser.add_argument('flow_name', type=str, metavar='FLOW', choices=FLOWS, 
            help='which flow to use, possible phases: %(choices)s')

    return parser.parse_args()

def get_py_module_name(mod):
    py_module_name = mod[:mod.index('.')]
    return py_module_name

def translate(args):
    if os.path.exists(args.v_dir):
        shutil.rmtree(args.v_dir)
    os.mkdir(args.v_dir)

    mod_name = args.module[0]
    py_mod_name = get_py_module_name(mod_name)
    exec('import {}'.format(py_mod_name))

    exec('mod_inst = {}(depth_width=2)'.format(mod_name))

    _ = pymtl.TranslationTool(mod_inst)

    file_list = [ '{}.v', '{}_v.cpp', '{}_v.py', 'lib{}_v.so', 'obj_dir_{}' ]
    for i in xrange(len(file_list)):
        file_list[i] = file_list[i].format(mod_inst.class_name)

    for f in file_list:
        shutil.move(f, args.v_dir)


def main():
    args = get_arguments()

    if args.flow_name == 'translate':
        translate(args)

    
    
if __name__ == '__main__':
    main()
