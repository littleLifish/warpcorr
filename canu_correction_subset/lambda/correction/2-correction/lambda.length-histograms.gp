set title 'read length'
set ylabel 'number of reads'
set xlabel 'read length, bin width = 250'

binwidth=250
set boxwidth binwidth
bin(x,width) = width*floor(x/width) + binwidth/2.0

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.length-histograms.lg.png'
plot [1:17400] [0:] \
  '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using (bin($2,binwidth)):(1.0) smooth freq with boxes title 'original', \
  '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using (bin($3,binwidth)):(1.0) smooth freq with boxes title 'expected', \
  '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using (bin($4,binwidth)):(1.0) smooth freq with boxes title 'corrected'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.length-histograms.sm.png'
replot

set xlabel 'difference between expected and corrected read length, bin width = 250, min=-314, max=6682'

set terminal png size 1024,1024
set output '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.length-difference-histograms.lg.png'
plot [-314:6682] [0:] \
  '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.original-expected-corrected-length.dat' using (bin($7,binwidth)):(1.0) smooth freq with boxes title 'expected - corrected'
set terminal png size 256,256
set output '/home/shao4/compgenomics/project/R73_Lambda/assembly/lambda/correction/2-correction/lambda.length-difference-histograms.sm.png'
replot
