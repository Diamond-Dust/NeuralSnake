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
};
