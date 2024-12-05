#!/bin/bash
# Author: Yao Ye yy6024@ic.ac.uk
# Script: CountLines.sh
# Description: count the number of lines of the input file
#
# print the outcome on the screen
# Arguments: 1 -> input file
# Date: Oct 2024

if [ -n "$1" ]    # please give a relative path to $1 when use this shell script 
then
    NumLines=`wc -l < $1`
    echo "The file $1 has $NumLines lines"
    echo
else
    echo "There is no input file"
fi 