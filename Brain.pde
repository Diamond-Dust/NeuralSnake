class Brain {
  Matrix S0;  // Synapses between In -> L1
  Matrix S1;  // Synapses between L1 -> L2
  Matrix S2;  // Synapses between L2 -> Out
  Matrix[] S = new Matrix[3];
  float[][] Memory;
  boolean isSnek = false;
  
  Matrix RandomiseMatrixNormalised(int w, int h, float from, float to) {
    Matrix s = Matrix.random(w, h).timesEquals(to-from);
    for(int i=0; i<w; i++)
      for(int j=0; i<h; i++)
        s.set(i, j, s.get(i, j)+from);
    return s;
  }
  
  Brain() {
    Memory = new float[rayNumber][2];
    
    S[0] = RandomiseMatrixNormalised(rayNumber*2, 5, -1, 1);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -1, 1);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -1, 1);                // Synapses between Layer2 -> Output 
  };
  Brain(boolean isSnake) {
    Memory = new float[rayNumber][2];
    isSnek = isSnake;
    
    S[0] = RandomiseMatrixNormalised(rayNumber*2, 5, -1, 1);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -1, 1);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -1, 1);                // Synapses between Layer2 -> Output 
  };
  
  float rememberClosest() {
    float minDistSighting = Memory[0][0];
    for(int i=1; i<rayNumber; i++)
      minDistSighting = (Memory[i][0] < minDistSighting) ? Memory[i][0] : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    if(!isSnek)
      return random(-PI/6, PI/6);
    
    return -PI/6 + (float)FeedForward()*PI/3;
    
  };
  double FeedForward() {
    // Create input matrix
    Matrix input = new Matrix(1, 2*rayNumber);
    for(int i=0; i<rayNumber; i++)
      for(int j=0; j<2; j++)
        input.set(0, i+j*rayNumber, sigmoid(Memory[i][j]));
    
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
      
    out = out.times(S[2]);          // Output is 1 x 1 matrix
    return sigmoid(out.get(0,0));
  }
  
  boolean IsInputEmpty(float[][] input) {
    for(int i=0; i<rayNumber; i++)
      if(input[i][0] != Float.POSITIVE_INFINITY)
        return false;
    return true;
  }
  
  void GetSightings(float[][] sightings) {
    if(IsInputEmpty(sightings))
      Memory = sightings;
    //println(Memory);
  };
  
  double sigmoid(double x){
    return 1.0d / (1.0d + (double) Math.exp(-x));
  }
  
};
