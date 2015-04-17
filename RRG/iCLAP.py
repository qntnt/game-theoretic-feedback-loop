from planner import feedback as fb
from extend import RRG as rrg
from helper import visualize as vis
import matplotlib.image as mpimg
from env_classes.States import *
from time import clock
from math import floor
from helper.iClap_helpers import *
from helper.logging import *
import helper.bvp as bvp


def main():
	global robots, robotNum, env, graphs, goals, prevTime, curTime, iterations

	maxIterations = int(raw_input("How many iterations? [default = 1500]") or "1500")
	env = str(raw_input("What is the environment file? [default = env.png]") or "./env.png")
	x = int(raw_input("What is the robot's x coord? [default = 10]") or "10")
	y = int(raw_input("What is the robot's y coord? [default = 10]") or "10")
	gx = int(raw_input("What is the goal's x coord? [default = 10]") or "90")
	gy = int(raw_input("What is the goal's y coord? [default = 10]") or "90")

	setup(maxIterations=maxIterations, robotPos={'x':x, 'y':y}, goalPos={'x':gx, 'y':gy})

	run_loop()

	cleanup()

	vis.run(robots[0], env)

def cleanup():
	global robots, robotNum, env, graphs, goals, prevTime, curTime, iterations, logg

	imgOutput = []
	for robot in robots:
		if robot['finished']:
			robot['path'] = fb.pathFinding(robot['graph'], robot['root'], robot['goal'])
			logg.write_path(iterations, robot['path'])
			logg.write_states(robot['graph'])
		else:
			logg.ERROR("Robot did not finish")
	logg.close()

def output(i):
	global robots, robotNum, env, graphs, goals, prevTime, curTime, iterations, logg

	prevTime = curTime
	curTime = clock()
	if floor(curTime)-floor(prevTime) >= 1:
		logg.OUTPUT("Iteration: "+str(i))
		logg.OUTPUT("Time elapsed (s): %f" % clock(), lvl=2)
		logg.VERBOUT("- Framerate: %f" % (1/(curTime-prevTime)))

def run_loop():
	global robots, robotNum, env, graphs, goals, prevTime, curTime, iterations
	for i in range(iterations):
		for robot in robots:
			# Run RRG
			robot['graph'] = rrg.run(robot['graph'], robot['goal'])

			# Check if finished
			if not robot['finished']:
				robot = finishCheck(robot)
			else:
				# Run feedback loop
				robot['graph'] = fb.run(robot['graph'], robot['goal'])
				robot['path'] = fb.pathFinding(robot['graph'], robot['root'], robot['goal'])
				logg.write_path(i, robot['path'])
		output(i)


def setup(maxIterations=1000, robotPos=None, goalPos=None):
	global robots, robotNum, env, graphs, goals, prevTime, curTime, iterations, logg

	logg = logger()
	for arg in sys.argv[-2:]:
		if arg == "-v" or arg == "--verbose":
			logg.verbose = True
		if arg == "-d" or arg == "--debug":
			logg.debug = True

	fb.LOG = logg

	env = mpimg.imread(env)

	robots = []
	robotNum = 1
	graphs = []
	goals = []
	prevTime = clock()
	curTime = clock()
	iterations = maxIterations

	rrg.initRRG(env, dyType='point', goalRadius=5, minRadius=5, logg=logg)

	for i in range(robotNum):
		robots.append({})
		robots[i]['finished'] = False

		logg.VERBOUT("Initializing robot")
		if robotPos == None:
			robots[i]['graph'] = rrg.initGraph()
			robots[i]['root'] = next(iter(robots[i]['graph'].keys()))
		else:
			x = floor(robotPos['x'])
			y = floor(robotPos['y'])
			robots[i]['root'] = State(x, y)
			robots[i]['graph'] = {robots[i]['root']:[]}
		logg.VERBOUT("Initial state: "+str(robots[i]['root']), lvl=2)

		logg.VERBOUT("Initializing goal")
		if goalPos == None:
			robots[i]['goal'] = rrg.sample(env)
		else:
			x = floor(goalPos['x'])
			y = floor(goalPos['y'])
			robots[i]['goal'] = State(x, y)
		logg.VERBOUT("Initial goal: "+str(robots[i]['goal']), lvl=2)
		robots[i]['path'] = {}

		robots[i]['goal'].cost = -100

if __name__ == '__main__':
    main()
