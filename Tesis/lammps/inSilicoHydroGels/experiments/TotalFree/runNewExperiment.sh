#!/bin/bash

# Script that runs the assembly and deformation simulation

julia sysFiles/auxs/createBashAux.jl

echo -e 'Assembly Bash script running \n'

bash runAssembly.sh

echo -e 'Deformation Bash script running \n'

bash runDeformation.sh

echo -e 'Move files Bash script running \n'

bash moveAux.sh

git pull; git add *; git commit -m "Experiment done"; git push
