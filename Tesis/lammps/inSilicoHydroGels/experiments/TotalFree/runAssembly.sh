#!/bin/bash

# Script that runs the assembly simulation

julia sysFiles/auxs/createBashAssembly.jl

echo -e 'Bash script created \n'
echo -e 'Run the bash script \n'

bash assemblySimulation.sh
