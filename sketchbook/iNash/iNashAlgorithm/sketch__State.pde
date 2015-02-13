class State
{
  // State MEMBERS
  PVector position;
  PVector rotation;
  PVector velocity;
  
  // State CONSTRUCTORS
  State()
  {
    position = new PVector(random(width), random(height));
    rotation = new PVector(random(2)-1, random(2)-1);
    velocity = new PVector(0,0);
    while(map.pixels[int(position.y)*width+int(position.x)] == color(0,0,0))
    {
      position = new PVector(random(width), random(height));
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
    ellipse(position.x, position.y,2,2);
  }
}
