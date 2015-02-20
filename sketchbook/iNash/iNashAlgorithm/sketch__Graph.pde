class Graph
{
  State[] vertices;
  Edge[] edges;
  
  Graph(State[] _vertices, Edge[] _edges)
  {
    vertices = _vertices;
    edges = _edges;
  }
  void drawGraph()
  {
    for(Edge e : edges)
    {
      e.drawEdge();
    }
  }
}
