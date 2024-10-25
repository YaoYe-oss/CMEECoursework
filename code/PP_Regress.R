# draw and save a pdf file showing linear regression of 18 subsets (all 
# available Feeding Type * Predator life stage combination) of the data
# and calculate regression results exported to a formatted table in csv

# load the data from a csv file
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv", stringsAsFactors = FALSE)

# transform 2 character variables to factor variables
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
MyDF$Predator.lifestage <- as.factor(MyDF$Predator.lifestage)

# load ggplot2 to draw graphic
library(ggplot2)

# draw the linear regression and origin data point in a graphic and then export in pdf
pdf("../result/PP_Regress.pdf")
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,facets = Type.of.feeding.interaction ~.,colour = Predator.lifestage, 
      shape= I(3)) + geom_smooth(method = "lm", fullrange = TRUE) + theme(legend.position = "bottom")
graphics.off()

# load dplyr and tidyverse packages for the following regression results calculation
library(dplyr)
library(tidyverse)

# create a dataframe including different feeding type and predator life stage pairs (subset couldn't be empty)
allsubset <- MyDF %>% group_by(Type.of.feeding.interaction, Predator.lifestage) %>% count()
allsubset <- as.data.frame(allsubset[,1:2])

# create the colnames of another dataframe showing numeric variables of regression results
regression <- c("regression intercept", "regression slope", "R^2", "F-statistic value", "p-value")

# create new values including unique feeding types and predator life stage
feeding <- unique(MyDF$Type.of.feeding.interaction)
predlife <- unique(MyDF$Predator.lifestage)

# create subsets, do the linear regression and write regression results in the dataframe
for (i in sort(feeding)){
  subset1 <- subset(MyDF, Type.of.feeding.interaction == i)
  for (j in sort(predlife)){
    subset2 <- subset(subset1, Predator.lifestage == j)
    if (length(subset2$Predator.lifestage) != 0){
      model <- lm(log(Predator.mass)~log(Prey.mass), data=subset2)
      regression <- rbind(regression, c(coef(model),broom::glance(model)[[1]], broom::glance(model)[[4]], broom::glance(model)[[5]]))
    }
  }
}

# make the first row as column names
reg <- as.data.frame(regression[-1,])
colnames(reg) <- regression[1,]

# combine subset dataframe and regression numeric varials dataframe together
result <- cbind(allsubset, reg)
row.names(result) <- NULL

# export regression result into a csv file
write.csv(result, "../result/PP_Regress_Results.csv")

