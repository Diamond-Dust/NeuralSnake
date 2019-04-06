public int size[] = {640, 360};
public color backgroundColor = #000000;
public int rayNumber = 10;
public int FOVBaseSize = 50;
public float safetyMargin = 10.;
public float sightInterval = 5.;
public float consumptionDistance = 15.;
public float fitnessFromDistanceModifier = 1.25;
//CreatureDen den = new CreatureDen(1,5);
//LifeTime life = new LifeTime(5, 2);
//Snake snek = new Snake();
Habitat hub = new Habitat(5, 5, 2);

void settings() { 
  size(640, 360);
}

void setup() {
  frameRate(30);
  background(backgroundColor);
  //life.setSpecimen(snek);
}

public boolean wait = true;

void draw() { 
  if(!wait) {
    clear();
    background(backgroundColor);
    //den.update(); //<>//
    /*if(life.update()) {
      life.setSpecimen(snek);
      life.startTiming();
      snek.setPosition();
      println(life.popFitness());
      //snek.fitness = 0;
    }*/
    hub.update();
    //wait = true; //Comment out if smooth simulation is desired
  }
}

void keyPressed() {
  wait = false;
}
