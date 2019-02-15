PImage img;
int smallPoint, largePoint;
public int size[] = {640, 360};

Snake snek = new Snake();
Snake snak = new Snake(snek);

void settings() { 
  size(640, 360);
}

void setup() {
  frameRate(30);
  smallPoint = 4;
  largePoint = 40;
  background(125);
  
  snek.setPosition(320.0, 130.0);
  snek.setAngle(-PI/90);
  
  snak.setPosition(310.0, 120.0);
  
  print(snek.getL(), snek.getV(), snek.getPhi(), snek.getF(), snek.getM());
}

void draw() { 
  clear();
  snek.update(!snak.IsPassedThrough(snek.headPosition, snek.calculateNewPosition())); //<>//
  snak.update(!snek.IsPassedThrough(snak.headPosition, snak.calculateNewPosition()));
}
