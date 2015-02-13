class Edge
{
  State v1;
  State v2;
  
  Edge(State _v1, State _v2)
  {
    v1 = _v1;
    v2 = _v2;
  }
  void drawEdge()
  {
    line(v1.position.x, v1.position.y, v2.position.x, v2.position.y);
    v1.drawState();
    v2.drawState();
  }
}
