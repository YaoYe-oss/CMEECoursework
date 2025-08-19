# === Load necessary packages ===
library(tidyverse)
library(minpack.lm)
library(patchwork)
library(readxl)
library(forcats)

# === Read data ===
data <- read_excel("../data/pH-growth rate dataset.xlsx")

# === Clean and normalize ===
cleaned_data <- data %>%
  filter(!is.na(`standard trait value`), !is.na(`second stressor value`)) %>%
  mutate(
    growth_rate = as.numeric(`standard trait value`),
    pH = as.numeric(`second stressor value`),
    originalid = as.character(`original id`)
  ) %>%
  group_by(originalid) %>%
  mutate(
    growth_rate = growth_rate / max(growth_rate, na.rm = TRUE),
    group = case_when(
      mean(range(pH, na.rm = TRUE)) < 6.0 ~ "Acidophile",
      mean(range(pH, na.rm = TRUE)) > 7.5 ~ "Alkaliphile",
      TRUE ~ "Neutrophile"
    )
  ) %>%
  ungroup() %>%
  select(originalid, pH, growth_rate, group)

# === Model definition ===
gaussian_model <- function(pH, mu_max, pHopt, sigma) {
  mu_max * exp(-((pH - pHopt)^2) / (2 * sigma^2))
}

briere_model <- function(pH, a, Tmin, Tmax) {
  a * pH * (pH - Tmin) * sqrt(pmax(Tmax - pH, 0))
}

cpm_model <- function(pH, Amax, pHmin, pHopt, pHmax) {
  numerator <- (pH - pHmin) * (pH - pHmax)
  denominator <- numerator - (pH - pHopt)^2
  Amax * (numerator / denominator)
}

# === Fitting function ===
fit_model <- function(df, model_name) {
  pH_seq <- seq(min(df$pH), max(df$pH), length.out = 100)
  pred_df <- tibble(pH = pH_seq)
  
  tryCatch({
    fit <- switch(model_name,
                  "Gaussian" = nlsLM(growth_rate ~ gaussian_model(pH, mu_max, pHopt, sigma),
                                     data = df,
                                     start = list(mu_max = max(df$growth_rate, na.rm = TRUE),
                                                  pHopt = mean(df$pH), sigma = 1)),
                  
                  "Briere" = nlsLM(growth_rate ~ briere_model(pH, a, Tmin, Tmax),
                                   data = df,
                                   start = list(a = 0.01, Tmin = min(df$pH) - 0.5, Tmax = max(df$pH) + 0.5)),
                  
                  "CPM" = {
                    r <- range(df$pH)
                    span <- diff(r)
                    if (length(unique(df$pH)) < 4 || span < 0.75) stop("Too narrow pH range for CPM")
                    
                    start_vals <- list(
                      Amax = max(df$growth_rate, na.rm = TRUE),
                      pHmin = r[1] + 0.05 * span,
                      pHopt = mean(r),
                      pHmax = r[2] - 0.05 * span
                    )
                    
                    nlsLM(
                      growth_rate ~ cpm_model(pH, Amax, pHmin, pHopt, pHmax),
                      data = df,
                      start = start_vals,
                      lower = c(0, 4.0, 4.5, 5.5),
                      upper = c(2, 7, 8, 9)
                    )
                  }
    )
    
    pred_df$fitted <- predict(fit, newdata = pred_df)
    fitted_vals <- predict(fit, newdata = df)
    rmse <- sqrt(mean((df$growth_rate - fitted_vals)^2))
    aic <- AIC(fit)
    
    pred_df %>% mutate(
      originalid = df$originalid[1],
      model = model_name,
      RMSE = rmse,
      AIC = aic
    )
  }, error = function(e) {
    assign("fit_failures_log", c(get("fit_failures_log", envir = .GlobalEnv),
                                 paste(model_name, "failed for", df$originalid[1], ":", conditionMessage(e))),
           envir = .GlobalEnv)
    return(NULL)
  })
}

fit_failures_log <- c()

# === Loess fitting ===
fit_loess <- function(df) {
  pH_seq <- seq(min(df$pH), max(df$pH), length.out = 100)
  tryCatch({
    fit <- loess(growth_rate ~ pH, data = df, span = 0.75)
    tibble(
      pH = pH_seq,
      fitted = predict(fit, newdata = tibble(pH = pH_seq)),
      originalid = df$originalid[1],
      model = "Loess"
    )
  }, error = function(e) NULL)
}

# === Batch fitting execution ===
models <- c("Gaussian", "Briere", "CPM")

fit_all <- function(model_name) {
  cleaned_data %>%
    group_by(originalid) %>%
    group_split() %>%
    map_df(~fit_model(.x, model_name))
}

fit_loess_all <- function() {
  cleaned_data %>%
    group_by(originalid) %>%
    group_split() %>%
    map_df(fit_loess)
}

all_preds <- map_df(models, fit_all)
loess_preds <- fit_loess_all()

