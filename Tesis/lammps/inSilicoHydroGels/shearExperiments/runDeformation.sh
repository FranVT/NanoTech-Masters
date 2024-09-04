#!/bin/bash

# Script that runs the deformation experiment

julia sysFiles/auxs/createBashDeformation.jl

echo -e 'Bash script created \n'
echo -e 'Run the bash script \n'

bash deformationSimulation.sh

echo -e 'Run the analysis script \n'

cd info;
if [[ -f stressVirial_shear.fixf ]]; then
    cd ..;
    echo 'Move the files to the system directory \n'
    julia info/analysis.jl 1
else
    cd ..;
    echo 'Running the julia script \n'
    julia info/analysis.jl 0
fi

cd ..;
