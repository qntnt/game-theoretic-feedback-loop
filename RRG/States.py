from Vectors import Vector
import random
from graphics import *

def sample(MAP):
	temp = State(random.uniform(0,MAP['width']), random.uniform(0,MAP['height']))
	return temp

def closest(states, state):
	xNearest = states[0]
	for node in states:
		if node.dist(state) < xNearest.dist(state):
			xNearest = node
	return xNearest
	
class State:
	def __init__(self, *args):
		if len(args) == 2:
			self.position = Vector(args[0], args[1], 0)
		elif len(args) == 1:
			self.position = args[0]
		self.point = Point(
			self.position._get_x(),
			self.position._get_y()
		)
		self.cost = 0
	
	def addToScene(self, window):
		self.circle = Circle(self.point, 3)
		self.circle.setFill('blue')
		self.circle.draw(window)	

	def copy(self):
		return State(self.position.copy())

	def dist(self, s):
		return self.position.get_distance_to(s.position)

	def __key(self):
		return (self.position, self.cost)

	def __eq__(self, rhs):
		return self.position == rhs.position and self.cost == rhs.cost

	def __hash__(self):
		return hash(self.__key())