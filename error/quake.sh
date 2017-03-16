#!/bin/bash

# explaining how to load quake and how to run it

#get quake from here: wget http://www.cbcb.umd.edu/software/quake/downloads/quake-0.3.5.tar.gz
#untar the tarball using gunzip xzvf

#make sure you have boost installed - this can be downloaded here: https://sourceforge.net/projects/boost/?source=typ_redirect
# once boost is downloaded, go into the folder, and copy the boost folder and everything inside it into the Quake/src folder
# run the makefile inside the Quake/src folder to build Quake

# so documentation explains that to run Quake you should use run quake.py -f reads.fastq -k [k-mer integer] -p 4

# here we test it out - for example:
~/Quake/bin/quake.py -f ch100_file1.fastq -k 5 -p 4 #left kmers as 5 here since that is the same as our model, but this has been fiddled around with. Tested 10 as well
#specific reads can be pulled out of lambda_ds.fastq 

# try with full dataset

python ~/Quake/bin/quake.py -f lambda_ds.fastq -k 5 -p 4

# unfortunately, running this leads to errors - so tried step by step
#1) count kmers

cat lambda_ds.fastq | ~/Quake/bin/count-qmers -k 5 > test.txt
#note that an issue with this is that determining the correct q will take a lot of work - part of the reason we think this would not work properly for later steps is that the quality is off

#okay, try coverage cutoff

python ~/Quake/bin/cov_model.py test.txt

#get error involving unable to differentiate kmers: Optimization of distribution likelihood function to choose k-mer cutoff failed. Inspect the k-mer counts for a clear separation of the error and true k-mer distributions.

#Try whole process with kmer counting instead?
cat lambda_ds.fastq | ~/Quake/bin/count-kmers -k 5 > test.txt

python ~/Quake/bin/cov_model.py test.txt
# Same error occurs

#Part 3 requires the file created in part 2....
#Switch to test a different process then


