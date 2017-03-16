#!/bin/sh

if [ -e /home/shao4/compgenomics/project/assembly/lambda/correction/lambda.tigStore/seqDB.v001.tig ] ; then
  exit 0
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


#  Purge any previous intermediate result.  Possibly not needed, but safer.

rm -f /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.WORKING*

$bin/meryl \
  -B -C -L 2 -v -m 16 -threads 4 -memory 6553 \
  -s /home/shao4/compgenomics/project/assembly/lambda/correction/lambda.gkpStore \
  -o /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.WORKING \
&& \
mv /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.WORKING.mcdat /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.FINISHED.mcdat \
&& \
mv /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.WORKING.mcidx /home/shao4/compgenomics/project/assembly/lambda/correction/0-mercounts/lambda.ms16.FINISHED.mcidx

exit 0
