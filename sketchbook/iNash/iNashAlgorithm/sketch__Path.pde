class Path
{
  State[] vertices;
  Edge[] edges;
  
  Path()
  {
    vertices = new State[0];
    edges = new Edge[0];
  }
  Path(State vertex)
  {
    vertices = new State[1];
    vertices[0] = vertex;
    edges = new Edge[0];
  }
  
  void pushByEdge(Edge edge)
  {
    edges = (Edge[]) append(edges, edge);
    vertices = (State[]) append(vertices, edge.v2);
  }
  void pushByState(State vertex)
  {
    if(vertices == null)
    {
      print("Initializing path vertices\n");
      vertices = new State[1];
      vertices[0] = vertex;
      return;
    }
    else
      vertices = (State[]) append(vertices, vertex); 
    // Null Check?
    if(edges == null)
    {
      edges = new Edge[1];
      edges[0] = new Edge(vertex, vertices[vertices.length-1]);
    }
    else
      edges = (Edge[]) append(edges, new Edge(vertex, vertices[vertices.length-1]));
  }
  boolean checkPath()
  {
    if(vertices == null)
    {
      print("ERROR: Path integrity. No vertices\n");
      return false;
    }
    if(edges == null)
    {
      print("ERROR: Path integrity. No edges\n");
      return false;
    }
    for(State v : vertices)
    {
      if(v == null)
      {
        print("ERROR: Path integrity. Null vertex\n");
        return false;
      }
    }
    
    for(Edge e : edges)
    {
      if(e == null)
      {
        print("ERROR: Path integrity. Null edge\n");
        return false;
      }
    }
    return true;
  }
  void drawPath()
  {
    if(edges.length != 0)
      for(Edge e : edges)
      {
        stroke(0,0,255);
        e.drawEdge();
      }
    else
      print("Edges is empty\n");
  }
}
