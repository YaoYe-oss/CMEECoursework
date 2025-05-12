# Miniproject Feedback and Assessment

## Report

**"Guidelines" below refers to the MQB report [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) [here](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html) (which were provided to the students in advance).**

**Title:** “Mechanistic and Polynomial Models Exhibit Systematic Differences in Predicting Bacterial Growth Dynamics”

- **Introduction (15%)**  
  - **Score:** 12/15  
  - Context is laid out (lines 23–60), with some mention of research questions but somewhat brief. The [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) emphasize more explicit, clearly stated hypotheses.

- **Methods (15%)**  
  - **Score:** 11/15  
  - Data cleaning and subsetting are described (61–82). The rationale for choosing/initializing parameters is not very detailed; the [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) call for thorough justification of approach.

- **Results (20%)**  
  - **Score:** 14/20  
  - Highlights Gompertz for lag-phase data. Including numeric details or a tabular summary of model “wins” would align better with the [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report)' emphasis on explicit numeric results.

- **Tables/Figures (10%)**  
  - **Score:** 6/10  
  - The text references multiple visualizations, but they are not cited in detail. The [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report) call for explicit captions and references in the text.

- **Discussion (20%)**  
  - **Score:** 13/20  
  - Good interpretation regarding differences between polynomial and mechanistic fits, though limitations are not extensively covered.

