#!/bin/bash

#Author: yy6024@ic.ac.uk
#Script: run_Vectorise.sh
#Desc: Runs and times the different Vectorise scripts in R and python
#Date: Oct 2024

python3 Vectorize1.py

python3 Vectorize2.py

Rscript Vectorize1.R

Rscript Vectorize2.R

#exit
