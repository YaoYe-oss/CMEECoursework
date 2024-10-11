#!/bin/bash

# Check if three arguments are provided (two input files and one output file)
if [ $# -ne 3 ]; then
    echo "Error: Two input files and one output file are required."
    echo "Usage: $0 <file1> <file2> <output_file>"
    exit 1
fi

# Check if both input files exist
if [ ! -f "$1" ]; then
    echo "Error: First input file '$1' does not exist."
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "Error: Second input file '$2' does not exist."
    exit 1
fi

# Check if the output file already exists
if [ -f "$3" ]; then
    read -p "Output file '$3' already exists. Do you want to overwrite it? (y/n): " answer
    if [[ $answer != [Yy]* ]]; then
        echo "Operation cancelled."
        exit 1
    fi
fi

# Concatenate the two files into the output file
cat "$1" > "$3"
cat "$2" >> "$3"

echo "Merged File is:"
cat "$3"

echo "Files have been successfully merged into '$3'."
