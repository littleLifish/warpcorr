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
  blk="000001"
  slf=""
  cvt="-h 1 0 -q 1"
  qry="000001"
fi


if [ x$qry = x ]; then
  echo Error: Job index out of range.
  exit 1
fi

if [ -e /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.ovb.gz ]; then
  echo Job previously completed successfully.
  exit
fi

if [ ! -d /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results ]; then
  mkdir /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results
fi

echo Running block $blk in query $qry

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


if [ ! -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap" ] ; then
  java -d64 -server -Xmx6g \
    -jar $bin/mhap-2.1.jar \
    --repeat-weight 0.9 -k 16 \
    --num-hashes 256 \
    --num-min-matches 3 \
    --threshold 0.8 \
    --filter-threshold 0.000005 \
    --ordered-sketch-size 1000 \
    --ordered-kmer-size 14 \
    --num-threads 12 \
    -f /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.frequentMers.ignore.gz\
    -s /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/blocks/$blk.dat $slf\
    -q /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/queries/$qry\
  > /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.WORKING \
  && \
  mv -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.WORKING /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap
fi

if [   -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap" -a \
     ! -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.ovb.gz" ] ; then
  $bin/mhapConvert \
    $cvt \
    -o /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.WORKING.gz \
    /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap \
  && \
  mv /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.WORKING.gz /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.gz
fi

if [   -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap" -a \
       -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.gz" ] ; then
  rm -f /home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap
fi

if [ -e "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.gz" ] ; then
  mv -f "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.mhap.ovb.gz" "/home/shao4/compgenomics/project/assembly/lambda/correction/1-overlapper/results/$qry.ovb.gz"
fi



exit 0
