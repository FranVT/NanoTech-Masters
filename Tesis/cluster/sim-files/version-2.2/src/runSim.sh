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
rm -f "$dir_src/*.sge*"
rm -f "$dir_src/*.sge"
rm -f "$dir_src/docs/assembly*"
rm -f "$dir_src/docs/shear*"

# Go to source directory
cd $dir_src;

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

## Loops of parameters
for var_ccL in 0.5;
do

    # Directory to store the data from the simulations
    dir_system="$dir_data/system-$id-CL-$var_ccL"
    
    # File name of assembly simulation
    filename="system-$id-CL-$var_ccL.sge"

    # Create the config file for the assembly
    bash $dir_src/docs/create-file_config-assembly.sh $dir_src $id $var_ccL

    # Create the sge file to run the assembly protocol
    bash $dir_src/docs/create-file_experiment-sge.sh $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL $filename

    # Create directory to save the simulation data
    mkdir $dir_system; mkdir "$dir_system/traj"

    # Run the assembly
    qsub $dir_src/$filename $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL

    # Create the sge files to run the shear protocol
    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
    do
   
        # Directory to store the data from the shear simulations
        dir_shearexp="$dir_system/shear-$id-shearRate$var_shearRate"
        mkdir $dir_shearexp; 
       
        # Create the config file for the shear simulations
        bash $dir_src/docs/create-file_config-shear.sh $dir_src $id $var_shearRate

        # Create the README and data.dat files in the shear directory
        bash $dir_src/docs/create-file_reference.sh $dir_home $dir_shearexp $dir_system $id $var_ccL $var_shearRate

        for var_N in $(seq $Nexp)
        do
            fileshearname="shear-$id-shearRate-$var_shearRate-exp$var_N.sge"
            # Create the directory to save the data
            mkdir "$dir_shearexp/Exp$var_N"
            mkdir "$dir_shearexp/Exp$var_N/traj"

            # Create the sge files for the simulations
            bash $dir_src/docs/create-file_shear-sge.sh $fileshearname
        done
    done

    # This while loop will exit when the data.hydrogel file is available for the deformation simulations
    # Execute the deformation files
    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
    do
        for var_N in $(seq $Nexp)
        do
            echo $(pwd)
            dir_shearexp="$dir_system/shear-$id-shearRate$var_shearRate"
            fileshearname="shear-$id-shearRate-$var_shearRate-exp$var_N.sge"

            # Run the shear simulation
            qsub $dir_src/$fileshearname $dir_home $dir_data $dir_system $dir_shearexp $id $var_ccL $var_shearRate $var_N
        done
    done

done

