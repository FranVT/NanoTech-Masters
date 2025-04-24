: '
    Script to create a config file for the shear simulations
'

#!/bin/bash

dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
dir_shear=$5
id=$6
shearRate=$7
Nexp=$8

# Load the parameter file for assembly
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

Nstep_per_strain=$(echo "scale=$cs; $(echo "scale=$cs; 1 / $var_shearRate" | bc) * $(echo "scale=$cs; 1 / $dt" | bc)" | bc) ;
Nstep_per_strain=${Nstep_per_strain%.*};    # Number of steps to deform 1 strain.
shear_it=$(( $max_strain * $Nstep_per_strain)); # Total number of steps to achive the max strain parameter
seed3=$(date +%F%H%M%S | tr -d '-')

# Define the output parameters file (default: parameters.config)
OUTPUT_FILE="shear$id-$shearRate-$Nexp.parameters"

# List of variable names to include in the parameters file
VAR_NAMES=(
  "Nstep_per_strain"
  "shear_it"
  "seed3"
)

# Create or overwrite the parameters file
> "$OUTPUT_FILE" || { echo "Error: Cannot write to $OUTPUT_FILE"; exit 1; }

# Write variables to the file
for var in "${VAR_NAMES[@]}"; do
  # Check if the variable is set (exists and not empty)
  if [ -n "${!var}" ]; then
    echo "$var=${!var}" >> "$OUTPUT_FILE"
  else
    echo "Warning: $var is not set. Skipping." >&2
  fi
done

echo "Parameters file generated: $OUTPUT_FILE"

mv $OUTPUT_FILE "$dir_src/docs"
