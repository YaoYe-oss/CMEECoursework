# ===============================
# Load Package
# ===============================
library(tidyverse)
library(minpack.lm)
library(readxl)

# ===============================
# Data reading and cleaning
# ===============================
data <- read_excel("../data/pH-growth rate dataset.xlsx")

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

group_info <- cleaned_data %>% select(originalid, group) %>% distinct()

# ===============================
# Model Definition
# ===============================
gaussian_model <- function(pH, mu_max, pHopt, sigma) {
  mu_max * exp(-((pH - pHopt)^2) / (2 * sigma^2))
}

cpm_model <- function(pH, Amax, pHmin, pHopt, pHmax) {
  numerator <- (pH - pHmin) * (pH - pHmax)
  denominator <- numerator - (pH - pHopt)^2
  Amax * (numerator / denominator)
}

# ===============================
# Gaussian  fitting
# ===============================
fit_gaussian <- function(df) {
  if (length(unique(df$pH)) < 4 || all(df$growth_rate == 0)) return(NULL)
  tryCatch({
    fit <- nlsLM(
      growth_rate ~ gaussian_model(pH, mu_max, pHopt, sigma),
      data = df,
      start = list(mu_max = max(df$growth_rate), pHopt = mean(df$pH), sigma = sd(df$pH)/2),
      control = nls.lm.control(maxiter = 500),
      lower = c(0.001, 3.0, 0.05), upper = c(10, 10, 5)
    )
    coef(fit) %>%
      as.list() %>%
      as_tibble() %>%
      mutate(ToleranceWidth = 2 * sigma, originalid = df$originalid[1]) %>%
      select(originalid, mu_max, pHopt, sigma, ToleranceWidth)
  }, error = function(e) NULL)
}

# ===============================
# CPM  fitting
# ===============================
fit_cpm <- function(df) {
  if (length(unique(df$pH)) < 4 || diff(range(df$pH)) < 0.75) return(NULL)
  tryCatch({
    r <- range(df$pH)
    span <- diff(r)
    fit <- nlsLM(
      growth_rate ~ cpm_model(pH, Amax, pHmin, pHopt, pHmax),
      data = df,
      start = list(
        Amax = max(df$growth_rate),
        pHmin = r[1] + 0.05 * span,
        pHopt = mean(df$pH),
        pHmax = r[2] - 0.05 * span
      ),
      lower = c(0, 4.0, 4.5, 5.5), upper = c(2, 7, 8, 9),
      control = nls.lm.control(maxiter = 500)
    )
    coef(fit) %>%
      as.list() %>%
      as_tibble() %>%
      mutate(ToleranceWidth = pHmax - pHmin, originalid = df$originalid[1]) %>%
      rename(mu_max = Amax) %>%
      select(originalid, mu_max, pHopt, ToleranceWidth)
  }, error = function(e) NULL)
}

# ===============================
# Batch  fitting
# ===============================
gaussian_results <- cleaned_data %>%
  group_by(originalid) %>%
  group_split() %>%
  map_df(fit_gaussian) %>%
  left_join(group_info, by = "originalid") %>%
  mutate(model = "Gaussian")

cpm_results <- cleaned_data %>%
  group_by(originalid) %>%
  group_split() %>%
  map_df(fit_cpm) %>%
  left_join(group_info, by = "originalid") %>%
  mutate(model = "CPM")

combined_results <- bind_rows(gaussian_results, cpm_results)

# ===============================
# Color settings
# ===============================
group_colors <- c(
  "Acidophile" = "#E69F00",
  "Neutrophile" = "#56B4E9",
  "Alkaliphile" = "#009E73"
)

# ===============================
# Boxplot function
# ===============================
plot_param_box <- function(df, model_name) {
  df_long <- df %>%
    pivot_longer(cols = c(mu_max, pHopt, ToleranceWidth),
                 names_to = "Parameter", values_to = "Value")
  
  ggplot(df_long, aes(x = group, y = Value, fill = group)) +
    geom_boxplot(alpha = 0.7) +
    facet_wrap(~ Parameter, scales = "free_y") +
    scale_fill_manual(values = group_colors) +
    labs(title = paste0(model_name, " Parameter distribution (grouping) "),
         x = "Group", y = "Parameter Value") +
    theme_minimal(base_size = 14)
}

# ===============================
# pHopt vs Tolerance Width
# ===============================
ggplot(combined_results, aes(x = pHopt, y = ToleranceWidth)) +
  geom_point(color = "gray70", alpha = 0.5) +
  geom_smooth(aes(color = group), method = "lm", se = TRUE, linewidth = 1) +
  facet_wrap(~ model) +
  scale_color_manual(values = group_colors) +
  labs(title = "pHopt vs Tolerance Width by Group and Model",
       x = "Optimal pH (pHopt)", y = "Tolerance Width") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "bottom")

# ===============================
# Output plots
# ===============================
plot_param_box(gaussian_results, "Gaussian")
plot_param_box(cpm_results, "CPM")
