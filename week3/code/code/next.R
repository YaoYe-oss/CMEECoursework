# a control flow tool, next, is used to skip to next iteration of a loop

for (i in 1:10){
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop
  print(i)
}