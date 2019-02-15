public class Point {
  public float x;
  public float y;
  
  void Set(float X, float Y) {
    x = X;
    y = Y;
  };
  void Set(Point P) {
    x = P.x;
    y = P.y;
  };
  
  Point clone() {
    return new Point(this);
  }
  
  String toString() {
    return "(" + x + ", " + y + ")";
  };
  
  Point(float X, float Y) {
    x = X;
    y = Y;
  };
  Point(Point P) {
    x = P.x;
    y = P.y;
  };
};
