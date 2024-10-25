# using the maps package in R to do mapping 

# load the Global Population Dynamics Database(GPDD) which is available on TheMulQuaBio git repository
load("../data/GPDDFiltered.RData")

# load dependence packages
library(maps)
library(ggplot2)

# draw a world map
mp <- NULL
mapworld<-borders("world",colour = "gray50",fill="white")
mp <- ggplot() + mapworld + ylim(-60,90)

# create new values for latitude and longitude information of gpdd dataframe
long <- gpdd$long
lat <- gpdd$lat

# superimpose on the map all the locations from gpdd dataframe
mp2 <- mp + geom_point(data=gpdd, aes(x=long,y=lat, colour=common.name))

# draw the graphic without legend and store it in a pdf in result directory
pdf("../result/gpdd.pdf", 14, 7)
mp2 + theme(legend.position = "none")
graphics.off()

# expected bias based on the data represented:
# 1. species in America continent and European continent are different
# 2. species near the sea and inland are different
# 3. different species have their own distrubution pattern



