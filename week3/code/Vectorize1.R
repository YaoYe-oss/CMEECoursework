# an example illustrating that vectorization can optimize code computational efficiency 
# and make code more concise, easy to read, less prone

# create a matrix
M <- matrix(runif(1000000),1000,1000)

# create a function to calculate sum of numbers by loops
SumAllElements <- function(M){
  Dimensions <-dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]) {
      Tot <- Tot + M[i,j]
    }
  }
  return(Tot)
}

# compare system time taken to operating vectorized function and non-vectorized function
print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))
