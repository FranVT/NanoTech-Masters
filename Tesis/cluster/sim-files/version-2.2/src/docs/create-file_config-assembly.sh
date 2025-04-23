: '
    Script that creates a config file for the assembly simulation
    Template code created by DeepSeek
'

#!/bin/bash

dir_home=$1
dir_src=$2
dir_sim=$3
dir_data=$4
id=$5
cl_con=$6

# Load the parameter file for assembly
chmod +x dir_src/docs/load_parameters.sh
source dir_src/docs/load_parameters.sh system.parameters

# Define variables
N_CL=$(echo "scale=0; $CL_con * $N_particles" | bc);
N_CL=${N_CL%.*};
N_MO=$(( $N_particles - $N_CL ));
Vol_MO=$(echo "scale=$cs; $Vol_MO1 * $N_MO" | bc);         # Vol of N f=2 patchy particles
Vol_CL=$(echo "scale=$cs; $Vol_CL1 * $N_CL" | bc);          # Vol of N f=4 patchy particles 
Vol_Totg=$(echo "scale=$cs; $Vol_MO + $Vol_CL" | bc);       # Total volume of a mixture of N f=2 and M f=4 patchy particles
Vol_Tot=$(echo "scale=$cs; $Vol_Totg / $phi" | bc);
L_real=$(echo "scale=$cs; e( (1/3) * l($Vol_Tot) )" | bc -l );
L=$(echo "scale=$cs; $L_real / 2" | bc);

aux=$(echo "scale=0; $CL_con * $N_particles" | bc); aux=${aux%.*};

# Seed for the langevin thermostat and initial positions
seed1=$((1234 + aux));     # MO positions
seed2=$((4321 + aux));     # CL positions
seed3=$((10 + aux));       # Langevin thermostat

# Directory to save the data. Make it available for the sge script
dir_system="system-$id-CL-$cl_con"

# Define the output parameters file (default: parameters.config)
OUTPUT_FILE="${1:-assembly$id.parameters}"

# List of variable names to include in the parameters file
VAR_NAMES=(
  "N_CL"
  "Vol_MO"
  "Vol_CL"
  "Vol_Totg"
  "L"
  "seed1"
  "seed2"
  "seed3"
  "dir_system"
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
