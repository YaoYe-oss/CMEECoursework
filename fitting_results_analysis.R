# Load necessary libraries
library(dplyr)
library(tidyr)

# Read the model fitting results of all subsets
results_files <- list.files(path = "../result/results", pattern = "_results.csv", full.names = TRUE)
all_results <- lapply(results_files, read.csv) %>% bind_rows(.id = "Subset")

# Count the number of successful fits for each model
success_counts <- all_results %>%
  group_by(Model) %>%
  summarise(Success_Count = sum(!is.na(AIC)))

# Generate AIC and BIC statistical tables
summary_table <- all_results %>%
  group_by(Model) %>%
  summarise(
    Mean_AIC = mean(AIC, na.rm = TRUE),
    SD_AIC = sd(AIC, na.rm = TRUE),
    Mean_BIC = mean(BIC, na.rm = TRUE),
    SD_BIC = sd(BIC, na.rm = TRUE)
  )

# Statistically analyze the dataset where all four models have been successfully fitted
datasets_with_all_models <- all_results %>%
  group_by(Subset) %>%
  summarise(Complete_Fit = all(!is.na(AIC) & !is.na(BIC))) %>%
  filter(Complete_Fit) %>%
  pull(Subset)

num_complete_fit_datasets <- length(datasets_with_all_models)

# Compute best model based on AIC
best_model_aic <- all_results %>%
  filter(Subset %in% datasets_with_all_models) %>%
  group_by(Subset) %>%
  slice_min(AIC, n = 1, with_ties = FALSE) %>%
  count(Model) %>%
  group_by(Model) %>%
  summarise(Best_AIC_Count = sum(n))

# Compute best model based on BIC
best_model_bic <- all_results %>%
  filter(Subset %in% datasets_with_all_models) %>%
  group_by(Subset) %>%
  slice_min(BIC, n = 1, with_ties = FALSE) %>%
  count(Model) %>%
  group_by(Model) %>%
  summarise(Best_BIC_Count = sum(n))

# Merge AIC and BIC results
best_model_summary <- full_join(best_model_aic, best_model_bic, by = "Model")

# Replace NA values with 0
best_model_summary[is.na(best_model_summary)] <- 0

# ----- MODIFIED R-SQUARED CALCULATION SECTION -----

