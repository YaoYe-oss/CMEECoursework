# draw and save 3 graphics relatively for distribution of log(Predator mass), log(Prey mass) and
# the size ratio of Prey mass over Predator mass, containing subplots by Type.of.feeding.interaction

# import the data
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv", stringsAsFactors = FALSE)

# change type of certain column to factor
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)

# subset the dataframe by type.of.feeding.interaction
insectivorous <- subset(MyDF,Type.of.feeding.interaction=="insectivorous")
piscivorous <- subset(MyDF,Type.of.feeding.interaction=="piscivorous")
planktivorous <- subset(MyDF,Type.of.feeding.interaction=="planktivorous")
predacious <- subset(MyDF,Type.of.feeding.interaction=="predacious")
predacious.piscivorous <- subset(MyDF,Type.of.feeding.interaction=="predacious/piscivorous")

# draw Pred_Subplots.pdf
pdf("../result/Pred_Subplots.pdf")
par(mfcol=c(5,1))
par(mfg = c(1,1))
hist(log(insectivorous$Predator.mass), xlab = "log(Predator Mass (g))", ylab = "Count", main = "insectivorous")
hist(log(piscivorous$Predator.mass), xlab = "log(Predator Mass (g))", ylab = "Count", main = "piscivorous")
hist(log(planktivorous$Predator.mass), xlab = "log(Predator Mass (g))", ylab = "Count", main = "planktivorous")
hist(log(predacious$Predator.mass), xlab = "log(Predator Mass (g))", ylab = "Count", main = "predacious")
hist(log(predacious.piscivorous$Predator.mass), xlab = "log(Predator Mass (g))", ylab = "Count", main = "predacious/piscivorous")
graphics.off()

# draw Prey_Subplots.pdf
pdf("../result/Prey_Subplots.pdf")
par(mfcol=c(5,1))
par(mfg = c(1,1))
hist(log(insectivorous$Prey.mass), xlab = "log(Prey Mass (g))", ylab = "Count", main = "insectivorous")
hist(log(piscivorous$Prey.mass), xlab = "log(Prey Mass (g))", ylab = "Count", main = "piscivorous")
hist(log(planktivorous$Prey.mass), xlab = "log(Prey Mass (g))", ylab = "Count", main = "planktivorous")
hist(log(predacious$Prey.mass), xlab = "log(Prey Mass (g))", ylab = "Count", main = "predacious")
hist(log(predacious.piscivorous$Prey.mass), xlab = "log(Prey Mass (g))", ylab = "Count", main = "predacious/piscivorous")
graphics.off()

# draw SizeRatio_Subplots.pdf
pdf("../result/SizeRatio_Subplots.pdf")
par(mfcol=c(5,1))
par(mfg = c(1,1))
hist(log(insectivorous$Prey.mass/insectivorous$Predator.mass), xlab = "log(Prey mass / Predator Mass)", ylab = "Count", main = "insectivorous")
hist(log(piscivorous$Prey.mass/piscivorous$Predator.mass), xlab = "log(Prey mass / Predator Mass)", ylab = "Count", main = "piscivorous")
hist(log(planktivorous$Prey.mass/planktivorous$Predator.mass), xlab = "log(Prey mass / Predator Mass)", ylab = "Count", main = "planktivorous")
hist(log(predacious$Prey.mass/predacious$Predator.mass), xlab = "log(Prey mass / Predator Mass)", ylab = "Count", main = "predacious")
hist(log(predacious.piscivorous$Prey.mass/predacious.piscivorous$Predator.mass), xlab = "log(Prey mass / Predator Mass)", ylab = "Count", main = "predacious/piscivorous")
graphics.off()


# calculating mean and median of log(predator mass), log(prey mass) and 
# ratio of prey mass over predator mass, then save them into a csv file

# calculate means and transform tapply results to dataframes
log.predmass.mean <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
log.predmass.mean <- as.data.frame(log.predmass.mean)
log.preymass.mean <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, mean)
log.preymass.mean <- as.data.frame(log.preymass.mean)
log.sizeratio.mean <- tapply(log(MyDF$Prey.mass/MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
log.sizeratio.mean <- as.data.frame(log.sizeratio.mean)

# calculate medians and transform tapply results to dataframes
log.predmass.median <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)
log.predmass.median <- as.data.frame(log.predmass.median)
log.preymass.median <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, median)
log.preymass.median <- as.data.frame(log.preymass.median)
log.sizeratio.median <- tapply(log(MyDF$Prey.mass/MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)
log.sizeratio.median <- as.data.frame(log.sizeratio.median)

# combine all of means and medians together, add feeding type as the first column
total <- cbind(log.predmass.mean, log.predmass.median, log.preymass.mean, log.preymass.median, 
               log.sizeratio.mean, log.sizeratio.median)
total <- cbind(Type.of.feeding.interaction=row.names(total),total)

# export means and medians to a csv file
write.csv(total, "../result/PP_Results.csv", row.names = F)


