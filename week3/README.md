# Week 3 README
## Description
This project contains a collection of R scripts and data files used for various computational tasks, ranging from data wrangling and population modeling to visualization and debugging. The scripts demonstrate R programming concepts such as vectorization, control flows, and function applications, making this project a great resource for learning and applying R programming techniques.
Languages
R: The primary language used for all scripts and data analysis.

## Dependencies
The project requires the following R packages:
ggplot2: For creating visualizations.
dplyr: For data manipulation (if used in wrangling scripts).
tidyr: For data tidying.
readr: For reading and writing data files.
base: Standard R package (default).
Ensure these packages are installed before running the scripts.

## Installation
Please download all of the files in a suitable directory.

## Project Structure and Usage: 
**Please remember to run these shell scripts in code directory.**
### Code
- DataWrang.R: Wrangling the Pound Hill Dataset
- R_conditionals.R: some examples of functions with conditionals
- Ricker.R: a script shows Ricker model which is a classic discrete population model
- TreeHeight.R: This script reads a csv file containing trees' species, distance and angle, calculates all of the trees' height, then append heights to the origin csv file as a new csv file stored in ../results
- Vectorize1.R: an example illustrating that vectorization can optimize code computational efficiency and make code more concise, easy to read, less prone
- apply1.R: use apply to vectorize code, applying the same function to rows/columns of a matrix
- apply2.R: use apply to define your own functions
- boilerplate.R: A boilerplate R script
- break.R: a control flow tool, break, is useful to break out of loops when some condition is met
- browse.R: use browser() to debug script, inserting a breakpoint in code and then stepping throuth code
- control_flow.R: control flow tools in R including if, then, else and for and while loops
- next.R: a control flow tool, next, is used to skip to next iteration of a loop
- preallocate.R: an example shows pre-allocate a vector can make results faster
- sample.R: an example of vectorization involving lapply and sapply
- try.R: use try keyword to catch the error and keep going instead of having R throw you out
- basic_io.R: a simple script to illustrate R input-output.
- Girko.R: draw the results of a simulation displaying Girko's circular law
- MyBars.R: use ggplot geom_text to annotate a plot
- plotLin.R: mathematical annotation on a axis and in the plot area
- PP_Dists.R: draw and save 3 graphics relatively for distribution of log(Predator mass), log(Prey mass) and the size ratio of Prey mass over Predator mass, containing subplots by Type.of.feeding.interaction

### Data
- EcolArchives-E089-51-D1.csv: import file of PP_Dists.R
- PoundHillData.csv: import file of DataWrang.R 
- PoundHillMetaData.csv: import file of DataWrang.R
### Result
An empty directory as origin version only with a .gitignore.

## Author and contact
Yao Ye   yy6024@ic.ac.uk
