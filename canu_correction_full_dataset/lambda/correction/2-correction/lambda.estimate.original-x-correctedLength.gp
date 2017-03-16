set title 'original length (x) vs corrected length (y)'
set xlabel 'original read length'
set ylabel 'corrected read length (expected)'
set pointsize 0.25

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.original-x-corrected.lg.png'
plot '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.tn.log' using 2:4 title 'tn', \
     '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.fn.log' using 2:4 title 'fn', \
     '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.fp.log' using 2:4 title 'fp', \
     '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.tp.log' using 2:4 title 'tp'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/assembly/lambda/correction/2-correction/lambda.estimate.original-x-corrected.sm.png'
replot
