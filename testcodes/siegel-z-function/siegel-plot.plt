# script for gnuplot

set zeroaxis
set key left
set xlabel 't'
set ylabel 'y'

set terminal png
set output 'siegel-z.png'
plot 'siegel-log.csv' t 'Riemann-Siegel Z function: y = Z(t)' w l lw 2
set output
