class CreatureDen {
  
  ArrayList<Creature> creatures = new ArrayList<Creature>();
  ArrayList<Point> snakePositions = new ArrayList<Point>();
  ArrayList<Point> mousePositions = new ArrayList<Point>();
  int currentMouseIndex;
  
  CreatureDen() { };
  CreatureDen(int numberOfSnakes) {
    currentMouseIndex = 0;
    for(int i=0; i<numberOfSnakes; i++) {
      snakePositions.add( new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin))) );
      creatures.add(new Snake());
    }
  };
  CreatureDen(int numberOfSnakes, int numberOfMice) {
    currentMouseIndex = 0;
    for(int i=0; i<numberOfSnakes; i++) {
      snakePositions.add( new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin))) );
      creatures.add(new Snake());
    }
    for(int i=0; i<numberOfMice; i++) {
      mousePositions.add( new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin))) );
      creatures.add(new Mouse(mousePositions.get(i)));
    }
  };
  CreatureDen(Snake specimen, int numberOfMice) {
    currentMouseIndex = 0;
    creatures.add(specimen);
    for(int i=0; i<numberOfMice; i++) {
      mousePositions.add( new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin))) );
      creatures.add(new Mouse(mousePositions.get(i)));
    } //<>// //<>//
  };
  CreatureDen(Snake specimen, int numberOfMice, ArrayList<Point> MousePositions) {
    currentMouseIndex = 0;
    mousePositions = MousePositions;
    creatures.add(specimen);
    for(int i=0; i<numberOfMice; i++) {
      creatures.add(new Mouse(mousePositions.get(i)));
    }
  };
  CreatureDen(Snake snake, Mouse mouse){ //<>// //<>//
    creatures.add(snake);
    creatures.add(mouse);
  };
  CreatureDen(Snake snake, ArrayList<Mouse> mice){
    creatures.add(snake);
    for(Mouse m : mice)
      creatures.add(m);
  };
  CreatureDen(ArrayList<Snake> snakes, Mouse mouse){
    for(Snake s : snakes)
      creatures.add(s);
    creatures.add(mouse); //<>//
  };
  CreatureDen(ArrayList<Snake> snakes, ArrayList<Mouse> mice){
    for(Snake s : snakes)
      creatures.add(s);
    for(Mouse m : mice)
      creatures.add(m);
  };
  
  void update(boolean DoDraw) {
    boolean CanGoAhead;    
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
            currentCreature.miceCaught++;
            currentCreature.IncreaseFitness(mouseFitnesBounty*currentCreature.miceCaught);
            creatures.remove(j);
            creatures.add(new Mouse(mousePositions.get(currentMouseIndex)));
            currentMouseIndex++;
            currentMouseIndex %= mousePositions.size();
            continue;
          }
        
          int seeingRay = currentCreature.IsSeenByRay(currentPossibleSnake);
          if(seeingRay != -1)
            Sightings.add(new Sighting(currentCreature, currentPossibleSnake, seeingRay));
        
          if(currentPossibleSnake instanceof Snake && CanGoAhead)
            CanGoAhead = !((Snake)currentPossibleSnake).IsPassedThrough(currentHeadPosition, futureHeadPosition, DoDraw);
          if(!CanGoAhead)
            continue;

        }
      }
      
      currentCreature.update(CanGoAhead, DoDraw);
      if(currentCreature instanceof Snake)
        currentCreature.GetSightings(parseSightings(Sightings));
    }
  };
  
  float[][] parseSightings(ArrayList<Sighting> sightings) {
    float[][] parsed = new float[rayNumber][2]; // [dist ; angle]
    for(int i=0; i<rayNumber; i++)
      for(int j=0; j<2; j++)
        parsed[i][j] = Float.POSITIVE_INFINITY;
    
    for(int i=0; i<sightings.size(); i++) {
      if(parsed[sightings.get(i).rayIndex][0] > sightings.get(i).Distance) {
        parsed[sightings.get(i).rayIndex][0] = sightings.get(i).Distance; 
        parsed[sightings.get(i).rayIndex][1] = sightings.get(i).relativeAngle;
      }
    }
    
    return parsed;
  }
  
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
  
  void CheckIfReacted() {
    Creature currentPossibleSnake = creatures.get(0);
    if(!currentPossibleSnake.hasReactedToInput){
      currentPossibleSnake.MultiplyFitness(0.1);
    }
  }
  
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
