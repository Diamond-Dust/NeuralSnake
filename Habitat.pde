class Habitat {
  LifeTime life;
  ArrayList<Snake> snakes;
  FloatList fitnesses;
  int currentSnake = 0, currentGeneration = 0;
  int population;
  
  Habitat(){
    life = new LifeTime(5, -1);
    snakes = new ArrayList<Snake>(1);
    population = 1;
    snakes.add(new Snake());
    life.setSpecimen(snakes.get(0));
  };
  Habitat(int numOfMice, int numOfSeconds) {
    life = new LifeTime(numOfMice, numOfSeconds);
    snakes = new ArrayList<Snake>(1);
    snakes.add(new Snake());
    population = 1;
    fitnesses = new FloatList(1);
    life.setSpecimen(snakes.get(0));
  };
  Habitat(int numOfSnakes, int numOfMice, int numOfSeconds) {
    life = new LifeTime(numOfMice, numOfSeconds);
    snakes = new ArrayList<Snake>(numOfSnakes);
    population = numOfSnakes;
    fitnesses = new FloatList(numOfSnakes);
    for(int i=0; i<numOfSnakes; i++){
      snakes.add(new Snake());
    }
    life.setSpecimen(snakes.get(0));
  };
  
  void update() {
    if(life.update(currentGeneration % drawGenerationEvery == 0)) {
      if(currentGeneration % drawGenerationEvery == 0){
        frameRate(30);
      } else{
        frameRate(30*1000);
      }
      fitnesses.append(life.popFitness());
      life.setSpecimen(snakes.get(currentSnake));
      life.startTiming();
      snakes.get(currentSnake).setPosition();
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
    print(fitnessSum + "\n");
    if(fitnessSum < 1e-9) {
      print("Generation " + currentGeneration + " unusable\n");
      while(newGeneration.size() < population) {
        newGeneration.add(new Snake());
      }
    }
    else {
      while(newGeneration.size() < population/2 + population%2) {
        fitnessRoll = random(fitnessSum);
        curSum = 0;
        for(int i=0; i<snakes.size(); i++){
          curSum += fitnesses.get(i);
          if(curSum >= fitnessRoll) {
            fitnessSum -= fitnesses.get(i);
            newGeneration.add(snakes.get(i));
            snakes.remove(i);
            fitnesses.remove(i);
            break;
          }
        }
      }
      
      int parent_index = 0;
      while(newGeneration.size() < population) {
        newGeneration.add(new Snake(newGeneration.get(parent_index))); //<>//
        parent_index += 1; //<>//
      }
    }
     //<>//
    fitnesses.clear(); //<>//
    snakes = newGeneration;
    currentSnake = 0;
  };
  
  void writeGenInfo() {
    String cS = 'G'+str(currentGeneration)+" #"+str(currentSnake);
    rectMode(CORNERS);  
    fill(200);  
    rect(0, size[1]-25, 75, size[1]);  
    fill(50);  
    textSize(14);
    textAlign(CENTER, CENTER);
    text(cS, 0, size[1]-25, 75, size[1]);
    noFill();
  };
  
};
