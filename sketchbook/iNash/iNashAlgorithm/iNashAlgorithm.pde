final int N = 1;
final int K = 200000;
int frame = 0;
PImage map;
State[][] vertices = new State[N][1];  //[robot][vertex#]
Edge[][] edges = new Edge[N][1];  //[robot][edge#]
Graph[] graphs = new Graph[N];  //[robot]
State[] goals = new State[N];  //[robot]
int[] finishedRobots = {};  //[finish_order]
Path[] bestPaths = new Path[N];  // Previous best paths [robot]
Path[] _bestPaths = new Path[N];  // Current best paths [robot]
Path[][] otherRobotPaths = new Path[N][1];  //[robot][path#]
int k;
int currentRobot = 0; // For goal checking
color[] robotColors = new color[N];
float[] goalRadii = new float[N];

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
    vertices[i][0] = new State();
    edges[i] = new Edge[0];
    graphs[i] = new Graph(vertices[i], edges[i]);
    goals[i] = new State();
    bestPaths[i] = new Path();
    _bestPaths[i] = new Path();
    robotColors[i] = color(random(150),random(150),random(150),70);
    goalRadii[i] = random(5)+15;
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
      currentRobot = i;
      // sample() in Primitives
      State xrand = sample(); 
      
      // extend() in sketch__Methods
      graphs[i] = extend(graphs[i], xrand);
      vertices[i] = graphs[i].vertices;
      edges[i] =  graphs[i].edges;
      
      // Draw the root
      fill(0,255,0);
      stroke(0,255,0);
      vertices[i][0].drawState();
      
      // draw the graph
      if(graphs[currentRobot].edges.length != 0)
      {
        stroke(robotColors[currentRobot]);
        graphs[currentRobot].drawGraph();
      }
    }
    
    // Check if any robots have reached their goals
    for (int i=0; i<N; i++)
    {
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
        for(State vertex: vertices[i])
        {
          if (vertex == goals[i])
          {
            finishedRobots = append(finishedRobots, i);
            break;
          }
        }
      }
      inA = false;
    }
    
    // Update all finishedRobots' previous bestPaths
    for (int i : finishedRobots)
    {
      // Substitute underscore for tilde
      _bestPaths[i] = bestPaths[i]; 
    }
    
    // Play the game for the current robots best path against all other finishedRobots' best paths
    for(int j : finishedRobots)
    {
      // Reset the otherRobotPaths to all other robots' paths
      otherRobotPaths[j] = null;
      for(int l: finishedRobots)
      {
        if(l < j)
        {
          otherRobotPaths[j] = (Path[]) append(otherRobotPaths[j], bestPaths[l]);
        }
        if(l > j)
        {
 
        }
      }
      
      // Play the game for the current robot vs all other robots' bestPaths
      bestPaths[j] = betterResponse(graphs[j], otherRobotPaths[j], bestPaths[j], goals[j]);
    }
  }
  k++;
}

void draw()
{
  background(map);
  for(int i=0; i<N; i++)
  {
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(goals[i].position.x, goals[i].position.y, goalRadii[i], goalRadii[i]);
    text(str(i)+") vertices: "+str(vertices[i].length), 0, 45+30*i);
  }
  iNash();
  fill(0,255,0);
  stroke(0,255,0);
  text("Iteration: "+str(frame), 0, 15);
  text("Finished robots: "+str(finishedRobots.length), 0, 30);
  frame++;
}
