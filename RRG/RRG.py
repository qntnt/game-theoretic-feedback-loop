from networkx import *
from States import *
from math import log
from graphics import *
from Vectors import Vector
from math import cos, sin, pi

global GOAL, MAP, WINDOW, MAX_ITERATIONS, NUM_ROBOTS, CURREN_ROBOT, ITERATION, GRAPHS, GAMMA, MIN_RADIUS, DYTYPE

MAP = {'width':100, 'height':100}
NUM_ROBOTS = 1
CURRENT_ROBOT = 0
ITERATION = 1
MAX_ITERATIONS = 1000
GRAPHS = []
GOAL_RADIUS = 10
MIN_RADIUS = 10
DYTYPE = 'point'
GOALS = []

def dfs():
	return dfs_edges(GRAPHS[CURRENT_ROBOT], nodes(GRAPHS[CURRENT_ROBOT])[0])

def init(width=100, height=100, robots=1, maxIterations=1000, dyType='point'):
	global MAP, MAX_ITERATIONS, WINDOW, NUM_ROBOTS, CURRENT_ROBOT, ITERATION, GRAPHS, GAMMA, MIN_RADIUS, DYTYPE

	MAP['width'] = width
	MAP['height'] = height
	NUM_ROBOTS = robots
	MAX_ITERATIONS = maxIterations
	DYTYPE = dyType

	WINDOW = GraphWin("Graph", MAP['width'], MAP['height'])
	GAMMA = 2*(1+(1/len(MAP)))+(freeArea(MAP)/ITERATION)

	for n in range(NUM_ROBOTS):
		GRAPHS.append(Graph())
		GOALS.append(sample(MAP))
		addGoalToScene(GOALS[n])
	for graph in GRAPHS:
		temp = sample(MAP)
		graph = graph.add_node(temp)
		addToScene(temp)

def freeArea(MAP):
	return MAP['width']*MAP['height']

def output():
	#draw()
	#input("Press enter to close")
	return

def rrg():
	global GRAPHS, NUM_ROBOTS, CURRENT_ROBOT
	for n in range(NUM_ROBOTS):
		CURRENT_ROBOT = n
		GRAPHS[n] = extend(GRAPHS[n])
		#print(nx.number_of_nodes(graph))

def setup():
	global GAMMA, MAP, ITERATION
	GAMMA = 2*(1+(1/len(MAP)))+(freeArea(MAP)/ITERATION)
	
def extend(graph):
	global MAP, ITERATION, NUM_ROBOTS, GAMMA, MIN_RADIUS
	xRand = sample(MAP)
	xNearest = nearest(graph, xRand)
	xNew = steer(xNearest, xRand)

	if obstacleFree(xNearest, xNew): #TODO add if obstacleFree(xNearest, xNew):
		xNear = nearVertices(
			nodes(graph), 
			xNew, 
			min(GAMMA*pow((log(ITERATION)/ITERATION),(1/ITERATION)), MIN_RADIUS+1)
		)
		graph.add_node(xNew)
		checkGoal(xNew)
		addToScene(xNew)
		for x in xNear:
			if obstacleFree(x, xNew): #TODO add if obstacleFree(x, xNew):
				graph.add_edge(x, xNew)
				addToScene(x, xNew)
	return graph

def checkGoal(s):
	if s.dist(GOALS[CURRENT_ROBOT]) <= GOAL_RADIUS:
		GRAPHS[CURRENT_ROBOT].add_node(GOALS[CURRENT_ROBOT])
		GRAPHS[CURRENT_ROBOT].add_edge(s, GOALS[CURRENT_ROBOT])
		addGoalToScene(GOALS[CURRENT_ROBOT])
		addToScene(s, GOALS[CURRENT_ROBOT])

def addGoalToScene(goal):
	global WINDOW
	goal.addToScene(WINDOW)
	goal.circle.setFill('red')

def addToScene(*args):
	global WINDOW
	if len(args) == 1:
		args[0].addToScene(WINDOW)
	elif len(args) == 2:
		model = Line(args[0].point, args[1].point)
		model.draw(WINDOW)
	elif len(args) == 3:
		model = Line(args[0].point, args[1].point)
		model.setOutline(args[2])
		model.draw(WINDOW)

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
			temp.position += direction.position
			moveSet.append(temp)
	return moveSet

def obstacleFree(s1, s2):
	# for state in nx.nodes(GRAPHS[CURRENT_ROBOT]):
	# 	if s1 == s2:
	# 		return False
	return True

if __name__ == '__main__':
	main()