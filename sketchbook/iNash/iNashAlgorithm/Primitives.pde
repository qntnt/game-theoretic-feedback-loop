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
  
  return path.edges.length;
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
Edge[] findParentEdges(State vertex, Edge[] edges)
{
  Edge[] children = new Edge[0];
  for(Edge e : edges)
  {
    if(vertex.position.equals(e.v2.position))
    {
      if(children == null)
      {
        children = new Edge[1];
        children[0] = e;
      }
      else
      {
        children = (Edge[]) append(children, e);
      }
    }
  }
  //print("# of parents: "+str(children.length)+"\n");
  return children;
}
Path[] traceFromState(State x, Edge[] edges)
{
  //print("Entering traceFromState\n");
  Edge[] parents = findParentEdges(x, edges);
  Path[] paths = new Path[0];
  if(parents.length == 0)
  {
    paths = new Path[1];
    paths[0] = new Path(edges[0].v1);
    return paths;
  }
  for (int i=0; i<parents.length; i++)
  {
    if(i==0)
    {
      paths = traceFromState(parents[i].v1, edges);
      paths[i].pushByEdge(parents[i]);
    }
    else
    {   
      Path[] newParents = traceFromState(parents[i].v1, edges);
      paths = (Path[]) concat(paths, newParents);
      paths[i].pushByEdge(parents[i]);
    }
  }
  //print("Completed traceFromState\n");
  return paths;
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
          
          x = edge.v1;
          // Check for parent
          hasParent = true;
        }
      }
    }
  }
  return path;
}
Path[] pathGeneration(Graph graph)
{
  //Depth-first search
  Path[] paths = traceFromState(goals[currentRobot], graph.edges);
  print("# of paths: "+str(paths.length)+"\n");
  return paths;
  /*
  State[] leaves = traceFromState(graph.vertices[0], graph.edges);
  for(State leaf : leaves)
  {
    // Draw the leaf
    fill(robotColors[currentRobot]);
    leaf.drawState();
    
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
  for(Path p : paths)
  {
    if(p != null)
    {
      fill(color(random(255),random(255),random(255)));
      p.drawPath();
    }
    else
    {
      print("Path is null");
    }
  }
  return paths;
  */
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
  for(State x : vertices[currentRobot])
  {
    if(x.position.equals(v2.position))
    {
      print("Attempted to extend to internal position\n");
      return false;
    }
  }
  return true;
}
