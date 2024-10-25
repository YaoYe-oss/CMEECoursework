#!/bin/bash

#Author: yy6024@ic.ac.uk
#Script: run_get_TreeHeight.sh
#Desc: Runs the get_TreeHeights.R  and the get_TreeHeight.py scripts with the file trees.csv from the Data directory as arguement
#Date: Oct 2024

Rscript get_TreeHeight.R ../data/trees.csv 
python3 get_TreeHeight.py ../data/trees.csv

#exit