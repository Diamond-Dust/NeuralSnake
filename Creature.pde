abstract class Creature implements Hoverable {
  float v;    //velocity
  float phi;  //field of view angle
  float f;    //recognition constant
  
  color headColor = #000000, FOVColor = #000000;
  Point headPosition = new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin)));
  float delta = PI/90, courseAngle = 0;
  
  float fitness = 0;
  
  Ray[] Rays = new Ray[rayNumber];
  
  Brain brain = new Brain();
  
  Creature() {
    v = 0.0;
    phi = 0.0;
    f = 0.0;
    for (int i=0; i<rayNumber; i++) {
      Rays[i] = new Ray();
    }
  };
  Creature(float Phi, float LToVTimesPhiFToLConstant) {
    phi = Phi;
    f = -phi/(2*PI)+1.05;
    v = LToVTimesPhiFToLConstant/(phi*f);
    for (int i=0; i<rayNumber; i++) {
      Rays[i] = new Ray();
    }
  }
  
  float getV() {
    return v;
  };
  float getPhi() {
    return phi;
  };
  float getF() {
    return f;
  };
  
  void SetFitness(float F) {
    fitness = F;
  };
  void IncreaseFitness(float By) {
    fitness += By;
  };
  
  void setPosition() {
    headPosition = new Point(int(random(safetyMargin, size[0])), int(random(safetyMargin, size[1])));
  };
  void setPosition(Point head) {
    headPosition = head;
  };
  void setPosition(float X, float Y) {
    headPosition.x = X;
    headPosition.y = Y;
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
  
  void DrawFOV() {
    fill(FOVColor, 128);
    stroke(#FFFF00);
    beginShape(TRIANGLE_FAN);
    vertex(headPosition.x,headPosition.y);
    Point P = new Point();
    for(int i=0; i<rayNumber; i++) {
      P.Set(headPosition.x+FOVBaseSize*(f+0.5)*cos(courseAngle-phi/2+i*phi/rayNumber),
              headPosition.y+FOVBaseSize*(f+0.5)*sin(courseAngle-phi/2+i*phi/rayNumber));
      vertex(P.x, P.y);
      Rays[i].Set(headPosition, P);
      //Rays[i].Draw(#FFFF00);
    }
    endShape();
  };
  
  void DrawHead() {
    headPosition.Draw(headColor, 5);
  };
  
  void update(boolean CanGoAhead, boolean DoDraw) {
    if(CanGoAhead) {
      courseAngle = (courseAngle+delta)%(2*PI);
      headPosition.x = min(max(0, headPosition.x+v*cos(courseAngle)), size[0]);
      headPosition.y = min(max(0, headPosition.y+v*sin(courseAngle)), size[1]);
    }
    
    if(DoDraw) {
      DrawFOV();  
      DrawHead();
    }
  
    this.setAngle(brain.DecideAngle());
  };
  
  void GetSightings(float[][] Sightings) {
    brain.GetSightings(Sightings);
  };
  
  public int IsSeenByRay(Creature C) {
    int IS = -1;
    for(int i=0; i< rayNumber; i++) {
      if(Rays[i].CheckIfInFrontAndInInterval(C.headPosition, sightInterval))
        IS = i;
    }
    return IS;
  };
  public int IsSeenByRay(Point P) {
    int IS = -1;
    for(int i=0; i< rayNumber; i++) {
      if(Rays[i].CheckIfInFrontAndInInterval(P, sightInterval))
        IS = i;
    }
    return IS;
  };
  
  //Hoverable
  void HoverInfo(float[] information, String[] informationNames) { 
    float rectX=0, rectY=0, rectW=0, rectH=0;
    textSize(10);
    rectMode(CORNER);
    textAlign(BASELINE);
    
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
