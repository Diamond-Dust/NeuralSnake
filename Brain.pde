class Brain {
  
  ArrayList<Sighting> Memory;
  boolean isSnek = false;
  
  Brain() {
    Memory = new ArrayList<Sighting>();
  };
  Brain(boolean isSnake) {
    Memory = new ArrayList<Sighting>();
    isSnek = isSnake;
  };
  
  Sighting rememberClosest() {
    Sighting minDistSighting = Memory.get(0);
    for(int i=1; i<Memory.size(); i++)
      minDistSighting = (Memory.get(i).Distance < minDistSighting.Distance) ? Memory.get(i) : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    return (Memory.size() == 0 || !isSnek) ? random(-PI/6, PI/6) : rememberClosest().relativeAngle/30.;
  };
  
  void GetSightings(ArrayList<Sighting> Sightings) {
    if(Sightings.size() != 0)
      Memory = Sightings;
    //println(Memory);
  };
  
};
