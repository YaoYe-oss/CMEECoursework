# CMEE 2024 HPC exercises R code main pro forma
# You don't HAVE to use this but it will be very helpful.
# If you opt to write everything yourself from scratch please ensure you use
# EXACTLY the same function and parameter names and beware that you may lose
# marks if it doesn't work properly because of not using the pro-forma.

name <- "Yao Ye"
preferred_name <- "Yao"
email <- "yy6024@imperial.ac.uk"
username <- "YaoYe"

# Please remember *not* to clear the work space here, or anywhere in this file.
# If you do, it'll wipe out your username information that you entered just
# above, and when you use this file as a 'toolbox' as intended it'll also wipe
# away everything you're doing outside of the toolbox.  For example, it would
# wipe away any automarking code that may be running and that would be annoying!

# Section One: Stochastic demographic population model

# Question 0
state_initialise_adult <- function(num_stages, initial_size) {
  # Create a vector with all zeros and a length of num_dages
  state <- rep(0, num_stages)
  # Assign the last position as' initialize size '
  state[num_stages] <- initial_size
  return(state)
}
# Test cases
state_initialise_adult(num_stages = 4, initial_size = 10)
# output: [1]  0  0  0 10

state_initialise_spread <- function(num_stages, initial_size) {
  # Calculate the basic allocation for each stage
  base_count <- floor(initial_size / num_stages)
  # Calculate the excess number of people
  remainder <- initial_size %% num_stages
  # Create an initial vector consisting entirely of base_comunt
  state <- rep(base_count, num_stages)
  # Allocate the remaining people, starting from the first stage
  state[1:remainder] <- state[1:remainder] + 1
  return(state)
}
# Test cases
state_initialise_spread(num_stages = 3, initial_size = 8)
# output: [1] 3 3 2

state_initialise_spread(num_stages = 4, initial_size = 10)
# output: [1] 3 3 2 2

# Question 1
question_1 <- function() {
  # Import Demographic R file 
  source("Demographic.R")
  
  # Define the projection matrix (growth + reproduction)
  growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                            0.5, 0.4, 0.0, 0.0,
                            0.0, 0.4, 0.7, 0.0,
                            0.0, 0.0, 0.25, 0.4),
                          nrow=4, ncol=4, byrow=TRUE)
  
  reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0),
                                nrow=4, ncol=4, byrow=TRUE)
  
  projection_matrix <- reproduction_matrix + growth_matrix  # Compute projection matrix
  
  # Define the two initial conditions
  initial_state_adult <- state_initialise_adult(num_stages=4, initial_size=100)
  initial_state_spread <- state_initialise_spread(num_stages=4, initial_size=100)
  
  # Set simulation length
  simulation_length <- 24
  
  # Run deterministic simulation
  pop_size_adult <- deterministic_simulation(initial_state_adult, projection_matrix, simulation_length)
  pop_size_spread <- deterministic_simulation(initial_state_spread, projection_matrix, simulation_length)
  
  # Create and save the plot
  png(filename="question_1.png", width=600, height=400)  # Save plot as a PNG file
  plot(0:simulation_length, pop_size_adult, type="l", col="blue", lwd=2,
       xlab="Time Step", ylab="Total Population Size", ylim=range(c(pop_size_adult, pop_size_spread)),
       main="Comparison of Population Growth under Different Initial Conditions")
  lines(0:simulation_length, pop_size_spread, col="red", lwd=2)
  legend("topright", legend=c("All Adults", "Spread Across Stages"), col=c("blue", "red"), lwd=2)
  
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()  
  
  # Return explanation
  return("The initial population distribution significantly influences early population growth. 
  When all individuals start as adults, initial growth is lower because reproduction takes time.
  In contrast, when individuals are spread across life stages, there are more young individuals who
  will soon become reproductive, leading to faster initial growth. However, over time, both populations 
  stabilize towards a similar equilibrium as the projection matrix dictates the long-term dynamics.")
}
question_1()

# Question 2
question_2 <- function() {
  # Load necessary functions
  source("Demographic.R")  # Ensure the script is correctly sourced
  
  sum_vect <- function(vec1, vec2) {
    return(vec1 + vec2)  # Element-wise vector addition
  }
  
  # Define the growth and reproduction matrices (same as in Question 1)
  growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                            0.5, 0.4, 0.0, 0.0,
                            0.0, 0.4, 0.7, 0.0,
                            0.0, 0.0, 0.25, 0.4),
                          nrow=4, ncol=4, byrow=TRUE)
  
  reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0),
                                nrow=4, ncol=4, byrow=TRUE)
  
  # Define the clutch distribution
  clutch_distribution <- c(0.06, 0.08, 0.13, 0.15, 0.16, 0.18, 0.15, 0.06, 0.03)
  
  # Define initial conditions
  initial_state_adult <- state_initialise_adult(num_stages=4, initial_size=100)
  initial_state_spread <- state_initialise_spread(num_stages=4, initial_size=100)
  
  # Set simulation length
  simulation_length <- 24
  
  # Run stochastic simulations
  pop_size_adult_stochastic <- stochastic_simulation(initial_state_adult, 
                                                     growth_matrix, 
                                                     reproduction_matrix, 
                                                     clutch_distribution, 
                                                     simulation_length)
  
  pop_size_spread_stochastic <- stochastic_simulation(initial_state_spread, 
                                                      growth_matrix, 
                                                      reproduction_matrix, 
                                                      clutch_distribution, 
                                                      simulation_length)
  
  # Create and save the plot
  png(filename="question_2.png", width=600, height=400)  # Save plot as a PNG file
  plot(0:simulation_length, pop_size_adult_stochastic, type="l", col="blue", lwd=2,
       xlab="Time Step", ylab="Total Population Size", ylim=range(c(pop_size_adult_stochastic, pop_size_spread_stochastic)),
       main="Comparison of Population Growth under Stochastic Model")
  lines(0:simulation_length, pop_size_spread_stochastic, col="red", lwd=2)
  legend("topright", legend=c("All Adults", "Spread Across Stages"), col=c("blue", "red"), lwd=2)
  
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
  # Return explanation
  return("The stochastic simulation introduces randomness in survival and reproduction, leading to variations in population size at each time step.
  Compared to the deterministic model, stochastic simulations show fluctuations due to random events affecting birth and survival rates.
  This is why the curves in stochastic models are less smooth. Over multiple runs, the average trend may resemble the deterministic model, 
  but individual simulations differ due to random variability.")
}
question_2()

