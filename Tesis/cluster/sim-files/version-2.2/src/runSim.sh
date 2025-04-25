: '
    Script that runs a numerical experiment.
    The assembly simulation is run once, then the shear simulation it is run N times.
    The N times are difenied by a rane of shear rates and the number of deformation per shear rate
    RUN THIS SCRIOT WITH NOHUP: nohup path/runSim.sh &
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

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters 

## Loops of parameters
for var_ccL in 0.5;
do

    dir_system="$dir_data/system-$id-CL-$var_ccL"
    filename="system-$id-CL-$var_ccL.sge"

    # Create the sge file to run the assembly protocol
    bash $dir_src/docs/create-file_experiment-sge.sh $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL $filename

    # Create the sge files to run the shear protocol
    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
    do
        for var_N in $(seq $Nexp)
        do
            echo $(pwd)
            echo "Before bash shear"
            dir_shearexp="$dir_system/shear-$id-shearRate$var_shearRate-Nexp$var_N"
            fileshearname="shear-$id-shearRate-$var_shearRate-exp$var_N.sge"
            bash $dir_src/docs/create-file_shear-sge.sh $dir_shearexp $fileshearname
        done
    done

    #echo "Running the assembly" # This qsub runs the assembly
    qsub $dir_src/$filename $dir_home $dir_src $dir_sim $dir_data $dir_system $id $var_ccL

    # This while loop will exit when the data.hydrogel file is available for the deformation simulations
    # Execute the deformation files
    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
    do
        for var_N in $(seq $Nexp)
        do
            echo $(pwd)
            dir_shearexp="$dir_system/shear-$id-shearRate$var_shearRate-Nexp$var_N"
            fileshearname="shear-$id-shearRate-$var_shearRate-exp$var_N.sge"
            qsub $dir_src/$fileshearname $dir_home $dir_data $dir_system $dir_shearexp $id $var_ccL $var_shearRate $var_N
        done
    done

done

