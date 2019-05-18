public class Ray extends Line{
  Point Start = new Point();
  PVector Versor = new PVector();
  
  Ray() {
    super();
    Start = new Point();
    Versor = new PVector();
    Versor.normalize();
  };
  Ray(Point start, Point on) {
    super(start, on);
    Start = start;
    Versor.y = on.y-start.y;
    Versor.x = on.x-start.x;
    Versor.normalize();
  };
  Ray(Point start, PVector V) {
    super(start, start.Translate(V));
    Start = start;
    Versor = V;
    Versor.normalize();
  };
  Ray(Ray R) {
    super(R.Start, R.Start.Translate(R.Versor));
    Start = R.Start.clone();
    Versor = R.Versor.copy();
  };
  
  void Set(Point start, Point on) {
    super.Set(start, on);
    Start = start;
    Versor.y = on.y-start.y;
    Versor.x = on.x-start.x;
    Versor.normalize();
  };
  void Set(Point start, PVector V) {
    super.Set(start, start.Translate(V));
    Start = start;
    Versor = V;
    Versor.normalize();
  };
  void Set(Ray R) {
    super.Set(R.Start, R.Start.Translate(R.Versor));
    Start = R.Start;
    Versor = R.Versor;
  };
  
  public boolean CheckIfInFront(Point P) {
    return cos(PVector.angleBetween(Versor, new PVector(P.x-Start.x, P.y-Start.y))) > 0;
  };
  
  public boolean CheckIfInFrontAndInInterval(Point P, float Interval) {
    if(CheckIfInFront(P)) {
      if(super.CalculateDistance(P) <= Interval) {
        //strokeWeight(sightInterval);
        //Draw(#FF00FF);
        P.Draw(#FF00FF, 10);
        //super.Draw(#F0F0F0);
        //strokeWeight(1);
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
  
  public void Draw(color c) {
    float maxLength = sqrt(sq(size[0]) + sq(size[1]));
    Point Coord = Start.Translate(Versor.mult(maxLength));
    stroke(c);
    line(Start.x, Start.y, Coord.x, Coord.y);
    //super.Draw(#F0F0F0);
    noStroke();
  };
}
