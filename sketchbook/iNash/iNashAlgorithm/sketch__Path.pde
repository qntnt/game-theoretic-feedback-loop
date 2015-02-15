class Path
{
  State[] vertices;
  Edge[] edges;
  
  Path()
  {
    vertices = null;
    edges = null;
  }
  Path(State vertex)
  {
    vertices = new State[1];
    vertices[0] = vertex;
    edges = null;
  }
  
  void pushByEdge(Edge edge)
  {
    edges = (Edge[]) append(edges, edge);
    vertices = (State[]) append(vertices, edge.v2);
  }
  void pushByVertex(State vertex)
  {
    edges = (Edge[]) append(edges, new Edge(vertices[vertices.length-1], vertex));
    vertices = (State[]) append(vertices, vertex); 
  }
}
