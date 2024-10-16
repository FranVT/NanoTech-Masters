#!/bin/bash

for n in $(seq 1 10);
do 
    echo $n
done

for var_cCL in 0.02 0.06 0.1 0.14 0.18;
do 
for var_damp in 0.05 0.075 0.1;
do
echo -e ""CL concentration "${var_cCL}" with a damp of "${var_damp}"
done
done
