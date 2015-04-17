from Vectors import Vector
import random
from helper.graphics import *
from math import floor

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

	def __str__(self):
		return '[ '+str(self.position._get_x())+', '+str(self.position._get_y())+', '+str(self.cost)+' ]'

	def __key(self):
		return (self.position)

	def __eq__(self, rhs):
		if self is None or rhs is None:
			return False
		return self.position == rhs.position

	def __hash__(self):
		return hash(self.__key())
