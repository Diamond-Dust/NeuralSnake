class CreatureDen {
  
  ArrayList<Creature> creatures = new ArrayList<Creature>();
  
  CreatureDen() { };
  CreatureDen(int numberOfSnakes) {
    for(int i=0; i<numberOfSnakes; i++)
      creatures.add(new Snake());
  };
  
  void update() {
    boolean CanGoAhead; //<>//
    Point currentHeadPosition, futureHeadPosition;
    Creature currentCreature, currentPossibleSnake;
    
    for(int i=0; i<creatures.size(); i++)
    {
      CanGoAhead = true;
      currentCreature = creatures.get(i);
      currentHeadPosition = currentCreature.headPosition;
      futureHeadPosition = currentCreature.calculateNewPosition();
      
      for(int j=0; j<creatures.size(); j++)
      {
        currentPossibleSnake = creatures.get(j);
        if(currentPossibleSnake instanceof Snake && i != j)
          CanGoAhead = !((Snake)currentPossibleSnake).IsPassedThrough(currentHeadPosition, futureHeadPosition);
        if(!CanGoAhead)
          break;
      }
      
      currentCreature.update(CanGoAhead);
    }
  };
};
