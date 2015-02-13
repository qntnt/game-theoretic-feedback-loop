Graph extend(Graph prevGraph, State xrand)
{
  State[] vertices = prevGraph.vertices;
  Edge[] edges = prevGraph.edges;
  State xNearest = nearest(vertices, xrand);
  State xNew = steer(xNearest, xrand);
  if (obstacleFree(xNearest, xNew))
  {
    State[] Xnear = nearVertices(vertices, xNew, 15); //r = 15
    vertices = (State[]) append(vertices, xNew);
    if( Xnear == null)
      return prevGraph;
    for (State xNear : Xnear)
    {
      if (obstacleFree(xNearest, xNew))
      {
        if(edges[0] == null)
          edges[0] = new Edge(xNearest, xNew);
        else
          edges = (Edge[]) append(edges, new Edge(xNearest, xNew));
      }
    }
  }
  for(Edge e : edges)
    if(e == null)
      print("ERROR in extend(): edge is null");
  return new Graph(vertices, edges);
}
Path betterResponse(Graph graph, Path[] otherRobotPaths, Path bestPath, State goal)
{
  Path[] paths = (Path[]) pathGeneration(graph);
  Path[] feasiblePaths = null;
  for(Path path : paths)
  {
    if(collisionFreePath(path, otherRobotPaths) && meetsPathConstraints(path))
    {
      if(feasiblePaths == null)
      {
        feasiblePaths = new Path[1];
        feasiblePaths[0] = path;
      }
      else
        feasiblePaths = (Path[]) append(feasiblePaths, path);
    }
  }
  Path minPath = bestPath;
  for(Path path : feasiblePaths)
  {
    print("Entering pathCost(path)");
    pathCost(path, goal);
    print("Entering pathCost(path)");
    pathCost(minPath, goal);
    if (pathCost(path, goal) < pathCost(minPath, goal))
    {
      minPath = path;
      break;
    }
  }
  return minPath;
}
