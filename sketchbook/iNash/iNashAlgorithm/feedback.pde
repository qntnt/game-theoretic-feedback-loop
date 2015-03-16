void feedbackLoop()
{
  for(int i=0; i<N; i++)
  {
    float bestCost = 10000;
    for(State s : GRAPHS[i].vertices)
    {
      for(Action a : ACTIONS)
      {
        if(bestCost > s.actionCost(a))
          bestCost = s.actionCost(a);
      }
      s.cost = bestCost;
    }
  }
}
