#!/bin/bash

# Script that runs the deformation experiment

julia sysFiles/auxs/createBashDeformation.jl

echo -e 'Bash script created \n'
echo -e 'Run the bash script \n'

bash deformationSimulation.sh
