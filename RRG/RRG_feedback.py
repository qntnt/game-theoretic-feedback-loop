import networkx as nx
import States as st
import Primitives as pr
from math import log
from graphics import *

global MAP, NUM_ROBOTS, ITERATION, GRAPHS, GAMMA, ETA

MAP = {'width':600, 'height':500}
NUM_ROBOTS = 1
ITERATION = 1
GRAPHS = []
GAMMA = 2*(1+(1/len(MAP)))+(pr.freeArea(MAP)/ITERATION)
ETA = 2
WINDOW = GraphWin()

for n in range(0,NUM_ROBOTS):
	GRAPHS.append(nx.Graph())
	GRAPHS[n].add_node(st.sample(MAP))

def main():
	global ITERATION
	while ITERATION < 10000:
		rrg()
		ITERATION += 1
	output()
		
def output():
	global ITERATION, NUM_ROBOTS, GRAPHS
	print("ITERATION: "+str(ITERATION))
	for graph in GRAPHS:
		for node in nx.nodes(graph):
			pt = Point(node.position.x, node.position.y)
			pt.draw(WINDOW)
def rrg():
	global GRAPHS, NUM_ROBOTS
	for n in range(NUM_ROBOTS):
		GRAPHS[n] = extend(GRAPHS[n])
		print(nx.number_of_nodes(GRAPHS[n]))

def setup():
	global GAMMA, MAP, ITERATION
	GAMMA = 2*(1+(1/len(MAP)))+(pr.freeArea(MAP)/ITERATION)
	
def extend(graph):
	global MAP, ITERATION, NUM_ROBOTS, GAMMA, ETA
	xRand = st.sample(MAP)
	xNearest = pr.nearest(graph, xRand)
	xNew = pr.steer(xNearest, xRand)

	if True: #TODO add if obstacleFree(xNearest, xNew):
		xNear = pr.nearVertices(
			nx.nodes(graph), 
			xNew, 
			min(GAMMA*pow((log(ITERATION)/ITERATION),(1/NUM_ROBOTS)), ETA)
		)
		graph.add_node(xNew)
		for x in xNear:
			if True: #TODO add if obstacleFree(x, xNew):
				graph.add_edge(x, xNew)
	
	return graph	

main()