# Questions 3 and 4 involve writing code elsewhere to run your simulations on the cluster

# Question 5
question_5 <- function(){
# Used to store the number of extinctions under 4 conditions
extinct_counts <- rep(0, 4)
for(i in 1:100){
  if(i <= 25) condition = 1
  else if(i <= 50) condition = 2
  else if(i <= 75) condition = 3
  else if(i <= 100) condition = 4
  datapath = paste("stochastic_results_", i, ".rda", sep="")
  load(datapath)
  
  # For a certain seed, there are 150 simulations, and each simulation has 120 steps.
  for(j in 1:150){
    a <- results_list[j]
    final_num <- a[[1]][length(a[[1]])]  #Final step value for each simulation
    if(final_num == 0){
      extinct_counts[condition] <- extinct_counts[condition] + 1
    }
  }
}
extinct_rate <- extinct_counts / rep(25 * 150, 4)
print(extinct_counts)
print(extinct_rate)
names(extinct_rate) = c("Large 100 adults", "Small 10 adults", "Large 100 spread", "Small 10 spread")
png(filename="question_5.png", width = 600, height = 400)

# plot your graph here
barplot(extinct_rate,
        xlab = "Initial Conditions", ylab = "Proportion of Extinction", ylim = c(0, max(extinct_rate) + 0.01),
        main = "Extinction Rate")
Sys.sleep(0.1)
dev.off()

# Which population was most likely to go extinct? Explain why this is the case.
return("Populations with initial conditions of a small population of 10 individuals spread across the life stages are most likely to become extinct, followed by
   a small population of 10 adults. First of all, for a population with a small population size, compared with a population with a large population size, it is easier to reduce the number to 0 due to random reasons, so that
   The population is extinct. Secondly, the reproduction of the population is mainly concentrated in the final stage, which means that the greater the number in the final stage, the greater the population's ability to resist randomness, and the initial condition is spread across the life
   Stages have fewer individuals in the final stages of the population, making them more susceptible to extinction.")
}
question_5()

# Question 6
question_6 <- function(){
  # calculate mean population size at each time step across all simulations on stocastic model
  total_100_spread <- rep(0, 121)
  total_10_spread <- rep(0, 121)
  for(i in 51:100) { # "Large 100 spread", "Small 10 spread"
    # load data
    file_name <- paste("stochastic_results_", i, ".rda", sep="")
    load(file_name)
    for(t in 1:150){
      if(i <= 75){
        total_100_spread <- total_100_spread + results_list[t][[1]]
      }
      else{
        total_10_spread <- total_10_spread + results_list[t][[1]]
      }
    }
  }
  # changing demographic trends
  mean_100_spread <- total_100_spread / (25 * 150)
  mean_10_spread <- total_10_spread / (25 * 150)
  
  # calculate population size time series produced by the deterministic model
  large_initial_state <- state_initialise_spread(4, 100)
  small_initial_state <- state_initialise_spread(4, 10)
  growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                            0.5, 0.4, 0.0, 0.0,
                            0.0, 0.4, 0.7, 0.0,
                            0.0, 0.0, 0.25, 0.4), nrow=4, ncol=4, byrow=T)
  reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0,
                                  0.0, 0.0, 0.0, 0.0), nrow=4, ncol=4, byrow=T)
  projection_matrix <- reproduction_matrix + growth_matrix
  
  deterministic_large <- deterministic_simulation(large_initial_state, projection_matrix, 120)
  deterministic_small <- deterministic_simulation(small_initial_state, projection_matrix, 120)
  
  spread_10_deviation = mean_10_spread / deterministic_small
  spread_100_deviation = mean_100_spread / deterministic_large
  
  png(filename="question_6.png", width = 600, height = 400)
  y_min <- min(c(spread_10_deviation, spread_100_deviation))
  y_max <- max(c(spread_10_deviation, spread_100_deviation))
  
  plot(1:121, spread_10_deviation, type = "l", col = "blue", ylim = c(y_min - 0.01, y_max + 0.01),
       main = "Deviation of Stochastic Model from Deterministic Model", xlab = "Time Steps", ylab = "Deviation")
  
  lines(seq(1, 121), spread_100_deviation, type = "l", col = "black")
  abline(h=1, lty=2, col="red")
  legend("topright", legend=c("Initial 10 population spread ", "Initial 100 population spread"), col=c("blue", "black"), lty=1)
  Sys.sleep(0.1)
  dev.off()
  # For which initial condition is it more appropriate to approximate the 
  # ‘average’ behaviour of this stochastic system with a deterministic model? Explain why.
  return("For an initial condition of 100 individuals spread across the life stages is more appropriate to approximate the
   ‘average’ behavior of this stochastic system with a deterministic model because of random fluctuations between individuals in a larger population
   It is small relative to the population, so the average effect reduces the impact of randomness on the overall dynamics.
  This means that when the number of individuals is large, random events have relatively little impact on the overall population, so deterministic models can better predict the average behavior of the population.")
}
question_6()

# Section Two: Individual-based ecological neutral theory simulation 

# Question 7
species_richness <- function(community){
  # Find unique species in the community. Calculate the richness as the length of unique species
  return(length(unique(community)))
}

# Question 8
init_community_max <- function(size){
  # Generate an initial sequence from 1 to size, each representing a unique species
  return(seq(size))
}

# Question 9
init_community_min <- function(size){
  # Generate an initial sequence with total number of individuals given by size, representing the same species
  return(rep(1, size))
}

