# HPC Simulation Project

## Overview
This repository contains R code for running ecological simulations using High-Performance Computing (HPC) resources. The project includes two main simulation components:

1. **Demographic Model**: A stochastic and deterministic demographic population model
2. **Neutral Theory Model**: An individual-based ecological neutral theory simulation

## File Structure

### Core Scripts
- `Demographic.R` - Core functions for the demographic model
- `YaoYe_HPC_2024_main.R` - Main script containing core functions and analysis code
- `YaoYe_HPC_2024_demographic_cluster.R` - Script for running demographic simulations on HPC cluster
- `YaoYe_HPC_2024_neutral_cluster_run.R` - Script for running neutral model simulations on HPC cluster
- `submit_jobs.sh` - Shell script for submitting jobs to the HPC cluster

### Generated Output Files
- `stochastic_results_*.rda` - Results from stochastic demographic simulations
- `my_test_file_1.rda` - Test output from neutral model simulations
- `simulation_output_*.rda` - Results from neutral model simulations on the cluster

### Visualization Results
- `question_*.png` - Plots addressing specific questions in the assignment
- `Challenge_*.png` - Plots addressing challenge questions in the assignment
- `plot_neutral_cluster_results.png` - Visualization of neutral model cluster results

## Demographic Model

The demographic model simulates population growth under different initial conditions:
- Deterministic vs. stochastic approaches
- Different initial population distributions (all adults vs. spread across life stages)
- Various population sizes (10 vs. 100)

The model tracks:
- Population size over time
- Extinction rates
- Differences between deterministic and stochastic behavior

## Neutral Theory Model

The neutral model simulates ecological communities based on neutral theory principles:
- Random birth and death processes
- Optional speciation events
- Various community sizes (500, 1000, 2500, 5000)

This model examines:
- Species richness over time
- Species abundance distributions
- Effects of initial conditions
- Equilibrium properties

## HPC Implementation

The project utilizes High-Performance Computing (HPC) resources to run multiple simulations in parallel using job arrays. The `submit_jobs.sh` script handles job submission to the cluster, and output files are collected for post-processing and analysis.

## Analysis Visualizations

Various visualization files (PNG format) show:
- Population growth trajectories
- Species richness over time
- Extinction rates
- Species abundance distributions
- Burn-in period analysis
- Comparative analysis between different simulation approaches

## Challenge Questions

The repository also includes solutions to more complex challenge questions, exploring:
- Population trajectory visualization
- Dynamic equilibrium analysis
- Initial condition sensitivity
- Burn-in period optimization
- Coalescence vs. forward-time simulation efficiency

## Usage

1. Run `YaoYe_HPC_2024_main.R` locally for basic simulations and analysis
2. Use `submit_jobs.sh` to submit cluster jobs for large-scale simulations
3. Process output files with the analysis code in `YaoYe_HPC_2024_main.R`

## Author

Yao Ye (yy6024@imperial.ac.uk)
