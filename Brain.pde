class Brain {
  Matrix[] S = new Matrix[3];
  float[] Memory;
  boolean isSnek = false;
  
  Matrix RandomiseMatrixNormalised(int h, int w, float from, float to) {
    Matrix s = Matrix.random(h, w).timesEquals(to-from);
    for(int i=0; i<h; i++)
      for(int j=0; j<w; j++)
        s.set(i, j, s.get(i, j)+from);
    return s;
  }
  
  Brain() {
    Memory = new float[rayNumber];
    for(int i=0; i<Memory.length; i++)
        Memory[i] = Float.POSITIVE_INFINITY;
    
    S[0] = RandomiseMatrixNormalised(rayNumber/2, 5, -5, 3);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -5, 3);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -5, 3);                // Synapses between Layer2 -> Output 
  };
  Brain(boolean isSnake) {
    Memory = new float[rayNumber];
    for(int i=0; i<Memory.length; i++)
        Memory[i] = Float.POSITIVE_INFINITY;
    isSnek = isSnake;
    
    S[0] = RandomiseMatrixNormalised(rayNumber/2, 5, -5, 3);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -5, 3);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -5, 3);                // Synapses between Layer2 -> Output 
  };
  Brain(Brain Parent) {
    Memory = new float[Parent.Memory.length];
    for(int i=0; i<Memory.length; i++)
        Memory[i] = Float.POSITIVE_INFINITY;
    isSnek = Parent.isSnek;
    
    for(int i=0; i<Parent.S.length; i++)
      S[i] = Parent.S[i].copy();
  };
  
  void Mutate() {
    for(int i=0; i<S.length; i++)
      for(int j=0; j<S[i].getRowDimension(); j++)
        for(int k=0; k<S[i].getColumnDimension(); k++)
          if(random(0, 1.) < brainMutationRate)
            S[i].set(j, k, (abs((float)S[i].get(j, k)) < 1e-6) ? random(-brainMutationSpread, brainMutationSpread) :  S[i].get(j, k) * (1+random(-brainMutationSpread, brainMutationSpread)));
  }
  
  float rememberClosest() {
    float minDistSighting = Memory[0];
    for(int i=1; i<rayNumber; i++)
      minDistSighting = (Memory[i] < minDistSighting) ? Memory[i] : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    if(!isSnek)
      return random(-PI/6, PI/6);
    return -PI/6 + FeedForward()*PI/3;
  };
  
  float FeedForward() {
    double yl, yp;
    // Create input matrix
    Matrix inputl = new Matrix(1, rayNumber/2);
    for(int i=0; i<rayNumber/2; i++)
        inputl.set(0, i, 1 - logistic(Memory[i], 1./100, 0, 1));
    yl=HalfFeedForward(inputl);
        
    Matrix inputp = new Matrix(1, rayNumber/2);
    for(int i=0; i<rayNumber/2; i++)
        inputp.set(0, i, 1 - logistic(Memory[rayNumber-1-i], 1./100, 0, 1));
    yp=HalfFeedForward(inputp);
    
    //println("..",yp,"-",yl,"=",yp-yl," then to ", logistic((yp-yl), 5, 0, 1)); //<>// //<>//
    return (float)logistic((yp-yl), 5, 0, 1);
    
  }
  
  double HalfFeedForward(Matrix input) {
    // Feed forward through layers
    Matrix out = input.times(S[0]); // Output is 1 x 5 matrix
    for(int i=0; i<5; i++)
      out.set(0, i, sigmoid(out.get(0, i)));
      
    for(int i=1; i<S.length-1; i++) {
      out = out.times(S[i]);          
      for(int j=0; j<out.getRowDimension(); j++)
        for(int k=0; k<out.getColumnDimension(); k++)
          out.set(j, k, sigmoid(out.get(j, k)));
    }
      
    out = out.times(S[S.length-1]);          // Output is 1 x 1 matrix
    return out.get(0,0);
  }
  
  boolean IsInputEmpty(float[][] input) {
    for(int i=0; i<rayNumber; i++)
      if(input[i][0] != Float.POSITIVE_INFINITY)
        return false;
    return true;
  }
  
  void GetSightings(float[][] sightings) {
    if(!IsInputEmpty(sightings)){
<<<<<<< HEAD
      for(int i=0; i<rayNumber; i++)
        Memory[i] = sightings[i][0];
    }
=======
      Memory = sightings; 
    } 
>>>>>>> develop_mouseplace
  };
  
  double logistic(double x, double k, double mid, double max){
    return max / (1.0d + (double) Math.exp(-k*(x-mid)));
  }
  double sigmoid(double x){
    return logistic(x, 1, 0, 1);
  }
  
};
