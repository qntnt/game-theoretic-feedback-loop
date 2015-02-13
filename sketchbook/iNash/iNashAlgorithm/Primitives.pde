State sample()
{
  State s = new State(
    new PVector(random(width), random(height)),
    new PVector(random(2)-1, random(2)-1)
    );
  return s;
}
float pathCost(Path path, State goal)
{
  float cost = 0;
  if(path.edges == null)
    print("ERROR in pathCost: path.edges is NULL\n");
  for(int i=0; i<path.edges.length; i++)
  {
    cost += edgeCost(path.edges[i], goal);
  }
  return cost;
}
float edgeCost(Edge edge, State goal)
{
  return PVector.dist(edge.v2.position, goal.position) - PVector.dist(edge.v1.position, goal.position);
}
boolean collisionFreePath(Path path, Path[] otherRobotPaths)
{
  // Check that the current path doesn't overlap with other robot paths
  
  return true;
}
boolean meetsPathConstraints(Path path)
{
  //TODO
  return true;
}
Edge[] findChildEdges(State vertex, Edge[] edges)
{
  Edge[] children = null;
  for(Edge e : edges)
  {
    if(vertex.position.equals(e.v1.position))
    {
      if(children == null)
        children = new Edge[0];
      children = (Edge[]) append(children, e);
    }
  }
  return children;
}
State[] traceFromState(State x, Edge[] edges)
{
  Edge[] children = findChildEdges(x, edges);
  State[] leaves = null;
  if(children == null)
  {
    leaves = new State[1];
    leaves[0] = x;
    return leaves;
  }
  for (int i=0; i<children.length; i++)
  {
    if(i==0)
    {
      leaves = traceFromState(children[i].v2, edges);
    }
    else
    {   
      leaves = (State[]) concat(leaves, traceFromState(children[i].v2, edges));
    }
  }
  return leaves;
}
Path generatePath(State x, Edge[] edges)
{
  Path path = new Path();
  boolean hasParent = true;
  while(hasParent)
  {
    hasParent = false;
    for(Edge edge : edges)
    {
      if(edge != null)
      {
        if(edge.v2.position.equals(x))
        {
          path.pushByState(edge.v1);
          
          // Check for parent
          hasParent = true;
        }
      }
    }
  }
  path.checkPath();
  return path;
}
Path[] pathGeneration(Graph graph)
{
  //Depth-first search
  Path[] paths = null;
  State[] leaves = traceFromState(graph.vertices[0], graph.edges);
  for(State leaf : leaves)
  {
    if(paths == null)
    {
      paths = new Path[1];
      paths[0] = generatePath(leaf, graph.edges);
    }
    else
    {
      paths = (Path[]) append(paths, generatePath(leaf, graph.edges));
    }
  }
  return paths;
}
State nearest(State[] vertices, State xrand)
{
  State nearestState = vertices[0];
  for(State vertex : vertices)
  {
    if(PVector.dist(vertex.position, xrand.position) < PVector.dist(nearestState.position, xrand.position))
      nearestState = vertex;
  }
  return nearestState;
}
State steer(State x, State y)
{
  float dt = 10;
  State[] outcomes = dynamics( x, y, dt);
  State optimalY = outcomes[0];
  for(State outcome : outcomes)
  {
    if(PVector.dist(outcome.position, y.position) < PVector.dist(optimalY.position, y.position))
    {
      optimalY = outcome;
    }
  }
  if(PVector.dist(x.position, goals[currentRobot].position) <= dt)
    return goals[currentRobot];
  return optimalY;
}
State[] dynamics(State x, State u, float dt)
{
  //TODO apply dynamics to steer()
  PVector direction = PVector.sub(u.position, x.position);
  direction.normalize();
  direction.setMag(dt);
  State steered = new State();
  steered.position = PVector.add(x.position, direction);
  State[] result = {steered};
  return result;
}
State[] nearVertices(State[] vertices, State x, float r)
{
  State[] result = null;
  for(State s : vertices)
  {
    if(PVector.dist(s.position, x.position) <= r)
    {
      if(result == null)
      {
        result = new State[1];
        result[0] = s;
      }
      else
        result = (State[]) append(result, s);
    }
  }
  return result;
}
boolean obstacleFree(State v1, State v2)
{
  if(map.pixels[floor(v1.position.y)*width+floor(v1.position.x)] == color(0,0,0))
    return false;
  if(map.pixels[floor(v2.position.y)*width+floor(v2.position.x)] == color(0,0,0))
    return false;
  return true;
}
