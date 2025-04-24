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

## Loops of parameters
for var_ccL in 0.5;
do

    dir_system=dir_system="$dir_data/system-$id-CL-$cl_con"
    filename="system-$id-CL-$var_ccL.sge"

    # Run the assembly protocol and create necessary files
    bash $dir_src/docs/create-file_experiment-sge.sh $dir_home $dir_src $dir_sim $dir_data $id $var_ccL $filename

    echo "Running the qsub system-var_ccL.sge" # This qsub runs the assembly
    qsub $dir_src/docs/$filename


    # WAIT UNTIL ASSEMBLY SIMULATION HAS FINISHED
    # This while loop will exit when the data.hydrogel file is available for the deformation simulations
    dir_file="$dir_system/data.hydrogel"

    # Continuously check if the file exists
    while [ ! -e "$dir_file" ]; do
        echo "Waiting for $dir_file to be created..."
        sleep 30  # Wait for 30 second before checking again to reduce CPU usage
    done

    # Exit the loop once the file exists
    echo "$dir_file found! Exiting."

    # Execute the deformation files
    for var_shearRate in $(seq $dgamma_o $dgamma_d $dgamma_f);
    do
        for N in $(seq $Nexp)
        do
            echo $(pwd)
            echo "Before bash shear"
            fileshearname="shear-$id-shearRate-$var_shearRate-exp$N.sge"
            qsub $dir_src/docs/$fileshearname
        done
    done

done






