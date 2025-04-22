: '
    Script that runs the assembly procotol once per cross link concentration and the shear protocol Nexp times.
'

#!/bin/bash

# Main Directories
dir_home=$(pwd);
dir_sim="$dir_home/sim";
dir_data="$dir_home/data";
id=$(date +%F-%H%M%S);

echo $dir_home;

# Clean the simulation directory from previus simulations
rm -f "$dir_home/sim/*.sge";

# Get the parameters from the parameter file
chmod +x load_parameters.sh
source ./load_parameters.sh parameters.txt

# Significant decimals
cs=6;

## Loops of parameters
for var_ccL in 0.5;
do

    # Assembly parameters
    CL_con=$var_ccL;
    # Create the sge file 
    bash create_sge-file.sh filenname.sge
        cd $dir_home; # Go to the general directory, such that in we can go into sim directory in line 79

done

