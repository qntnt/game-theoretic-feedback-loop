class Graph
{
  State[] vertices;
  Edge[] edges;
  
  Graph()
  {
    vertices = new State[0];
    edges = new Edge[0];
  }
  Graph(State[] _vertices, Edge[] _edges)
  {
    vertices = new State[_vertices.length];
    arrayCopy(_vertices, vertices);
    edges = new Edge[_edges.length];
    arrayCopy(_edges, edges);
  }
  void drawGraph()
  {
    for(Edge e : edges)
    {
      e.drawEdge();
    }
  }
  Edge[] childEdges(State v)
  {
    Edge[] results = new Edge[0];
    for(Edge e : edges)
    {
      if(e.v1.isEqual(v))
        results = (Edge[]) append(results, e);
    }
    return results;
  }
  Edge[] parentEdges(State v)
  {
    Edge[] results = new Edge[0];
    for(Edge e : edges)
    {
      if(e.v2.isEqual(v) && e.v2.position != null && v.position != null)
      {
        results = (Edge[]) append(results, e);
        //DEBOUT("Parent edge: "+e.toString());
      }
    }
    //DEBOUT(str(results.length)+" child edges");
    return results;
  }
  Graph copy()
  {
    Graph copy = new Graph();
    copy.vertices = new State[vertices.length];
    copy.edges = new Edge[edges.length];
    arrayCopy( vertices, copy.vertices);
    arrayCopy( edges, copy.edges);
    return copy;
  }
}
