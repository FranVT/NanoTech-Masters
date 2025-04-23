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

# Clean the simulation directory from previus simulations
rm -f "$dir_sim/*.sge";

# Go to source directory
cd $dir_src;

# Get the parameters from the parameter file
chmod +x docs/load_parameters.sh
source docs/load_parameters.sh parameters.txt

## Loops of parameters
for var_ccL in 0.5;
do

    bash $dir_src/create-file_assembly-sge.sh $var_ccL
    #qsub assembly-$var_ccL.sge

done












## Loops of parameters
for var_ccL in 0.5;
do

    # Assembly parameters
    CL_con=$var_ccL;
    # Create the sge file 
    bash create_sge-file.sh filenname.sge
        cd $dir_home; # Go to the general directory, such that in we can go into sim directory in line 79

done

