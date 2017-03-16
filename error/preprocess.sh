#!/bin/bash

# commands/script for doing all of the preprocessing stuff

#acquire run data
wget ftp://ftp.sra.ebi.ac.uk/vol1/ERA476/ERA476754/oxfordnanopore_native/Lambda_run_d.tar.gz

#untar the file, find reads - for your sanity and computational space we're just going to give you the files we ended up running for this analysis

#convert reads to fasta
#please note that for this part you will need to download poretools https://github.com/arq5x/poretools

poretools fastq fast5_directory/ > lambda_ds.fastq #fast5_directory is where your fast5 files are located - in our case they are in R73_model/

#separating out reads individually if you so wish - note that it changes the name of each read to a number
awk '/^@/{s=++d".fastq"} {print > s}' lambda_ds.fastq

# using poretools to create a fasta from the fast5files
poretools fasta fast5_directory/ > lambda_ds.fasta

# separating out reads individually again if you so wish - note that it changes the name of each read to a number
awk '/^>/{s=++d".fa"} {print > s}' lambda_ds.fasta

