#!/bin/bash
rm cpu.dat
rm gpu.dat

for (( th=0 ; th<12; ++th))
do
    #nice ../main cpu $th $i $th >> ./cpu/n$th
    ../main cpu $th filename.png >> cpu.dat
    ../main gpu $th filename.png >> gpu.dat
done