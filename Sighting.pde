class Sighting {
  float Distance;
  float relativeAngle;
  int rayIndex;
  
  Sighting(float D, float rA, int rN) {
    Distance = D;
    relativeAngle = rA;
    rayIndex = rN;
  };
  Sighting(Point viewerPosition, float viewerAbsoluteAngle, Point sightingPosition, int rN) {
    Distance = viewerPosition.DistanceTo(sightingPosition);
    relativeAngle = PVector.angleBetween(
                                           PVector.fromAngle(viewerAbsoluteAngle), 
                                           new PVector(
                                                        sightingPosition.x-viewerPosition.x, 
                                                        sightingPosition.y-viewerPosition.y
                                           )
                                         );
     rayIndex= rN;
  };
  Sighting(Creature beholder, Creature beholden, int rN) {
    Distance = beholder.headPosition.DistanceTo(beholden.headPosition);
    relativeAngle = PVector.angleBetween(
                                           PVector.fromAngle(beholder.courseAngle), 
                                           new PVector(
                                                         beholden.headPosition.x-beholder.headPosition.x, 
                                                         beholden.headPosition.y-beholder.headPosition.y
                                           )
                                         );
    rayIndex = rN;
  };
};
