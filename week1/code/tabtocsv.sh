#!/bin/sh
# Author: yy6024@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2024

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit

# Check if an input file is provided
if [ $# -eq 0 ]; then
    echo "Error: No input file provided."
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist."
    exit 1
fi

# Convert tab-separated file to CSV
sed 's/\t/,/g' "$1"
