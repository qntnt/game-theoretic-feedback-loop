from math import sqrt, pow

class Vector:
	def __init__(self, x, y):
		self.x = x
		self.y = y
		
	def dist(self, v):
		return sqrt(pow(abs(self.x - v.x), 2) + pow(abs(self.y-v.y), 2))
