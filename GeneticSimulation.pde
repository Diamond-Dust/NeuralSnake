class GeneticSimulation{
  
  ArrayList<Snake> snake_population = new ArrayList<Snake>();
  ArrayList<Mouse> snake_feed = new ArrayList<Mouse>();
  ArrayList<CreatureDen> dens = new ArrayList<CreatureDen>();
  int population_size = 10;
  int feed_size = 10;
  
  int generations;
  int current_generation = 0;
  long generation_length;
  long current_length = 0;
  int current_snake = 0;
  boolean is_in_progress = false;
  
  GeneticSimulation(){
    generations = 5;
    generation_length = 50;
    
    // Generate our initial population
    for(int i=0; i<population_size; i++)
      snake_population.add(new Snake());
    for(int i=0; i<feed_size; i++)
      snake_feed.add(new Mouse());
    
    for(Snake s : snake_population)
      dens.add(new CreatureDen(s, (ArrayList <Mouse>)snake_feed.clone()));
    // First generation is ready
    is_in_progress = true;
    println("Starting generation: 0");
    println("Specimen number: 0");
  }
  GeneticSimulation(int g, long g_len){
    generations = g;
    generation_length = g_len;
   
    // Generate our initial population
    for(int i=0; i<population_size; i++)
      snake_population.add(new Snake());
    for(int i=0; i<feed_size; i++)
      snake_feed.add(new Mouse());
    
    for(Snake s : snake_population)
      dens.add(new CreatureDen(s, snake_feed));
    // First generation is ready
    is_in_progress = true;
    println("Starting generation: 0");
    println("Specimen number: 0");
  }
  
  void update(){
    if(current_generation > generations){
      // We finished all generations already
      return;
    }
    if(is_in_progress){
      // Current generation is in progress
      current_length += 1;
      if(current_length > generation_length){
        //Current snake simulation is finished
        current_snake += 1;
        current_length = 0;
        if(current_snake >= population_size){
          println("Ending generation: " + str(current_generation));
          current_generation += 1;
          is_in_progress = false;
        } else {
          println("Specimen number: " + str(current_snake));
        }
      } else {
        //This generations is still in progress
        dens.get(current_snake).update();
      }
    } else {
      // Move onto next generation
      println("Calculating fitness, making new population");
      // Here we would calculate fitness, for the time being let's assume everyone has the same fitness
      // Skim down the population in half using roulette method
      snake_population = roulette();
      // Fill the rest with children using mutations;
      repopulate();
      // Everything is ready for new generation
      println("Starting generation: " + str(current_generation));
      is_in_progress = true;
      current_snake = 0;
    }
  }
  
  ArrayList<Snake> roulette(){
    ArrayList<Snake> new_snake_population = new ArrayList<Snake>();
    println("Surviving snakes: ");
    int specimens_left = population_size / 2;
    for(int i=0; i<specimens_left; i++){
      //Calculate the sum of fitness for every snake in population
      float sum_tot = 0.0;
      for(CreatureDen d : dens)
        sum_tot  += d.getFitness();
      // Roll who get to live
      float chance = random(0, sum_tot);
      float sum_cum = 0.0;
      for(int j=0; j<snake_population.size(); j++){
        sum_cum += dens.get(j).getFitness();
        if(sum_cum > chance){
          //We got him
          new_snake_population.add(snake_population.get(j));
          println(snake_population.get(j));
          snake_population.remove(j);   
          break;
        }
      }
    }
    println();
    return new_snake_population;  
  }
  
  void repopulate(){
    println("New snakes: ");
    for(int i=0; i<population_size/2; i++){
      snake_population.add(new Snake(snake_population.get(i)));
      println(snake_population.get(snake_population.size()-1));
    }
  }
}
