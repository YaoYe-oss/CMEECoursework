library(ggplot2)
library(nlstools)

# Calculate the dynamic initial value
calculate_init_params <- function(time, popbio) {
  slopes <- diff(popbio) / diff(time)
  max_slope_index <- which.max(slopes)
  N_0 <- min(popbio)
  N_max <- max(popbio)
  r_max <- max(slopes)
  t_lag <- time[max_slope_index] - (log(N_max / N_0) / r_max)  
  
  return(list(N_0 = N_0, N_max = N_max, r_max = r_max, t_lag = t_lag))
}

# Define four models
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

# Batch fitting of four models
fit_models <- function(data) {
  init_params <- calculate_init_params(data$Time, data$logPopBio)
  
  logistic_fit <- tryCatch({
    nls(logPopBio ~ logistic_model(Time, N_0, K, r),
        data = data, start = list(N_0 = init_params$N_0, K = init_params$N_max, r = init_params$r_max),
        control = nls.control(maxiter = 1000))
  }, error = function(e) return(NULL))
  
  gompertz_fit <- tryCatch({
    nls(logPopBio ~ gompertz_model(Time, N_0, K, r_max, t_lag),
        data = data, start = list(N_0 = init_params$N_0, K = init_params$N_max, r_max = init_params$r_max, t_lag = init_params$t_lag),
        control = nls.control(maxiter = 1000))
  }, error = function(e) return(NULL))
  
  quadratic_fit <- tryCatch({
    nls(logPopBio ~ quadratic_model(Time, b0, b1, b2),
        data = data, start = list(b0 = 1, b1 = 1, b2 = 1),
        control = nls.control(maxiter = 1000))
  }, error = function(e) return(NULL))
  
  cubic_fit <- tryCatch({
    nls(logPopBio ~ cubic_model(Time, b0, b1, b2, b3),
        data = data, start = list(b0 = 1, b1 = 1, b2 = 1, b3 = 1),
        control = nls.control(maxiter = 1000))
  }, error = function(e) return(NULL))
  
  return(list(logistic = logistic_fit, gompertz = gompertz_fit, quadratic = quadratic_fit, cubic = cubic_fit))
}

# evaluate model
evaluate_models <- function(models) {
  evaluate <- function(model) {
    if (!is.null(model)) return(c(AIC(model), BIC(model), summary(model)$r.squared)) else return(c(NA, NA, NA))
  }
  
  results <- data.frame(
    Model = c("Logistic", "Gompertz", "Quadratic", "Cubic"),
    AIC = c(evaluate(models$logistic)[1], evaluate(models$gompertz)[1], evaluate(models$quadratic)[1], evaluate(models$cubic)[1]),
    BIC = c(evaluate(models$logistic)[2], evaluate(models$gompertz)[2], evaluate(models$quadratic)[2], evaluate(models$cubic)[2]),
    R2 = c(evaluate(models$logistic)[3], evaluate(models$gompertz)[3], evaluate(models$quadratic)[3], evaluate(models$cubic)[3])
  )
  
  return(results)
}

# Count the number of successful fitting attempts
count_successful_fits <- function(models_list) {
  model_names <- c("Logistic", "Gompertz", "Quadratic", "Cubic")
  success_counts <- sapply(model_names, function(model) sum(sapply(models_list, function(m) !is.null(m[[model]]))))
  return(data.frame(Model = model_names, Success_Count = success_counts))
}

# Draw a fitting curve
plot_fits <- function(models, data, file_name) {
  time_seq <- seq(min(data$Time), max(data$Time), length.out = 100)
  
  get_predictions <- function(model, time_seq) {
    if (!is.null(model)) return(predict(model, newdata = list(Time = time_seq))) else return(rep(NA, length(time_seq)))
  }
  
  plot_data <- data.frame(
    Time = rep(time_seq, 4),
    logPopBio = c(get_predictions(models$logistic, time_seq),
                  get_predictions(models$gompertz, time_seq),
                  get_predictions(models$quadratic, time_seq),
                  get_predictions(models$cubic, time_seq)),
    Model = rep(c("Logistic", "Gompertz", "Quadratic", "Cubic"), each = length(time_seq))
  )
  
  plot_data <- na.omit(plot_data) 
  
  p <- ggplot(data, aes(x = Time, y = logPopBio)) +
    geom_point(color = "black", size = 2) +
    geom_line(data = plot_data, aes(x = Time, y = logPopBio, color = Model), linewidth = 1) +
    labs(title = paste("Model Fitting:", file_name), x = "Time", y = "log(PopBio)") +
    theme_minimal()
  
  ggsave(filename = file_name, plot = p, width = 6, height = 4, dpi = 300)
}

# Process all sub datasets
subsets_dir <- "../result/subsets"
results_dir <- "../result/results"

if (!dir.exists(results_dir)) dir.create(results_dir)

file_list <- list.files(subsets_dir, full.names = TRUE)

all_models <- list()

for (file in file_list) {
  data <- tryCatch({ read.csv(file) }, error = function(e) return(NULL))
  if (is.null(data) || nrow(data) == 0) next
  
  models <- fit_models(data)
  all_models[[file]] <- models
  results <- evaluate_models(models)
  
  result_file <- paste0(results_dir, "/", basename(file), "_results.csv")
  write.csv(results, result_file, row.names = FALSE)
  
  plot_file <- paste0(results_dir, "/", basename(file), "_plot.png")
  plot_fits(models, data, plot_file)
  
  print(paste("Processed:", file))
}

# Count the number of successful fits for all models
success_counts <- count_successful_fits(all_models)
write.csv(success_counts, paste0(results_dir, "/success_counts.csv"), row.names = FALSE)

print("All data processing completed!")

