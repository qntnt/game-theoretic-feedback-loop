import feedback as fb
from time import clock

prevTime = clock()
currTime = clock()
iterations = 1500

fb.init(width=200, height=200, goalCost=-1, iterations=iterations, mapFile="./map.png")
for i in range(iterations):
	fb.run()
	prevTime = currTime
	currTime = clock()
	print("- Framerate: %f" % (1/(currTime-prevTime)))
	print("- Time elapsed (s): %f" % clock())
	
fb.drawGraph()


input('Press enter to close')