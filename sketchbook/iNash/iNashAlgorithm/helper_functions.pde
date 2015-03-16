
// HELPER FUNCTIONS

void DEBOUT(String s)
{
  if (DEBUG)
    print("("+minute()+"m"+second()+"s)    "+s+"\n");
}

void keyPressed() {
  final int k = keyCode;

  if (k == 'P')
  {
    if (looping)  
    {
      noLoop();
    } else          loop();
  }
  if (k == 'I')
    DRAW_INFO = !DRAW_INFO;
  if (k == 'G')
  {
    DRAW_GRAPH = !DRAW_GRAPH;
    DRAW_STATES = false;
  }
  if (k == 'R') {
    frame=0;
    for (int i=0; i<N; i++)
    {
      FEEDBACK_COST_OUTPUT[i].flush();
      PATH_COST_OUTPUT[i].flush();
      VERTS_EDGES_OUTPUT[i].flush();
      FEEDBACK_COST_OUTPUT[i].close();
      PATH_COST_OUTPUT[i].close();
      VERTS_EDGES_OUTPUT[i].close();
    }
    save("output_"+timestamp+"/final_env.png");
    setup();
  }
  if (k == 'S')
  {
    DRAW_STATES = !DRAW_STATES;
    DRAW_GRAPH = false;
  }
  if (k == 'D')
    DEBUG = !DEBUG;
  if (k == 'Q')
  { 
    for (int i=0; i<N; i++)
    {
      FEEDBACK_COST_OUTPUT[i].flush();
      PATH_COST_OUTPUT[i].flush();
      VERTS_EDGES_OUTPUT[i].flush();
      FEEDBACK_COST_OUTPUT[i].close();
      PATH_COST_OUTPUT[i].close();
      VERTS_EDGES_OUTPUT[i].close();
    }
    save("output_"+timestamp+"/final_env.png");
    exit();
  }
}

