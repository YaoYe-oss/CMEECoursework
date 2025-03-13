#!/bin/bash

#PBS -l walltime=01:00:00
#PBS -l select=1:ncpus=1:mem=1gb

# Load the correct R module
module load R

echo "R stochastic model is about to run."

# Copy necessary scripts to the temporary directory
cp /rds/general/user/yy6024/home/Demographic.R $TMPDIR
cp /rds/general/user/yy6024/home/YaoYe_HPC_2024_demographic_cluster.R $TMPDIR

# Change directory to TMPDIR
cd $TMPDIR

# Run the R script
R --vanilla < YaoYe_HPC_2024_demographic_cluster.R

# Ensure output directory exists
mkdir -p /rds/general/user/yy6024/home/output_files/

# Move output files to a safe directory
mv $TMPDIR/simulation_results* /rds/general/user/yy6024/home/output_files/ 2>/dev/null || echo "No output files found."

echo "R stochastic model has finished running."
