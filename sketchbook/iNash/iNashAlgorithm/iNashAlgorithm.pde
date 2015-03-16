final int N = 1;
final int K = 200000;
int frame = 0;
PImage map;
State[][] VERTICES;  //[robot][vertex#]
Edge[][] EDGES;  //[robot][edge#]
Graph[] GRAPHS;  //[robot]
State[] GOALS;  //[robot]
int[] FINISHED_ROBOTS;  //[finish_order]
Path[] BEST_PATHS;  // Previous best paths [robot]
Path[] _BEST_PATHS;  // Current best paths [robot]
Path[][] OTHER_ROBOT_PATHS;  //[robot][path#]
int k;
int CURRENT_ROBOT; // For goal checking
color[] ROBOT_COLORS;
float[] GOAL_RADII;
Action[] ACTIONS;

boolean DEBUG = false;
boolean DRAW_GRAPH = true;
boolean DRAW_INFO = false;
boolean DRAW_STATES = false;

DynamicsType DYNAMICS_TYPE = DynamicsType.DOUBLE_INTEGRATOR;

String FEEDBACK_COST_FILENAME = "feedback_cost.log";
String PATH_COST_FILENAME = "path_cost.log";

PrintWriter FEEDBACK_COST_OUTPUT;
PrintWriter PATH_COST_OUTPUT;

void setup()
{
  // Setup data logging
  FEEDBACK_COST_OUTPUT = createWriter(FEEDBACK_COST_FILENAME);
  PATH_COST_OUTPUT = createWriter(PATH_COST_FILENAME);
  
  frameRate(10000);
  map = loadImage("map1.png");
  size(map.width,map.height);
  
  ACTIONS = new Action[0];
  for(int i=0; i<100; i++)
  {
    ACTIONS = (Action[]) append(ACTIONS, new Action(random(width), random(height)));
  }
  VERTICES = new State[N][1];
  EDGES = new Edge[N][1];
  GRAPHS = new Graph[N];
  GOALS = new State[N];
  FINISHED_ROBOTS = new int[0];
  BEST_PATHS = new Path[N];
  _BEST_PATHS = new Path[N];
  OTHER_ROBOT_PATHS = new Path[N][N];
  k=0;
  CURRENT_ROBOT = 0; 
  ROBOT_COLORS = new color[N];
  GOAL_RADII = new float[N];
  for (int i=0; i<N; i++)
  {
    VERTICES[i][0] = new State();
    EDGES[i] = new Edge[0];
    GRAPHS[i] = new Graph(VERTICES[i], EDGES[i]);
    GOALS[i] = new State();
    BEST_PATHS[i] = new Path();
    _BEST_PATHS[i] = new Path();
    ROBOT_COLORS[i] = color(random(150),random(150),random(150),150);
    GOAL_RADII[i] = random(5)+15;
  }
  k=1;
}

void draw()
{
  background(map);
  
  // REGION iNash Algorithm + Feedback loop
  iNash();
  feedbackLoop();
  
  // Draw robots
  for(int i=0; i<N; i++)
  {
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(GOALS[i].position.x, GOALS[i].position.y, GOAL_RADII[i], GOAL_RADII[i]);
    fill(ROBOT_COLORS[i]);
    stroke(ROBOT_COLORS[i]);
    ellipse(VERTICES[i][0].position.x, VERTICES[i][0].position.y, 6, 6);
    stroke(0);
    strokeWeight(2);
    line(VERTICES[i][0].position.x, VERTICES[i][0].position.y,
      PVector.add(VERTICES[i][0].position,
        PVector.mult(VERTICES[i][0].rotation, 6)).x, 
      PVector.add(VERTICES[i][0].position,
        PVector.mult(VERTICES[i][0].rotation, 6)).y);
      strokeWeight(1);
    
    // draw the graph
    if(GRAPHS[i].edges.length != 0 && DRAW_GRAPH)
    {
      stroke(ROBOT_COLORS[i]);
      GRAPHS[i].drawGraph();
    }
    if(DRAW_STATES)
    {
      for(State s : VERTICES[i])
      {
        s.drawState();
      }
    }
  }
  // Draw information
  if(DRAW_INFO)
  {
    fill(255,255,255,190);
    stroke(255,255,255,210);
    rect(0,0,225,50+75*N);
  }
  for(int i=0; i<N; i++)
  {
    if(k % 100 == 0)
    {
      FEEDBACK_COST_OUTPUT.println(str(i)+","+"TODO"+"\n");
      PATH_COST_OUTPUT.println(str(i)+","+BEST_PATHS[i].vertices.length+"\n");
    }
    if(DRAW_INFO)
    {
      fill(ROBOT_COLORS[i]);
      stroke(ROBOT_COLORS[i]);
      text(str(i)+") location: "+VERTICES[i][0].toString(), 0, 45+75*i);
      text("    vertices: "+str(VERTICES[i].length), 0, 60+75*i);
      text("    edges: "+str(VERTICES[i].length), 0, 75+75*i);
      text("    path length: "+str(BEST_PATHS[i].vertices.length), 0, 90+75*i);
      text("    goal: "+GOALS[i].toString(), 0, 105+75*i);
      //VERTICES[i][0].drawState();
      text("("+str(i)+")",VERTICES[i][0].position.x+5, VERTICES[i][0].position.y);
    }
  }
  fill(0,255,0);
  stroke(0,255,0);
  text("Iteration: "+str(frame), 0, 15);
  text("Finished robots: "+str(FINISHED_ROBOTS.length), 200, 15);
  text("'D':debug, 'S':states, 'G':graph, 'I':info, 'P':pause", 0, 30);
  frame++;
}

// HELPER FUNCTIONS

void DEBOUT(String s)
{
  if(DEBUG)
    print("("+minute()+"m"+second()+"s)    "+s+"\n");
}

void keyPressed() {
  final int k = keyCode;

  if (k == 'P')
  {
    if (looping)  
    {
      noLoop();
    }
    else          loop();
  }
  if(k == 'I')
    DRAW_INFO = !DRAW_INFO;
  if(k == 'G')
  {
    DRAW_GRAPH = !DRAW_GRAPH;
    DRAW_STATES = false;
  }
  if(k == 'R') {
    frame=0;
    setup();
  }
  if(k == 'S')
  {
    DRAW_STATES = !DRAW_STATES;
    DRAW_GRAPH = false;
  }
  if(k == 'D')
    DEBUG = !DEBUG;
  if(k == 'Q')
  { 
    FEEDBACK_COST_OUTPUT.flush();
    PATH_COST_OUTPUT.flush();
    FEEDBACK_COST_OUTPUT.close();
    PATH_COST_OUTPUT.close();
    save("final_env.png");
    exit();
  }
}
