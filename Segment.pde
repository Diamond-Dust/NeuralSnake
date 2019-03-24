public class Segment {
  public Point Start, End;
  
  Segment() {
    Start = new Point(0, 0);
    End = new Point(0, 0);
  };
  Segment(Point S, Point E) {
    Start = S.clone();
    End = E.clone();
  };
  Segment(Segment S) {
    Start = S.Start.clone();
    End = S.End.clone();
  };
  
  void Set(Point S, Point E) {
    Start = S.clone();
    End = E.clone();
  };
  void Set(Segment S) {
    Start = S.Start.clone();
    End = S.End.clone();
  };
  
  Segment clone() {
    return new Segment(this);
  }
  
  String toString() {
    return "(" + Start.toString() + ", " + End.toString() + ")";
  };
  
  boolean hasNoInterlockingIntervals(Segment S) {
    return ((max( min(S.Start.x,S.End.x), min(Start.x,End.x) ) > min( max(S.Start.x,S.End.x), max(Start.x,End.x) )) || 
      (max( min(S.Start.y,S.End.y), min(Start.y,End.y) ) > min( max(S.Start.y,S.End.y), max(Start.y,End.y) )));
  };
  
  boolean PointInsideSegmentSquare(Point P, Segment S) {
    return ( (P.x >= max( min(S.Start.x,S.End.x), min(Start.x,End.x) )) &&
             (P.x <= min( max(S.Start.x,S.End.x), max(Start.x,End.x) )) &&
             (P.y >= max( min(S.Start.y,S.End.y), min(Start.y,End.y) )) &&
             (P.y <= min( max(S.Start.y,S.End.y), max(Start.y,End.y) )) );
  };
  boolean PointInsideSegmentSquare(float X, float Y, Segment S) {
    return ( (X >= max( min(S.Start.x,S.End.x), min(Start.x,End.x) )) &&
             (X <= min( max(S.Start.x,S.End.x), max(Start.x,End.x) )) &&
             (Y >= max( min(S.Start.y,S.End.y), min(Start.y,End.y) )) &&
             (Y <= min( max(S.Start.y,S.End.y), max(Start.y,End.y) )) );
  };
  
  Point CalculateIntersectionPointWithVerticalSegment(Segment S) {
    float A = (Start.y-End.y)/(Start.x-End.x);
    float B = Start.y-A*Start.x;
    float Xi = S.Start.x;
    float Yi = A*Xi+B;
    
    return new Point(Xi, Yi);
  };
  Point CalculateIntersectionPointWithNonVerticalSegment(Segment S) {
    float A = (S.Start.y-S.End.y)/(S.Start.x-S.End.x);
    float B = S.Start.y-A*S.Start.x;
    float Xi = Start.x;
    float Yi = A*Xi+B;
    
    return new Point(Xi, Yi);
  };
  Point CalculateIntersectionPointWithNoVerticalSegments(Segment S) {
    float A1 = (S.Start.y-S.End.y)/(S.Start.x-S.End.x);
    float A2 = (Start.y-End.y)/(Start.x-End.x);
    float B1 = S.Start.y-A1*S.Start.x;
    float B2 = Start.y-A2*Start.x;
    
    if (A1 == A2) {
      return null;
    } 
    else {
      float Xi = (B2 - B1) / (A1 - A2);
      float Yi = A1*Xi+B1;
      
      return new Point(Xi, Yi);
    }
  };
  
  public boolean IsIntersecting(Segment S) {
    if (hasNoInterlockingIntervals(S)) {
      return false;
    } else if (S.Start.x == S.End.x) {
      //Colinear vertical lines
      if (Start.x == End.x) {
        if (S.Start.x == Start.x)
          return true;
      } 
      else {
        Point P = CalculateIntersectionPointWithVerticalSegment(S);
        if ( PointInsideSegmentSquare(P, S) )
          return true;
      } 
    }
    else if (Start.x == End.x) {
      Point P = CalculateIntersectionPointWithNonVerticalSegment(S);
      if ( PointInsideSegmentSquare(P, S) )
        return true;
    }
    else {
      Point P = CalculateIntersectionPointWithNoVerticalSegments(S);
          
      //Colinear segments
      if (P == null) {
        return true;
      } 
      else if ( PointInsideSegmentSquare(P, S) ) {
          return true;
      }
    }
    return false;
  };
  
  public Point WhereIsIntersecting(Segment S) {
    if (hasNoInterlockingIntervals(S)) {
      return null;
    } else if (S.Start.x == S.End.x) {
      //Colinear vertical lines
      if (Start.x == End.x) {
        if (S.Start.x == Start.x)
          return null;
      } 
      else {
        Point P = CalculateIntersectionPointWithVerticalSegment(S);
        if ( PointInsideSegmentSquare(P, S) )
          return P;
      } 
    }
    else if (Start.x == End.x) {
      Point P = CalculateIntersectionPointWithNonVerticalSegment(S);
      if ( PointInsideSegmentSquare(P, S) )
        return P;
    }
    else {
      Point P = CalculateIntersectionPointWithNoVerticalSegments(S);
          
      //Colinear segments
      if (P == null) {
        return null;
      } 
      else if ( PointInsideSegmentSquare(P, S) ) {
          return P;
      }
    }
    return null;
  };
};
