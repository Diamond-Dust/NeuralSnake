public int size[] = {640, 360};
public color backgroundColor = #777777;
public int rayNumber = 10;
public int FOVBaseSize = 50;
public float safetyMargin = 10.;
public float sightInterval = 5.;
public float consumptionDistance = 15.;
public float fitnessFromDistanceModifier = 1.25;
Habitat hub = new Habitat(5, 5, 2);

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
}
