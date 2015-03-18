
State[] findGoalVertices(State[] vertices)
{
  State[] result = new State[0];
  for (State v : vertices)
  {
    if (inGoal(v))
      result = (State[]) append(result, v);
  }
  DEBOUT(str(CURRENT_ROBOT)+") has "+str(result.length)+" goal vertices");
  return result;
}
Edge[] findParentEdges(State vertex, Edge[] edges)
{
  Edge[] parents = new Edge[0];
  for (Edge e : edges)
  {
    if (vertex.isEqual(e.v2))
    {
      parents = (Edge[]) append(parents, e);
    }
  }
  return parents;
}
Path[] fromRootGeneratePaths(Graph g, State v, State[] discovered, Path[] paths, int j)
{
  discovered = (State[]) append(discovered, v);
  Edge[] adjacentEdges = g.childEdges(v);
  DEBOUT("Vertex has "+str(adjacentEdges.length)+" child edges");
  for (int i=0; i<adjacentEdges.length; i++)
  {
    boolean d = false;
    for (State s : discovered)
    {
      if (s.isEqual(adjacentEdges[i].v2))
        d = true;
    }
    if (!d)
    {
      if (i == 0)
      {
        paths[i].vertices = (State[]) append(paths[i].vertices, adjacentEdges[i].v2);
        paths[i].edges = (Edge[]) append(paths[i].edges, adjacentEdges[i]);
        paths = fromRootGeneratePaths(g, adjacentEdges[i].v2, discovered, paths, i);
      } else
      {
        paths = (Path[]) append(paths, paths[j].copy());
        j = paths.length - 1;
        paths[j].vertices = (State[]) append(paths[j].vertices, adjacentEdges[i].v2);
        paths[j].edges = (Edge[]) append(paths[j].edges, adjacentEdges[i]);
        paths = fromRootGeneratePaths(g, adjacentEdges[i].v2, discovered, paths, i);
      }
    }
  }
  return paths;
}
Path[] fromLeafGeneratePaths(Graph g, State v, State[] discovered, Path[] paths, int j)
{
  discovered = (State[]) append(discovered, v);
  State[] newDisc = new State[discovered.length];
  arrayCopy(discovered, newDisc);
  Edge[] adjacentEdges = g.parentEdges(v);
  //DEBOUT("Vertex has "+str(adjacentEdges.length)+" parent edges");
  for (int i=0; i<adjacentEdges.length; i++)
  {
    boolean d = false;
    for (State s : discovered)
    {
      if (s.isEqual(adjacentEdges[i].v1))
        d = true;
    }
    if (!d)
    {
      if (i == 0)
      {
        //DEBOUT("Extending path");
        paths[i].vertices = (State[]) append(paths[i].vertices, adjacentEdges[i].v1);
        paths[i].edges = (Edge[]) append(paths[i].edges, adjacentEdges[i]);
        paths = fromLeafGeneratePaths(g, adjacentEdges[i].v1, discovered, paths, i);
      } else
      {
        //DEBOUT("Branching path");
        j = paths.length - 1;
        // Checks if it is making a cycle and doesn't add the new edge and vertice if it is. Only works if it isn't checking for the goal state for now, i.e. there can still be a "cycle" when reaching the goal, though I've changed it around a few
        // times and it appears to be working. It is pretty rare though, so it's tought to know for sure.
        boolean add = true;
        for (int cnt = 0; cnt < paths[j].edges.length; cnt++) {
          if (adjacentEdges[i].v2 == paths[j].edges[cnt].v2) {
            add = false;
            break;
          }
        }
        if (add == true) {
          paths[j].vertices = (State[]) append(paths[j].vertices, adjacentEdges[i].v1);
          paths[j].edges = (Edge[]) append(paths[j].edges, adjacentEdges[i]);
          paths = fromLeafGeneratePaths(g, adjacentEdges[i].v1, newDisc, paths, i);
        }
      }
    }
  }
  return paths;
}

