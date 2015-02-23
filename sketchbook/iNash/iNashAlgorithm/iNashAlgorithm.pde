final int N = 4;
final int K = 200000;
int frame = 0;
PImage map;
State[][] VERTICES = new State[N][1];  //[robot][vertex#]
Edge[][] EDGES = new Edge[N][1];  //[robot][edge#]
Graph[] GRAPHS = new Graph[N];  //[robot]
State[] GOALS = new State[N];  //[robot]
int[] finishedRobots = {};  //[finish_order]
Path[] BEST_PATHS = new Path[N];  // Previous best paths [robot]
Path[] _BEST_PATHS = new Path[N];  // Current best paths [robot]
Path[][] otherRobotPaths = new Path[N][N];  //[robot][path#]
int k;
int CURRENT_ROBOT = 0; // For goal checking
color[] ROBOT_COLORS = new color[N];
float[] GOAL_RADII = new float[N];

boolean DEBUG = true;
boolean DRAW_GRAPH = true;

void DEBOUT(String s)
{
  if(DEBUG)
    print("("+minute()+"m"+second()+"s)\t"+s+"\n");
}

void keyPressed() {
  final int k = keyCode;

  if (k == ' ')
    if (looping)  noLoop();
    else          loop();
}

void setup()
{
  frameRate(10000);
  map = loadImage("map1.png");
  size(map.width,map.height);
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

void iNash()
{
  if (!(k >= K))
  {
    // Sample and extend all robots' graphs
    for (int i=0; i<N; i++)
    {
      CURRENT_ROBOT = i;
      // sample() in Primitives
      State xrand = sample(); 
      
      // extend() in sketch__Methods
      GRAPHS[i] = extend(GRAPHS[i], xrand);
      VERTICES[i] = GRAPHS[i].vertices;
      EDGES[i] =  GRAPHS[i].edges;
      
      // draw the graph
      if(GRAPHS[i].edges.length != 0 && DRAW_GRAPH)
      {
        stroke(ROBOT_COLORS[i]);
        GRAPHS[i].drawGraph();
      }
    }
    
    // Check if any robots have reached their GOALS
    for (int i=0; i<N; i++)
    {
      CURRENT_ROBOT = i;
      // Begin BOILERPLATE
      boolean inA = false;
      for(int j :  finishedRobots)
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
            finishedRobots = append(finishedRobots, i);
            break;
          }
        }
      }
      inA = false;
    }
    
    // Update all finishedRobots' previous BEST_PATHS
    for (int i : finishedRobots)
    {
      // Substitute underscore for tilde
      _BEST_PATHS[i] = BEST_PATHS[i]; 
    }
    
    // Play the game for the current robots best path against all other finishedRobots' best paths
    for(int j : finishedRobots)
    {
      CURRENT_ROBOT = j;
      // Reset the otherRobotPaths to all other robots' paths
      otherRobotPaths[j] = new Path[0];
      for(int l : finishedRobots)
      {
        if(l < j)
        {
          otherRobotPaths[j] = (Path[]) append(otherRobotPaths[j], BEST_PATHS[l]);
        }
        if(l > j)
        {
          otherRobotPaths[j] = (Path[]) append(otherRobotPaths[j], BEST_PATHS[l]);
        }
      }
      
      // Play the game for the current robot vs all other robots' BEST_PATHS
      BEST_PATHS[j] = betterResponse(GRAPHS[j], otherRobotPaths[j], BEST_PATHS[j], GOALS[j]);
      DEBOUT(str(j)+") path length: "+str(BEST_PATHS[j].edges.length));
      stroke(0,0,255,100);
      BEST_PATHS[j].drawPath();
    }
  }
  k++;
}

void draw()
{
  background(map);
  iNash();
  fill(255,255,255,150);
  stroke(255,255,255,150);
  rect(0,0,200,50+75*N);
  for(int i=0; i<N; i++)
  {
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(GOALS[i].position.x, GOALS[i].position.y, GOAL_RADII[i], GOAL_RADII[i]);
    fill(ROBOT_COLORS[i]);
    stroke(ROBOT_COLORS[i]);
    text(str(i)+") location: "+VERTICES[i][0].toString(), 0, 45+75*i);
    text("    vertices: "+str(VERTICES[i].length), 0, 60+75*i);
    text("    edges: "+str(VERTICES[i].length), 0, 75+75*i);
    text("    path length: "+str(BEST_PATHS[i].vertices.length), 0, 90+75*i);
    text("    goal: "+GOALS[i].toString(), 0, 105+75*i);
    VERTICES[i][0].drawState();
    text("("+str(i)+")",VERTICES[i][0].position.x+5, VERTICES[i][0].position.y);
  }
  fill(0,255,0);
  stroke(0,255,0);
  text("Iteration: "+str(frame), 0, 15);
  text("Finished robots: "+str(finishedRobots.length), 0, 30);
  frame++;
}
