
MyFunction <- function(Arg1, Arg2) {
  
  print(paste("Argument", as.character(Arg1), "is a", class(Arg1))) # print Arg1's type
  print(paste("Argument", as.character(Arg2), "is a", class(Arg2))) # print Arg2's type
    
  return (c(Arg1, Arg2)) 

MyFunction(1,2) 
MyFunction("Riki","Tiki") 

is.even <- function(n = 2) {
  if (n %% 2 == 0) {
    return(paste(n,'is even!'))
  } else {
  return(paste(n,'is odd!'))
  }
} }

is.even(6)

is.power2 <- function(n = 2) {
  if (log2(n) %% 1==0) {
    return(paste(n, 'is a power of 2!'))
  } else {
  return(paste(n,'is not a power of 2!'))
    }
}
``
is.power2(4)

# Checks if a number is prime
is.prime <- function(n) {
  if (n==0) {
    return(paste(n,'is a zero!'))
  } else if (n==1) {
    return(paste(n,'is just a unit!'))
  }
    
  ints <- 2:(n-1)
  
  if (all(n%%ints!=0)) {
    return(paste(n,'is a prime!'))
  } else {
  return(paste(n,'is a composite!'))
    }
}

is.prime(3)