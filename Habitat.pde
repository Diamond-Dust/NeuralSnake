class Habitat {
  LifeTime life;
  ArrayList<Snake> snakes;
  FloatList fitnesses;
  int currentSnake = 0, currentGeneration = 0;
  
  Habitat(){
    life = new LifeTime(5, -1);
    snakes = new ArrayList<Snake>(1);
    snakes.add(new Snake());
    life.setSpecimen(snakes.get(0));
  };
  Habitat(int numOfMice, int numOfSeconds) {
    life = new LifeTime(numOfMice, numOfSeconds);
    snakes = new ArrayList<Snake>(1);
    snakes.add(new Snake());
    fitnesses = new FloatList(1);
    life.setSpecimen(snakes.get(0));
  };
  Habitat(int numOfSnakes, int numOfMice, int numOfSeconds) {
    life = new LifeTime(numOfMice, numOfSeconds);
    snakes = new ArrayList<Snake>(numOfSnakes);
    fitnesses = new FloatList(numOfSnakes);
    for(int i=0; i<numOfSnakes; i++){
      snakes.add(new Snake());
    }
    life.setSpecimen(snakes.get(0));
  };
  
  void update() {
    if(life.update()) {
      life.setSpecimen(snakes.get(currentSnake));
      life.startTiming();
      snakes.get(currentSnake).setPosition();
      fitnesses.append(life.popFitness());
      currentSnake++;
    }
    
    if(snakes.size() <= currentSnake) {
      nextGeneration();
      currentGeneration++;
    }
    
    writeGenInfo();
  };
  
  void nextGeneration() {
    float fitnessSum=0, curSum, fitnessRoll;
    fitnessSum = fitnesses.sum();
    
    ArrayList<Snake> newGeneration = new ArrayList<Snake>();
    
    while(newGeneration.size() < (float)snakes.size()/2) {
      fitnessRoll = random(fitnessSum);
      curSum = 0;
      for(int i=0; i<snakes.size(); i++){
        curSum += fitnesses.get(i);
        if(curSum >= fitnessRoll) {
          fitnessSum -= fitnesses.get(i);
          newGeneration.add(snakes.get(i));
          snakes.remove(i);
          fitnesses.remove(i);
        }
      }
    }
    
    while(newGeneration.size() < snakes.size()) {
      int newGenHalfSize = newGeneration.size();
      for(int i=0; i<newGenHalfSize; i++){
        newGeneration.add(new Snake(newGeneration.get(i)));
      }
    }
    
    currentSnake = 0;
  };
  
  void writeGenInfo() {
    String cS = 'G'+str(currentGeneration)+" #"+str(currentSnake);
    rectMode(CORNERS);  
    fill(200);  
    rect(0, size[1]-25, 50, size[1]);  
    fill(50);  
    textSize(14);
    textAlign(CENTER, CENTER);
    text(cS, 0, size[1]-25, 50, size[1]);
    noFill();
  };
  
};