# Create a function to calculate R-squared for a subset and model
calculate_subset_r2 <- function(subset_file, model_name) {
  # Read the subset data
  subset_data <- tryCatch({
    read.csv(subset_file)
  }, error = function(e) {
    return(NULL)
  })
  
  if (is.null(subset_data) || nrow(subset_data) < 3 || 
      !all(c("Time", "logPopBio") %in% colnames(subset_data))) {
    return(NA)
  }
  
  # Define model functions (same as in Model fitting.R)
  logistic_model <- function(t, N_0, K, r) {
    return(K / (1 + ((K - N_0) / N_0) * exp(-r * (t - min(t)))))
  }
  
  gompertz_model <- function(t, N_0, K, r_max, t_lag) {
    return(N_0 + (K - N_0) * exp(-exp((r_max / (K - N_0)) * (t_lag - t) + 1)))
  }
  
  quadratic_model <- function(t, b0, b1, b2) {
    return(b0 + b1 * t + b2 * t^2)
  }
  
  cubic_model <- function(t, b0, b1, b2, b3) {
    return(b0 + b1 * t + b2 * t^2 + b3 * t^3)
  }
  
  # Calculate initial parameters
  init_params <- tryCatch({
    slopes <- diff(subset_data$logPopBio) / diff(subset_data$Time)
    max_slope_index <- which.max(slopes)
    N_0 <- min(subset_data$logPopBio)
    N_max <- max(subset_data$logPopBio)
    r_max <- max(slopes)
    t_lag <- subset_data$Time[max_slope_index] - (log(N_max / N_0) / r_max)
    
    list(N_0 = N_0, N_max = N_max, r_max = r_max, t_lag = t_lag)
  }, error = function(e) {
    list(N_0 = min(subset_data$logPopBio), 
         N_max = max(subset_data$logPopBio), 
         r_max = 0.1, 
         t_lag = min(subset_data$Time))
  })
  
  # Fit the specified model
  model_fit <- tryCatch({
    if (model_name == "Logistic") {
      nls(logPopBio ~ logistic_model(Time, N_0, K, r),
          data = subset_data, 
          start = list(N_0 = init_params$N_0, K = init_params$N_max, r = init_params$r_max),
          control = nls.control(maxiter = 1000))
    } else if (model_name == "Gompertz") {
      nls(logPopBio ~ gompertz_model(Time, N_0, K, r_max, t_lag),
          data = subset_data, 
          start = list(N_0 = init_params$N_0, K = init_params$N_max, 
                       r_max = init_params$r_max, t_lag = init_params$t_lag),
          control = nls.control(maxiter = 1000))
    } else if (model_name == "Quadratic") {
      nls(logPopBio ~ quadratic_model(Time, b0, b1, b2),
          data = subset_data, 
          start = list(b0 = 1, b1 = 1, b2 = 1),
          control = nls.control(maxiter = 1000))
    } else if (model_name == "Cubic") {
      nls(logPopBio ~ cubic_model(Time, b0, b1, b2, b3),
          data = subset_data, 
          start = list(b0 = 1, b1 = 1, b2 = 1, b3 = 1),
          control = nls.control(maxiter = 1000))
    } else {
      NULL
    }
  }, error = function(e) {
    NULL
  })
  
  # Calculate R-squared if model fitting was successful
  if (!is.null(model_fit)) {
    observed <- subset_data$logPopBio
    predicted <- predict(model_fit)
    residuals <- observed - predicted
    ss_res <- sum(residuals^2)
    ss_tot <- sum((observed - mean(observed))^2)
    return(1 - (ss_res / ss_tot))
  } else {
    return(NA)
  }
}

# Get only the subset files that correspond to the datasets where all models fit
subsets_dir <- "../result/subsets"
subset_files <- list.files(path = subsets_dir, pattern = ".csv", full.names = TRUE)

# Extract subset numbers from datasets_with_all_models and match with file names
subset_numbers <- as.numeric(datasets_with_all_models)
complete_subset_files <- subset_files[sapply(subset_numbers, function(num) {
  any(grepl(paste0("subset", num, ".csv"), subset_files))
})]

print(paste("Calculating R² for", length(complete_subset_files), "complete subsets"))

# Calculate R-squared values for only the complete subsets
model_names <- c("Logistic", "Gompertz", "Quadratic", "Cubic")
all_r2_values <- list()

for (model in model_names) {
  model_r2 <- numeric()
  for (file in complete_subset_files) {
    r2 <- calculate_subset_r2(file, model)
    if (!is.na(r2)) {
      model_r2 <- c(model_r2, r2)
    }
  }
  all_r2_values[[model]] <- model_r2
}

# Create the final R-squared table with Mean and SD
r_squared_table <- data.frame(
  Model = model_names,
  Mean_R2 = sapply(all_r2_values, mean),
  SD_R2 = sapply(all_r2_values, sd)
)

# ----- END OF MODIFIED SECTION -----

# Save statistical results
write.csv(success_counts, "../result/results/success_counts.csv", row.names = FALSE)
write.csv(summary_table, "../result/results/model_aic_bic_summary.csv", row.names = FALSE)
write.csv(best_model_summary, "../result/results/best_model_summary.csv", row.names = FALSE)
write.csv(data.frame(Datasets_with_all_models = num_complete_fit_datasets), "../result/results/complete_fit_count.csv", row.names = FALSE)
write.csv(r_squared_table, "../result/results/model_r_squared_summary.csv", row.names = FALSE)

# Print statistical results
print(success_counts)
print(summary_table)
print(paste("Number of datasets with all models fitting successfully:", num_complete_fit_datasets))
print(best_model_summary)
print(r_squared_table)

