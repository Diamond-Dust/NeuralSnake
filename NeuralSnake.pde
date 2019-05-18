import Jama.*; // Java matrix

public int size[] = {640, 360};
public color backgroundColor = #777777;
public int rayNumber = 10; // Must be even
public int FOVBaseSize = 50;
public int drawGenerationEvery = 20;
public float safetyMargin = 10.;
public float sightInterval = 5.;
public float consumptionDistance = 15.;
public float fitnessFromDistanceModifier = 1.25;
public float brainMutationRate = 0.05;
public float brainMutationSpread = 0.01;
public float areaFitnessScale = 150;
Habitat hub = new Habitat(50, 5, 2);

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
    hub.update();
    //wait = true; //Comment out if smooth simulation is desired
  }
}

void keyPressed() {
  wait = false;
  frameRate(30*1000);
}
