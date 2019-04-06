public int size[] = {640, 360};
public color backgroundColor = #000000;
public int rayNumber = 10;
public int FOVBaseSize = 50;
public float safetyMargin = 10.;
public float sightInterval = 5.;
GeneticSimulation simulation = new GeneticSimulation();
 //<>//
void settings() { 
  size(size[0], size[1]);
}

void setup() {
  frameRate(30);
  background(backgroundColor);
}

public boolean wait = true;

void draw() { 
  if(!wait) {
    clear();
    background(backgroundColor);
    simulation.update();
    //wait = true; //Comment out if smooth simulation is desired //<>//
  }
}

void keyPressed() {
  wait = false;
}
