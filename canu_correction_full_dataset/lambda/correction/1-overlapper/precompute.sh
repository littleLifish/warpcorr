#!/bin/sh

jobid=$1
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need 1 set, or a job index on the command line.
  exit 1
fi

if [ $jobid -eq 1 ] ; then
  rge="-b 1 -e 1905"
  job="000001"
fi


if [ x$job = x ] ; then
  echo Job partitioning error.  jobid $jobid is invalid.
  exit 1
fi

if [ ! -d /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks ]; then
  mkdir /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks
fi

if [ -e /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.dat ]; then
  echo Job previously completed successfully.
  exit
fi

#  If the fasta exists, our job failed, and we should try again.
if [ -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta" ] ; then
  rm -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.dat
fi

syst=`uname -s`
arch=`uname -m`
name=`uname -n`

if [ "$arch" = "x86_64" ] ; then
  arch="amd64"
fi
if [ "$arch" = "Power Macintosh" ] ; then
  arch="ppc"
fi

bin="/home/shao4/canu-1.3/$syst-$arch/bin"

if [ ! -d "$bin" ] ; then
  bin="/home/shao4/canu-1.3"
fi


$bin/gatekeeperDumpFASTQ \
  -G /home/shao4/compgenomics/project/assembly/lambda/correction/lambda.gkpStore \
  $rge \
  -nolibname \
  -fasta \
  -o /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job \
|| \
mv -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta.FAILED


if [ ! -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta" ] ; then
  echo Failed to extract fasta.
  exit 1
fi

echo Starting mhap precompute.

#  So mhap writes its output in the correct spot.
cd /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks

java -d64 -server -Xmx6g \
  -jar $bin/mhap-2.1.jar \
  --repeat-weight 0.9 -k 16 \
  --num-hashes 256 \
  --num-min-matches 3 \
  --ordered-sketch-size 1000 \
  --ordered-kmer-size 14 \
  --threshold 0.8 \
  --filter-threshold 0.000005 \
  --num-threads 12 \
  -f /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.frequentMers.ignore.gz\
  -p /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta\
  -q /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks\
|| \
mv -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.dat /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.dat.FAILED

if [ ! -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.dat" ] ; then
  echo Mhap failed.
  exit 1
fi

#  Clean up, remove the fasta input
rm -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$job.fasta

exit 0
