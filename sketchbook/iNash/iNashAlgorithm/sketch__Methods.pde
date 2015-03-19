Graph extend(Graph prevGraph, State xrand)
{
  State[] vertices = new State[prevGraph.vertices.length]; 
  arrayCopy(prevGraph.vertices, vertices);
  Edge[] edges = new Edge[prevGraph.edges.length];
  arrayCopy(prevGraph.edges, edges);

  State xNearest = nearest(vertices, xrand);
  State xNew = steer(xNearest, xrand);

  if (xNearest == null)
    DEBOUT("xNearest is unset");
  if (xNew == null)
    DEBOUT("xNew is unset");

  if (obstacleFree(xNearest, xNew))
  {
    State[] Xnear = nearVertices(vertices, xNew, min((GAMMA*pow((log(k)/k), (1/VERTICES[CURRENT_ROBOT].length))), ETA)); //r = 15
    vertices = (State[]) append(vertices, xNew);
    edges = (Edge[]) append(edges, new Edge(xNearest, xNew));
    if (inGoal(xNew))
    {
      boolean alreadyDone = false;
      for(int i : FINISHED_ROBOTS)
      {
        if( i == CURRENT_ROBOT )
        {
          alreadyDone = true;
        }
      }
      if(!alreadyDone)
      {
          vertices = (State[]) append(vertices, GOALS[CURRENT_ROBOT]);
          edges = (Edge[]) append(edges, new Edge(xNew, GOALS[CURRENT_ROBOT]));
      }
    }
    for (State xNear : Xnear)
    {
      if (xNear.position == null)
        DEBOUT("Some xNear is unset");
      if (obstacleFree(xNear, xNew))
      {
        //If the edge is consistent with path constraints, add the edge
        if (!xNear.isEqual(xNearest))
          if (viableAction(xNear, xNew))
          {
            State xNewer = calcVel(xNear, xNew);
            vertices = (State[]) append(vertices, xNewer);
            edges = (Edge[]) append(edges, new Edge(xNear, xNewer));

            
            if (inGoal(xNewer))
            {
              boolean alreadyDone = false;
              for(int i : FINISHED_ROBOTS)
              {
                if( i == CURRENT_ROBOT )
                {
                  alreadyDone = true;
                }
              }
              if(!alreadyDone)
              {
                  vertices = (State[]) append(vertices, GOALS[CURRENT_ROBOT]);
                  edges = (Edge[]) append(edges, new Edge(xNewer, GOALS[CURRENT_ROBOT]));
              }
            }
          }
      }
    }
  }
  Graph ret = new Graph(vertices, edges);
  return ret;
}
Path betterResponse(Graph graph, Path[] OTHER_ROBOT_PATHS, Path bestPath, State goal)
{
  Path[] paths = (Path[]) pathGeneration(graph);
  Path[] feasiblePaths = new Path[0];
  for (Path path : paths)
  {
    if (collisionFreePath(path, OTHER_ROBOT_PATHS) && meetsPathConstraints(path))
    {
      if (feasiblePaths.length == 0)
      {
        feasiblePaths = new Path[1];
        feasiblePaths[0] = path;
      } else
        feasiblePaths = (Path[]) append(feasiblePaths, path);
    }
  }
  Path minPath = new Path();
  if (feasiblePaths.length > 0)
    minPath = feasiblePaths[0];
  for (Path path : feasiblePaths)
  {
    if (path.iNashCost() < minPath.iNashCost())
    {
      minPath = path;
      break;
    }
  }
  return minPath;
}

