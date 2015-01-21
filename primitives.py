# This file contains the primitives defined in 
# the paper "Game-Theoretic Motion Planning for Multi-Robot Control"
import random

# Sample
# Description:
#   sample(A) returns a uniformly random sample from A.
#
# Arguments:
#   A = the set to sample from
def sample(A):
	return random.sample(A, 1)

# Local Steering
# Description:
#   steer(x, y) returns an intermediate state by steering x toward y.
#
# Arguments:
#   x = initial state
#   y = final state
def steer(x, y):
	return 

# Nearest Neighbor
# Description:
#   nearest(S, x) returns the state in S that is closest to x.
#
# Arguments:
#   S = a finite set
#   x = a state
def nearest(S, x):
	return

# Near Vertices
# Description:
#   nearVertices(S, x, r) returns a set of states in S that are r-close to x.
#
# Arguments:
#   S = a finite set
#   x = a state
#   r = a positive real number
def nearVertices(S, x, r):
	return 

# Path Generation
# Description:
#   pathGeneration(G) takes a digraph G and returns the set of paths from the root to the leaf vertices.
#
# Arguments:
#   G = a directed graph
def pathGeneration(G):
	return

# Collision Check of Paths
# Description:
#   collisionFreePath(p, pathSet) returns 0 if p collides with any path in pathSet.
#
# Arguments:
#   p = a path
#   pathSet = a set of paths
def collisionFreePath(p, pathSet):
	return

# Feasible Paths
# Description:
#   feasible(Ei, Oi) returns the set of paths in Ei where no path collides with any path in Oi.
#
# Arguments:
#   Ei = a set of paths
#   Oi = a set of paths
def feasible(Ei, Oi):
	return
