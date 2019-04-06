class Habitat {
  LifeTime life;
  ArrayList<Snake> snakes;
  float[] fitnesses;
  int currentSnake = 0;
  
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
    fitnesses = new float[1];
    fitnesses[0] = 0;
    life.setSpecimen(snakes.get(0));
  };
  Habitat(int numOfSnakes, int numOfMice, int numOfSeconds) {
    life = new LifeTime(numOfMice, numOfSeconds);
    snakes = new ArrayList<Snake>(numOfSnakes);
    fitnesses = new float[numOfSnakes];
    for(int i=0; i<numOfSnakes; i++){
      snakes.add(new Snake());
      fitnesses[i] = 0;
    }
    life.setSpecimen(snakes.get(0));
  };
  
  void update() {
    if(life.update()) {
      life.setSpecimen(snakes.get(currentSnake));
      life.startTiming();
      snakes.get(currentSnake).setPosition();
      fitnesses[currentSnake] = life.popFitness();
      currentSnake++;
    }
    
    if(snakes.size() <= currentSnake) {
      nextGeneration();
    }
  };
  
  void nextGeneration() {
    //TODO
    currentSnake = 0;
  };
  
};
