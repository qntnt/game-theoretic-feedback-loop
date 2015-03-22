import networkx as nx
import States as st

def nearest(graph, xRand):
	nodes = nx.nodes(graph)
	return st.closest(nodes, xRand)
		
def steer(xNearest, xRand):
	moves = dynamics(xNearest)
	return st.closest(moves, xRand);

def nearVertices(vertices,xNew,r):
	xNear = []
	for x in vertices:
		if x.dist(xNew) <= r:
			xNear.append(x)
	return xNear
	
def dynamics(xNearest):
	return [xNearest]
	
def freeArea(MAP):
	return MAP['width']*MAP['height']