class LifeTime {
  CreatureDen den;
  int allowedTime, numOfMice, currentTime;
  
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
  };
  LifeTime(int numOfMice, int seconds) {
    this.numOfMice = numOfMice;
    allowedTime = seconds*1000;
    currentTime = 0;
  };
  
  void setTime(int time) {
    allowedTime = time*1000;
  };
  void setNumOfMice(int num) {
    numOfMice = num;
  };
  void setSpecimen(Snake specimen) {
    den = new CreatureDen(specimen, numOfMice);
  };
  
  void startTiming() {
    currentTime = 0;
  };
  
  boolean update() {
    if(allowedTime == -1) {
      den.update();
    }
    else if(allowedTime > currentTime) {
      int timeNow = millis();
      den.update();
      currentTime += millis()-timeNow;
      writeTimeLeft();
      return allowedTime <= currentTime;
    }
    return false;
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
