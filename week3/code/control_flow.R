a <- TRUE
if (a == TRUE) {
    print ("a is TRUE")
} else {
    print ("a is FALSE")
}
z <- runif(1) ## Generate a uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}

for (i in 1:10) {
    j <- i * i
    print(paste(i, " squared is", j ))
}

for(species in c('Heliodoxa rubinoides', 
                 'Boissonneaua jardini', 
                 'Sula nebouxii')) {
      print(paste('The species is', species))
}7

v1 <- c("a","bc","def")
for (i in v1) {
    print(i)
}

i <- 0
while (i < 10) {
    i <- i+1
    print(i^2)
}

i <- 0 #Initialize i
    while (i < Inf) {
        if (i == 10) {
            break 
        } else { # Break out of the while loop!  
            cat("i equals " , i , " \n")
            i <- i + 1 # Update i
    }
}

for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop 
  print(i)
}
