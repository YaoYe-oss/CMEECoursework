#!/usr/bin/env Rscript

# This function calculates heights of trees given distance of each tree
# from its base and angle to its top, using the trigonometric formula
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees: The angle of elevation of tree
# distance: The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

# CLean your environment
rm(list = ls())
graphics.off()

# Function to calculate tree heights
TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)    
}

# Function to stop the execution
exit <- function() {
  .Internal(.invokeRestart(list(NULL, NULL), NULL))
}

# Get the file from the argument
argum <- commandArgs(trailingOnly = TRUE)

# Stops execution if no input is given
if (length(argum) == 0){
  print("You should input one file to run.")
  exit()
}

# Read the file
Trees <- read.csv(argum)

# Calculate tree height
Trees$Tree.Height.m  <- TreeHeight(Trees$Angle.degrees, Trees$Distance.m)

# Save results to a file with the same name in ../Results

## Spits name from relative paths
full_name <- strsplit(argum, "/")
name <- full_name[[1]][length(full_name[[1]])]

## Removes extension from filename
just_name <- tools::file_path_sans_ext(name)

## Uses it to name the result file
write.csv(Trees, paste("../result/", just_name,"_treeheights.csv", sep = ""), row.names = FALSE)