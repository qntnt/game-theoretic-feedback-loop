Graph extend(Graph prevGraph, State xrand)
{
  State[] vertices = new State[prevGraph.vertices.length]; 
  arrayCopy(prevGraph.vertices, vertices);
  Edge[] edges = new Edge[prevGraph.edges.length];
  arrayCopy(prevGraph.edges, edges);
  State xNearest = nearest(vertices, xrand);
  State xNew = steer(xNearest, xrand);
  if (obstacleFree(xNearest, xNew))
  {
    State[] Xnear = nearVertices(vertices, xNew, 15); //r = 15
    vertices = (State[]) append(vertices, xNew);
    edges = (Edge[]) append(edges, new Edge(xNearest, xNew));
    if( Xnear.length == 0)
      return prevGraph;
    for (State xNear : Xnear)
    {
      if (obstacleFree(xNear, xNew))
      {
        //edges = (Edge[]) append(edges, new Edge(xNear, xNew));
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
  Path[] feasiblePaths = new Path[0];
  for(Path path : paths)
  {
    if(collisionFreePath(path, otherRobotPaths) && meetsPathConstraints(path))
    {
      if(feasiblePaths.length == 0)
      {
        feasiblePaths = new Path[1];
        feasiblePaths[0] = path;
      }
      else
        feasiblePaths = (Path[]) append(feasiblePaths, path);
    }
  }
  Path minPath = feasiblePaths[0];
  for(Path path : feasiblePaths)
  {
    if (pathCost(path, goal) < pathCost(minPath, goal))
    {
      minPath = path;
      break;
    }
  }
  return minPath;
}
