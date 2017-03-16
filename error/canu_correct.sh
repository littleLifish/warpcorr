#!/bin/bash

#Note that to run this command, we first had to download canu, which can be found here:

##git clone https://github.com/marbl/canu.git
##cd canu/src
##make -j 6

##this is for the entire tarred fileset
#lambda_cg is formed when you untar the entire tar.gz and then run poretools on it
~/canu-1.3/Linux-amd64/bin/canu --correct -p lambda_cg  -d assembly/lambda_cg -genomeSize=50000 -nanopore-raw lambda_cg.fastq

##this is for the subset of 9 reads
~/canu-1.3/Linux-amd64/bin/canu --correct -p lambda_9r  -d assembly/lambda_9r -genomeSize=50000 -nanopore-raw combined_reads.fasta



