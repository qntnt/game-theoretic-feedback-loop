int acceleration_range = 20;

boolean viableAction(State s1, State s2)
{
  if (DYNAMICS_TYPE == DynamicsType.DOUBLE_INTEGRATOR)
  {
    PVector acc = PVector.mult(s1.velocity, -1);
    acc.add(PVector.sub(s2.position, s1.position));
    if (acc.mag() <= acceleration_range)
    {
      DEBOUT("viableAction() returned true.");
      return true;
    } else 
      return false;
  }
  return false;
}
State calcVel(State s1, State s2)
{
  State result = new State(s2.position, s2.rotation);
  PVector acc = PVector.mult(s1.velocity, -1);
  acc.add(PVector.sub(s2.position, s1.position));
  result.velocity = PVector.add(s2.velocity, acc);
  return result;
}
State[] dynamics(State x, State u, float dt)
{
  //Dubin's car
  int resultNum = 10;
  switch(DYNAMICS_TYPE)
  {
  case DUBINS_CAR : 
    return dubinsCar(x, u, dt, resultNum);
  case DOUBLE_INTEGRATOR : 
    return doubleIntegrator(x, u, dt, resultNum);
  default : 
    return dubinsCar(x, u, dt, resultNum);
  }
  //TODO apply dynamics to steer()
  /*PVector direction = PVector.sub(u.position, x.position);
   direction.normalize();
   direction.setMag(dt);
   State steered = new State();
   steered.position = PVector.add(x.position, direction);
   State[] result = {steered};*/
}

// SECTION
// DYNAMICS TYPES

State[] dubinsCar(State x, State u, float dt, int resultNum)
{
  State[] results = new State[0];
  float velocity = 1;
  float theta = x.rotation.heading();
  float turnRadius = PI/8;
  for (int i=0; i<resultNum; i++)
  {
    float temp = theta - turnRadius + (i*turnRadius*2/resultNum);
    State tempState = new State(x.position.get(), x.rotation.get());
    tempState.rotation = PVector.fromAngle(temp);
    tempState.rotation.setMag(velocity*dt);
    tempState.position.add(tempState.rotation);
    tempState.time = x.time + 1;
    if (obstacleFree(x, tempState))
      results = (State[]) append(results, tempState);
  }
  return results;
}
boolean dubinCheck(State x, State y)
{
  return false;
}
State[] doubleIntegrator(State x, State u, float dt, int resultNum)
{
  // #TODO
  float[] acceleration_set = new float[0];
  for (int i=0; i<acceleration_range; i++)
  {
    acceleration_set = (float[]) append(acceleration_set, acceleration_range/2-acceleration_range + i);
  }
  State[] results = new State[acceleration_set.length];
  PVector accDirection = PVector.sub(u.position, x.position);
  for (int i=0; i<acceleration_set.length; i++)
  {
    State temp = new State(x);
    accDirection.setMag(acceleration_set[i]);
    temp.velocity.add(accDirection);
    temp.position.add(temp.velocity);
    results[i] = temp;
  }
  return results;
}

