#!/bin/bash

# Script that runs the assembly and deformation simulation

julia sysFiles/auxs/createBashAux.jl

bash runAssembly.sh

echo -e 'Deformation Bash script running \n'

bash runDeformation.sh
