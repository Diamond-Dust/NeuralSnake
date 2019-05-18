import Jama.*; // Java matrix

public PrintWriter trainer;

public int size[] = {640, 360};
public color backgroundColor = #777777;
public int rayNumber = 10;
public int FOVBaseSize = 50;
public int drawGenerationEvery = 1;
public float safetyMargin = 10.;
public float sightInterval = 5.;
public float consumptionDistance = 15.;
public float fitnessFromDistanceModifier = 1.25;
public float brainMutationRate = 0.01;
public float areaFitnessScale = 150;
Habitat hub = new Habitat(1, 5, 200);

void settings() { 
  size(size[0], size[1]);
}

void setup() {
  trainer = createWriter("./t_data/training_data");
  frameRate(30);
  background(backgroundColor);
}

public boolean wait = true;
public boolean saveCurrentGen = false;
public boolean loadNextGen = false;

void draw() { 
  if(!wait) {
    clear();
    background(backgroundColor);
    hub.update();
    wait = true; //Comment out if smooth simulation is desired
  }
}

public double player_input = 0.5;
public double step = 0.2;

void keyPressed() {
   wait = false;
   if(key == CODED)
     if(keyCode == LEFT)
       player_input = player_input -step < 0 ? 0 : player_input - step;
     else if(keyCode == RIGHT)
       player_input = player_input +step > 1 ? 1 : player_input + step;
}
