class State
{
  // State MEMBERS
  PVector position;
  PVector rotation;
  PVector velocity;
  
  // State CONSTRUCTORS
  State()
  {
    position = new PVector(random(map.width), random(map.height));
    rotation = new PVector(random(2)-1, random(2)-1);
    velocity = new PVector(0,0);
    while(map.pixels[int(position.y)*map.width+int(position.x)] == color(0,0,0))
    {
      position = new PVector(random(map.width), random(map.height));
      rotation = new PVector(random(2)-1, random(2)-1);
      velocity = new PVector(0,0);
    }
  }
  State(PVector _location, PVector _rotation)
  {
    new State();
    position = _location;
    rotation = _rotation;
  }
  
  // State METHODS
  void drawState()
  {
    ellipse(position.x, position.y,3,3);
  }
  String toString()
  {
    return "["+str(position.x)+", "+str(position.y)+"]";
  }
  boolean equals(State s)
  {
    if( position == null )
    {
      DEBOUT("Null position detected");
    }
    if( rotation == null )
    {
      DEBOUT("Null position detected");
    }
    if( velocity == null )
    {
      DEBOUT("Null position detected");
    }
    if(position.equals(s.position) && rotation.equals(s.rotation) && velocity.equals(s.velocity))
      return true;
    else
      return false;
  }
}
