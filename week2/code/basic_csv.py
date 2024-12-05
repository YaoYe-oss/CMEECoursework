#!/usr/bin/env python3 

"""Some practices on basic commands in csv package to manipulate CSV file"""

import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male (Kg)'
f = open('../data/testcsv.csv', 'r')

from itertools import islice
csvread = csv.reader(f)
temp = []
for row in islice(csvread, 1, None):       # remove the first row of csv file
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

#write a file containing only species name and Body mass
f = open('../data/testcsv.csv', 'r')
g = open('../data/bodymass.csv', 'w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()