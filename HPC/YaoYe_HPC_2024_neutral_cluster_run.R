# CMEE 2024 HPC exercises R code pro forma
# For neutral model cluster run

# Clear workspace
rm(list=ls())
graphics.off()

# Load necessary functions
source("YaoYe_HPC_2024_main.R")  # Change this to match your filename

# Print start message
print("Starting simulation script...")
flush.console()

# Get job ID from cluster environment
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Set seed for reproducibility
set.seed(iter)

# Assign community sizes to jobs
if (iter <= 25) {
  size <- 500
} else if (iter <= 50) {
  size <- 1000
} else if (iter <= 75) {
  size <- 2500
} else {
  size <- 5000
}

# Define speciation rate (replace with your assigned value)
speciation_rate <- 0.1

# Set file name for output
output_file_name <- paste("simulation_output_", iter, ".rda", sep="")

# Print debug info
print(paste("Job ID:", iter, " | Community size:", size))
flush.console()

print("Calling neutral_cluster_run function...")
flush.console()

# Run the neutral cluster simulation
neutral_cluster_run(
  speciation_rate = speciation_rate,
  size = size,
  wall_time = 690,  # 11.5 hours
  interval_rich = 1,
  interval_oct = size / 10,
  burn_in_generations = 8 * size,
  output_file_name = output_file_name
)

# Print completion message
print("Simulation completed successfully.")
flush.console()

# Check if file was saved
print(paste("Results saved in:", output_file_name))
flush.console()


