from networkx import *
from functools import reduce

global GOALS, GOAL_WEIGHT, FINISHED_ROBOTS, ROBOT_TREES, GRAPHS, WIN

def run(graph, goal):
	# Apply feedback loop to finished robots
	graph = applyCosts(graph, goal)
	return graph

def applyCosts(graph, goal):
	for state in list(graph.keys()):
		if state != goal:
			costs = []
			for neighbor in graph[state]:
				if state != neighbor:
					costs.append(1/neighbor.dist(state) + (1-1/len(graph.keys()))*neighbor.cost)
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
		if neighbor.cost < minState.cost:
			minState = neighbor
	return minState



def pathFinding(graph, root, goal):
	path = {root:minState(graph[root])}
	curState = root
	while curState != goal:
		curState = path[curState]
		path[curState] = minState(graph[curState])
		print(str(curState))
	return path

def totalCost(graph):
	cost =0
	for state in nodes(graph):
		cost += state.cost
	return cost
