class CreatureDen {
  
  ArrayList<Creature> creatures = new ArrayList<Creature>();
  
  CreatureDen() { };
  CreatureDen(int numberOfSnakes) {
    for(int i=0; i<numberOfSnakes; i++)
      creatures.add(new Snake());
  };
  CreatureDen(int numberOfSnakes, int numberOfMice) {
    for(int i=0; i<numberOfSnakes; i++)
      creatures.add(new Snake());
    for(int i=0; i<numberOfMice; i++)
      creatures.add(new Mouse());
  };
  CreatureDen(Snake specimen, int numberOfMice) {
    creatures.add(specimen);
    for(int i=0; i<numberOfMice; i++)
      creatures.add(new Mouse());
  };
  
  void update() {
    boolean CanGoAhead; //<>//
    Point currentHeadPosition, futureHeadPosition;
    Creature currentCreature, currentPossibleSnake;
    ArrayList<Sighting> Sightings = new ArrayList<Sighting>();
    
    for(int i=0; i<creatures.size(); i++)
    {
      Sightings.clear();
      CanGoAhead = true;
      currentCreature = creatures.get(i);
      currentHeadPosition = currentCreature.headPosition;
      futureHeadPosition = currentCreature.calculateNewPosition();
      
      for(int j=0; j<creatures.size(); j++)
      {
        if(i != j) {
          currentPossibleSnake = creatures.get(j);
            
          if(currentCreature instanceof Snake && currentPossibleSnake instanceof Mouse 
            && currentCreature.headPosition.DistanceTo(currentPossibleSnake.headPosition) < consumptionDistance) {
            currentCreature.IncreaseFitness(1);
            creatures.remove(j);
            creatures.add(new Mouse());
            continue;
          }
        
          if(currentCreature.IsSeen(currentPossibleSnake))
            Sightings.add(new Sighting(currentCreature, currentPossibleSnake));
        
          if(currentPossibleSnake instanceof Snake && CanGoAhead)
            CanGoAhead = !((Snake)currentPossibleSnake).IsPassedThrough(currentHeadPosition, futureHeadPosition);
          if(!CanGoAhead)
            continue;

        }
      }
      
      currentCreature.update(CanGoAhead);
      currentCreature.GetSightings(Sightings);
    }
  };
  
  void increaseFitnessFromMouseDistance() {
    Creature currentPossibleSnake = creatures.get(0), currentPossibleMouse;
    float minDistance;
    
    for(int j=1; j<creatures.size(); j++)
    {
        if(currentPossibleSnake instanceof Snake)
          break;
        currentPossibleSnake = creatures.get(j);
    }
    if(!(currentPossibleSnake instanceof Snake))
          return;
    minDistance = size[1]+size[0];
    for(int j=0; j<creatures.size(); j++)
    {
        currentPossibleMouse = creatures.get(j);
        if(currentPossibleMouse instanceof Mouse)
          minDistance = min(minDistance, currentPossibleMouse.headPosition.DistanceTo(currentPossibleSnake.headPosition));
    }
    currentPossibleSnake.IncreaseFitness(pow(fitnessFromDistanceModifier, -minDistance/50));
  };
  float getFitness() {
    Creature currentPossibleSnake;
    for(int j=0; j<creatures.size(); j++)
    {
        currentPossibleSnake = creatures.get(j);
        if(currentPossibleSnake instanceof Snake)
          return currentPossibleSnake.fitness;
    }
    return 0;
  };
  void resetFitness() {
    Creature currentPossibleSnake;
    for(int j=0; j<creatures.size(); j++)
    {
        currentPossibleSnake = creatures.get(j);
        if(currentPossibleSnake instanceof Snake)
          currentPossibleSnake.fitness = 0;
    }
  }
  
};
