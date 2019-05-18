class Mouse extends Creature {
  private final float m;    //mutation constant
  
  Mouse() {
    super( random(PI/8, 2*PI),  LToVTimesPhiFToLConstant );
    
    m = random(0.0, 1.0);
    
    headColor = FOVColor = #FF0000; 
  }
  Mouse(Point P) {
    this();
    headPosition = P;
  }
  
  void update(boolean CanGoAhead, boolean DoDraw) {
    super.update(CanGoAhead, DoDraw); 
    
    if(DoDraw) {
      float[] info = {v, phi, f, m};
      String[] infoNames = {"V", "Phi", "F", "M"};
      HoverInfo(info, infoNames);  
    }
  }
}
