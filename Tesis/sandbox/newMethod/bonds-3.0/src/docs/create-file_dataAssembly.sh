: '
    Bash script that creates the data file for the assembly simulation
'

#!/bin/bash

dir_system=$1
dir_src=$2
var_ccL=$3

# Load the parameters file
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

# Load the assembly config file
source $dir_src/docs/load_parameters.sh $dir_src/docs/assembly$id-$var_ccL.parameters

# Go to the directory in which the files are going to be created 
cd $dir_system;

# Create the data.dat file
file_name="dataAssembly.dat";

# Initialize arrays to hold headers and values
headers=()
values=()

# Populate headers and values arrays
for i in "${!files_name[@]}"; do
    headers+=("file$i")
    values+=("${files_name[$i]}")
done

headers+=("phi")
values+=("${phi}")

headers+=("CL-Con")
values+=("${var_ccL}")

headers+=("Npart")
values+=("${N_particles}")

headers+=("Temperature")
values+=("${T}")

headers+=("damp")
values+=("${damp}")

headers+=("time-step")
values+=("${dt}")

headers+=("N_heat")
values+=("${steps_heat}")

headers+=("N_isot")
values+=("${steps_isot}")

headers+=("N_CL")
values+=("${N_CL}")

headers+=("N_MO")
values+=("${N_MO}")

headers+=("L")
values+=("${L}")

headers+=("save-dump")
values+=("${Ndump}")

headers+=("save-fix")
values+=("${Nsave}")

headers+=("save-stress")
values+=("${NsaveStress}")

# Write headers and values to the file
echo "$(IFS=,; echo "${headers[*]}")" > "$file_name"
echo "$(IFS=,; echo "${values[*]}")" >> "$file_name"

