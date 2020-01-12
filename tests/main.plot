set xlabel "N"
set ylabel "temps"
set title "tests diamond square cpu/gpu"
set terminal pdf
set output "tests.pdf"

plot "cpu.dat"
plot "gpu.dat"

