import RRG as rrg
from networkx import *
from graphics import *
from functools import reduce

global GOALS, GOAL_WEIGHT, FINISHED_ROBOTS, ROBOT_TREES, GRAPHS, WIN

		

def init(width=100, height=100, robots=1, iterations=2000, dyType='point', goalCost=-1000, mapFile="./map.png"):
	global GOALS, GOAL_WEIGHT, FINISHED_ROBOTS, ROBOT_TREES, GRAPHS, WIN
	rrg.init( width=width, height=height, robots=robots, maxIterations=iterations, dyType=dyType, goalCost = goalCost)
	
	GOAL_WEIGHT = goalCost
	GOALS = rrg.GOALS
	FINISHED_ROBOTS = []
	ROBOT_TREES = []
	WIN = GraphWin("Feedback", rrg.MAP.getWidth(), rrg.MAP.getHeight())

def finishCheck():
	global FINISHED_ROBOTS, GOALS
	for n in range(rrg.NUM_ROBOTS):
		if n not in FINISHED_ROBOTS:
			for state in nodes(rrg.GRAPHS[n]):
				if state == GOALS[n]:
					FINISHED_ROBOTS.append(n)
					
def run():
	# Perform RRG
	rrg.rrg()
	
	# Check for finished robots
	finishCheck()
	
	# Apply feedback loop to finished robots
	applyCosts()
	GRAPHS = rrg.GRAPHS
	
	output()
		
def drawGraph():
	global WIN
	rrg.MAP.draw(WIN)
	for edge in edges(rrg.GRAPHS[0]):
		line = Line(edge[0].point, edge[1].point)
		line.setOutline(color_rgb(150,150,150))
		line.draw(WIN)
	minCost = 1000
	maxCost = 1
	for state in nodes(rrg.GRAPHS[0]):
		if state != rrg.GOALS[0]:
			if state.cost < minCost:
				minCost = state.cost
			elif state.cost > maxCost:
				maxCost = state.cost
	offset = -minCost+1
	maxCost += offset
	minCost += offset
	print("maxCost: "+str(maxCost))
	print("minCost: "+str(minCost))
	print("offset: "+str(offset))
	for state in nodes(rrg.GRAPHS[0]):
		if state != rrg.GOALS[0]:
			col = color_rgb(255*(state.cost+offset)/maxCost, 0, 255/(state.cost+offset))
			model = Circle(state.point, 2)
			model.setFill(col)
			model.setOutline(col)
			model.draw(WIN)
		else:
			model = Circle(state.point, 2)
			model.setFill('green')
			model.draw(WIN)
		
def applyCosts():
	global FINISHED_ROBOTS, GOALS
	for n in FINISHED_ROBOTS:
		for i in range(len(nodes(rrg.GRAPHS[0]))):
			state = nodes(rrg.GRAPHS[0])[i]
			if state != rrg.GOALS[0]:
				#print("state cost: "+str(state.cost))
				costs = []
				for neighbor in all_neighbors(rrg.GRAPHS[0], state):
					if state != neighbor:
						costs.append(1/neighbor.dist(state) + (1-1/len(nodes(rrg.GRAPHS[0])))*neighbor.cost)
				nodes(rrg.GRAPHS[0])[i].cost = reduce(min, costs)
				#print(nodes(rrg.GRAPHS[n])[i].cost)
	
def totalCost(graph):
	cost =0
	for state in nodes(graph):
		cost += state.cost
	return cost
		
def output():
	print("Iteration: "+str(rrg.ITERATION))
	print("- Nodes: "+str(len(rrg.nodes(rrg.GRAPHS[0]))))
	print("- Edges: "+str(len(rrg.edges(rrg.GRAPHS[0]))))