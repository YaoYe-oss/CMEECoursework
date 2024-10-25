# autocorralation in weather, answering whether temperatures of one year are 
# signigicantly correlated with the next year, across years in a given location

# load data from a given RData
load("../data/KeyWestAnnualMeanTemperature.Rdata")

# create 2 temperature vector pair successive years temperature
temp <- ats$Temp
temp1 <- temp[-length(temp)]
temp2 <- temp[-1]

# calculate correlation between n-1 pairs of years, n is the total number of years
cor0 <- cor(temp1,temp2)

# define a function to permute time series randomly and calculate correlation
permute <- function(temp){
  sam <- sample(temp,length(temp),replace = F)
  temp1 <- sam[-length(sam)]
  temp2 <- sam[-1]
  return(cor(temp1, temp2))
}

# repeat permute time series10000 times and write correlation in result
result <- sapply(1:10000, function(i) permute(temp))

# filter correlation over original correlation cor0
over <- which(result > cor0)

# calculate approximate p-value
pvalue <- length(over)/10000

print("correlation coefficient is ")
print(cor0)
print("approximate p-value is ")
print(pvalue)
