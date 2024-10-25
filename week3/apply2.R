# use apply to define your own functions

# define a function
SomeOperation <- function(v){ 
  if (sum(v) > 0){
    return(v * 100)
  }
  return(v)
}

# create a matrix
M <- matrix(rnorm(100),10,10)

# print result of defined function applied to matrix
print(apply(M, 1, SomeOperation))