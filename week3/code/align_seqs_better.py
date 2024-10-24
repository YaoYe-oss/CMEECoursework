#!/usr/bin/env python3

"""A program which creates a text file of the best alignments between two sequences."""

__author__ = 'Lucy Mansfield (lam124@imperial.ac.uk)'

import sys
import os

# Read sequences into a list
def read_seqs(filepath):
    """Read fasta sequences from a fasta file."""
    with open(filepath, 'r') as f:
        seqlist = [line.strip() for line in f]
        seqlist = seqlist[1:]
        seq = ""
        for line in seqlist:
            seq = seq + line
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
        s1 = seq2
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
    return score

def find_best_alignments(s1, s2, l1, l2):
    """Find all best alignments of two sequences."""
    global my_best_align
    global my_best_score
    best_score = -1
    best_alignments = []
    
    for i in range(l1):
        score = calculate_score(s1, s2, l1, l2, i) # cycle through all possible startpoints and print the alignments
        alignment = "." * i + s2
        
        if score > best_score:
            best_alignments = [(alignment, score, i)] # assign best alignment of seq 2 to best align (showing base sequence)
            best_score = score # assign corresponding alignment score to my_best_score
        elif score == best_score:
            best_alignments.append((alignment, score, i)) # Append scores that exactly match the best score
    
    return best_alignments, best_score

# main function
def main(argv):
    """Output the best alignment(s) of 2 DNA sequences and their scores as a .txt file"""
    if len(argv) == 3: 
        seq1 = read_seqs(str(sys.argv[1]))
        seq2 = read_seqs(str(sys.argv[2]))
    elif len(argv) > 3 or len(argv) == 2:
        print("Incorrect input; please input 2 fasta files, or no arguments to run the function with the default fasta files.")
        sys.exit()
    else: # otherwise, read from default file ("../data")
        seq1 = read_seqs("../data/407228326.fasta")
        seq2 = read_seqs("../data/407228412.fasta")
    
    # reorder seqs if first is shorter than the second
    order_seqs(seq1, seq2)
    
    # Assign variables to add best alignment and best score
    best_alignments, best_score = find_best_alignments(s1, s2, l1, l2)
    
    # Create results directory if it doesn't exist
    if not os.path.exists("../results"):
        os.makedirs("../results")

    # Write best alignments and scores to a .txt file
    print("Writing bestalign.txt file to results folder....")
    with open("../results/bestalign.txt", "w") as oo:
        oo.write(f"Best score: {best_score}\n\n")
        for alignment, score, startpoint in best_alignments:
            oo.write(f"Alignment starting at position {startpoint}:\n")
            oo.write(f"{alignment}\n")
            oo.write(f"{s1}\n\n")
    
    print(f"Done! {len(best_alignments)} alignment(s) saved with the best score of {best_score}.")

if __name__ == "__main__":
    status = main(sys.argv)

