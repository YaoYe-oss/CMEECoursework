#import csv

import sys

import doctest

import re

import os

import difflib

# Define function to check if the genus is close to 'quercus' using fuzzy matching
def is_an_oak(name):
    """
    Returns True if the name is close to 'quercus'
    
    >>> is_an_oak('Quercus')
    True
    >>> is_an_oak('quercus')
    True
    >>> is_an_oak('Querqus')
    True
    >>> is_an_oak('Pinus')
    False
    >>> is_an_oak('quercuz')
    True
    >>> is_an_oak('Betula')
    False
    
    """
    #cutoff=0.85 is the minimum similarity ratio required for a match to be considered.
    close_matches = difflib.get_close_matches(name.lower(), ['quercus'], n=1, cutoff=0.85)
    return len(close_matches) > 0
 
doctest.testmod()
 
def main(argv): 

    # Define the input and output file paths

    input_file = '../data/TestOaksData.csv'

    output_dir = '../results'

    output_file = os.path.join(output_dir, 'JustOaksData.csv')
 
    # Ensure the output directory exists

    os.makedirs(output_dir, exist_ok=True)
 
    # Use 'with' to handle files safely

    with open(input_file, 'r') as f, open(output_file, 'w', newline='') as g:

        taxa = csv.reader(f)

        csvwrite = csv.writer(g)
 
        # Write the header in the output file

        csvwrite.writerow(["Genus", "Species"])
 
        # Process the rows and check for oaks

        for row in taxa: 

            # Check if the first row is the header

            if row[0].lower() == "genus" and row[1].lower() == "species":

                print("Skipping header row")

                continue  # Skip processing the header row
 
            print(row)

            print("The genus is: ")

            print(row[0] + '\n')
 
            if is_an_oak(row[0].strip()):

                print('FOUND AN OAK!\n')

                csvwrite.writerow([row[0].strip(), row[1]])  # Write genus and species if it's an oak
 
    return 0

if __name__ == "__main__":

    status = main(sys.argv)

    sys.exit(status)

 
 
