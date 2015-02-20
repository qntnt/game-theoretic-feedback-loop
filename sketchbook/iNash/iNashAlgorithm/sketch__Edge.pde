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
    PVector halfway = v1.position.get();
    halfway.lerp(v2.position, 0.8);
    line(v1.position.x, v1.position.y, halfway.x, halfway.y);
    stroke(255,0,0);
    line(halfway.x, halfway.y, v2.position.x, v2.position.y);
    stroke(robotColors[currentRobot]);
    v1.drawState();
    v2.drawState();
  }
}
