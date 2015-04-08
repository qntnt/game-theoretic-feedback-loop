from networkx import *
from functools import reduce
from logging import *

global GOALS, GOAL_WEIGHT, FINISHED_ROBOTS, ROBOT_TREES, GRAPHS, WIN, LOG

def run(graph, goal):
	# Apply feedback loop to finished robots
	graph = applyCosts(graph, goal)
	return graph

def applyCosts(graph, goal):
	stateNum = len(graph.keys())
	for state in list(graph.keys()):
		if state != goal:
			costs = []
			for neighbor in graph[state]:
				if state != neighbor and neighbor.dist(state) and stateNum:
					costs.append(1/neighbor.dist(state) + (1-1/stateNum)*neighbor.cost)
			if len(costs) > 0:
				state.cost = reduce(min, costs)
	return graph

# path = {
# 	state1:state2,
# 	state2:state3,
# 	state3:state4,
# 	...
# }
#
# path[state1] -> state2
# path[state2] -> state3

def minState(states):
	minState = states[0]
	for neighbor in states:
		if neighbor.cost <= minState.cost :
			minState = neighbor
	return minState


def pathFinding(graph, root, goal):
	LOG.DEBOUT("Entering pathfinding")
	path = {}
	curState = root
	nextState = minState(graph[root])
	while nextState != goal and path.get(nextState) != curState:
		LOG.DEBOUT(str(curState)+"->"+str(nextState))
		path[curState] = nextState
		curState = nextState
		nextState = minState(graph[nextState])
	path[curState] = nextState
	return path

def totalCost(graph):
	cost =0
	for state in nodes(graph):
		cost += state.cost
	return cost
