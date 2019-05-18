class LifeTime {
  CreatureDen den;
  int allowedTime, numOfMice, currentTime;
  int timeEpsilon = 10; // Independent of system time
  ArrayList<Point> mousePositions = new ArrayList<Point>();
    
  LifeTime() {
    numOfMice = 5;
    allowedTime = -1;
    currentTime = 0;
    den = new CreatureDen(1, numOfMice);
  };
  LifeTime(int numOfMice) {
    this.numOfMice = numOfMice;
    allowedTime = -1;
    currentTime = 0;
    this.NewMousePositions();
  };
  LifeTime(int numOfMice, int seconds) {
    this.numOfMice = numOfMice;
    allowedTime = seconds*1000;
    currentTime = 0;
    this.NewMousePositions();
  };
  
  void setTime(int time) {
    allowedTime = time*1000;
  };
  void setNumOfMice(int num) {
    numOfMice = num;
  };
  void setSpecimen(Snake specimen) {
    den = new CreatureDen(specimen, numOfMice, mousePositions);
  };
  void NewMousePositions() {
    for(int i=0; i<numOfMice; i++)
      mousePositions.add( new Point(int(random(safetyMargin, size[0]-safetyMargin)), int(random(safetyMargin, size[1]-safetyMargin))) ); 
  }
  
  void startTiming() {
    currentTime = 0;
  };
  
  float popFitness() {
    den.increaseFitnessFromMouseDistance();
    den.IncreaseFitnessFromAreaTravelled();
    float fit = den.getFitness();
    println("    ", fit);
    den.resetFitness();
    return fit;
  };
  
  boolean update(boolean DoDraw) {
    if(!DoDraw) {
       for(currentTime = 0; allowedTime > currentTime; currentTime += timeEpsilon) {
         den.increaseFitnessFromMouseDistance();
         den.update(DoDraw);
         }
    }
    if(allowedTime == -1) {
      den.increaseFitnessFromMouseDistance();
      den.update(DoDraw);
      return false;
    }
    else if(allowedTime > currentTime) {
      den.update(DoDraw);
      den.increaseFitnessFromMouseDistance(); 
      currentTime += timeEpsilon;
      writeTimeLeft();
      return allowedTime <= currentTime;
    }
    return true;
  };
  
  void writeTimeLeft() {
    String time = nf( ((float)(allowedTime - currentTime)) / 1000.0, 2, 3 );
    rectMode(CORNERS);  
    fill(200);  
    rect(size[0]-50, size[1]-25, size[0], size[1]);  
    fill(50);  
    textSize(14);
    textAlign(CENTER, CENTER);
    text(time, size[0]-50, size[1]-25, size[0], size[1]);
    noFill();
  };
};