# === Add group information ===
group_info <- cleaned_data %>% select(originalid, group) %>% distinct()
all_preds <- all_preds %>% left_join(group_info, by = "originalid")
loess_preds <- loess_preds %>% left_join(group_info, by = "originalid")

# === Model evaluation ===
model_metrics <- all_preds %>%
  group_by(originalid, model) %>%
  summarise(RMSE = mean(RMSE), AIC = mean(AIC), .groups = "drop")

best_models_rmse <- model_metrics %>%
  group_by(originalid) %>%
  slice_min(RMSE, with_ties = FALSE)

best_models_aic <- model_metrics %>%
  filter(!is.na(AIC)) %>%
  group_by(originalid) %>%
  slice_min(AIC, with_ties = FALSE)

# === Fit the curve graph and divide it by group===
plot_fits_by_group <- function(group_type) {
  sub_preds <- all_preds %>% filter(group == group_type)
  sub_loess <- loess_preds %>% filter(group == group_type)
  sub_raw <- cleaned_data %>% filter(group == group_type)
  
  p <- ggplot() +
    geom_point(data = sub_raw, aes(pH, growth_rate), alpha = 0.5) +
    geom_line(data = bind_rows(sub_preds, sub_loess), aes(pH, fitted, color = model), linewidth = 1) +
    facet_wrap(~ originalid, scales = "free_y") +
    labs(title = paste0("Growth rate vs pH (", group_type, ")"), x = "pH", y = "Relative Growth") +
    theme_minimal()
  print(p)
}

unique(cleaned_data$group) %>% walk(plot_fits_by_group)

# === Model performance graph (updated:adding grouped Facet)===
plot_model_comparison <- function(metrics_df) {
  metrics_df <- metrics_df %>% left_join(group_info, by = "originalid")
  
  p1 <- ggplot(metrics_df, aes(x = model, y = RMSE, fill = model)) +
    geom_boxplot(alpha = 0.6, outlier.shape = NA) +
    geom_jitter(width = 0.2, size = 1, alpha = 0.4) +
    facet_wrap(~ group) +
    labs(title = "RMSE Comparison by Group", x = NULL, y = "RMSE") +
    theme_minimal()
  
  p2 <- ggplot(metrics_df %>% filter(!is.na(AIC)), aes(x = model, y = AIC, fill = model)) +
    geom_boxplot(alpha = 0.6, outlier.shape = NA) +
    geom_jitter(width = 0.2, size = 1, alpha = 0.4) +
    facet_wrap(~ group) +
    labs(title = "AIC Comparison by Group", x = NULL, y = "AIC") +
    theme_minimal()
  
  print(p1); print(p2)
}

# === heatmaps ===
plot_heatmap_grouped <- function(df, title) {
  df <- df %>% left_join(group_info, by = "originalid")
  ggplot(df, aes(x = model, y = fct_rev(originalid), fill = model)) +
    geom_tile(color = "white") +
    geom_text(aes(label = model), size = 3) +
    facet_wrap(~ group, scales = "free_y") +
    scale_fill_brewer(palette = "Set2") +
    labs(title = title, x = "Model", y = "Sample") +
    theme_minimal()
}

# === Bar chart ===
plot_best_model_bar <- function(df, title, split_by_group = TRUE) {
  df <- df %>% left_join(group_info, by = "originalid")
  p <- ggplot(df, aes(x = model, fill = model)) +
    geom_bar(position = "dodge") +
    labs(title = title, x = "Best Model", y = "Count") +
    scale_fill_brewer(palette = "Set2") +
    theme_minimal()
  
  if (split_by_group) p <- p + facet_wrap(~ group)
  print(p)
}

# === output all plots ===
plot_model_comparison(model_metrics)
plot_heatmap_grouped(best_models_rmse, "Best Model by RMSE")
plot_heatmap_grouped(best_models_aic, "Best Model by AIC")
plot_best_model_bar(best_models_rmse, "Best Model Count (RMSE)")
plot_best_model_bar(best_models_aic, "Best Model Count (AIC)")
plot_best_model_bar(best_models_rmse, "Overall Best Model Count (RMSE)", split_by_group = FALSE)
plot_best_model_bar(best_models_aic, "Overall Best Model Count (AIC)", split_by_group = FALSE)

# === Fitting failure statistics ===
# Split fit_failures_log into data boxes
fit_failure_df <- tibble(raw = fit_failures_log) %>%
  separate(raw, into = c("model", "rest"), sep = " failed for ", fill = "right") %>%
  separate(rest, into = c("originalid", "message"), sep = ":", fill = "right") %>%
  mutate(model = str_trim(model),
         originalid = str_trim(originalid),
         message = str_trim(message))

# === Count the number of failures in each model ===
failure_summary <- fit_failure_df %>%
  count(model, name = "fail_count") %>%
  arrange(desc(fail_count))

# === Display detailed information and summary of failures ===
print(failure_summary)
print(fit_failure_df)

# Export
write_csv(failure_summary, "model_fit_failure_summary.csv")
write_csv(fit_failure_df, "model_fit_failure_details.csv")
