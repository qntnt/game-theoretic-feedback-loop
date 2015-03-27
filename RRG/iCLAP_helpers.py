from graphics import *
from math import floor

def imgPlot(img, _x, _y, w, h, color):
	x = _x
	y = _y
	for i in range(w):
		for j in range(h):
			img.setPixel(x+i-floor(w/2), y+j-floor(h/2), color)
	return img

def finishCheck(robot):
	for state in list(robot['graph'].keys()):
		if state == robot['goal']:
			robot['finished'] = True
			return robot
	return robot

def drawPath(path, window):
	for state in path.keys():
		line = Line(state.point, path[state].point)
		line.setWidth(3)
		line.setOutline('green')
		line.draw(window)
	return True

def drawGraph(map, window, graph, goal):
	exports = map.clone()
	# for state1 in list(graph.keys()):
	# 	for state2 in graph[state1]:
	# 		line = Line(state1.point, state2.point)
	# 		line.setOutline(color_rgb(150,150,150))
	# 		line.draw(window)
	minCost = -goal.cost
	maxCost = goal.cost
	for state in list(graph.keys()):
		if state != goal:
			if state.cost < minCost:
				minCost = state.cost
			elif state.cost > maxCost:
				maxCost = state.cost
	offset = -minCost
	maxCost += offset
	minCost += offset
	if maxCost == 0:
		print ("Did not reach goal")
		return
	print("maxCost: "+str(maxCost))
	print("minCost: "+str(minCost))
	print("offset: "+str(offset))
	for state in list(graph.keys()):
		if state != goal:
			ratio = (state.cost+offset)/(maxCost)
			if ratio == 1:
				print (str(ratio))
			col = color_rgb((ratio)*255, 0, 255-(ratio)*255)
			model = state.point
			model.setFill(col)
			model.setOutline(col)
			model.draw(window)
			exports = imgPlot(exports, floor(state.point.getX()), floor(state.point.getY()), 1, 1, col)
	return exports
