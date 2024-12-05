#!/bin/bash
# Author: Yao Ye yy6024@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2024

if [ -n "$1" ]    # please give a relative path to $1 when use this shell script 
then
    if [ -e $1 ]
    then
        if [ $(grep -o "\t" $1 | wc -l) != 0 ]
        then
            echo "Creating a comma delimited version of $1 ..."
            cat $1 | tr -s "\t" "," >> $1.csv
            echo "Done!"
        else
            echo "$1 is not a tab delimited file"
        fi
    else
        echo "$1 does not exist"
    fi
else 
   echo "There is no input file"
fi 