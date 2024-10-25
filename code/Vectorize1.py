#!/usr/bin/env python3

"""  A script that illustrates how vectorization apart from computational efficiency, 
        makes writing code more concise, easy to read, and less error prone. """

__appname__ = 'Vectorize1.py'
__author__ = 'yy6024@ic.ac.uk'
__version__ = '0.0.1'
__date__ = 'oct 2024'

#import libraries
import numpy as np
import sys
import time

M = np.random.rand(1000,1000)

def SumAllElements(M):
    """ Adds all components of a matrix """
    Dimensions = M.shape
    Tot = 0
    for i in range(Dimensions[0]):
        for j in range(Dimensions[1]):
            Tot = Tot + M[i,j]

    return Tot

def main(argv):
    """ Main entry point of the program """
    start_func = time.time()
    SumAllElements(M)
    print("Using loops in python3, the time taken is:")
    print(time.time() - start_func)
    start_sum = time.time()
    print("Using the in-built vectorized function in python3, the time taken is:")
    np.sum(M)
    print(time.time() - start_sum)
    return 0

if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)