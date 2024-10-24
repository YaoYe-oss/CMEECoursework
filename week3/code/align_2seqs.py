#!/usr/bin/env/python3

"""
A program which creates a text file of the best alignment between two sequences.

Input = 2 fasta files containing one DNA sequence each.

The sequences are read into strings, which can then be assessed for the best alignment by cycling through all possible alignments and counting the matches.
The best alignment found is sent to a .txt file (bestalign.txt), as well as its score.
If there is more than one alignments with the best score, only the first is outputted to the .txt file.

The file is saved to the results directory.
"""

__author__ = 'Lucy Mansfield (lam124@imperial.ac.uk)'
import sys
import os

# Read sequences into a list
def read_seqs(filepath):
    """Read fasta sequences from a fasta file."""
    with open(filepath, 'r') as f:
        seqlist = [line.strip() for line in f] # get each line of file into a list
        seqlist = seqlist[1:] # remove first line (not DNA sequence)
        seq = "" # create string
        for line in seqlist:
            seq = seq + line # add each line to the string to create the sequence as a continuous string
    return seq

## function that orders the seqs provided ##
def order_seqs(seq1, seq2):
    """Order the sequences"""
    global l1, l2, s1, s2
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2 # change seq numbers to ensure s1 is the longest
        s2 = seq1
        l1, l2 = l2, l1
# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """Check the alignment of two sequences from a startpoint and return an alignment score."""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2): # cycle through all bases in shorter seq
        if (i + startpoint) < l1: # if base lies within the length of the largest sequence
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1 # score increases for every match in alignment
            else:
                matched = matched + "-"

    # some formatted output
    return score

def find_best_align(s1, s2, l1, l2):
    """find best alignment of two sequences."""
    global my_best_align, my_best_score # ensure they can be accessed outside of the function
    my_best_align = None
    my_best_score = -1   
    for i in range(l1):
        z = calculate_score(s1, s2, l1, l2, i) # cycle through all possible startpoints and print the alignments
        if z > my_best_score:
            my_best_align = "." * i + s2 # assign best alignment of seq 2 to best align (showing base sequence)
            my_best_score = z # assign corresponding alignment score to my_best_score
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)


# main function
def main(argv):
    """Output the first best alignment of 2 DNA sequences and its score as a .txt file"""
    if len(argv) == 3: # if argument provided, read file
        if os.path.isfile(str(sys.argv[1])) == True and os.path.isfile(str(sys.argv[2])) == True:
            seq1 = read_seqs(str(sys.argv[1]))
            seq2 = read_seqs(str(sys.argv[2]))
        else:
            print("One or more files not found: please check the filepath of the files intending to be used.")
            sys.exit()
    elif len(argv) > 3 or len(argv) == 2: # print error if incorrect input given 
        print("Incorrect input; please input 2 fasta files, or no arguments to run the function with the default fasta files.")
        sys.exit()
    else: # otherwise, read from default files
        if os.path.isfile("../data/407228326.fasta") == True and os.path.isfile("../data/407228412.fasta") == True:
            seq1 = read_seqs("../data/407228326.fasta")
            seq2 = read_seqs("../data/407228412.fasta")
        else:
            print("One or more files not found: please check the filepath of the files intending to be used.")
            sys.exit()
    # reorder seqs if first is shorter than the second
    order_seqs(seq1, seq2)
    # Assign variables to add best alignment and best score
    find_best_align(s1, s2, l1, l2)
    # check if results path exists; if not make it
    if not os.path.exists("../results"):
        os.makedirs("../results")
    # write best alignment and score to a .txt file in results folder
    best_alignment = [my_best_align, my_best_score]
    print("Writing bestalign.txt file to results folder....") # tell user where to find file
    with open("../results/bestalign.txt", "w") as oo:
        for i in best_alignment:
            oo.write(str(i) + "\n")
    print("Done!")

if (__name__ == "__main__"):
    status = main(sys.argv)