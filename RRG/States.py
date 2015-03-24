from Vectors import Vector
import random
from graphics import *
from math import floor
	
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
		self.cost = 1
	
	def addToScene(self, window):
		self.circle = Circle(self.point, 1)
		self.circle.setFill('blue')
		self.circle.setOutline('blue')
		self.circle.draw(window)	

	def copy(self):
		return State(self.position.copy())

	def dist(self, s):
		return self.position.get_distance_to(s.position)

	def __key(self):
		return (self.position)

	def __eq__(self, rhs):
		return self.position == rhs.position

	def __hash__(self):
		return hash(self.__key())