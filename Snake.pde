public class Snake extends Creature{
  private final float l;    //length
  private final float m;    //mutation constant
  
  color tailColor = #000000;

  float getL() {
    return l;
  };
  float getM() {
    return m;
  };

  float[] Mutate(float L, float V, float Phi, float F, float M) {
    float[] mutatedValues = new float[5];
    float VtoLRatio = V*L;
    float PhiLtoFRatio = Phi*F/L;

    mutatedValues[1] = constrain(V+random((-M*V), (M*V)), 1, 5);
    mutatedValues[0] = VtoLRatio/mutatedValues[1];
    PhiLtoFRatio *= mutatedValues[0];
    mutatedValues[2] = constrain(Phi+random((-M*Phi), (M*Phi)), 0, 2*PI);
    mutatedValues[3] = PhiLtoFRatio/mutatedValues[2];
    mutatedValues[4] = constrain(M+random((-M*M), (M*M)), 0, 1);

    return mutatedValues;
  };

  Snake() {
    super( random(1.0, 5.0), random(0, 2*PI) );
    l = 125.0 / v;
    m = random(0.0, 1.0);
    
    FOVColor = headColor = color(0, int(random(128, 255)), 0);
    tailColor = color(0, 0, int(random(128, 255)));
    
    Coords.add(headPosition.clone());
  };

  Snake(float L, float V, float Phi, float M) {
    super( V, Phi );
    l = L;
    m = M;
    
    FOVColor = headColor = color(0, int(random(128, 255)), 0);
    tailColor = color(0, 0, int(random(128, 255)));
    
    Coords.add(headPosition.clone());
  };

  Snake(Snake Parent) {
    super();
    float[] mutatedValues = Mutate(Parent.getL(), Parent.getV(), Parent.getPhi(), Parent.getF(), Parent.getM());
    l = mutatedValues[0];
    v = mutatedValues[1];
    phi = mutatedValues[2];
    f = mutatedValues[3];
    m = mutatedValues[4];
    
    FOVColor = headColor = color(0, int(random(128, 255)), 0);
    tailColor = color(0, 0, int(random(128, 255)));
    
    Coords.add(headPosition.clone());
  };

  //Snake-specific drawing
  ArrayList<Point> Coords = new ArrayList<Point>();
  
  void setPosition(float X, float Y) {
    super.setPosition(X, Y);
    Coords.add(headPosition.clone());
  };
  
  void drawTail() {
    float distance = 0;
    noFill();
    stroke(tailColor);
    beginShape();
    curveVertex(Coords.get(Coords.size()-1).x, Coords.get(Coords.size()-1).y);
    for(int i=Coords.size()-2; i>-1; i--)
      {
        curveVertex(Coords.get(i).x, Coords.get(i).y);
        distance += sqrt(sq(Coords.get(i).x - Coords.get(i+1).x)+sq(Coords.get(i).y - Coords.get(i+1).y));
        if(distance >= l)
        {
          for(; i>-1; i--)
          {
            Coords.remove(0);
          }
        }
      }
    endShape();
  };

  void update(boolean CanGoAhead) { 
    super.update(CanGoAhead);
    
    if(CanGoAhead) {
      Coords.add(headPosition.clone());
    }
      
    this.drawTail();
      
    float[] info = {l, v, phi, f, m};
    String[] infoNames = {"L", "V", "Phi", "F", "M"};
    HoverInfo(info, infoNames);    
  }
  
  //Does that pass through?
  boolean IsPassedThrough(Point start, Point end) {
    if(Coords.size() < 2)
      return false;
    else
    {
      float A1, A2, B1, B2, Xi, Yi;
      Point snakePartStart, snakePartEnd; //<>//
      for(int i=0; i<Coords.size()-1; i++)
      {
        snakePartStart = Coords.get(i);
        snakePartEnd = Coords.get(i+1);
        //Do the segments have interlocking intervals?
        if ((max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) ) > min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) || 
              (max( min(start.y,end.y), min(snakePartStart.y,snakePartEnd.y) ) > min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) ))) {
          continue;
        } else if (start.x == end.x)
          //Colinear vertical lines
          if (snakePartStart.x == snakePartEnd.x) {
            if (start.x == snakePartStart.x)
              return true;
          } else {
            A2 = (snakePartStart.y-snakePartEnd.y)/(snakePartStart.x-snakePartEnd.x);
            B2 = snakePartStart.y-A2*snakePartStart.x;
            Xi = start.x;
            Yi = A2*Xi+B2;
            
            //Shows the collision
            fill(#FF0000);
            ellipse(Xi, Yi, 15, 15);
            
            if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi >= max( min(start.y,end.y), min(snakePartStart.y,snakePartEnd.y) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) )
              return true;
          } 
        else if (snakePartStart.x == snakePartEnd.x) {
          //Colinear askew lines
          A1 = (start.y-end.y)/(start.x-end.x);
          B1 = start.y-A1*start.x;
          Xi = snakePartStart.x;
          Yi = A1*Xi+B1;
          
          //Shows the collision
          fill(#FF0000);
          ellipse(Xi, Yi, 15, 15);
          
          if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi >= max( min(start.y,end.y), min(snakePartStart.y,snakePartEnd.y) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) )
              return true;
        }
        else {
          A1 = (start.y-end.y)/(start.x-end.x);
          A2 = (snakePartStart.y-snakePartEnd.y)/(snakePartStart.x-snakePartEnd.x);
          B1 = start.y-A1*start.x;
          B2 = snakePartStart.y-A2*snakePartStart.x;
          
          //Colinear segments
          if (A1 == A2) {
            return true;
          } else {
            Xi = (B2 - B1) / (A1 - A2);
            Yi = A1*Xi+B1;
            
            //Shows the collision
            fill(#FF0000);
            ellipse(Xi, Yi, 15, 15);
            
            if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi >= max( min(start.y,end.y), min(snakePartStart.y,snakePartEnd.y) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) )
                   return true;
          }
        }
      }
    }
    return false;
  };
  
};
