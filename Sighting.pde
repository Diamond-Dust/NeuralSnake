class Sighting {
  float Distance;
  float relativeAngle;
  String typeSeen;
  
  Sighting(float D, float rA, String tS) {
    Distance = D;
    relativeAngle = rA;
    typeSeen = tS;
  };
  Sighting(Point viewerPosition, float viewerAbsoluteAngle, Point sightingPosition, String TypeSeen) {
    Distance = viewerPosition.DistanceTo(sightingPosition);
    relativeAngle = PVector.angleBetween(
                                           PVector.fromAngle(viewerAbsoluteAngle), 
                                           new PVector(
                                                        sightingPosition.x-viewerPosition.x, 
                                                        sightingPosition.y-viewerPosition.y
                                           )
                                         );
    typeSeen = TypeSeen;
  };
  Sighting(Creature beholder, Creature beholden) {
    Distance = beholder.headPosition.DistanceTo(beholden.headPosition);
    relativeAngle = PVector.angleBetween(
                                           PVector.fromAngle(beholder.courseAngle), 
                                           new PVector(
                                                         beholden.headPosition.x-beholder.headPosition.x, 
                                                         beholden.headPosition.y-beholder.headPosition.y
                                           )
                                         );
    typeSeen = beholden.getClass().getName();
  };
};
