class Brain {
  
  Brain() {};
  
  float DecideAngle() {
    return random(-PI/6, PI/6);
  };
  
  void GetSightings(ArrayList<Point> Sightings) {
      println(Sightings);
  };
  
};
