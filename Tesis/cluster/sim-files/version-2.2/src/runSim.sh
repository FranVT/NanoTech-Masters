: '
    Script that runs a numerical experiment.
    The assembly simulation is run once, then the shear simulation it is run N times.
    The N times are difenied by a rane of shear rates and the number of deformation per shear rate
'

#!/bin/bash

cd ..;

# Main Directories
dir_home=$(pwd);
dir_src="$dir_home/src";
dir_sim="$dir_src/sim";
dir_data="$dir_home/data";

# Id for the filenames and directories for simulations
id=$(date +%F-%H%M%S);

# Clean the source directory from previus simulations
rm -f "$dir_src/*.sge";
rm -f "$dir_src/assembly*"

# Go to source directory
cd $dir_src;

## Loops of parameters
for var_ccL in 0.5;
do
    # Run the assembly protocol and create necessary files
    bash $dir_src/docs/create-file_experiment-sge.sh $dir_home $dir_src $dir_sim $dir_data $id $var_ccL
    qsub system-$var_ccL.sge
done

