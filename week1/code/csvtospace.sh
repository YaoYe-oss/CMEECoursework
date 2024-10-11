#!/bin/bash

# Set data directory
data_dir="../data"

# Check input parameters
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_file.csv>"
    exit 1
fi

# Get input filename
input_file=$1

# Check if file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist"
    exit 1
fi

# Check if file is CSV format
if [[ ${input_file##*.} != "csv" ]]; then
    echo "Error: '$input_file' is not a CSV file"
    exit 1
fi

# Create output filename
output_file="${input_file%.csv}_improved.csv"

# Convert CSV to space-separated file
awk -F'"' -v OFS='' '
{
    for (i=2; i<=NF; i+=2) {
        gsub(",", "§", $i)
    }
    gsub(",", "\t")
    gsub("§", ",")
    print
}' "$input_file" > "$output_file"

echo "Conversion complete: '$input_file' -> '$output_file'"
