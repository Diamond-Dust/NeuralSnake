public class Ray extends Line{
  Point Start;
  PVector Versor;
  
  Ray(Point start, Point on) {
    super(start, on);
    Start = start;
    Versor.y = on.y-start.y;
    Versor.x = on.x-start.x;
    Versor.normalize();
  };
  
  public boolean CheckIfInFront(Point P) {
    Point T = Start.Translate(Versor);
    Line L = new Line(Versor, Start);
    if(T.DistanceTo(P) <= L.CalculateDistance(P)) {
      return true;
    }
    else {
      return false;  
    }
  };
  
  public boolean CheckIfInFrontAndInInterval(Point P, float Interval) {
    if(CheckIfInFront(P)) {
      if(super.CalculateDistance(P) <= Interval) {
        return true;
      }
      else {
        return false;  
      }
    }
    else {
      return false;
    }    
  };
}
