
set pointsize 0.25

set title 'original read length vs expected corrected read length'
set xlabel 'original read length'
set ylabel 'expected corrected read length'

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.originalLength-vs-expectedLength.lg.png'
plot [0:44947] [0:44947] '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using 2:3 title 'original (x) vs expected (y)'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.originalLength-vs-expectedLength.sm.png'
replot

set title 'original read length vs sum of corrected read lengths'
set xlabel 'original read length'
set ylabel 'sum of corrected read lengths'

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.originalLength-vs-correctedLength.lg.png'
plot [0:44947] [0:44947] '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using 2:4 title 'original (x) vs corrected (y)'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.originalLength-vs-correctedLength.sm.png'
replot

set title 'expected read length vs sum of corrected read lengths'
set xlabel 'expected read length'
set ylabel 'sum of corrected read lengths'

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.expectedLength-vs-correctedLength.lg.png'
plot [0:44947] [0:44947] '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using 3:4 title 'expected (x) vs corrected (y)'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.expectedLength-vs-correctedLength.sm.png'
replot
