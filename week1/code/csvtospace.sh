#!/bin/bash
# Author: Yao Ye yy6024@ic.ac.uk
# Script: csvtospace.sh
# Description: substitute the commas in the files with spaces
#
# Saves the output into a .txt file
# Arguments: 1 -> comma delimited file
# Date: Oct 2024

if [ -n "$1" ]    # please give a relative path to $1 when use this shell script 
then
    if [ -e $1 ]
    then
        if [ $(grep -o "," $1 | wc -l) != 0 ]
        then
            echo "Creating a space delimited version of $1 ..."
            cat $1 | tr -s "," " " >> $1.txt
            echo "Done!"
        else
            echo "$1 is not a comma delimited file"
        fi
    else
        echo "$1 does not exist"
    fi
else 
   echo "There is no input file"
fi 