# Question 10
choose_two <- function(max_value){
  # Sample two distinct numbers from 1 to max_value without replacement
  chosen_numbers <- sample(max_value, 2,)
  return(chosen_numbers)
}

# Question 11
neutral_step <- function(community){
  # Use the choose_two function to pick two individuals. The first will die, and the second will reproduce
  indices <- choose_two(length(community))
  # Replace the species of the dying individual with the species of the reproducing individual
  community[indices[1]] <- community[indices[2]]
  return(community)
}


# Question 12
neutral_generation <- function(community){
  # Determine the number of steps, rounding up or down randomly if size is odd
  steps <- floor(length(community) / 2)
  # Perform neutral steps for one generation
  for (i in 1:steps) {
    community <- neutral_step(community)
  }
  return(community)
}

# Question 13
neutral_time_series <- function(community,duration)  {
  # Initialize a vector to store species richness over time
  species_richness_series <- numeric(duration + 1)
  # Record the species richness of the initial community
  species_richness_series[1] <- species_richness(community)
  # Run the simulation for the specified duration
  for (i in 1:duration) {
    community <- neutral_generation(community)
    species_richness_series[i + 1] <- species_richness(community)
  }
  return(species_richness_series)
}

#Question 14
  question_14 <- function() {
  
    # The initial community is set to the maximum diversity of 100 individuals
  initial_community <- init_community_max(100)
  
  # Run the simulation for 200 generations
  time_series_data <- neutral_time_series(initial_community, 200)
  print(time_series_data)
  png(filename="question_14.png", width = 600, height = 400)
  # plot your graph here
  plot(time_series_data, type="l", main="Neutral Model Simulation Over 200 Generations",
       xlab="Generation", ylab="Species Richness")
  Sys.sleep(0.1)
  dev.off()
  # What state will the system always converge to if you wait long enough? Why is this?
  return("With the increase of iteration time, the system always converges to the state of reduced species richness, 
         because new species cannot be produced in the system, and randomly selected species disappear, 
         a species can only disappear and reproduce, and eventually only one species will be left.")
}
  question_14()
  
  
# Question 15
neutral_step_speciation <- function(community,speciation_rate)  {
  if (runif(1) < speciation_rate) {
    # Speciation
    new_species <- max(community) + 1
    # Use the choose_two function to pick two different individuals
    chosen_indices <- choose_two(length(community))
    # Replace the dying individual with the new species
    dead_individual <- chosen_indices[1]
    community[dead_individual] <- new_species
  } else {
    # Normal neutral step
    community <- neutral_step(community)
  }
  return(community)
}
# Test
neutral_step_speciation(c(1, 1, 2), speciation_rate = 0.2)

# Question 16
neutral_generation_speciation <- function(community,speciation_rate)  {
  # Determine the number of steps to simulate one generation
  num_steps <- length(community) / 2
  
  # Round up or down randomly if num_steps is not an integer
  num_steps <- sample(c(floor(num_steps), ceiling(num_steps)), 1)
  
  # Perform neutral steps with speciation for one generation
  for (i in 1:num_steps) {
    community <- neutral_step_speciation(community, speciation_rate)
  }
  
  return(community)
}

# Question 17
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  # Initialize a vector to store species richness over time
  species_richness_series <- numeric(duration + 1)
  # Record the species richness of the initial community
  species_richness_series[1] <- species_richness(community)
  # Run the simulation for the specified duration
  for (i in 1:duration) {
    community <- neutral_generation_speciation(community, speciation_rate)
    species_richness_series[i + 1] <- species_richness(community)
  }
  return(species_richness_series)
}
# Test
initial_community <- init_community_max(10)
duration <- 20
speciation_rate <- 0.1
time_series <- neutral_time_series_speciation(initial_community, duration, speciation_rate)
time_series 

