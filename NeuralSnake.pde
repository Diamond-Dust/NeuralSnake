public int size[] = {640, 360};
public color backgroundColor = #000000;
CreatureDen den = new CreatureDen(50);

Snake snek = new Snake();
Snake snak = new Snake(snek);

void settings() { 
  size(640, 360);
}

void setup() {
  frameRate(30);
  background(backgroundColor);
}

void draw() { 
  clear();
  background(backgroundColor);
  den.update(); //<>//
}
