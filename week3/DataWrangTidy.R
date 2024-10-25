################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

# load the tidyverse package
require(tidyverse) 

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv",header = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

############# Inspect the dataset ###############
head(MyData) # show top 5 rows
dim(MyData)
dplyr::glimpse(MyData)
utils::View(MyData) #you can also do this
utils::View(MyMetaData)


############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)   # show top 5 rows
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############

?gather #check out the gather function

# use species as key and count as value, other 4 variables as other selected columns
MyWrangledData <- TempData %>% gather(key = "Species", value = "Count", -Cultivation, -Block, -Plot, -Quadrat)

# transform the new dataframe variables to specific class
MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

dplyr::glimpse(MyWrangledData)
slice(MyWrangledData, 1:5) # show top 5 rows
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############
