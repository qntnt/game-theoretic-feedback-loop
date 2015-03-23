#!/bin/bash

$version = python --version
if (( "$version" < "Python 3.4" ))
then echo "You must have Python 3.4 or greater installed"
else [ pip install networkx && pip install matplotlib ]
