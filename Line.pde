public class Line {
  float A,B,C;
  
  Line() {
    A=B=C=0;
  };
  Line(PVector Perpendicular) {
    A = Perpendicular.x;
    B = Perpendicular.y;
    C = 0;
  };
  Line(PVector Perpendicular, Point Through) {
    A = Perpendicular.x;
    B = Perpendicular.y;
    C = -A*Through.x-B*Through.y;
  };
  Line(Point P1, Point P2) {
    A = P2.y-P1.y;
    B = P2.x-P1.x;
    C = B*P1.y - A*P1.x;
  };
  Line(Line L) {
    A = L.A;
    B = L.B;
    C = L.C;
  };
  
  public float CalculateDistance(Point P) {
    return (abs(A*P.x+B*P.y+C))/(sqrt(sq(A)+sq(B)));
  };
  
  public void DrawLine(color c) {
    float Coord;
    stroke(c);
    if(B == 0) {
      Coord = -C/A;
      line(Coord, 0, Coord, size[1]);
    }
    else if (abs(-A/B) > 1) {
      Coord = -(B*size[1]+C)/A;
      line(-C/A, 0, Coord, size[1]);
    }
    else {
      Coord = -(A*size[0]+C)/B;
      line(0, -C/B, size[0], Coord);
    }
  };
  
  
};
