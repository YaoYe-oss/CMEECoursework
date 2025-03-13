#!/bin/bash
#PBS -lselect=1:ncpus=1:mem=4gb
#PBS -lwalltime=12:00:00
#PBS -J 1-100
#PBS -o $PBS_O_WORKDIR/neutral_sim.o$PBS_ARRAY_INDEX
#PBS -e $PBS_O_WORKDIR/neutral_sim.e$PBS_ARRAY_INDEX
#PBS -N neutral_sim

module load R

# Switch to the directory for submitting assignments
cd $PBS_O_WORKDIR

# Run Rscript
Rscript YaoYe_HPC_2024_neutral_cluster_run.R 

