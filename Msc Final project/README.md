# MSc Final Project — pH–Growth Rate Analysis

This project investigates **microbial growth rates across pH gradients** using curve fitting and parameter extraction.  
The analysis consists of two parts:  
1) Multi-model fitting and performance comparison.  
2) Extraction of biological parameters from fitted models.

---

## Project Structure

Msc Final project/
│
├─ code/ # R scripts
│ ├─ pH-growth rate results analysis.R
│ ├─ pH-growth rate parameters analysis.R
│ └─ .gitkeep
│
├─ data/ # Input data
│ ├─ pH-growth rate dataset.xlsx
│ └─ .gitkeep
│
├─ result/ # Suggested folder for plots/tables (outputs)
│ └─ (generated after running scripts)
│
└─ README.md


---

## Dataset

- **File**: `data/pH-growth rate dataset.xlsx`  
- **Key columns**:
  - `original id` – Sample/experiment identifier  
  - `standard trait value` – Growth rate measurement  
  - `second stressor value` – pH value  

> Preprocessing:  
> - Growth rates are normalized per sample (`max = 1`).  
> - Groups are assigned based on mean pH range:  
>   - `< 6.0 → Acidophile`  
>   - `> 7.5 → Alkaliphile`  
>   - Otherwise → `Neutrophile`.

---

## Models Used

- **Gaussian**:  
  \[
  \mu(pH) = \mu_{max}\,\exp\!\left(-\frac{(pH - pH_{opt})^2}{2\sigma^2}\right)
  \]

- **Brière** (for model comparison only):  
  \[
  a \cdot pH \cdot (pH-T_{min}) \cdot \sqrt{\max(T_{max}-pH,0)}
  \]

- **CPM** (Cardinal Parameter Model):  
  \[
  A_{max}\,\frac{(pH-pH_{min})(pH-pH_{max})}
  {(pH-pH_{min})(pH-pH_{max})-(pH-pH_{opt})^2}
  \]

- **Loess**: Non-parametric smoothing (for visualization).

---

## Scripts

### 1) `pH-growth rate results analysis.R`
**Purpose:** Fits Gaussian, Brière, and CPM models to each sample; compares performance using RMSE and AIC; includes Loess for visualization.  
**Main outputs**:
- Curve fitting plots (by sample and group: Acidophile, Neutrophile, Alkaliphile).  
- Model performance comparisons (RMSE, AIC).  
- Heatmaps and bar charts of best-fitting models.  
- Failure logs and summaries:  
  - `model_fit_failure_summary.csv`  
  - `model_fit_failure_details.csv`

### 2) `pH-growth rate parameters analysis.R`
**Purpose:** Extracts biological parameters from Gaussian and CPM models.  
**Parameters extracted**:
- `mu_max` – Maximum relative growth rate  
- `pHopt` – Optimal pH  
- `ToleranceWidth` – pH tolerance range  
  - Gaussian: `2*sigma`  
  - CPM: `pHmax - pHmin`  

**Main outputs**:
- Parameter distribution boxplots (mu_max, pHopt, ToleranceWidth).  
- Scatter plots of pHopt vs ToleranceWidth (per group, per model).  

---

## How to Run

### 1. Environment
- **R ≥ 4.0**
- Required packages:
  ```r
  install.packages(c("tidyverse", "minpack.lm", "patchwork", "readxl", "forcats"))
2. Running the scripts
Both scripts assume the working directory is code/ (because they read ../data/...).

From command line:
```r
cd "Msc Final project/code"
Rscript "pH-growth rate results analysis.R"
Rscript "pH-growth rate parameters analysis.R"
From R / RStudio:
```r
setwd("Msc Final project/code")
source("pH-growth rate results analysis.R")
source("pH-growth rate parameters analysis.R")
3. Outputs
CSV logs and plots are saved to the current working directory (default: code/).

To save in result/, update the scripts’ output paths (e.g., ../result/...).

4. Save plots manually
To export figures:
```r
ggsave("../result/figure_name.png", width = 9, height = 6, dpi = 300)
Reproducibility Notes
Each sample is normalized individually (relative growth rate).

CPM requires ≥ 4 distinct pH points and a pH span ≥ 0.75.

Model fitting failures are logged in CSV outputs.



