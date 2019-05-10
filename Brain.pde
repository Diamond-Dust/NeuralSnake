class Brain {
  
  float[][] Memory;
  boolean isSnek = false;
  
  Brain() {
    Memory = new float[rayNumber][2];
  };
  Brain(boolean isSnake) {
    Memory = new float[rayNumber][2];
    isSnek = isSnake;
  };
  
  float rememberClosest() {
    float minDistSighting = Memory[0][0];
    for(int i=1; i<rayNumber; i++)
      minDistSighting = (Memory[i][0] < minDistSighting) ? Memory[i][0] : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    return (IsInputEmpty(Memory) || !isSnek) ? random(-PI/6, PI/6) : rememberClosest()/30.;
  };
  
  boolean IsInputEmpty(float[][] input) {
    for(int i=0; i<rayNumber; i++)
      if(input[i][0] != Float.POSITIVE_INFINITY)
        return false;
    return true;
  }
  
  void GetSightings(float[][] sightings) {
    if(IsInputEmpty(sightings))
      Memory = sightings;
    //println(Memory);
  };
  
};
