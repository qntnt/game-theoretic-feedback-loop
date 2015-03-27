#!/bin/bash

py_v=$(python --version 2>&1)
echo On $py_v
echo Requires Python 3.4 or greater
pip install networkx
pip install numpy
echo To install scikits, install NumPy on this system
easy_install scikits
curl -o RRG/graphics.py http://mcsp.wartburg.edu/zelle/python/graphics.py