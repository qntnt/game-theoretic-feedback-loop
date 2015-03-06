class State
{
  // State MEMBERS
  PVector position;
  PVector rotation; // for use with 'dubins_car' dynamics
  PVector velocity; // for use with 'double_integrator' dynamics
  float time;
  float cost;
  
  // State CONSTRUCTORS
  State()
  {
    position = new PVector(random(map.width), random(map.height));
    rotation = new PVector(random(2)-1, random(2)-1);
    velocity = new PVector(0,0);
    time = 0;
    cost = 0;
    while(map.pixels[int(position.y)*map.width+int(position.x)] == color(0,0,0))
    {
      position = new PVector(random(map.width), random(map.height));
      rotation = new PVector(random(2)-1, random(2)-1);
      velocity = new PVector(0, 0);
      time = 0;
      cost = 0;
    }
    rotation.normalize();
  }
  State(PVector _location, PVector _rotation)
  {
    new State();
    position = _location.get();
    rotation = _rotation.get();
  }
  State(State s)
  {
    position = s.position.get();
    rotation = s.rotation.get();
    velocity = s.velocity.get();
    time = s.time;
    cost = s.cost;
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
  float actionCost(float action)
  {
    return 0;
  }
}
