: '
    Bash script that creates the data file for shear simulation
'

#!/bin/bash

dir_src=$1
dir_shear=$2
id=$3
var_shearRate=$4

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

# Load the shear config file
source $dir_src/docs/load_parameters.sh $dir_src/docs/shear$id-$var_shearRate.parameters

# Go to the directory in which the files are going to be created 
cd $dir_shear;

# Create the data.dat file
file_name="dataShear.dat";

# Initialize arrays to hold headers and values
headers=()
values=()

# Populate headers and values arrays
for i in "${!files_name[@]}"; do
    headers+=("file$i")
    values+=("${files_name[$i]}")
done

headers+=("Nexp")
values+=("${Nexp}")

headers+=("Shear-rate")
values+=("${var_shearRate}")

headers+=("Max-strain")
values+=("${max_strain}")

headers+=("N_def")
values+=("${Nstep_per_strain}")

headers+=("Nrlx0")
values+=("${Nrlx0}")

headers+=("time-step")
values+=("${dt}")

headers+=("save-dump")
values+=("${Ndump}")

headers+=("save-fix")
values+=("${Nsave}")

headers+=("save-stress")
values+=("${NsaveStress}")

# Write headers and values to the file
echo "$(IFS=,; echo "${headers[*]}")" > "$file_name"
echo "$(IFS=,; echo "${values[*]}")" >> "$file_name"

