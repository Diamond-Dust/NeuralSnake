class Brain {
  Matrix[] S = new Matrix[3];
  float[][] Memory;
  boolean isSnek = false;
  
  Matrix RandomiseMatrixNormalised(int h, int w, float from, float to) {
    Matrix s = Matrix.random(h, w).timesEquals(to-from);
    for(int i=0; i<h; i++)
      for(int j=0; j<w; j++)
        s.set(i, j, s.get(i, j)+from);
    return s;
  }
  
  Brain() {
    Memory = new float[rayNumber][2];
    
    S[0] = RandomiseMatrixNormalised(rayNumber*2, 5, -5, 3);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -5, 3);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -5, 3);                // Synapses between Layer2 -> Output 
  };
  Brain(boolean isSnake) {
    Memory = new float[rayNumber][2];
    isSnek = isSnake;
    
    S[0] = RandomiseMatrixNormalised(rayNumber*2, 5, -5, 3);      // Synapses between Input -> Layer1
    S[1] = RandomiseMatrixNormalised(5, 5, -5, 3);                // Synapses between Layer1 -> Layer2
    S[2] = RandomiseMatrixNormalised(5, 1, -5, 3);                // Synapses between Layer2 -> Output 
  };
  Brain(Brain Parent) {
    Memory = new float[Parent.Memory.length][Parent.Memory[1].length];
    isSnek = Parent.isSnek;
    
    for(int i=0; i<Parent.S.length; i++)
      S[i] = Parent.S[i].copy();
  };
  
  void Mutate() {
    for(int i=0; i<S.length; i++)
      for(int j=0; j<S[i].getRowDimension(); j++)
        for(int k=0; k<S[i].getColumnDimension(); k++)
          S[i].set(j, k, (abs((float)S[i].get(j, k)) < 1e-6) ? random(-brainMutationRate, brainMutationRate) :  S[i].get(j, k) * (1+random(-brainMutationRate, brainMutationRate)));
  }
  
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
        input.set(0, i+j*rayNumber, 1 - sigmoid(Memory[i][j]));
    
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
    return sigmoid(out.get(0,0)); //<>// //<>// //<>//
  }
  
  boolean IsInputEmpty(float[][] input) {
    for(int i=0; i<rayNumber; i++)
      if(input[i][0] != Float.POSITIVE_INFINITY)
        return false;
    return true;
  };
  
  void GetSightings(float[][] sightings) {
    if(!IsInputEmpty(sightings)){
      Memory = sightings; 
    } 
  };
  
  double sigmoid(double x){
    return 1.0d / (1.0d + (double) Math.exp(-x));
  };
  
  double der_sigmoid(double x){
    return sigmoid(x)*(1-sigmoid(x));
  };
  
  void train(String path){    
    Matrix[] data_set = parseData(path);
    Matrix X_in = data_set[0];
    Matrix Target = data_set[1];
    
    PrintWriter log = createWriter("Err.log");
    
    float dw = 0.02;
    int max_epochs = 10000;
    double cost = calculateCost(X_in, Target);
    while(max_epochs > 0 && cost > 0.1){
      Matrix S_0 = S[0].copy();
      Matrix S_1 = S[1].copy();
      Matrix S_2 = S[2].copy();
      for(Matrix s : S)
        s.plusEquals(RandomiseMatrixNormalised(s.getRowDimension(), s.getColumnDimension(), -dw, dw));
      double n_cost = calculateCost(X_in, Target);
      if(n_cost > cost){
        S[0] = S_0;
        S[1] = S_1;
        S[2] = S_2;
        //println("Cost Unusable: " + n_cost);
      } else {
        cost = n_cost;
        //println("Cost: " + cost);
      }
      log.println(cost);
      println(cost);
      max_epochs--;
    }
    println(cost);
    log.close();
  };
  
  double calculateCost(Matrix X_in, Matrix Target){
    double cost = 0.0;
    for(int n=0; n<X_in.getRowDimension(); n++){
      Matrix input = new Matrix(1, 2*rayNumber);
      for(int j=0; j<input.getColumnDimension(); j++)
        input.set(0, j, X_in.get(n, j));
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
      cost += pow((float)(sigmoid(out.get(0,0)) - Target.get(n, 0)), 2);  
    }
    return cost;
  }
  
  Matrix[] parseData(String path){
    println(in);
    //BufferedReader in = createReader(path);
    Matrix X_in;
    Matrix Target;
    int sets = 0;
    try{
      while(in.readLine() != null) sets++;
      in.close();
      in = createReader(path);
      String line = null;
      X_in = new Matrix(sets, 2*rayNumber);
      Target = new Matrix(sets, 1);
      int index = 0;
      while((line = in.readLine()) != null){
        String [] values = line.split(";");
        for(int i=0; i<2*rayNumber; i++){
          X_in.set(index, i, Double.parseDouble(values[i]));
        }
        Target.set(index, 0, Double.parseDouble(values[2*rayNumber]));
        index++;
      }
      Matrix arr[] = {X_in, Target};
      return arr;
    } catch(IOException e){
      e.printStackTrace();
    }
    return null;
  }
  
  
  
};
