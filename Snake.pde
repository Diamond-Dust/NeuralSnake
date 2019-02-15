public class Snake implements Hoverable {
  private final float l;    //length
  private final float v;    //velocity
  private final float phi;  //field of view angle
  private final float f;    //recognition constant
  private final float m;    //mutation constant

  float getL() {
    return l;
  };
  float getV() {
    return v;
  };
  float getPhi() {
    return phi;
  };
  float getF() {
    return f;
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
    l = random(25.0, 125.0);
    v = 125.0 / l;
    phi = random(0, 2*PI);
    f = -phi/(2*PI)+1;
    m = random(0.0, 1.0);
  };

  Snake(float L, float V, float Phi, float F, float M) {
    l = L;
    v = V;
    phi = Phi;
    f = F;
    m = M;
  };

  Snake(Snake Parent) {
    float[] mutatedValues = Mutate(Parent.getL(), Parent.getV(), Parent.getPhi(), Parent.getF(), Parent.getM());
    l = mutatedValues[0];
    v = mutatedValues[1];
    phi = mutatedValues[2];
    f = mutatedValues[3];
    m = mutatedValues[4];
  };

  //Position should be separate class
  Point headPosition = new Point(0, 0);
  float delta, courseAngle = 0;
  ArrayList<Point> Coords = new ArrayList<Point>();

  void setPosition(float X, float Y) {
    headPosition.x = X;
    headPosition.y = Y;
    Coords.add(headPosition.clone());
  };
  
  Point calculateNewPosition() {
    return new Point(
      min(max(0, headPosition.x+v*cos(courseAngle)), size[0]),
        min(max(0, headPosition.y+v*sin(courseAngle)), size[1])
    );
  };

  void setAngle(float Delta) {
    delta = Delta;
  };

  void update(boolean CanGoAhead) { 
    if(CanGoAhead) {
      courseAngle = (courseAngle+delta)%(2*PI);
      headPosition.x = min(max(0, headPosition.x+v*cos(courseAngle)), size[0]);
      headPosition.y = min(max(0, headPosition.y+v*sin(courseAngle)), size[1]);
      
      Coords.add(headPosition.clone());
    } else {
      //print("[", headPosition.x, headPosition.y, "]", "[", min(max(0, headPosition.x+v*cos(courseAngle)), size[0]), min(max(0, headPosition.y+v*sin(courseAngle)), size[0]), "]", "\n");
    };
    
    fill(#00FF00, 128);
    noStroke();
    beginShape(TRIANGLE_FAN);
    vertex(headPosition.x,headPosition.y);
    for(int i=0; i<10; i++)
      vertex(headPosition.x+50*(f+0.5)*cos(courseAngle-phi/2+i*phi/10), 
        headPosition.y+50*(f+0.5)*sin(courseAngle-phi/2+i*phi/10));
    endShape();
  
    this.setAngle(random(-PI/6, PI/6)); //AAAAA
      
    fill(#00FF00);
    ellipse(headPosition.x, headPosition.y, 5, 5);
      
    float distance = 0;
    noFill();
    stroke(#0000FF);
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
      
    float[] info = {l, v, phi, f, m};
    String[] infoNames = {"L", "V", "Phi", "F", "M"};
    HoverInfo(info, infoNames);    
  }
  
  //Does that pass through?
  boolean IsPassedThrough(Point start, Point end) {
    if(Coords.size() < 2) //<>//
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
        if ((max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) ) < min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) || 
              (max( min(start.y,end.y), min(snakePartStart.y,snakePartEnd.y) ) < min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) ))) {
          continue;
        }
        
        println("Close! ", i);  
        
        if (start.x == end.x)
          //Colinear vertical lines
          if (snakePartStart.x == snakePartEnd.x) {
            if (start.x == snakePartStart.x)
              return true;
          } else {
            A2 = (snakePartStart.y-snakePartEnd.y)/(snakePartStart.x-snakePartEnd.x);
            B2 = snakePartStart.y-A2*snakePartStart.x;
            Xi = start.x;
            Yi = A2*Xi+B2;
            if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) )
              return true;
          } 
        else if (snakePartStart.x == snakePartEnd.x) {
          //Colinear askew lines
          A1 = (start.y-end.y)/(start.x-end.x);
          B1 = start.y-A1*start.x;
          Xi = snakePartStart.x;
          Yi = A1*Xi+B1;
          if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) &&
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
            if ( (Xi >= max( min(start.x,end.x), min(snakePartStart.x,snakePartEnd.x) )) &&
                 (Xi <= min( max(start.x,end.x), max(snakePartStart.x,snakePartEnd.x) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) &&
                 (Yi <= min( max(start.y,end.y), max(snakePartStart.y,snakePartEnd.y) )) )
              return true;
          }
        }
      }
    }
    return false;
  };
  
  //Hoverable
  void HoverInfo(float[] information, String[] informationNames) { 
    float rectX=0, rectY=0, rectW=0, rectH=0;
    textSize(10);
    
    if(abs(mouseX-headPosition.x)<25 && abs(mouseY-headPosition.y)<25) 
    {
        rectW = 50;
        for(int i=0; i<information.length; i++)
          if(rectW < informationNames[i].length()+10+80)
            rectW = informationNames[i].length()+10+80;
        rectH = information.length*12;
        
        if(headPosition.x>= size[0]/2) {
           if(headPosition.y>=size[1]/2) {
             rectX = headPosition.x - 10 - rectW;
             rectY = headPosition.y - 10 - rectH;
           }
           else {
             rectX = headPosition.x - 10 - rectW;
             rectY = headPosition.y + 10;
           }
        }
        else {
           if(headPosition.y>=size[1]/2) {
             rectX = headPosition.x + 10;
             rectY = headPosition.y - 10 - rectH;
           }
           else {
             rectX = headPosition.x +  10;
             rectY = headPosition.y +  10;
           }
        }
        
        stroke(#FF00FF);
        fill(255, 192);
        rect(rectX, rectY, rectW, rectH, 2);
        
        for(int i=0; i<information.length; i++)
        {
           informationNames[i] += ": ";
           float difference = rectW-90-informationNames[i].length()+2;
           for(int j=0; j<difference; j++) 
           {
              informationNames[i] += " ";
           }
        }
        
        for(int i=0; i<information.length; i++)
        {
            fill(0, 0, 255);
            text(informationNames[i]+information[i], rectX, rectY+((float)i/information.length)*rectH+10);
        }
    }
      
  };
};
