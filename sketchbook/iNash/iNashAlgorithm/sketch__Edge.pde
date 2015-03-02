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
    color c = g.strokeColor;
    PVector halfway = v1.position.get();
    halfway.lerp(v2.position, 0.8);
    line(v1.position.x, v1.position.y, halfway.x, halfway.y);
    stroke(255,0,0);
    line(halfway.x, halfway.y, v2.position.x, v2.position.y);
    stroke(c);
  }
  
  float cost()
  {
    return PVector.dist(v2.position, v1.position);
  }
  
  boolean isEqual(Edge e)
  {
    if(v1.isEqual(e.v1) && v2.isEqual(e.v2))
    {
      return true;
    }
    return false;
  }
  String toString()
  {
    return v1.toString()+"->"+v2.toString();
  }
  float slope()
  {
    return (v1.position.y - v2.position.y)/(v1.position.x - v2.position.x);
  }
  boolean crosses(Edge e)
  {
    float a1 = v1.position.y - slope()*v1.position.x;
    float a2 = e.v1.position.y - e.slope()*e.v1.position.x;
    float xi = - (a1-a2)/(slope() - e.slope());
    if((v1.position.x - xi)*(xi - v2.position.x) >= 0)
      return true;
    else
      return false;
  }
}
