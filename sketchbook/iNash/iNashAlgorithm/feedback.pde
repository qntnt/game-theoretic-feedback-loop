boolean traceFromRoot = false;

void feedbackLoop()
{
  DEBOUT("=== STARTING FEEDBACK LOOP ===");
  calculateCosts();
  findPaths();
}

void calculateCosts()
{
  for (int i=0; i<N; i++)
  {
    CURRENT_ROBOT = i;
    for (State s : GRAPHS[i].vertices)
    {
      float bestCost = s.cost;
      if(inGoal(s))
        s.cost = -10000;
      else
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
}

//Find the best path like in A*
void findPaths()
{
  for (int i : FINISHED_ROBOTS)
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
    if(traceFromRoot)
    {
      FEEDBACK_PATHS[i] = findPathFromRoot(VERTICES[i][0], new Path());
      DEBOUT("feedback path edges #: "+str(FEEDBACK_PATHS[i].edges.length));
      DEBOUT("feedback path verts #: "+str(FEEDBACK_PATHS[i].vertices.length));
    }
    else
    {
      for (State g : goals)
      {
        paths[j] = findPathFromGoal(g, paths[j]);
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
        DEBOUT("feedback path edges #: "+str(bestPath.edges.length));
        DEBOUT("feedback path verts #: "+str(bestPath.vertices.length));
        FEEDBACK_PATHS[i] = bestPath;
      }
    }
  }
}

Path findPathFromGoal(State s, Path p)
{
  if(p.vertices.length == 0)
    p.vertices = (State[]) append(p.vertices, s);
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
  return findPathFromGoal(bestEdge.v1, p);
}

Path findPathFromRoot(State s, Path p)
{
  if(p.vertices.length == 0)
    p.vertices = (State[]) append(p.vertices, s);
  Edge[] adjEdges = new Edge[0];
  for (int i=0; i<GRAPHS[CURRENT_ROBOT].edges.length; i++)
  {
    if (GRAPHS[CURRENT_ROBOT].edges[i].v1.isEqual(s))
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
    if (bestEdge.v2.cost > e.v2.cost)
      bestEdge = e;
  }
  if (p == null)
    print("P is null");
  if (bestEdge == null)
    print("bestEdge is null");
  p.appendByEdge(bestEdge);
  return findPathFromRoot(bestEdge.v2, p);
}
