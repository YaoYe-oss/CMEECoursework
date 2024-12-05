# Clear the workspace
rm(list = ls())

# Import necessary libraries
library(ggplot2)
library(dplyr)

# Load the data
data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Convert masses from mg to g
data <- data %>%
  mutate(Prey.mass = ifelse(Prey.mass.unit == "mg", Prey.mass / 1000, Prey.mass),
         Prey.mass.unit = "g")

# Create PDF to save the plot
pdf("../results/PP_Regress.pdf", width = 9, height = 12)

# Plot predator and prey mass by feeding type and predator lifestage
p <- ggplot(data, aes(x = Prey.mass, y = Predator.mass, color = Predator.lifestage)) +
  geom_point(shape = 3) +
  geom_smooth(method = "lm", formula = y ~ x, fullrange = TRUE, na.rm = TRUE) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Prey mass in grams") +
  ylab("Predator mass in grams") +
  facet_grid(Type.of.feeding.interaction ~ .) +
  theme_bw() +
  theme(legend.position = "bottom",
        panel.border = element_rect(colour = "grey", fill = NA),
        legend.title = element_text(size = 9, face = "bold")) +
  guides(colour = guide_legend(nrow = 1)
  )

print(p)

# Close the PDF device
graphics.off()

# Calculate regression results corresponding to the lines fitted in the figure
LM <- data %>%
  # Remove subset that contains only 2 examples, both with the same species of prey and predator
  filter(Record.number != "30914" & Record.number != "30929") %>%
  # Subset only the data needed and group by feeding type and predator lifestage
  dplyr::select(Record.number, Predator.mass, Prey.mass, Predator.lifestage, Type.of.feeding.interaction) %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  # Perform linear model calculations and store specific values as columns in the dataframe
  do(mod = lm(Predator.mass ~ Prey.mass, data = .)) %>%
  mutate(
    Regression.slope = summary(mod)$coefficients[2, 1],
    Regression.intercept = summary(mod)$coefficients[1, 1],
    R.squared = summary(mod)$adj.r.squared,
    Fstatistic = summary(mod)$fstatistic[1],
    P.value = summary(mod)$coefficients[2, 4]
  ) %>%
  dplyr::select(-mod)

# Save regression results to CSV
write.csv(LM, "../results/PP_Regress_Results.csv", row.names = FALSE)


 