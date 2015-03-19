class Action 
{
  PVector acceleration; //action

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
  Action(float mag, float dir)
  {
    acceleration = PVector.fromAngle(dir);
    acceleration.setMag(mag);
  }
  
  Action sample()
  {
    return new Action(random(ACTION_MAG));
  }
}

