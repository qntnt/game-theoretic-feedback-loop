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
    DEBOUT("Initializing path with vertex: "+vertex.toString());
    vertices = new State[1];
    vertices[0] = vertex;
    edges = new Edge[0];
  }
  
  void pushByEdge(Edge edge)
  {
    //DEBOUT("Pushing path by edge");
    vertices = (State[]) append(vertices, edge.v1);
    edges = (Edge[]) append(edges, edge);
  }
  void pushByState(State vertex)
  {
    //DEBOUT("Pushing path by state");
    if(vertices.length == 0)
    {
      new Path(vertex);
    }
    else
    {
      if(edges.length == 0)
      {
        edges = new Edge[1];
        edges[0] = new Edge(vertices[vertices.length-1],vertex);
      }
      else
        edges = (Edge[]) append(edges, new Edge(vertices[vertices.length-1],vertex));
        
      vertices = (State[]) append(vertices, vertex); 
    }
  }
  boolean checkPath()
  {
    if(vertices.length == 0)
    {
      DEBOUT("ERROR: Path integrity. No vertices\n");
      return false;
    }
    if(edges.length == 0)
    {
      DEBOUT("ERROR: Path integrity. No edges\n");
      return false;
    }
    for(State v : vertices)
    {
      if(v == null)
      {
        DEBOUT("ERROR: Path integrity. Null vertex\n");
        return false;
      }
    }
    
    for(Edge e : edges)
    {
      if(e == null)
      {
        DEBOUT("ERROR: Path integrity. Null edge\n");
        return false;
      }
    }
    return true;
  }
  void drawPath()
  {
    strokeWeight(2);
    if(edges.length != 0)
      for(Edge e : edges)
      {
        stroke(0,0,255);
        e.drawEdge();
        
      }
    else
      print("Edges is empty\n");
    
    strokeWeight(1);
  }
}
