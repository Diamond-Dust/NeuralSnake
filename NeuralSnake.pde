import Jama.*; // Java matrix

public String savePath = "./snakes/";
public String trainPath = "./t_data/";
BufferedReader in;

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
  in = createReader("./t_data/training_data_5k");
}

void setup() {
  frameRate(60);
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
    //wait = true; //Comment out if smooth simulation is desired
  }
}

void keyPressed() {
  if(key == 's' || key == 'S'){
    saveCurrentGen = true;
  } else if(key == 'l' || key == 'L') {
    selectInput("Select file containing valid generation info:", "loadGeneration");
  } else {
     wait = false;
    frameRate(30*1000);
  }
}