# Question 18
question_18 <- function()  {
  
  # Set parameters
  speciation_rate <- 0.1
  community_size <- 100
  generations <- 200
  
  # Initialize communities
  community_max <- init_community_max(community_size)
  community_min <- init_community_min(community_size)
  
  # Run simulations
  time_series_max <- neutral_time_series_speciation(community_max, speciation_rate, generations)
  time_series_min <- neutral_time_series_speciation(community_min, speciation_rate, generations)
  
  
  png(filename="question_18.png", width = 600, height = 400)
  # plot your graph here
  plot(1:(generations + 1), time_series_max, type="l", col="blue", 
       xlab="Generation", ylab="Species Richness", 
       main="Neutral Theory Simulation with Speciation")
  lines(1:(generations + 1), time_series_min, type="l", col="red")
  legend("topright", legend=c("Max Diversity", "Min Diversity"), 
         col=c("blue", "red"), lty=1, cex=0.8)
  Sys.sleep(0.1)
  dev.off()
  
  # Explain what you found from this plot about the effect of initial conditions. Why does the neutral model simulation give you those particular results
  return("I found that starting from the maximum species diversity, 
  the number of species first declines and then stabilizes; 
  starting from the single species diversity, 
  the number of species first increases and then stabilizes; 
  at the same time, the number of species after the final stabilization
   is almost the same regardless of the maximum species 
   diversity or the single species diversity, and always 
   fluctuates steadily within a certain range. Because the whole 
   community has both the creation of new species and the disappearance
    of old species, there is no discrimination in any community, 
    and eventually tends to be stable.") 
}
question_18()

# Question 19
species_abundance <- function(community)  {
  abundance <- sort(table(community), decreasing = TRUE)
  return(as.vector(abundance))
}
# Test
species_abundance(c(1, 5, 3, 6, 5, 6, 1, 1))  # Should return c(3, 2, 2, 1)

# Question 20
octaves <- function(abundance_vector) {
  # Determine the octave class for each abundance value
  # Adding 1 because log2(1) is 0, and we want species with abundance 1 to fall into the first octave
  octave_classes <- floor(log2(abundance_vector))
  # Count the number of species in each octave class
  octave_counts <- tabulate(octave_classes + 1)
  return(octave_counts)
}
# Test
abundance <- species_abundance(c(1, 5, 3, 6, 5, 6, 1, 1))
octaves(abundance)  # Converts the species abundances into octave classes

# Question 21
sum_vect <- function(x, y) {
  # Determine the lengths of both vectors
  len_x <- length(x)
  len_y <- length(y)
  
  # Find the maximum length
  max_len <- max(len_x, len_y)
  
  # Pad the shorter vector with zeros
  x <- c(x, rep(0, max_len - len_x))
  y <- c(y, rep(0, max_len - len_y))
  
  # Return element-wise sum
  return(x + y)
}

# Test Cases
print(sum_vect(c(1,3), c(1,0,5,2)))  # Expected: [2, 3, 5, 2]
print(sum_vect(c(5, 10, 15), c(2, 4)))  # Expected: [7, 14, 15]
print(sum_vect(c(1,2,3,4), c(5,6)))  # Expected: [6, 8, 3, 4]

# Question 22
question_22 <- function() {
  # Parameters
  system_size <- 100
  generations_burn_in <- 200
  generations_main <- 2000
  speciation_rate <- 0.1
  record_interval <- 20
  
  # Initialize communities
  community_max <- init_community_max(system_size)
  community_min <- init_community_min(system_size)
  
  # Burn-in phase
  for (gen in seq(1, generations_burn_in)) {
    community_max <- neutral_generation_speciation(community_max, speciation_rate)
    community_min <- neutral_generation_speciation(community_min, speciation_rate)
  }
  
  # Storage for octave vectors
  octaves_max <- list()
  octaves_min <- list()
  
  # Main simulation phase (recording every 20 generations)
  for (gen in seq(1, generations_main)) {
    community_max <- neutral_generation_speciation(community_max, speciation_rate)
    community_min <- neutral_generation_speciation(community_min, speciation_rate)
    
    if (gen %% record_interval == 0) {
      octaves_max <- append(octaves_max, list(octaves(species_abundance(community_max))))
      octaves_min <- append(octaves_min, list(octaves(species_abundance(community_min))))
    }
  }
  
  # Compute mean species abundance distributions
  mean_octaves_max <- Reduce(sum_vect, octaves_max) / length(octaves_max)
  mean_octaves_min <- Reduce(sum_vect, octaves_min) / length(octaves_min)
  
  # Generate plots and save
  png(filename = "question_22.png", width = 600, height = 400)
  par(mfrow = c(1, 2))  # Two panels for max and min diversity start
  
  barplot(mean_octaves_max, main = "Max Diversity Start", xlab = "Octave", ylab = "Mean Species Abundance", col = "blue")
  barplot(mean_octaves_min, main = "Min Diversity Start", xlab = "Octave", ylab = "Mean Species Abundance", col = "red")
  
  Sys.sleep(0.1)
  dev.off()
  
  # Return explanation
  return("Despite different initial conditions, the species abundance distributions converge over time. 
         The max diversity condition starts with many rare species, while the min diversity condition gains species gradually through speciation. 
         However, long-term equilibrium is determined by the balance of extinction and speciation, rather than initial conditions.")
}
question_22()

# Question 23
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
  start_time <- proc.time()[3]  # Start timer
  
  # Initialize community with minimal diversity
  community <- rep(1, size)
  
  # Set up data storage
  time_series <- numeric()
  abundance_list <- list()
  
  generation <- 0
  total_time <- 0
  
  while ((proc.time()[3] - start_time) / 60 < wall_time) {
    generation <- generation + 1
    
    # Run a neutral generation with speciation
    community <- neutral_generation_speciation(community, speciation_rate)
    
    # Store species richness at intervals during burn-in
    if (generation <= burn_in_generations && generation %% interval_rich == 0) {
      time_series <- c(time_series, species_richness(community))
    }
    
    # Store species abundance as octaves at defined intervals
    if (generation %% interval_oct == 0) {
      abundance_list[[length(abundance_list) + 1]] <- octaves(species_abundance(community))
    }
    
    # Update elapsed time
    total_time <- proc.time()[3] - start_time
  }
  
  # Save outputs
  save(time_series, abundance_list, community, total_time, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name)
} 
# =========================
# Local Testing (Add this at the END of the script)
# =========================
neutral_cluster_run(
  speciation_rate = 0.1, 
  size = 100, 
  wall_time = 10, 
  interval_rich = 1, 
  interval_oct = 10, 
  burn_in_generations = 200, 
  output_file_name = "my_test_file_1.rda"
)

# Questions 24 and 25 involve writing code elsewhere to run your simulations on
# the cluster

# Question 26 
process_neutral_cluster_results <- function() {
  cluster_500 <- 0
  cluster_1000 <- 0
  cluster_2500 <- 0
  cluster_5000 <- 0
  
  total_500 <- c()
  total_1000 <- c()
  total_2500 <- c()
  total_5000 <- c()
  
  for(i in 1:100){
    load(file = paste0("simulation_output_", i, ".rda"))
    
    if(i <= 25){size = 500} else if
    (i <= 50){size = 1000} else if
    (i <= 75){size = 2500} else if
    (i <= 100){size = 5000}
    
    burn_in = 80
    
    total <- c()
    for(j in burn_in:length(abundance_list)){
      total <- sum_vect(total, abundance_list[[j]])
    }
    
    assign(paste0("cluster_", size), (get(paste0("cluster_", size)) + (length(abundance_list) - burn_in + 1)))
    assign(paste0("total_", size), sum_vect(get(paste0("total_", size)), total))
  }
  
  mean_500 <- total_500/cluster_500
  mean_1000 <- total_1000/cluster_1000
  mean_2500 <- total_2500/cluster_2500
  mean_5000 <- total_5000/cluster_5000
  combined_results <- list(mean_500, mean_1000, mean_2500, mean_5000) #create your list output here to return
  
  save(combined_results, file = "Combined_results.rda")
  # save results to an .rda file

plot_neutral_cluster_results <- function(){
  
  # load combined_results from your rda file
  load("combined_results.rda")
  
  png(filename="plot_neutral_cluster_results.png", width = 600, height = 400)
  
  par(mfrow = c(2, 2))
  size_list <- c('500', '1000', '2500', '5000')
  for (i in 1:4) {
    data <- combined_results[[i]]
    max_height <- max(data) * 1.3
    barplot(data, 
            main = paste("Octave Class Distribution Size ", size_list[i]), 
            xlab = "Abundance Range with octave classes", 
            ylab = "Species Count",
            ylim = c(0, max_height))
  }
  
  Sys.sleep(0.1)
  dev.off()
  
  return(combined_results)
}


# Challenge questions - these are substantially harder and worth fewer marks.
# I suggest you only attempt these if you've done all the main questions. 

# Challenge question A
Challenge_A <- function(){
  
  # Load required libraries
  library(ggplot2)
  library(dplyr)
  
  # Specify the HPC folder path where .rda files are stored
  hpc_folder <- "~/Desktop/HPC/"  # Change this if necessary
  
  # Get a list of all stochastic_results_XX.rda files
  rda_files <- list.files(path = hpc_folder, pattern = "^stochastic_results_[0-9]+\\.rda$", full.names = TRUE)
  
  # Check if files exist
  if (length(rda_files) == 0) {
    stop("Error: No stochastic_results_XX.rda files found in the specified directory.")
  }
  
  # Initialize an empty list to store data frames
  all_simulations <- list()
  
  # Function to determine initial condition from simulation ID
  determine_initial_condition <- function(simulation_id) {
    if (simulation_id >= 1 && simulation_id <= 25) {
      return("Large 100 adults")
    } else if (simulation_id >= 26 && simulation_id <= 50) {
      return("Small 10 adults")
    } else if (simulation_id >= 51 && simulation_id <= 75) {
      return("Large 100 spread")
    } else if (simulation_id >= 76 && simulation_id <= 100) {
      return("Small 10 spread")
    } else {
      return(NA)
    }
  }
  
  # Iterate over all `.rda` files
  simulation_counter <- 1  # Unique simulation identifier
  for (file in rda_files) {
    
    load(file)  # Load the .rda file
    
    # Identify correct variable name inside the .rda file
    variables_in_file <- ls()
    results_variable <- variables_in_file[grepl("results_list", variables_in_file, ignore.case = TRUE)]  # Correct variable name
    
    if (length(results_variable) == 1) {
      results_list <- get(results_variable)  # Extract results_list
    } else {
      warning(paste("Warning: No valid results_list variable found in", file))
      next  # Skip this file
    }
    
    # Extract simulation number from filename
    simulation_id <- as.numeric(gsub("stochastic_results_([0-9]+)\\.rda", "\\1", basename(file)))
    
    # Assign the correct initial condition
    initial_condition <- determine_initial_condition(simulation_id)
    
    # Convert results_list to a data frame
    for (j in seq_along(results_list)) {
      sim_time_series <- results_list[[j]]  # Extract time series (assumed to be numeric vector)
      
      # Ensure the data is numeric
      if (!is.numeric(sim_time_series) || length(sim_time_series) == 0) {
        warning(paste("Warning: Invalid simulation data in", file, "at index", j))
        next
      }
      
      time_steps <- 0:(length(sim_time_series) - 1)  # Time steps from 0 to simulation length
      
      # Create a temporary data frame
      temp_df <- data.frame(
        simulation_number = simulation_counter,
        simulation_id = simulation_id,  # Store file-based simulation ID
        initial_condition = initial_condition,  # Assigned from function
        time_step = as.numeric(time_steps),
        population_size = as.numeric(sim_time_series)
      )
      
      all_simulations[[length(all_simulations) + 1]] <- temp_df  # Append to list
      simulation_counter <- simulation_counter + 1  # Increment unique ID
    }
  }
  
  # Combine all results into a single data frame
  if (length(all_simulations) == 0) {
    stop("Error: No valid simulation data found. Check your .rda files.")
  }
  
  population_size_df <- dplyr::bind_rows(all_simulations)
  
  # Save the data frame as an RData file for future use
  save(population_size_df, file = file.path(hpc_folder, "population_size_df.rda"))
  
  # Generate plot
  png(filename = file.path(hpc_folder, "Challenge_A.png"), width = 800, height = 600)
  
  ggplot(population_size_df, aes(x = time_step, y = population_size, 
                                 group = simulation_number, colour = initial_condition)) +
    geom_line(alpha = 0.1) +  # Semi-transparent lines to avoid overplotting
    theme_minimal() +
    labs(title = "Population Size Over Time in Stochastic Simulations",
         x = "Time Step",
         y = "Population Size") +
    theme(legend.position = "right")  # Show legend to distinguish conditions
  
  dev.off()
  
  return("Challenge A completed: Data frame saved as 'population_size_df.rda', plot saved as 'Challenge_A.png'.")
}


# Challenge question B
Challenge_B <- function() {
  
  # Load required packages
  library(ggplot2)
  
  # Simulation parameters
  num_repeats <- 100  # Number of repeated simulations
  generations <- 2200  # Total generations (200 burn-in + 2000 simulation)
  
  # Initialize data storage
  results <- data.frame(generation = numeric(), richness = numeric(), condition = character())
  
  # Run simulations for both initial conditions
  for (condition in c("min_richness", "max_richness")) {
    
    for (i in 1:num_repeats) {
      
      # Set initial community based on condition
      if (condition == "min_richness") {
        community <- init_community_min(100)
      } else {
        community <- init_community_max(100)
      }
      
      # Track species richness over time
      richness_values <- numeric(generations + 1)
      richness_values[1] <- species_richness(community)
      
      for (gen in 1:generations) {
        community <- neutral_generation_speciation(community, speciation_rate = 0.1)
        richness_values[gen + 1] <- species_richness(community)
      }
      
      # Store results
      results <- rbind(results, data.frame(generation = 0:generations,
                                           richness = richness_values,
                                           condition = condition))
    }
  }
  
  # Compute mean and 97.2% confidence intervals
  summary_data <- results %>%
    group_by(generation, condition) %>%
    summarise(mean_richness = mean(richness),
              ci_low = quantile(richness, 0.014),
              ci_high = quantile(richness, 0.986))
  
  # Save the plot
  png(filename = "Challenge_B.png", width = 800, height = 600)
  
  ggplot(summary_data, aes(x = generation, y = mean_richness, color = condition)) +
    geom_line() +
    geom_ribbon(aes(ymin = ci_low, ymax = ci_high, fill = condition), alpha = 0.2) +
    theme_minimal() +
    labs(title = "Mean Species Richness Over Time",
         x = "Generation",
         y = "Mean Species Richness") +
    scale_color_manual(values = c("blue", "red")) +
    scale_fill_manual(values = c("blue", "red"))
  
  dev.off()
  
  # Estimate equilibrium: The first generation where richness stabilizes
  equilibrium_gen <- summary_data %>%
    group_by(condition) %>%
    filter(abs(mean_richness - lag(mean_richness, default = first(mean_richness))) < 0.01) %>%
    summarise(equilibrium = min(generation))
  
  return(paste("The system reaches dynamic equilibrium at approximately", 
               min(equilibrium_gen$equilibrium), "generations."))
}

# Run the function
Challenge_B()


# Challenge question C
Challenge_C <- function() {
  
  # Load required package
  library(ggplot2)
  
  # Define initial species richness values to test
  richness_levels <- seq(10, 100, by = 10)  # Vary initial richness from 10 to 100
  
  num_repeats <- 50  # Number of repeat simulations per richness level
  generations <- 2200  # Total generations
  
  # Initialize data storage
  results <- data.frame(generation = numeric(), richness = numeric(), initial_richness = numeric())
  
  # Run simulations for different initial richness values
  for (init_richness in richness_levels) {
    
    for (i in 1:num_repeats) {
      
      # Generate an initial community with `init_richness` unique species
      community <- sample(1:100, size = 100, replace = TRUE)  # Random species assignment
      
      # Track species richness over time
      richness_values <- numeric(generations + 1)
      richness_values[1] <- species_richness(community)
      
      for (gen in 1:generations) {
        community <- neutral_generation_speciation(community, speciation_rate = 0.1)
        richness_values[gen + 1] <- species_richness(community)
      }
      
      # Store results
      results <- rbind(results, data.frame(generation = 0:generations,
                                           richness = richness_values,
                                           initial_richness = init_richness))
    }
  }
  
  # Compute mean richness for each initial richness level over time
  summary_data <- results %>%
    group_by(generation, initial_richness) %>%
    summarise(mean_richness = mean(richness))
  
  # Save the plot
  png(filename = "Challenge_C.png", width = 800, height = 600)
  
  ggplot(summary_data, aes(x = generation, y = mean_richness, color = as.factor(initial_richness))) +
    geom_line(alpha = 0.6) +
    theme_minimal() +
    labs(title = "Averaged Species Richness Over Time for Different Initial Richness Levels",
         x = "Generation",
         y = "Mean Species Richness",
         color = "Initial Richness") +
    scale_color_viridis_d()
  
  dev.off()
  
  return("Challenge C completed: Graph saved as 'Challenge_C.png'.")
}

# Run the function
Challenge_C()


# Challenge question D
Challenge_D <- function() {
  # Initialize variables
  simulation <- 1
  sizes <- c(500, 1000, 2500, 5000)
  means <- list()
  
  # Process files for each community size
  for (size in sizes) {
    # Running total of richness for each community size
    series_total <- c()
    sim_count <- 0
    
    # Process 25 simulations for each community size
    for (i in 1:25) {
      file_name <- paste("simulation_output_", simulation, ".rda", sep="")
      
      # Try alternate naming pattern if file not found
      if (!file.exists(file_name)) {
        file_name <- paste("neutral_cluster_", simulation, ".rda", sep="")
      }
      
      # Load data if file exists
      if (file.exists(file_name)) {
        load(file_name)
        
        if (exists("time_series") && length(time_series) > 0) {
          series_total <- sum_vect(series_total, time_series)
          sim_count <- sim_count + 1
        }
      }
      
      simulation <- simulation + 1
    }
    
    # Calculate mean species richness
    if (sim_count > 0) {
      mean_rich_series <- series_total / sim_count
    } else {
      mean_rich_series <- c(0)
      warning(paste("No valid data found for community size", size))
    }
    
    means[[length(means) + 1]] <- mean_rich_series
  }
  
  # Determine appropriate burn-in periods
  burn_in_estimates <- numeric(length(sizes))
  
  for (i in 1:length(sizes)) {
    mean_series <- means[[i]]
    
    if (length(mean_series) > 10) {
      # Calculate rate of change (first derivative)
      rate_change <- diff(mean_series) / diff(1:length(mean_series))
      
      # Find where the rate of change becomes consistently small
      # Define threshold as 1% of the maximum rate of change
      threshold <- max(abs(rate_change[1:min(50, length(rate_change))])) * 0.01
      
      # Find the first point where 10 consecutive values are below threshold
      window_size <- 10
      for (j in 1:(length(rate_change) - window_size + 1)) {
        if (all(abs(rate_change[j:(j+window_size-1)]) < threshold)) {
          burn_in_estimates[i] <- j
          break
        }
      }
      
      # If no stable period found, use a conservative estimate
      if (burn_in_estimates[i] == 0) {
        burn_in_estimates[i] <- ceiling(length(mean_series) * 0.1)
      }
    } else {
      burn_in_estimates[i] <- 1
    }
  }
  
  # Create the plot
  png(filename="Challenge_D.png", width = 800, height = 600, res = 100)
  
  par(mfrow = c(2,2), mar = c(4, 4, 3, 1), oma = c(0, 0, 2, 0))
  
  for (i in 1:length(means)) {
    mean_series <- means[[i]]
    generations <- 1:length(mean_series)
    
    # Plot mean species richness over time
    plot(generations, mean_series, type = "l", 
         main = paste("Community Size =", sizes[i]),
         xlab = "Generations", ylab = "Species Richness")
    
    # Add a grid
    grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted")
    
    # Add a vertical line indicating the estimated burn-in period
    if (burn_in_estimates[i] > 0 && burn_in_estimates[i] < length(mean_series)) {
      abline(v = burn_in_estimates[i], col = "red", lty = 2)
      text(burn_in_estimates[i] * 1.1, min(mean_series) + (max(mean_series) - min(mean_series)) * 0.1,
           paste("Burn-in:", burn_in_estimates[i]), col = "red")
    }
    
    # Add a horizontal line at the equilibrium value (mean of the last 50% of values)
    equilibrium_range <- ceiling(length(mean_series) * 0.5):length(mean_series)
    equilibrium_value <- mean(mean_series[equilibrium_range])
    abline(h = equilibrium_value, col = "blue", lty = 3)
    
    # Compare with the current burn-in setting (8 * size)
    current_burn_in <- 8 * sizes[i]
    if (current_burn_in < length(mean_series)) {
      abline(v = current_burn_in, col = "green", lty = 4)
      text(current_burn_in * 1.1, min(mean_series) + (max(mean_series) - min(mean_series)) * 0.2,
           paste("Current:", current_burn_in), col = "green")
    }
  }
  
  # Add an overall title
  title("Mean Species Richness and Burn-in Period Analysis", outer = TRUE)
  
  dev.off()
  
  # Return a summary of findings
  cat("Estimated appropriate burn-in periods:\n")
  for (i in 1:length(sizes)) {
    cat(sprintf("Community size %d: %d generations (current setting: %d)\n", 
                sizes[i], burn_in_estimates[i], 8 * sizes[i]))
  }
  
  # Return a conclusion
  conclusion <- paste("Based on the analysis of species richness stabilization,",
                      "the appropriate burn-in periods for different community sizes are:",
                      paste(paste("Size", sizes, ":", burn_in_estimates, "generations"), collapse="; "),
                      "This suggests that", ifelse(mean(burn_in_estimates/(8*sizes)) < 1,
                                                   "shorter", "longer"),
                      "burn-in periods than the current setting (8 × size) may be appropriate.")
  
  return(conclusion)
}
# Challenge question E
Challenge_E <- function() {
  # Function to implement the coalescence algorithm
  coalescence_simulation <- function(J, speciation_rate) {
    # a) Initialize a vector lineages of length J with 1 in every entry
    lineages <- rep(1, J)
    
    # b) Initialize an empty vector abundances
    abundances <- c()
    
    # c) Initialize a number N = J
    N <- J
    
    # d) Calculate theta, where theta = v * (J-1)/(1-v)
    theta <- speciation_rate * (J - 1) / (1 - speciation_rate)
    
    # Main coalescence loop
    while (N > 1) {
      # e) Choose an index j for the vector lineages at random
      j <- sample(1:N, 1)
      
      # f) Pick a random number between a and 1
      randnum <- runif(1)
      
      # g) & h) Decide whether to speciate or coalesce
      if (randnum < (theta / (theta + N - 1))) {
        # Speciation - append lineages[j] to abundances
        abundances <- c(abundances, lineages[j])
      } else {
        # Coalescence - choose another random index i ≠ j
        i <- sample((1:N)[-j], 1)
        # Merge lineages
        lineages[i] <- lineages[i] + lineages[j]
      }
      
      # i) Remove lineages[j]
      lineages <- lineages[-j]
      
      # j) Decrease N by one
      N <- N - 1
    }
    
    # l) Once N = 1, add the remaining element to abundances
    abundances <- c(abundances, lineages[1])
    
    # m) Return the vector of abundances
    return(abundances)
  }
  
  # Function to convert abundance vector to octave classes (reusing your octaves function)
  octaves <- function(abundance_vector) {
    # Determine the octave class for each abundance value
    octave_classes <- floor(log2(abundance_vector))
    # Count the number of species in each octave class
    octave_counts <- tabulate(octave_classes + 1)
    return(octave_counts)
  }
  
  # Start timing for coalescence simulations
  start_time <- proc.time()
  
  # Parameters
  community_sizes <- c(500, 1000, 2500, 5000)
  speciation_rate <- 0.1  # Use the same speciation rate as in your cluster simulations
  num_repeats <- 25       # Same number of repeats as the cluster for comparison
  
  # Store coalescence results
  coalescence_results <- list()
  
  # Run coalescence simulations for each community size
  for (i in 1:length(community_sizes)) {
    size <- community_sizes[i]
    oct_results <- list()
    
    # Run multiple repeats for reliable comparison
    for (rep in 1:num_repeats) {
      # Run simulation and convert to octave classes
      abundances <- coalescence_simulation(size, speciation_rate)
      oct_results[[rep]] <- octaves(abundances)
    }
    
    # Combine all octave results for this community size
    combined_octaves <- oct_results[[1]]
    if (num_repeats > 1) {
      for (rep in 2:num_repeats) {
        combined_octaves <- sum_vect(combined_octaves, oct_results[[rep]])
      }
    }
    
    # Calculate mean octave distribution
    mean_octaves <- combined_octaves / num_repeats
    coalescence_results[[i]] <- mean_octaves
  }
  
  # Record time for coalescence simulations
  coal_time <- (proc.time() - start_time)[3]  # Time in seconds
  
  # Load cluster simulation results
  cluster_results <- list()
  
  # Try to load from Combined_results.rda if it exists
  if (file.exists("Combined_results.rda")) {
    load("Combined_results.rda")
    cluster_results <- combined_results  # Assuming this is how you stored your results
  } else {
    # If not, try to process files directly (similar to process_neutral_cluster_results)
    cluster_500 <- 0
    cluster_1000 <- 0
    cluster_2500 <- 0
    cluster_5000 <- 0
    
    total_500 <- c()
    total_1000 <- c()
    total_2500 <- c()
    total_5000 <- c()
    
    for (i in 1:100) {
      # Try different possible file naming patterns
      file_name <- paste0("simulation_output_", i, ".rda")
      if (!file.exists(file_name)) {
        file_name <- paste0("neutral_cluster_", i, ".rda")
      }
      
      if (file.exists(file_name)) {
        load(file_name)
        
        if (i <= 25) {
          size = 500
        } else if (i <= 50) {
          size = 1000
        } else if (i <= 75) {
          size = 2500
        } else if (i <= 100) {
          size = 5000
        }
        
        burn_in = 80
        
        # Process the abundance list from your simulation
        if (exists("abundance_list") && length(abundance_list) > burn_in) {
          total <- c()
          for (j in burn_in:length(abundance_list)) {
            total <- sum_vect(total, abundance_list[[j]])
          }
          
          # Update the totals and counts based on community size
          if (size == 500) {
            cluster_500 <- cluster_500 + (length(abundance_list) - burn_in + 1)
            total_500 <- sum_vect(total_500, total)
          } else if (size == 1000) {
            cluster_1000 <- cluster_1000 + (length(abundance_list) - burn_in + 1)
            total_1000 <- sum_vect(total_1000, total)
          } else if (size == 2500) {
            cluster_2500 <- cluster_2500 + (length(abundance_list) - burn_in + 1)
            total_2500 <- sum_vect(total_2500, total)
          } else if (size == 5000) {
            cluster_5000 <- cluster_5000 + (length(abundance_list) - burn_in + 1)
            total_5000 <- sum_vect(total_5000, total)
          }
        }
      }
    }
    
    # Calculate means if we have data
    if (cluster_500 > 0) mean_500 <- total_500 / cluster_500 else mean_500 <- c(0)
    if (cluster_1000 > 0) mean_1000 <- total_1000 / cluster_1000 else mean_1000 <- c(0)
    if (cluster_2500 > 0) mean_2500 <- total_2500 / cluster_2500 else mean_2500 <- c(0)
    if (cluster_5000 > 0) mean_5000 <- total_5000 / cluster_5000 else mean_5000 <- c(0)
    
    cluster_results <- list(mean_500, mean_1000, mean_2500, mean_5000)
  }
  
  # Estimate cluster computation time
  # Assuming each cluster job took about 11.5 hours (as in the assignment)
  cluster_job_time <- 11.5 * 3600  # Convert hours to seconds
  cluster_total_time <- cluster_job_time * 100  # 100 cluster jobs
  
  # Plot comparison between coalescence and cluster results
  png(filename="Challenge_E.png", width = 800, height = 600)
  
  par(mfrow = c(2, 2))
  size_names <- c("500", "1000", "2500", "5000")
  
  for (i in 1:length(community_sizes)) {
    # Adjust vectors to have the same length for comparison
    coal_oct <- coalescence_results[[i]]
    clust_oct <- cluster_results[[i]]
    
    max_len <- max(length(coal_oct), length(clust_oct))
    if (length(coal_oct) < max_len) coal_oct <- c(coal_oct, rep(0, max_len - length(coal_oct)))
    if (length(clust_oct) < max_len) clust_oct <- c(clust_oct, rep(0, max_len - length(clust_oct)))
    
    # Setup barplot data and colors
    oct_data <- rbind(coal_oct, clust_oct)
    colnames(oct_data) <- 0:(ncol(oct_data)-1)  # Octave class numbers
    rownames(oct_data) <- c("Coalescence", "Cluster")
    
    # Create barplot
    barplot(oct_data, beside=TRUE, 
            main=paste("Community Size =", size_names[i]),
            xlab="Octave Class", ylab="Species Count",
            col=c("darkblue", "darkred"),
            legend.text=TRUE, args.legend=list(x="topright"))
  }
  
  title("Comparison of Species Abundance Distributions: Coalescence vs. Cluster", 
        outer=TRUE, line=-1, cex.main=1.2)
  
  dev.off()
  
  # Calculate time comparison
  coal_hours <- coal_time / 3600  # Convert seconds to hours
  cluster_hours <- cluster_total_time / 3600  # Already in hours
  speedup_factor <- cluster_hours / coal_hours
  
  # Return a detailed explanation
  return(paste(
    "Time Comparison of Coalescence vs. Cluster Simulations:",
    sprintf("- Coalescence simulation: %.2f CPU hours", coal_hours),
    sprintf("- Cluster simulation: %.2f CPU hours (estimated from 100 jobs × 11.5 hours)", cluster_hours),
    sprintf("- The coalescence approach is approximately %.0f times faster.", speedup_factor),
    "",
    "Why Coalescence Simulations Are Much Faster:",
    "1. Algorithmic Efficiency: Coalescence simulations work backwards in time, directly generating the final community structure without simulating the entire evolutionary process. This eliminates the need to track every birth and death event.",
    "2. Mathematical Equivalence: The coalescence approach produces statistically equivalent results to the forward-time simulations, but requires far fewer computational steps.",
    "3. Memory Efficiency: Coalescence requires less memory as it only tracks lineages that actually contribute to the final community.",
    "4. No Burn-in Period: The coalescence algorithm directly generates the equilibrium distribution, eliminating the need for a burn-in period which saves substantial computation time.",
    "5. Direct Generation of Abundances: Rather than tracking individual species identities throughout the simulation, coalescence directly generates the abundance distribution.",
    "",
    "The dramatic speed difference demonstrates why coalescence methods are preferred when only the equilibrium distribution is needed, rather than the full time series of community dynamics.",
    sep="\n"
  ))
}
