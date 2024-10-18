# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
rainfall_over_100 = [(month, rain) for month, rain in rainfall if rain > 100]

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 
months_under_50 = [month for month, rain in rainfall if rain < 50]

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# Conventional loop for rainfall over 100 mm
rainfall_over_100_loop = []
for month, rain in rainfall:
    if rain > 100:
        rainfall_over_100_loop.append((month, rain))

# Conventional loop for months with rainfall less than 50 mm
months_under_50_loop = []
for month, rain in rainfall:
    if rain < 50:
        months_under_50_loop.append(month)

#Printing the results 
print("Months and rainfall values when the amount of rain was greater than 100mm:")
print(rainfall_over_100)

print("Months with rainfall less than 50mm:")
print(months_under_50)

# Printing the results from loops
print("\nResults from conventional loops:")
print("Months and rainfall values (loop) when the amount of rain was greater than 100mm:")
print(rainfall_over_100_loop)

print("\nMonths with rainfall less than 50mm (loop):")
print(months_under_50_loop)

# A good example output is:

