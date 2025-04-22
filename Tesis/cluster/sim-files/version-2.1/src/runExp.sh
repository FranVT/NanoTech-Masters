: '
    Bash script that runs the simulation. Creates files and more stuff
'

#!/bin/bash

chmod +x load_parameters.sh
source ./load_parameters.sh parameters.txt

echo "Number of particles in the simulation: $N_particles"
echo "Files names: ${files_name[3]}"

