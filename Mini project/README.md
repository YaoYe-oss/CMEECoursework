# Bacterial Growth Modeling Project

## Overview
This project compares the performance of mechanistic models (Logistic and Gompertz) and polynomial models (Quadratic and Cubic) in predicting bacterial growth dynamics. The analysis is performed on a comprehensive dataset of bacterial growth measurements across different species and environmental conditions.

## Project Structure
- `code/` - Contains all R scripts for data processing and analysis
  - `Data preparation.R` - Cleans and prepares the dataset for modeling
  - `Model fitting.R` - Fits four different mathematical models to the growth data
  - `fitting_results_analysis.R` - Analyzes and compares model performance
  - `run-miniproject-script.sh` - Shell script to run the entire analysis pipeline
  - `report.tex` - LaTeX source for the final scientific report
- `data/` - Contains raw data files
  - `LogisticGrowthData.csv` - Main dataset with bacterial growth measurements
  - `LogisticGrowthMetaData.csv` - Metadata describing the main dataset columns
- `result/` - Contains generated outputs
  - `subsets/` - Individual CSV files for each unique experimental condition
  - `results/` - Model fitting results, plots, and statistical summaries


## Mathematical Models
Four different models are implemented and compared:
1. **Logistic Model** - Classic sigmoidal growth model
2. **Gompertz Model** - Flexible sigmoidal growth model with asymmetric shape
3. **Quadratic Model** - Second-order polynomial model
4. **Cubic Model** - Third-order polynomial model

## Key Findings
- The Gompertz model provided the best fit for bacterial growth curves with pronounced lag phases
- The Logistic model performed well for symmetrical growth patterns
- Polynomial models showed higher fitting success rates but lower biological relevance
- Mechanistic models consistently outperformed polynomial models in terms of AIC, BIC, and R²

## How to Run the Analysis
The entire analysis pipeline can be executed using the provided shell script:

```bash
cd code
bash run-miniproject-script.sh
```

This will:
1. Clean and prepare the data
2. Fit all four models to each subset
3. Generate comparative statistics and visualizations
4. Compile the final LaTeX report

## Requirements
- R (with packages: tidyverse, ggplot2, nlstools)
- LaTeX distribution (for report compilation)
- BibTeX (for bibliography management)

## Results
The analysis generates several key outputs:
- Individual growth curve plots with fitted models
- Statistical summaries of model performance
- Comprehensive scientific report (PDF)

## Report
The final report (`report.pdf`) provides a detailed discussion of:
- Background on bacterial growth dynamics
- Methodological approach to model fitting
- Comparative analysis of model performance
- Biological interpretation of results
- Limitations and future research directions
