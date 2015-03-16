void feedbackLoop()
{
  calculateCosts();
  findPaths();
}

void calculateCosts()
{
  for (int i=0; i<N; i++)
  {
    CURRENT_ROBOT = i;
    float bestCost = 10000;
    for (State s : GRAPHS[i].vertices)
    {
      for (Action a : ACTIONS)
      {
        if (bestCost > s.actionCost(a))
          bestCost = s.actionCost(a);
      }
      s.cost = bestCost;
    }
  }
}

//Find the best path like in A*
void findPaths()
{
  for (int i=0; i < N; i++)
  {
    CURRENT_ROBOT = i;
    State[] goals = findGoalVertices(GRAPHS[i].vertices);
    if (goals.length == 0)
      return;

    Path[] paths = new Path[goals.length];
    for (int j=0; j<paths.length; j++)
    {
      paths[j] = new Path();
    }

    int j = 0;
    for (State g : goals)
    {
      paths[j] = findPath(g, paths[j]);
      j++;
    }
    if (paths.length > 0)
    {
      Path bestPath = paths[0];
      for (Path p : paths)
      {
        if (p.cost() < bestPath.cost())
        {
          bestPath = p;
        }
      }
      FEEDBACK_PATHS[i] = bestPath;
    }
  }
}

Path findPath(State s, Path p)
{
  Edge[] adjEdges = new Edge[0];
  for (int i=0; i<GRAPHS[CURRENT_ROBOT].edges.length; i++)
  {
    if (GRAPHS[CURRENT_ROBOT].edges[i].v2.isEqual(s))
      adjEdges = (Edge[]) append(adjEdges, GRAPHS[CURRENT_ROBOT].edges[i]);
  }

  if (adjEdges.length == 0)
  {
    //println("Path length: "+p.edges.length);
    return p;
  }

  Edge bestEdge = adjEdges[0];
  for (Edge e : adjEdges)
  {
    if (bestEdge.v1.cost > e.v1.cost)
      bestEdge = e;
  }
  if (p == null)
    print("P is null");
  if (bestEdge == null)
    print("bestEdge is null");
  p.pushByEdge(bestEdge);
  return findPath(bestEdge.v1, p);
}

