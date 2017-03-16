# warpcorr
An application which finds errors in test Nanopore genomes then correct them.

Contents and explanations of Warpcorr:


lambda_ref_genome.fasta
Lambda reference genome used for analysis


R73_Lambda
This directory contains 9 .fast5 files, which are the raw data we used for our analysis. It also contains 9 corresponding .fasta files. Many of the scripts in the root directory depend upon this organization.


plots
This directory serves as the destination for all plots generated. This location is hard coded in all scripts that generate images.


Corrected_reads
This directory serves as the destination for all the corrected reads. This location is hard coded in the dynamic_time_warping.py.


extract_template.py
This script extracts .fasta files from .fast5 files in R73_Lambda and writes them to that same directory. Input files and output locations are hardcoded. It is run using the following command:
python extract_template.py


Edit_locations.py
This script reads fasta files and globally aligns them to the reference genome lambda_ref_genome.fasta. Per input fasta, it returns text files containing locations of matches and non-matches, indexed by read position and reference position (4 files per fasta). Input files and output locations are hardcoded. It is run using the following command:
python Edit_locations.py


current_tools.py
This script contains functions to extract electronic sequences from the read and the reference. It is imported by dynamic_time _warp.py.


fandtw.py
Contains a function that implements DTW.


fandtw_kl.py
Contains a function that implements DTW with KL divergence as the cost function.


 kl.py
 Contains a function that computes the KL divergence between two gaussians given their means and standard deviations.


kl_dtw.py
Plots distributions of DTW distance using KL divergence as a cost function. Only analyzes one read at a time. A shortened read name, such as ‘ch100_file1’ must be set to the ‘read’ variable in the first line.


dynamic_time_warp.py
Calculates and plots DTW distance as well as corrects the replacement sequencing error. Uses threshold to distinguish sequencing error from true genome variant. The value of the threshold can be changed through the command line.
Note1: User should choose their own threshold according to the distribution graph of DTW distance to improve the accuracy of the result of correction.
Note2: The original threshold = 40


The input of this program is as following:
1.Four text file generated from Edit_locations.py,  which contain locations of matches and non-matches, indexed by read position and reference position.
2. A fasta file containing the original read.E.g .\R73_Lambda\ch100_file1.fasta
3. A  fasta file containing the reference E.g .\lambda_ref_genome.fasta
4.A fast5 file corresponding to the model of the input read. E.g .\R73_Lambda\minion_pc_Lambda_73d_3408_1_ch100_file1_strand.fast5
5. An integer type value: threshold, which is the threshold of the distance and can be changed through command line.
Input locations are hardcoded.


The output is:
1. A text files of the corrected reads.
2. A distribution diagram of dynamic time warping distance of matches k-mers and non-matches k-mers in the current read.
Output locations are hardcoded.
Following are the output of the command line
3. Number of perfect matching k-mers
4. Number of total mismatches in the read
5. Number of replacements in the read
6. Number of insertions in the read
7. Number of deletions in the read
8. Number of mismatches that have been corrected


It is run using the following command:
1. If you want to change the value of threshold:   python dynamic_time_warp.py --t threshold
2. If you don’t want to change the threshold:       python dynamic_time_warp.py


Error
This folder is full of commands that were run for error correction for each program
All of these files are commented, especially because some of these programs have commands that failed when we ran them and so the code comments the error messages that we may have gotten


Preprocess.sh - Essentially, it contains the FTP where the data is downloaded from and how to get it, as well as commands from poretools to convert your data into either fastq or fasta, depending on what the program needs.


Lighter.sh - An explanation as to downloading lighter, what commands we tried, and what errors we received when testing it. File names can be changed here depending on where you store your results and what some of your output is from preprocess.sh


Quake.sh - An explanation as to downloading quake, commands that were tested, and errors that occured when testing Quake. Again, file names can be changed here depending on where you put your files and such


Canu_correct.sh - An explanation as to downloading canu, and commands that were tested. File names may be modified as necessary.


Nanocorr.sh - An explanation as to downloading nanocorr, and the commands that were tested. File names and directories may be modified as necessary.


Edit_values.py - A python script that is a modification of the Edit_locations.py script. Essentially, this script just outputs the number of variants (insertions, deletions, and mismatches) that it finds in the sequence compared to our reference genome. Takes in any fasta file of a single read. To run type python Edit_values.py < read.fa


Nanocorr_refpol.fa - A fasta file of all of the nanocorred reads after comparing itself to the reference


Nanocorr_self.fa - A fasta file that contains all of the nanocorred reads after comparing itself to the other reads in the folder


Nanocorr_corrected - Folder containing output from Nanocorr correction attempts

canu_correction_subset - Folder containing output from canu attempts using only the 9 reads

canu_correction_full_dataset - Folder containing output from canu correction for all reads from the original dataset

