class Action 
{
  PVector acceleration; //action

  Action(float w, float h)
  {
    acceleration = new PVector(w, h);
  }
  Action(float mag)
  {
    acceleration = PVector.fromAngle(random(2*PI));
    acceleration.setMag(mag);
  }
  Action()
  {
    acceleration = PVector.fromAngle(random(2*PI));
    acceleration.setMag(10);
  }
}

