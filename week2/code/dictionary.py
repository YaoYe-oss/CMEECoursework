taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 

# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  
 
#### Your solution here #### 

# Using a loop to create the dictionary
taxa_dic = {}

for species, order in taxa:
    if order not in taxa_dic:
        taxa_dic[order] = set()  # Initialize with an empty set
    taxa_dic[order].add(species)

# Print the result
for order, species_set in taxa_dic.items():
    print(f"'{order}': {species_set}")

# Using a dictionary comprehension with set comprehensions inside
taxa_dic = {order: {species for species, o in taxa if o == order} for order in set(o for _, o in taxa)}

# Print the result
for order, species_set in taxa_dic.items():
    print(f"'{order}': {species_set}")

