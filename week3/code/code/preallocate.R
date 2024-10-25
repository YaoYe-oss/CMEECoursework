# an example shows pre-allocate a vector can make results faster

# a function using for loop that resizes vector repeatedly makes R re-allocate memory repeatedly
NoPreallocFun <- function(x){
  a <- vector()  # empty vector
  for (i in 1:x){
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}

# show system time of operating the non-preallocate function
system.time(NoPreallocFun(10))

# a function pre-allocate vector
PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}

# show system time of operating the preallocate function
system.time(PreallocFun(10))
