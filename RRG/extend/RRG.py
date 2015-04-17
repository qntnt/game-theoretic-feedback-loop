from networkx import *
from env_classes.States import *
from math import log
from math import cos, sin, pi
from helper.logging import *
import matplotlib.image as mpimg

global MAP, GAMMA, MIN_RADIUS, DYTYPE, OBSTACLES, GOAL_RADIUS, FREE_AREA, DIMENSIONS, LOG

# GRAPH is of the form { State : [] } where [] is a set of States it moves to

def initMAP(map):
	global MAP, GAMMA, OBSTACLES, DIMENSIONS
	MAP = map
	DIMENSIONS = {'width': len(MAP), 'height':len(MAP[0])}
	print(map)
	OBSTACLES = {}
	FREE_AREA = 0
	for i in range(len(MAP)):
		for j in range(len(MAP[0])):
			if MAP[i][j] != [0,0,0]:
				FREE_AREA += 1
				temp = State(i, j)
				OBSTACLES.update({temp: False})
			else:
				temp = State(i, j)
				OBSTACLES.update({temp: True})
	GAMMA = 2*pow(1+(1/len(DIMENSIONS)),(1/len(DIMENSIONS)))*pow((FREE_AREA/len(DIMENSIONS)),(1/len(DIMENSIONS)))

def initRRG(map, dyType='point', goalRadius=5, minRadius=10, logg=logger()):
	global DYTYPE, GOAL_RADIUS, MIN_RADIUS, LOG
	LOG = logg
	initMAP(map)
	DYTYPE = dyType
	GOAL_RADIUS=goalRadius
	MIN_RADIUS=minRadius

def initGraph(pos=None):
	graph = {}
	if pos == None:
		temp = sample(MAP)
		graph[temp] = []
	else:
		x = len(MAP)/pos['x']
		y = len(MAP[0])/pos['y']
		temp = State(x, y)
		graph[temp] = []
	return graph

def output():
	return

def run(graph, goal):
	graph = extend(graph, goal)
	return graph

def extend(graph, goal):
	global MAP, GAMMA, MIN_RADIUS
	xRand = sample(MAP)
	xNearest = nearest(graph, xRand)
	xNew = steer(xNearest, xRand)

	if obstacleFree(xNearest, xNew): #TODO add if obstacleFree(xNearest, xNew):
		card = len(graph)
		xNear = nearVertices(
			graph.keys(),
			xNew,
			min(GAMMA*pow(log(card)/card,(1/2)), MIN_RADIUS+1)
		)
		graph.update({xNew:[xNearest]}) # Add vertex
		graph[xNearest].append(xNew) # Add edge
		#graph.add_node(xNew, cost=0)
		#graph.add_edge(xNearest, xNew)
		graph = checkGoal(graph, xNew, goal)
		for x in xNear:
			if obstacleFree(x, xNew) and x != xNearest: #TODO add if obstacleFree(x, xNew):
				graph[x].append(xNew) # Add edge
				graph[xNew].append(x)
	return graph

def checkGoal(graph, state, goal):
	if state.dist(goal) <= GOAL_RADIUS:
		graph.update({goal:[]})
		graph[state].append(goal)
	return graph

# REGION PRIMITIVES

def nearest(graph, xRand):
	verts = list(graph.keys())
	return closest(verts, xRand)

def closest(stateSet,state):
	xNearest = stateSet[0]
	for node in stateSet:
		if node.dist(state) < xNearest.dist(state):
			xNearest = node
	return xNearest

def steer(xNearest, xRand):
	moves = dynamics(xNearest)
	return closest(moves, xRand);

def nearVertices(vertices, xNew,r):
	xNear = []
	for x in vertices:
		if x.dist(xNew) <= r:
			xNear.append(x)
	return xNear

def dynamics(xNearest):
	moveSet = []
	if DYTYPE == 'point':
		size = 17
		for i in range(size):
			x = cos(i*2*pi/size)
			y = sin(i*2*pi/size)
			temp = xNearest.copy()
			direction = State(x, y)
			direction.position *= MIN_RADIUS
			direction.position._set_x(float(floor(direction.position._get_x())))
			direction.position._set_y(float(floor(direction.position._get_y())))
			temp.position += direction.position
			moveSet.append(temp)
	return moveSet

def sample(MAP):
	x = floor(random.uniform(0,DIMENSIONS['width']))
	y = floor(random.uniform(0,DIMENSIONS['height']))
	temp = State(x, y)
	while not obstacleFree(temp, temp):
		LOG.DEBOUT("Sampled into obstacle")
		x = floor(random.uniform(0,DIMENSIONS['width']))
		y = floor(random.uniform(0,DIMENSIONS['height']))
		temp = State(x, y)
	return temp

def obstacleFree(s1, s2):
	# for state in nx.nodes(GRAPHS[CURRENT_ROBOT]):
	# 	if s1 == s2:
	# 		return False
	if OBSTACLES.get(s1) is None or OBSTACLES.get(s2) is None:
		return False

	return not OBSTACLES[s1] and not OBSTACLES[s2]

if __name__ == '__main__':
	main()
