	
def iNash():
	A = {}
	k = 1
	# REGION: Run algorithm
	while k < K:
		for i in range(1, N):
			new_sample = sample(Xi)
			i.G[k] = extend(i.G[k], new_sample)
		for i in # V[R] \ A[k-1]:
			if # intersection(i.V[k], G.X[i]) == {}:
				A[k] = union(A[k-1], {i})
		for i in A[k]:
			# TODO ask devesh
		for i in range(1, N):
			if i in A[k]:
				i.PI[k] = #something really complicated
				path = betterResponse(i.G[k], i.PI[k])
		
		k = k + 1

def extend(#TODO, sample):
	V = i.V[k-1]
	E = i.E[k-1]
	x-nearest = # Nearest(E, i.x-rand)
	x-new = # Steer(x-nearest, i.x-rand)
	if # ObstacleFree(x-nearest, x-new):
		X-near = # NearVertices(E, x-new, min{y(log(k)\k)^(1\n), n})
		V = # union(V, {x-new})
		for x-near in X-near:
			if # ObstacleFree(x-nearest, x-new):
				E = # union(E, {(x-nearest, x-new)})
	return # G = (V, E)

def betterResponse(diGraph, pathSet):
	Pk = PathGeneration(diGraph)
	Pf = {}
	
	for path in Pk:
		if CollisionFreePath(path, pathSet) == 1 :#and union(path, diGraph) in [greekthing]:
			Pf = union(Pf, {path})
	pathmin = path[k-1]
	for path in Pf:
		if Cost(path) < Cost(pathmin):
			pathmin = path
			break
	return pathmin
