private final float LToVTimesPhiFToLConstant = PI/2.0; //Sanity constant
private final float LToVConstant = 125.0; //Sanity constant

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

    mutatedValues[2] = constrain(Phi+random((-M*Phi), (M*Phi)), 0, 2*PI);
    mutatedValues[3] = -mutatedValues[2]/(2*PI)+(F+Phi/(2*PI));
    mutatedValues[0] = mutatedValues[2]*mutatedValues[3]/PhiLtoFRatio;
    mutatedValues[1] = VtoLRatio/mutatedValues[0];
    
    mutatedValues[4] = constrain(M+random((-M*M), (M*M)), 0, 1);

    return mutatedValues;
  };

  Snake() {
    super( random(PI/8, 2*PI),  LToVTimesPhiFToLConstant );
    l = LToVConstant / v;
    m = random(0.0, 1.0);
    
    FOVColor = headColor = color(0, int(random(128, 255)), 0);
    tailColor = color(0, 0, int(random(128, 255)));
    
    Coords.add(headPosition.clone());
    
    brain = new Brain(true);
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
    
    brain = new Brain(Parent.brain);
    brain.Mutate();
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

  void update(boolean CanGoAhead, boolean DoDraw) { 
    super.update(CanGoAhead, DoDraw);
    
    if(CanGoAhead) {
      Coords.add(headPosition.clone());
    }
      
    if(DoDraw) {
      this.drawTail();
        
      float[] info = {l, v, phi, f, m};
      String[] infoNames = {"L", "V", "Phi", "F", "M"};
      HoverInfo(info, infoNames);  
    }
  }
  
  //Does that pass through?
  boolean IsPassedThrough(Point start, Point end, boolean DoDraw) { //<>//
    if(Coords.size() < 2)
      return false;
    else
    {
      Point P; //<>//
      Segment snakePart = new Segment(), checkedPart = new Segment(start, end);
      for(int i=0; i<Coords.size()-1; i++)
      {
        snakePart.Set(Coords.get(i), Coords.get(i+1));
        P = snakePart.WhereIsIntersecting(checkedPart);
        if(P != null) {
          //Shows the collision
          if(DoDraw) {
            P.Draw(#FF0000, 15);
          }
          return true;
        }
      }
    }
    return false;
  };
  boolean IsPassedThrough(Segment checkedPart, boolean DoDraw) {
    if(Coords.size() < 2)
      return false;
    else
    {
      Point P;
      Segment snakePart = new Segment();
      for(int i=0; i<Coords.size()-1; i++)
      {
        snakePart.Set(Coords.get(i), Coords.get(i+1));
        P = snakePart.WhereIsIntersecting(checkedPart);
        if(P != null) {
          //Shows the collision
          if(DoDraw) {
            P.Draw(#FF0000, 15);
          }
          return true;
        }
      }
    }
    return false;
  };
  
};
