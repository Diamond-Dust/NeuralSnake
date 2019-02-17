class Mouse extends Creature {
  private final float m;    //mutation constant
  
  Mouse() {
    super( random(1.0, 5.0), random(0, 2*PI) );
    
    m = random(0.0, 1.0);
    
    headColor = FOVColor = #FF0000; 
  }
  
  void update(boolean CanGoAhead) {
    super.update(CanGoAhead); 
    
    float[] info = {v, phi, f, m};
    String[] infoNames = {"V", "Phi", "F", "M"};
    HoverInfo(info, infoNames);   
  }
}
