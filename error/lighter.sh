#!/bin/bash

#a script for testing lighter

#Before you begin, you will need to install lighter on your system, which can be downloaded here:

#git clone https://github.com/mourisl/Lighter.git, then go into the folder and run make

#As stated in their README for installation, the only dependencies you will need are pthreads and zlib

#testing lighter on a sample for example:

./lighter -r ch100_file1.fasta -noQual -K 5 50000

#running this leads to buffer overflow error

#test on a larger sampling maybe? like all of the reads in the tarball?

./lighter -r lambda_ds.fastq -K 9 50000 -noQual -t 8 -od ./

#still no good (still receiving buffer overflow error), am sad :'(
#will try another error corrector in the meantime
