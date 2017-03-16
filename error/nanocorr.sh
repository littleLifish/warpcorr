#!/bin/bash

#installing and running nanocorr

#nanocorr can be downloaded here using git:
#git clone https://github.com/jgurtowski/nanocorr.git
#follow instructions as given on the nanocorr readme

#you need virtualenv, blast and parallel installed for this to work
# make sure you have a temp directory somewhere

cd ~/nanocorr #or path to installed nanocorr

python partition.py 100 500 ~/lambda_ds.fa # this splits the read into 1 due to our limited amount of sample
cp 0001/p0001 ./

#compare against each other
for j in 1; do
       echo "SGE_TASK_ID=$j TMPDIR=~/tmp ~/nanocorr/nanocorr.py ~/compgenomics/project/lambda_ds.fa ~/compgenomics/project/lambda_ref";
done  | parallel -j 4


#rename so you aren't confused with what it is, especially the fasta file it ge\nerates if nothing else

cp p0001.blast6.r.fa Nanocorr_self.fa

# run against aligner and see how it works after splitting the file into one read

awk '/^>/{s=++d".fa"} {print > s}' Nanocorr_self.fa

#run against each set of reads - for example
python Edit_values.py < 1.fa

#compare against ref 
for j in 1; do
    echo "SGE_TASK_ID=$j TMPDIR=~/tmp ~/nanocorr/nanocorr.py ~/compgenomics/project/lambda_ref_genome.fasta ~/compgenomics/project/lambda_ref";
done  | parallel -j 4

#rename so you aren't confused with what it is, especially the fasta file it generates if nothing else

cp p0001.blast6.r.fa Nanocorr_ref.fa

# split the file so that way you get one read at a time
awk '/^>/{s=++d".fa"} {print > s}' Nanocorr_ref.fa

# run against aligner to see how well it worked

python Edit_values.py < Nanocorr_ref.fa


