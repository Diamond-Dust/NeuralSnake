class Brain {
  Matrix S0;  // Synapses between In -> L1
  Matrix S1;  // Synapses between L1 -> L2
  Matrix S2;  // Synapses between L2 -> Out
  float[][] Memory;
  boolean isSnek = false;
  
  Brain() {
    Memory = new float[rayNumber][2];
    S0 = Matrix.random(rayNumber*2, 5).timesEquals(2); // Input -> Layer1
    for(int i=0; i<rayNumber*2; i++)
      for(int j=0; i<5; i++)
        S0.set(i, j, S0.get(i, j)-1);
    S1 = Matrix.random(5, 5).timesEquals(2);           // Layer1 -> Layer2
    for(int i=0; i<5; i++)
      for(int j=0; i<5; i++)
        S1.set(i, j, S1.get(i, j)-1);
    S2 = Matrix.random(5, 1).timesEquals(2);           // Layer2 -> Output
    for(int i=0; i<5; i++)
        S2.set(i, 0, S2.get(i, 0)-1);
  };
  Brain(boolean isSnake) {
    Memory = new float[rayNumber][2];
    isSnek = isSnake;
    S0 = Matrix.random(rayNumber*2, 5).timesEquals(2); // Input -> Layer1
    for(int i=0; i<rayNumber*2; i++)
      for(int j=0; i<5; i++)
        S0.set(i, j, S0.get(i, j)-1);
    S1 = Matrix.random(5, 5).timesEquals(2);           // Layer1 -> Layer2
    for(int i=0; i<5; i++)
      for(int j=0; i<5; i++)
        S1.set(i, j, S1.get(i, j)-1);
    S2 = Matrix.random(5, 1).timesEquals(2);           // Layer2 -> Output
    for(int i=0; i<5; i++)
        S2.set(i, 0, S2.get(i, 0)-1);
  };
  
  float rememberClosest() {
    float minDistSighting = Memory[0][0];
    for(int i=1; i<rayNumber; i++)
      minDistSighting = (Memory[i][0] < minDistSighting) ? Memory[i][0] : minDistSighting;
    return minDistSighting;
  }
  
  float DecideAngle() {
    if(!isSnek)
      return (IsInputEmpty(Memory) || !isSnek) ? random(-PI/6, PI/6) : rememberClosest()/30.;
  
    // Create input matrix
    Matrix input = new Matrix(1, 2*rayNumber);
    for(int i=0; i<rayNumber; i++)
      for(int j=0; j<2; j++)
        input.set(0, i+j*rayNumber, sigmoid(Memory[i][j]));
    
    // Feed forward through layers
    Matrix out = input.times(S0); // Output is 1 x 5 matrix
    for(int i=0; i<5; i++)
      out.set(0, i, sigmoid(out.get(0, i)));
      
    out = out.times(S1);          // Output is 1 x 5 matrix
    for(int i=0; i<5; i++)
      out.set(0, i, sigmoid(out.get(0, i)));
      
    out = out.times(S2);          // Output is 1 x 1 matrix
    double res = sigmoid(out.get(0,0));
    
    return -PI/6 + (float)res*PI/3;
    
  };
  
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
