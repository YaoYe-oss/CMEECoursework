#!/bin/bash
# Author: Yao Ye yy6024@ic.ac.uk
# Script: ConcatenateTwoFiles.sh
# Description: merge 2 files into a new file
#
# Saves the output into a new given name file
# Arguments: 1 -> input file; 2 -> input file; 3 -> output file
# Date: Oct 2024

if [ -n "$1" ]
then
  if [ -n "$2" ]
  then
      if [ -n "$3" ]
      then
          cat $1 > $3    #cat command can automaticcally report the error if the input file doesn't exist
          cat $2 >> $3
          echo "Merged File is"
          cat $3
      else
          echo "You should give the output file name"
      fi
    else
        echo "There is no second input file"
    fi
else
  echo "You should give 2 input files and the output file name"
fi 