- **Style/Structure (20%)**  
  - **Score:** 13/20  
  - Mostly clear writing. Some placeholder references remain. More consistent citing and referencing in text would strengthen alignment with [MQB Miniproject report guidelines](https://mulquabio.github.io/MQB/notebooks/Appendix-MiniProj.html#the-report).

**Summary:** A good report with a clear introduction and reasonably described methods. Greater numeric detail in the results and a more thorough parameter rationale, and deeper discussion would have improved reproducibility and clarity.

**Report Score:** 66  

---

## Computing

### Project Structure & Workflow

**Strengths**

* Modular R scripts: responsibilities are divided among `Data preparation.R` (cleaning & splitting), `Model fitting.R` (NLLS model fits), and `fitting_results_analysis.R` (AIC/BIC/R² summaries).

**Suggestions**

1. **Shell Script Robustness**:

   * Use `#!/usr/bin/env bash` and add `set -euo pipefail` at the top to detect errors and undefined variables early.
   * Prepend `cd "$(dirname "$0")"` so that relative paths resolve correctly regardless of where the script is invoked.
   * Redirect stdout/stderr into a timestamped log (`results/pipeline_$(date +"%Y%m%d_%H%M").log`) to capture runtime details.
   * Parameterize key directories (e.g. `--data-dir`, `--results-dir`) via `getopts` to avoid hard-coded paths.

2. **Reproducible Environments**:

   * Initialize an **renv** project in `code/`, commit `renv.lock`, and call `renv::restore()` at script start to lock package versions.
   * Document required system tools (e.g. LaTeX, BibTeX versions) in README.

---

### README File

**Strengths**

* Concise overview of models compared (Logistic, Gompertz, Quadratic, Cubic) and key findings.
* Clear instructions for running the analysis via the shell script .

**Suggestions**

1. Include a tree diagram showing raw data location (`data/`), code (`code/`), and outputs (`results/`).
2. Replace ad-hoc mention of `tidyverse`, `ggplot2`, `nlstools` with a pointer to `renv.lock` and `report.tex` dependencies (e.g. TeX Live packages).
3.  Add a LICENSE file and formally cite the source of `LogisticGrowthData.csv` under a “Data” section.
4. Note common errors (e.g. LaTeX compilation failures), pointing users to the log file.

---

## `Data preparation.R`

**Strengths**

* Uses **tidyverse** for filtering, transformation, and splitting into subsets.
* Generates per-ID CSVs, facilitating independent model fits.
* Provides exploratory visualizations (loess curves, boxplots) to inspect raw and transformed data.

**Suggestions**

1. Use `here::here('data','LogisticGrowthData.csv')` and `here::here('results','subsets')` to build portable paths instead of hard-coded `"../data"` or `"result/subsets"`.
2. Wrap cleaning and splitting logic into functions (e.g. `prepare_data()`, `save_subsets()`), and protect execution with `if (interactive())` or a `main()` guard.
3. Avoid spaces in script names (`Data preparation.R` vs `data_preparation.R`) and standardize casing to simplify shell invocation.
4. After filtering steps, report the number of rows/IDs retained vs dropped, and log warnings if any units or metadata are unexpected.
5. Use `fs::dir_create()` or check-and-create logic before writing subsets, ensuring idempotency.

---

## `Model fitting.R`

**Strengths**

* Calculates plausible starting points (`N_0`, `K`, `r_max`, `t_lag`) from data trends .
* Fits four NLS models via `tryCatch()`, returning a list for downstream evaluation.
* `plot_fits()` generates and saves per-subset fit plots automatically.

**Suggestions**

1. Abstract repeated `nls()` calls into a helper `fit_nls(formula, start, lower, upper)` that accepts arguments for each model, reducing copy-paste.
2. Use **nls.multstart** (or `nlsLM(lower=...,upper=...)`) to define parameter bounds and perform systematic multi-start sampling, capturing convergence info.
3. Replace the `for` loop over files with `purrr::map()` or `furrr::future_map()` over `list.files()`, collecting fits and results in a tibble rather than a nested list.
4. In `tryCatch`, capture both errors and warnings to a structured log (e.g. a CSV) with identifiers for post-run diagnostics.
5. Consider using `future.apply::future_lapply()` or `furrr` for cross-platform parallelization, rather than relying solely on single-threaded loops.

---

## Results Analysis (`fitting_results_analysis.R`)

**Strengths**

* Aggregates per-subset CSVs into a unified `all_results` table and computes success counts, AIC/BIC summaries, and best-model tallies .
* Implements R-squared calculation for “complete” subsets using a robust helper function.
* Outputs summary CSVs for easy downstream plotting or reporting.

**Suggestions**

1. Use `here::here('results','results')` and consistent directory names (`results/` vs `result/results/`) to avoid confusion.
2. Leverage tidy pipelines to combine reading, summarizing, and writing in fewer, more expressive `dplyr` chains, reducing intermediate variables.
3. Use `fs::dir_ls(glob = '*_results.csv')` rather than manual regex to find result files.
4. Convert summary tables to long format where appropriate (e.g. pivoting AIC and BIC into a single metric column) to simplify plotting downstream.
5. Share model definitions (e.g. logistic vs Gompertz functions) between this script and `Model fitting.R` by sourcing a common utility file.

---

## NLLS Fitting Approach

**Strengths**

* Data-driven parameter guesses improve convergence rates and biological relevance.
* Reporting AIC, BIC, and R² offers a multifaceted evaluation of fit quality.

**Suggestions**

1. Adopt **nls.multstart** for built-in multi-start, bound enforcement, and convergence diagnostics to replace manual `tryCatch` loops.
2. Use `nlsLM` (from **minpack.lm**) with explicit `lower` and `upper` bounds to prevent unrealistic parameter drift.
3. Implement leave-one-timepoint-out or k-fold CV to test predictive accuracy beyond in-sample criteria.
4. Compute Akaike weights (`AICcmodavg::Weights()`) to quantify relative model support, and visualize weight distributions across conditions.
5. Centralize all fitting outcomes—parameter estimates, convergence codes, runtime, warnings—into a master CSV for systematic audit and debugging.

---

### Overall Summary

Functional and well modularized pipeline. To further enhance reproducibility and maintainability:

* Lock dependencies with **renv** and standardize directory layout.
* Refactor repetitive code into generic helper functions and shared utility files.
* Leverage specialized libraries (**nls.multstart**, **minpack.lm**, **AICcmodavg**) for robust fitting and model selection.
* Introduce structured logging of fit diagnostics and outlier decisions to aid transparency.

### **Score: 63**

---

## Overall Score: 66+63/2 = 64.5