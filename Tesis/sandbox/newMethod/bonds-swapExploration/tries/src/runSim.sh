: '
    Script that runs a numerical experiment.
    The assembly simulation is run once, then the shear simulation it is run N times.
    The N times are difenied by a rane of shear rates and the number of deformation per shear rate
'

#!/bin/bash

clear;

cd ..;

# Main Directories
dir_home=$(pwd);
dir_src="$dir_home/src";
dir_sim="$dir_src/sim";
dir_data="$dir_home/data";

# Id for the filenames and directories for simulations
id=$(date +%F-%H%M%S);

# Clean the source directory from previus simulations
rm -f $dir_src/system*;     rm -f $dir_src/shear*;
rm -f $dir_src/docs/*.config
rm -f $dir_src/docs/assembly*
rm -f $dir_src/docs/shear*

# Go to source directory
cd $dir_src;

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

## Loops of parameters
for var_ccL in $(seq $cl_con_o $cl_con_d $cl_con_f);
do

    # Directory to store the data from the simulations
    dir_system="$dir_data/system-$id-CL-$var_ccL"
    
    # File name of assembly simulation
    filename="system-$id-CL-$var_ccL.sh"

    # Create the config file for the assembly
    bash $dir_src/docs/create-file_config-assembly.sh $dir_src $id $var_ccL

    # Create the sge file to run the assembly protocol
    bash $dir_src/docs/create-file_experiment-sge.sh $dir_src $filename

    # Create directory to save the simulation data
    mkdir $dir_system; mkdir "$dir_system/traj"

    # Create the Readme file
    bash  $dir_src/docs/create-file_README.sh $dir_system $dir_src $var_ccL

    # Create the data file for the assembly simulation
    bash  $dir_src/docs/create-file_dataAssembly.sh $dir_system $dir_src $var_ccL $id

    # Run the assembly
    bash $dir_src/$filename $dir_sim $dir_src $dir_system $id $var_ccL

    sleep 2

done

