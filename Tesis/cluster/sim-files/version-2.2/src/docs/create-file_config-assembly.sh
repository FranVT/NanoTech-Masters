: '
    Script that creates a config file for the assembly simulation
    Template code created by DeepSeek
'

#!/bin/bash

# Load the parameters

# Define variables (customize these as needed)
variable_name1="value1"
variable_name2="value2"
variable_name3="value3"
variable_nameN="valueN"

# Define the output parameters file (default: parameters.config)
OUTPUT_FILE="${1:-parameters.config}"

# List of variable names to include in the parameters file
VAR_NAMES=(
  "variable_name1"
  "variable_name2"
  "variable_name3"
  "variable_nameN"
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
