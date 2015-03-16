void iNash()
{
  DEBOUT("");
  DEBOUT("=== STARTING iNASH ===");
  if (!(k >= K))
  {
    // Sample and extend all robots' graphs
    for (int i=0; i<N; i++)
    {
      CURRENT_ROBOT = i;
      // sample() in Primitives
      State xrand = sample(); 
      
      // extend() in sketch__Methods
      GRAPHS[i] = extend(GRAPHS[i].copy(), xrand);
      VERTICES[i] = GRAPHS[i].vertices;
      EDGES[i] =  GRAPHS[i].edges;
      
    }
    
    // Check if any robots have reached their GOALS
    for (int i=0; i<N; i++)
    {
      CURRENT_ROBOT = i;
      // Begin BOILERPLATE
      boolean inA = false;
      for(int j :  FINISHED_ROBOTS)
      {
        if(i == j)
        {
          inA = true;
          break;
        }
      }
      // End BOILERPLATE
      if(!inA)
      {
        for(State vertex: GRAPHS[i].vertices)
        {
          if (inGoal(vertex))
          {
            FINISHED_ROBOTS = append(FINISHED_ROBOTS, i);
            break;
          }
        }
      }
      inA = false;
    }
    
    // Update all FINISHED_ROBOTS' previous BEST_PATHS
    for (int i : FINISHED_ROBOTS)
    {
      // Substitute underscore for tilde
      _BEST_PATHS[i] = BEST_PATHS[i]; 
    }
    // Play the game for the current robots best path against all other FINISHED_ROBOTS' best paths
    for(int j : FINISHED_ROBOTS)
    {
      CURRENT_ROBOT = j;
      // Reset the OTHER_ROBOT_PATHS to all other robots' paths
      OTHER_ROBOT_PATHS[j] = new Path[0];
      for(int l : FINISHED_ROBOTS)
      {
        if(l < j)
        {
          OTHER_ROBOT_PATHS[j] = (Path[]) append(OTHER_ROBOT_PATHS[j], BEST_PATHS[l].copy());
        }
        if(l > j)
        {
          OTHER_ROBOT_PATHS[j] = (Path[]) append(OTHER_ROBOT_PATHS[j], BEST_PATHS[l].copy());
        }
      }
      
      // Play the game for the current robot vs all other robots' BEST_PATHS
      BEST_PATHS[j] = betterResponse(GRAPHS[j], OTHER_ROBOT_PATHS[j], BEST_PATHS[j], GOALS[j]);
      DEBOUT(str(j)+") best path length: "+str(BEST_PATHS[j].edges.length));
      strokeWeight(2);
      stroke(color((ROBOT_COLORS[j] & 0xffffff) | (200 << 24)));
      BEST_PATHS[j].drawPath();
      strokeWeight(1);
    }
  }
  k++;
  
}
