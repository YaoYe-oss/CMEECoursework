# 1.Clean the dataset
# Load necessary libraries
library(tidyverse)

# === Data Loading ===
# Read the CSV files
data <- read.csv("../data/LogisticGrowthData.csv")
meta_data <- read.csv("../data/LogisticGrowthMetaData.csv")

# Print basic data information
print(paste("Loaded", ncol(data), "columns."))
print(colnames(data))
head(data)

# Check unique values for PopBio_units and Time_units
print(unique(data$PopBio_units))  # Units of the response variable
print(unique(data$Time_units))  # Units of the independent variable

# === Data Cleaning ===
# Convert Time column to numeric and remove invalid values
data$Time <- as.numeric(data$Time)  # Convert to numeric
data <- data %>% filter(!is.na(Time) & Time > 0)  # Remove missing and negative values

# Convert PopBio column to numeric and remove invalid values
data$PopBio <- as.numeric(data$PopBio)  # Convert to numeric
data <- data %>% filter(!is.na(PopBio) & PopBio > 0)  # Remove missing and non-positive values

# === Feature Engineering ===
# Create a new column for the log-transformed population size
data <- data %>% mutate(logPopBio = log(PopBio))

# Generate a unique ID based on Species, Temp, Medium, and Citation
data <- data %>%
  mutate(ID = paste(Species, Temp, Medium, Citation, sep = "_"))

# Print the number of unique datasets
print(paste("The number of unique datasets is:", length(unique(data$ID))))

# === Data Splitting ===
# Create a directory for subsets if it does not exist
if (!dir.exists("result/subsets")) {
  dir.create("result/subsets", recursive = TRUE)
}

# Split data into subsets based on unique IDs and save each as a CSV file
split_data <- split(data, data$ID)
for (i in seq_along(split_data)) {
  write.csv(split_data[[i]], file = paste0("result/subsets/subset", i, ".csv"), row.names = FALSE)
}

# Check if there are any remaining missing values in the cleaned dataset
print(any(is.na(data)))

# 2.visualise the dataset
library(ggplot2)

# Population growth curve
ggplot(data, aes(x = Time, y = PopBio, color = Species)) +
  geom_point(alpha = 0.5) +  # Scatter plot for raw data
  geom_smooth(method = "loess", se = FALSE) + # Smoothed trend line
  labs(title = "Population Growth Over Time",
       x = "Time",
       y = "Population Size (PopBio)") +
  theme_minimal()

# Draw logPopBio to view growth trends
ggplot(data, aes(x = Time, y = logPopBio, color = Species)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Log-Transformed Population Growth",
       x = "Time",
       y = "Log(PopBio)") +
  theme_minimal()

# The Effect of Temperature on Growth
ggplot(data, aes(x = Temp, y = PopBio, color = Species)) +
  geom_jitter(alpha = 0.5) +  # Add jitter to avoid overlapping points
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Effect of Temperature on Population Growth",
       x = "Temperature (°C)",
       y = "Population Size (PopBio)") +
  theme_minimal()

# Growth conditions under different media
ggplot(data, aes(x = Medium, y = PopBio, fill = Medium)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Population Growth in Different Mediums",
       x = "Growth Medium",
       y = "Population Size (PopBio)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# The interaction between temperature and time
ggplot(data, aes(x = Time, y = PopBio, color = as.factor(Temp))) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Interaction Between Time and Temperature",
       x = "Time",
       y = "Population Size (PopBio)",
       color = "Temperature (°C)") +
  theme_minimal()

# Growth differences between species
ggplot(data, aes(x = Species, y = PopBio, fill = Species)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Growth Comparison Between Species",
       x = "Species",
       y = "Population Size (PopBio)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



