State sample()
{
  State s = new State(
    new PVector(random(map.width), random(map.height)),
    new PVector(random(2)-1, random(2)-1)
    );
  return s;
}
boolean collisionFreePath(Path path, Path[] OTHER_ROBOT_PATHS)
{
  // Check that the current path doesn't overlap with other robot paths
  for(Path p : OTHER_ROBOT_PATHS)
  {
    if(path.collides(p))
      return false;
  }
  return true;
}
boolean meetsPathConstraints(Path path)
{
  //TODO
  return true;
}
boolean inGoal(State s)
{
  if(PVector.dist(s.position,GOALS[CURRENT_ROBOT].position) <=  GOAL_RADII[CURRENT_ROBOT]/2)
    return true;
  else
    return false;
}
Path[] pathGeneration(Graph graph)
{
  //Depth-first search
  State[] goalVerts = findGoalVertices(graph.vertices);
  Path[] pathSet = new Path[0];
  Path[] paths;
  //paths[0] = new Path(graph.vertices[0]);
  for(State g : goalVerts)
  {
    paths = new Path[1];
    paths[0] = new Path(g);
    paths = fromLeafGeneratePaths(graph, g, new State[0], paths, 0);
    
    pathSet = (Path[]) concat(pathSet, paths); 
  }
  //DEBOUT("# of paths: "+str(pathSet.length));
  return pathSet;
}
State[] nearVertices(State[] vertices, State x, float r)
{
  State[] result = new State[0];
  for(State s : vertices)
  {
    if(PVector.dist(s.position, x.position) <= r)
    {
        result = (State[]) append(result, s);
    }
  }
  return result;
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
  if(outcomes.length == 0)
    return null;
  State optimalY = outcomes[0];
  for(State outcome : outcomes)
  {
    if(PVector.dist(outcome.position, y.position) < PVector.dist(optimalY.position, y.position))
    {
      optimalY = outcome;
    }
  }
  return optimalY;
}
boolean obstacleFree(State v1, State v2)
{
  if(v2 == null || v1 == null)
    return false;
  if(int(v2.position.y)*width+int(v2.position.x) >= width*height)
    return false;
  if(int(v2.position.y)*width+int(v2.position.x) < 0)
    return false;
  loadPixels();
  //TODO check the path between the points
  for(Edge e : EDGES[CURRENT_ROBOT])
  {
    if(e.v1.isEqual(v1) && e.v2.isEqual(v2))
      return false;
  }
  if(map.pixels[int(v2.position.y)*width+int(v2.position.x)] == color(0,0,0))
    return false;
  return true;
}
