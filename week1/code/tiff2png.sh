#!/bin/bash
# Author: Yao Ye yy6024@ic.ac.uk
# Script: tiff2png.sh
# Description: convert tiff file to png file
#
# Saves the output into a .png file
# Arguments: f -> tiff file
# Date: Oct 2024

for f in *.tiff;
    do 
        if [ -e $f ]
        then
            mv $f $(basename $f .tiff).tif;
            echo "Change the suffix of $f from .tiff to .tif"
        fi
    done

for f in *.tif; 
    do
        if [ -e $f ]
        then
            echo "Converting $f";
            convert "$f"  "$(basename "$f" .tif).png";
        else
            echo "There is no .tif file in the current directory"
        fi 
    done
