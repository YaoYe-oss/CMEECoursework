**Awesome Aardvarks - Group Practical**

**This practical involves working as a group to solve 2 problems. The work was divided among all 4 members and each person worked on their part individually with occasional help from other group members. Sean finished working on the second half of align_seqs before we realized that we weren't meant to do that part. All resources used can be found within each persons branch of the repository. The first task (DNA sequence alignment) involved aligning two DNA sequences in FASTA format instead of csv. The final output file shows the best alignment and its corresponding score. The second task involved modifying the oaks_debugme.py file to filter through data from a csv file and identify species from the genus Quercus (oak species). The script itself uses fuzzy matching to detect and filter rows where the genus is recognized as Quercus while also compensating for potential spelling errors and writing the filtered rows to a new CSV file. For the practical, new lines were added that ensure that headers are ignored when reading the data, and put back in once the output file is created.**

**Languages used**
Python 3.x

**Dependencies**
difflib (for fuzzy matching)
doctest (for inline testing of functions)


**Align DNA sequences**
Script: align_2seqs.py

**Functionality**
- Reads two DNA sequences from FASTA files and compares them.
- Identifies the best alignment based on the number of matching base pairs.
- Outputs the best alignment and its score to a file called bestalign.txt in the results directory.
- Defaults to using sequences stored in ../data if no input FASTA files are provided.

**How to use in terminal**
python3 align_2seqs.py seq1.fasta seq2.fasta
Alternatively, if no input files are provided:
python3 align_2seqs.py


**Missing Oaks**
Script: oaks_debugme.py

**Functionality**
- Filters tree species data to find entries where the genus is Quercus or close enough (using fuzzy matching).
- Outputs the filtered data to a CSV file called JustOaksData.csv.
- Ensures the header is properly included and distinguishes it from data.

**How to use in terminal**
python3 oaks_debugme.py


**Authors**
Lucy Mansfield (lam124@imperial.ac.uk)
Sean Barry (sb4524@ic.ac.uk)
Yao Ye (yy6024@ic.ac.uk)
Yumeng Huang (yh4724@ic.ac.uk)
