# Week4 - README

## Overview
This repository contains the files for CMEECoursework Week 4. The coursework focuses on statistical modeling, data analysis, and visualization using R programming. The project uses various datasets and scripts to explore different biological and environmental problems.

## Project Structure
The repository includes the following key components:

### 1. Code

Florida.R: Script analyzing temperature data for Florida. This script utilizes statistical methods to explore trends in environmental data.

PP_Regress.R: A script for analyzing predator-prey relationships using linear regression. This script reads data from a CSV file and performs various regression analyses.

TreeHeight.R: A script to calculate tree heights based on trigonometric relationships, using input data provided in a CSV file.

### 2. Data

KeyWestAnnualMeanTemperature.Rdata: Contains annual mean temperature data for Key West, Florida.

Predator_Prey.csv: Dataset used for analyzing predator-prey dynamics in PP_Regress.R.

trees.csv: Contains data related to tree measurements, used in TreeHeight.R.

### 3. Results

The results from executing the scripts are typically visualized as plots or statistical summaries, which will be saved in this directory. These outputs help to understand the data trends and relationships identified by the analyses.

### 4. Sandbox

This directory is intended for experimentation, temporary scripts, or intermediary analysis steps that help in building and refining the main scripts.

## Languages and Dependencies

R Programming Language is used for the entire coursework.

### Dependencies: This project uses the following R libraries (please ensure they are installed before running the scripts):

ggplot2: For plotting and visualization.

dplyr: For data manipulation.

tidyr: For data tidying.

To install the required libraries, run the following command in your R environment:

install.packages(c("ggplot2", "dplyr", "tidyr"))

## Usage

Florida Temperature Analysis: To analyze the temperature trends in Key West, run the Florida.R script. The script loads the KeyWestAnnualMeanTemperature.Rdata file and produces summary statistics and plots.

source("Florida.R")

Predator-Prey Regression Analysis: The PP_Regress.R script analyzes relationships between predator and prey populations using the Predator_Prey.csv dataset.

source("PP_Regress.R")

Tree Height Calculation: To calculate tree heights based on distance and angle measurements, use the TreeHeight.R script, which takes the trees.csv dataset as input.

source("TreeHeight.R")

## Author and Contact

### Author: Yao Ye

### Contact: yy6024@ic.ac.uk


