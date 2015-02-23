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
    rotation.normalize();
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
    ellipse(position.x, position.y, 1, 1);
  }
  String toString()
  {
    return "["+str(position.x)+", "+str(position.y)+"]";
  }
  boolean isEqual(State s)
  {
    if(PVector.sub(position,s.position).equals(new PVector(0,0)))
    {
      //DEBOUT("Equal state found at "+s.toString());
      return true;
    }
    else
      return false;
  }
}
