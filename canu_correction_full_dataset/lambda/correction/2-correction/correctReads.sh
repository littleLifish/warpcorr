#!/bin/sh

jobid=$1
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need 1 set, or a job index on the command line.
  exit 1
fi

if [ $jobid -gt 1 ]; then
  echo Error: Only 1 partitions, you asked for $jobid.
  exit 1
fi

if [ $jobid -eq 1 ] ; then
  bgn=1
  end=1905
fi

jobid=`printf %04d $jobid`

if [ -e "/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta" ] ; then
  echo Job finished successfully.
  exit 0
fi

if [ ! -d "/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs" ] ; then
  mkdir -p "/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs"
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



if [ "x$BASH" != "x" ] ; then
  set -o pipefail
fi

( \
$bin/generateCorrectionLayouts -b $bgn -e $end \
  -rl /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.readsToCorrect \
  -G /home/shao4/compgenomics/project/assembly/lambda/correction/lambda.gkpStore \
  -O /home/shao4/compgenomics/project/assembly/lambda/correction/lambda.ovlStore \
  -S /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.globalScores \
  -C 80 \
  -F \
&& \
  touch /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.dump.success \
) \
| \
$bin/falcon_sense \
  --min_idt 0.5 \
  --min_len 1000\
  --max_read_len 89998\
  --min_ovl_len 500\
  --min_cov 4 \
  --n_core 2 \
  > /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta.WORKING \
 2> /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.err \
&& \
mv /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta.WORKING /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta \

if [ ! -e "/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.dump.success" ] ; then
  echo Read layout generation failed.
  mv /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta /home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/correction_outputs/$jobid.fasta.INCOMPLETE
fi

exit 0
