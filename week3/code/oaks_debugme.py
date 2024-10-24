#!/usr/bin/env python3
"""
Purpose:
The goal of the script is to filter and save only the relevant rows where the genus is recognized as "Quercus" or a close match.

Inputs:
CSV file located at '../data/TestOaksData.csv'. The file is expected to contain two columns: 'Genus' and 'Species'. If a row's 
genus is recognized as 'Quercus' or a close match, that row is written to the output file.

Outputs:
CSV file saved at '../results/JustOaksData.csv'. This file contains only the rows where the genus is 'Quercus' or a close match 
(based on fuzzy matching), and it includes a header ('Genus', 'Species').

__author__ = Your name  (      @ic.ac.uk)

"""
import csv
import sys
import difflib
import os
import doctest  
 
# Define function to check if the genus is close to 'quercus' using fuzzy matching

def is_an_oak(name):

    """
    - Purpose: Uses fuzzy matching to check if the genus name is a close match to 'Quercus'.
    - Input: A string representing the genus name.
    - Output: Returns True if the genus is recognized as 'Quercus' (or close enough), otherwise False.
 
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

    close_matches = difflib.get_close_matches(name.lower(), ['quercus'], n=1, cutoff=0.85)
    return len(close_matches) > 0
 
def is_header(row):

    """
    - Purpose: Checks if the given row is a header (contains 'Genus' and 'Species').
    - Input: A list representing a row from the TestOaksData.csv
    - Output: Returns True if the row is recognized as a header, otherwise False.

    """

    return row[0].lower() == 'genus' and 'species' in row[1].lower()

#Define a main function
 
def main(argv):
    """
    - Purpose: Main function that processes the input CSV file, filters the rows where the genus is 
      'Quercus' or a close match, and writes these rows to the output file.
    - Input: Command-line arguments (not used in this version, but can be extended to accept file paths).
    - Output: Writes a new CSV file(JustOaksData.csv) with the filtered data ('Genus' and 'Species' columns), 
      and returns 0 on success or 1 on error.

    """
    # Define input and output file paths

    input_file = '../data/TestOaksData.csv'
    output_file = '../results/JustOaksData.csv'

    # Check if the input file exists

    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' does not exist.")
        return 1

    # Ensure the output directory exists

    output_dir = os.path.dirname(output_file)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    try:

        # Open the input file in read mode and the output file in write mode

        with open(input_file, 'r', encoding='utf-8') as f, open(output_file, 'w', newline='', encoding='utf-8') as g:
            taxa = csv.reader(f)
            csvwrite = csv.writer(g)

            # Read the first row and check if it's a header

            first_row = next(taxa)
            if not is_header(first_row):

                # If it's not a header, write header to output and process it like a normal data row

                csvwrite.writerow(['Genus', 'Species'])
                print(first_row)
                print("The genus is:")
                print(first_row[0] + '\n')
                if is_an_oak(first_row[0]):
                    print('FOUND AN OAK!\n')
                    csvwrite.writerow([first_row[0], first_row[1]])
 
            # Write the header to the output file if the first row was a header

            if is_header(first_row):
                csvwrite.writerow(['Genus', 'Species'])  # Add header if the first row was skipped

            # Process the remaining rows

            for row in taxa:

                # Ensure the row has at least 2 columns (to avoid IndexError)

                if len(row) < 2:

                    continue  # Skip malformed rows
 
                print(row)
                print("The genus is:")
                print(row[0] + '\n')  # Output the genus name

                # Check if the genus is close to 'quercus' using fuzzy matching

                if is_an_oak(row[0]):
                    print('FOUND AN OAK!\n')

                    # Write the relevant row to the output file if it's an oak

                    csvwrite.writerow([row[0], row[1]])

    except Exception as e:
        print(f"Error processing files: {e}")
        return 1
    return 0
 
# Entry point for script execution

if __name__ == "__main__":

    # Run doctest to test the is_an_oak function

    doctest.testmod()
    status = main(sys.argv)
    sys.exit(status)

 