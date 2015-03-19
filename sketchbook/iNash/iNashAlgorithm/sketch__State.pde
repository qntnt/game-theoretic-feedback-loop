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
    position = new PVector(floor(random(map.width)), floor(random(map.height)));
    rotation = new PVector(random(2)-1, random(2)-1);
    velocity = new PVector(0, 0);
    time = 0;
    cost = 1;
    while (map.pixels[int (position.y)*map.width+int(position.x)] == color(0, 0, 0))
    {
      position = new PVector(floor(random(map.width)), floor( random(map.height)));
      rotation = new PVector(random(2)-1, random(2)-1);
      velocity = new PVector(0, 0);
      time = 0;
      cost = 1;
    }
    rotation.normalize();
  }
  State(PVector _location)
  {
    new State();
    position = _location.get();
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
    if (position.x % 1 != 0)
      DEBOUT("Position.x not quantized");
    if (position.y % 1 != 0)
      DEBOUT("Position.y not quantized");
    ellipse(int(position.x), int(position.y), 1, 1);
  }
  String toString()
  {
    return "["+str(position.x)+", "+str(position.y)+"]";
  }
  boolean isEqual(State s)
  {
    if (position.x == s.position.x && position.y == s.position.y && velocity.x == s.velocity.x && velocity.y == s.velocity.y)
    {
      //DEBOUT("Equal state found at "+s.toString());
      return true;
    } else
      return false;
  }
  float actionCost(Action a)
  {
    float gamma = 1-(1/ ((float) GRAPHS[CURRENT_ROBOT].vertices.length)); // must be a value between 0 and 1
    State Sprime = nearest(GRAPHS[CURRENT_ROBOT].vertices, new State(PVector.add(PVector.add(PVector.mult(a.acceleration, dt), velocity), position)));
    //float actionCost = PVector.dist(GOALS[CURRENT_ROBOT].position, PVector.add(PVector.add(a.acceleration, velocity), position)); based on position to goal
    // Sprime = closest node on the graph
    float actionCost = pow(a.acceleration.mag()*dt, 2);
    actionCost += Sprime.cost*gamma;
    return actionCost;
  }
}

