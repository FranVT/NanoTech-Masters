: '
    Script that runs the assembly procotol once per cross link concentration and the shear protocol Nexp times.
'

#!/bin/bash

cd ..;
# Main Directories
dir_home=$(pwd);
dir_src="$dir_home/src";
dir_sim="$dir_src/sim";
dir_data="$dir_home/data";

# Id for the filenames and directories for simulations
id=$(date +%F-%H%M);

# Clean the source directory from previus simulations
rm -f "$dir_src/docs/*.sge";

# Go to source directory
cd $dir_src;

## Loops of parameters
for var_ccL in 0.5;
do

    bash $dir_src/docs/create-file_experiment-sge.sh $dir_home $dir_src $dir_sim $dir_data $id $var_ccL
    #qsub system-$var_ccL.sge

done

