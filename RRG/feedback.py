import RRG as rrg

global GOAL_WEIGHT

def init(width=100, height=100, robots=1, maxIterations=1000, dyType='point', goalWeight=-1000):
	rrg.init( width=width, height=height, robots=robots, maxIterations=maxIterations, dyType=dyType)
	GOAL_WEIGHT = goalWeight

def run():
	while(rrg.ITERATION <= rrg.MAX_ITERATIONS):
		rrg.rrg()
		for n in range(rrg.NUM_ROBOTS):
			tree = rrg.dfs()
			for edge in tree:
				rrg.addToScene(edge[0],edge[1], 'green')
		rrg.ITERATION += 1
		print("Iteration: "+str(rrg.ITERATION))
		print("- Nodes: "+str(len(rrg.nodes(rrg.GRAPHS[0]))))
		print("- Edges: "+str(len(rrg.edges(rrg.GRAPHS[0]))))