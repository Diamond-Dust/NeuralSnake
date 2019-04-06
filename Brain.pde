class Brain {
  
  ArrayList<Sighting> Memory;
  
  Brain() {
    Memory = new ArrayList<Sighting>();
  };
  
  Sighting rememberClosest() {
    Sighting minDistSighting = Memory.get(0);
    for(int i=1; i<Memory.size(); i++)
      minDistSighting = (Memory.get(i).Distance < minDistSighting.Distance) ? Memory.get(i) : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    //return random(-PI/6, PI/6);
    //println(Memory.size());
    return (Memory.size() == 0) ? random(-PI/6, PI/6) : rememberClosest().relativeAngle/30.;
  };
  
  void GetSightings(ArrayList<Sighting> Sightings) {
    if(Sightings.size() != 0)
      Memory = Sightings;
    //println(Memory);
  };
  
};
