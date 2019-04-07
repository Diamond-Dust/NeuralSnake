public class Point {
  
  public float x;
  public float y;
  
  Point() {
    x = 0;
    y = 0;
  };
  Point(float X, float Y) {
    x = X;
    y = Y;
  };
  Point(Point P) {
    x = P.x;
    y = P.y;
  };
  
  void Set(float X, float Y) {
    x = X;
    y = Y;
  };
  void Set(Point P) {
    x = P.x;
    y = P.y;
  };
  
  float DistanceTo(Point P) {
    return sqrt(sq(P.x-x)+sq(P.y-y));
  }
  
  Point Translate(PVector V) {
    return new Point(x+V.x, y+V.y);
  };
  
  void Draw(color c, int size) {
    stroke(c);
    fill(c);
    ellipse(x, y, size, size);
    //noFill();
  };
  
  Point clone() {
    return new Point(this);
  }
  
  String toString() {
    return "(" + x + ", " + y + ")";
  };
};
