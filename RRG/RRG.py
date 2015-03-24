from networkx import *
from States import *
from math import log
from Vectors import Vector
from math import cos, sin, pi
from graphics import *

global GOAL, MAP, MAX_ITERATIONS, NUM_ROBOTS, CURRENT_ROBOT, ITERATION
global GRAPH, EDGES, GAMMA, MIN_RADIUS, DYTYPE, OBSTACLES, VERTICES, EDGES, GOAL_COST

OBSTACLES = {}
VERTICES = {}
EDGES = {}
NUM_ROBOTS = 1
CURRENT_ROBOT = 0
ITERATION = 1
MAX_ITERATIONS = 1000
GRAPHS = []
EDGES = []
GOAL_RADIUS = 10
MIN_RADIUS = 10
DYTYPE = 'point'
GOALS = []

def initMap(picture_file):
	global MAP, GAMMA
	MAP = Image(Point(0,0), picture_file)
	MAP.move(MAP.getWidth()/2, MAP.getHeight()/2)
	freeArea = 0
	for i in range(MAP.getWidth()):
		for j in range(MAP.getHeight()):
			if MAP.getPixel(i, j) != [0,0,0]:
				freeArea += 1
				temp = State(i, j)
				OBSTACLES.update({temp: False})
			else:
				temp = State(i, j)
				OBSTACLES.update({temp: True})
	GAMMA = 2*pow(1+(1/2),(1/2))* pow((freeArea/1), (1/2))

def init(width=100, height=100, robots=1, maxIterations=1000, dyType='point', goalCost=-1000, mapFile="./map.png"):
	global MAP, MAX_ITERATIONS, WINDOW, NUM_ROBOTS, CURRENT_ROBOT, ITERATION, GRAPH, GAMMA, MIN_RADIUS, DYTYPE, GOAL_COST
	global VERTICES
	initMap(mapFile)
	NUM_ROBOTS = robots
	MAX_ITERATIONS = maxIterations
	DYTYPE = dyType


	for n in range(NUM_ROBOTS):
		GRAPHS.append(Graph())
		GOALS.append(sample(MAP))
		GOALS[n].cost = goalCost
		GOAL_COST = goalCost
	for graph in GRAPHS:
		temp = sample(MAP)
		VERTICES.update({temp:1})
	GRAPH = [VERTICES, EDGES]

def output():
	#draw()
	#input("Press enter to close")
	return

def rrg():
	global GRAPHS, NUM_ROBOTS, CURRENT_ROBOT, ITERATION, MAX_ITERATIONS
	if ITERATION > MAX_ITERATIONS:
		return
	for n in range(NUM_ROBOTS):
		CURRENT_ROBOT = n
		graph = extend()
	ITERATION += 1
	return graph
		#print(nx.number_of_nodes(graph))
	
def extend():
	global MAP, ITERATION, NUM_ROBOTS, GAMMA, MIN_RADIUS, VERTICES, EDGES, GRAPH
	xRand = sample(MAP)
	xNearest = nearest(GRAPH[0], xRand)
	xNew = steer(xNearest, xRand)

	if obstacleFree(xNearest, xNew): #TODO add if obstacleFree(xNearest, xNew):
		card = len(nodes(graph))
		xNear = nearVertices(
			nodes(graph), 
			xNew, 
			min(GAMMA*pow(log(card)/card,(1/2)), MIN_RADIUS+1)
		)
		VERTICES.update({xNew:1})
		EDGES.update({xNearest:xNew})
		#graph.add_node(xNew, cost=0)
		#graph.add_edge(xNearest, xNew)
		checkGoal(xNew)
		for x in xNear:
			if obstacleFree(x, xNew) and x != xNearest: #TODO add if obstacleFree(x, xNew):
				EDGES.update({x: xNew})
				#graph.add_edge(x, xNew)
	
	graph = [VERTICES, EDGES]
	return graph

def checkGoal(s):
	global VERTICES, EDGES
	if s.dist(GOALS[CURRENT_ROBOT]) <= GOAL_RADIUS:
		VERTICES.update({GOALS[CURRENT_ROBOT]:GOAL_COST})
		EDGES.update({s:GOALS[CURRENT_ROBOT]})

# REGION PRIMITIVES

def nearest(graph, xRand):
	states = nodes(graph)
	return closest(states, xRand)
		
def steer(xNearest, xRand):
	moves = dynamics(xNearest)
	return closest(moves, xRand);

def nearVertices(vertices,xNew,r):
	xNear = []
	for x in vertices:
		if x.dist(xNew) <= r:
			xNear.append(x)
	return xNear
	
def dynamics(xNearest, radius=MIN_RADIUS):
	global DYTYPE
	moveSet = []
	if DYTYPE == 'point':
		size = 8
		for i in range(size):
			x = cos(i*2*pi/size)
			y = sin(i*2*pi/size)
			temp = xNearest.copy()
			direction = State(x, y)
			direction.position *= radius
			direction.position._set_x(float(floor(direction.position._get_x())))
			direction.position._set_y(float(floor(direction.position._get_y())))
			temp.position += direction.position
			moveSet.append(temp)
	return moveSet
	
def sample(MAP):
	x = floor(random.uniform(0,MAP.getWidth()))
	y = floor(random.uniform(0,MAP.getHeight()))
	temp = State(x, y)
	while not obstacleFree(temp, temp):
		print("Sampled into obstacle")
		x = floor(random.uniform(0,MAP.getWidth()))
		y = floor(random.uniform(0,MAP.getHeight()))
		temp = State(x, y)
	return temp
	
def obstacleFree(s1, s2):
	# for state in nx.nodes(GRAPHS[CURRENT_ROBOT]):
	# 	if s1 == s2:
	# 		return False
	if s1 not in OBSTACLES or s2 not in OBSTACLES:
		return False
		
	return not OBSTACLES[s1] and not OBSTACLES[s2]
	
if __name__ == '__main__':
	main()