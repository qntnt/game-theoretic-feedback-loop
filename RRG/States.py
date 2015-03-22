from Vectors import Vector
import random

def sample(MAP):
	return State(random.uniform(0,MAP['width']), random.uniform(0,MAP['height']))

def closest(states, state):
	xNearest = states[0]
	for node in states:
		if node.dist(state) < xNearest.dist(state):
			xNearest = node
	return xNearest
	
class State:
	def __init__(self, x, y):
		self.position = Vector(x, y)
		self.cost = 0
		
	def dist(self, s):
		return self.position.dist(s.position)