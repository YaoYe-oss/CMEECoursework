MSc Final Project: pH–Growth Rate Analysis
Project Structure
Msc Final project/
│── code/                # R scripts for data analysis
│   ├── pH-growth rate results analysis.R
│   ├── pH-growth rate parameters analysis.R
│   └── .gitkeep
│
│── data/                # Input dataset
│   ├── pH-growth rate dataset.xlsx
│   └── .gitkeep
│
│── result/              # Output results (plots, tables, statistics)
│   └── (generated after running scripts)
│
└── README.md            # Project documentation

Dataset

File: data/pH-growth rate dataset.xlsx

Contains experimental measurements of growth rates under different pH conditions.

Key columns used:

original id – Sample identifier

standard trait value – Growth rate measurement

second stressor value – pH value

Code Description
1. pH-growth rate results analysis.R

Purpose: Fits multiple mathematical models to growth rate vs pH curves and compares their performance.

Models included:

Gaussian model

Brière model

CPM model

Loess smoothing (for visualization)

Outputs:

Curve fitting plots by sample and group (Acidophile, Neutrophile, Alkaliphile)

Model performance comparisons (RMSE, AIC)

Heatmaps and bar charts of best-fitting models

Fitting failure summary (model_fit_failure_summary.csv, model_fit_failure_details.csv)

2. pH-growth rate parameters analysis.R

Purpose: Extracts and compares key biological parameters from fitted models.

Models included:

Gaussian model

CPM model

Parameters extracted:

μmax – Maximum relative growth rate

pHopt – Optimal pH value

Tolerance Width – Range of pH where growth is sustained

Outputs:

Boxplots of parameter distributions across groups

Scatter plots of pHopt vs Tolerance Width

Group-level comparisons (Acidophile, Neutrophile, Alkaliphile)

Results

Model fitting shows different performance across groups:

Gaussian and CPM models capture tolerance ranges well.

Loess provides smooth visualizations but lacks interpretability.

Parameter analysis highlights differences in pH tolerance and optima between groups.

How to Run

Ensure R (≥4.0) and required packages are installed:

install.packages(c("tidyverse", "minpack.lm", "patchwork", "readxl", "forcats"))


Place pH-growth rate dataset.xlsx inside the data/ folder.

Run scripts from the code/ directory:

source("pH-growth rate results analysis.R")
source("pH-growth rate parameters analysis.R")


Figures and CSV outputs will be saved in the result/ folder.

Notes

Scripts are written to be modular and reproducible.

If a model fails to converge, the error will be logged in the failure summary.

The dataset is normalized per sample before fitting.
