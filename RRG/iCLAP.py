import feedback as fb
import RRG as rrg
import visualize as vis
from time import clock
from math import floor
from graphics import *
from iCLAP_helpers import *


map = Image(Point(0,0), "./map.png")
window = GraphWin("iCLAP", map.getWidth(), map.getHeight())
map.draw(window)

robots = []
robotNum = 1
graphs = []
goals = []
prevTime = clock()
currTime = clock()
iterations = 2000

rrg.initRRG(map, dyType='point', goalRadius=5, minRadius=5)

for i in range(robotNum):
	robots.append({'finished':False, 'graph':rrg.initGraph(), 'goal':rrg.sample(map), 'path':{}})
	robots[i]['root'] = next(iter(robots[i]['graph'].keys()))
	robots[i]['goal'].cost = -100
	x = floor(robots[i]['goal'].position._get_x())
	y = floor(robots[i]['goal'].position._get_y())
	goal = Circle(Point(x, y), 3)
	goal.setFill('green')
	goal.setOutline('green')
	goal.draw(window)
	x = floor(robots[i]['root'].position._get_x())
	y = floor(robots[i]['root'].position._get_y())
	start = Circle(Point(x, y), 3)
	start.setFill('gray')
	start.draw(window)

for i in range(iterations):
	print("Iteration: "+str(i))
	for robot in robots:
		# Run RRG
		robot['graph'] = rrg.run(robot['graph'], robot['goal'])

		# Check if finished
		if not robot['finished']:
			robot = finishCheck(robot)
		else:
			# Run feedback loop
			robot['graph'] = fb.run(robot['graph'], robot['goal'])
	prevTime = currTime
	currTime = clock()
	print("- Framerate: %f" % (1/(currTime-prevTime)))
	print("- Time elapsed (s): %f" % clock())

imgOutput = []
for robot in robots:
	if robot['finished']:
		robot['path'] = fb.pathFinding(robot['graph'], robot['root'], robot['goal'])
		drawPath(robot['path'], window)
		imgOutput.append(drawGraph(map, window, robot['graph'], robot['goal']))
		imgOutput[0].save('./imgOutput.png')
	else:
		print("Robot did not finish")

vis.run(robots[0], map)

input('Press enter to close')
