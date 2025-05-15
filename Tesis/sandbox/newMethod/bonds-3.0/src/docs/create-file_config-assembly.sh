: '
    Script that creates a config file for the assembly simulation
    Template code created by DeepSeek
'

#!/bin/bash

echo "Running the create config assembly"

dir_src=$1
id=$2
var_ccL=$3

# Load the parameter file for assembly
source $dir_src/docs/load_parameters.sh $dir_src/docs/system.parameters

echo "Parameters loaded in config assembly script"

# Compute the parameters
N_CL=$(echo "scale=0; $var_ccL * $N_particles" | bc);
N_CL=${N_CL%.*};
N_MO=$(( $N_particles - $N_CL ));
Vol_MO=$(echo "scale=$cs; $Vol_MO1 * $N_MO" | bc);         # Vol of N f=2 patchy particles
Vol_CL=$(echo "scale=$cs; $Vol_CL1 * $N_CL" | bc);          # Vol of N f=4 patchy particles 
Vol_Totg=$(echo "scale=$cs; $Vol_MO + $Vol_CL" | bc);       # Total volume of a mixture of N f=2 and M f=4 patchy particles
Vol_Tot=$(echo "scale=$cs; $Vol_Totg / $phi" | bc);
L_real=$(echo "scale=$cs; e( (1/3) * l($Vol_Tot) )" | bc -l );
L=$(echo "scale=$cs; $L_real / 2" | bc);
aux=$(echo "scale=$cs; 1 / $dt" | bc);
Nsave=$(echo "scale=0; 100 * $damp * $aux" | bc);
Nsave=${Nsave%.*};
Nsavestress=Nsave;
Ndump=$(echo "scale=0; 1000 *  $aux" | bc);
Ndump=${Ndump%.*};

# Seed for the langevin thermostat and initial positions
seed1=$((1234 + $N_CL));     # MO positions
seed2=$((4321 + $N_CL));     # CL positions
seed3=$((10 + $N_CL));       # Langevin thermostat

echo "Start writting the assembly config file"

# Define the output parameters file (default: parameters.config)
OUTPUT_FILE="assembly$id-$var_ccL.parameters"

# List of variable names to include in the parameters file
VAR_NAMES=(
    "N_particles"
    "N_CL"
    "N_MO"
    "L"
    "seed1"
    "seed2"
    "seed3"
    "Nsave"
    "Nsavestress"
    "Ndump"
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
