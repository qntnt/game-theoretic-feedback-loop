#!/usr/bin/env python

# This file contains the primitives defined in
# the paper "Game-Theoretic Motion Planning for Multi-Robot Control"
try:
    from ompl import base as ob
    from ompl import geometric as og
except:
    # if the ompl module is not in the PYTHONPATH assume it is installed in a
    # subdirectory of the parent directory called "py-bindings."
    from os.path import abspath, dirname, join
    import sys
    sys.path.insert(0, join(dirname(dirname(abspath(__file__))),'py-bindings'))
    from ompl import util as ou
    from ompl import base as ob
    from ompl import geometric as og

# G is a digraph with no cycles
def extend(G, x):
    '''
    V = V[i]
    '''
    return G = (V, E)

def planWithGameTheory(robots, environment):
    '''

    '''


