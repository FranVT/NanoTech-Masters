: '
    Bash file that reads the parameters from a script
    Code created by Deepseek.
'

#!/bin/bash

# Check if input file is provided
if [ $# -eq 0 ]; then
  echo "Error: No input file specified. Usage: $0 <config_file>"
  exit 1
fi

input_file="$1"

# Validate file existence
if [ ! -f "$input_file" ]; then
  echo "Error: File '$input_file' not found!"
  exit 1
fi

# Flags to handle comment block
inside_comment=0

# Read the input file line by line
while IFS= read -r line; do
  # Detect start of comment block
  if [[ "$line" =~ ^:[[:space:]]*\' ]]; then
    inside_comment=1
    continue
  fi

  # Detect end of comment block
  if [[ "$inside_comment" -eq 1 && "$line" == "'" ]]; then
    inside_comment=0
    continue
  fi

  # Skip lines inside the comment block
  if [ "$inside_comment" -eq 1 ]; then
    continue
  fi

  # Parse variable assignments (e.g., var=value)
  if [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]]; then
    # Handle arrays (e.g., files_name=(...))
    if [[ "$line" == *"=("* ]]; then
      array_name="${line%%=*}"
      array_value="${line#*=}"
      # Read until closing ")"
      while [[ "$array_value" != *")"* ]]; do
        IFS= read -r next_line
        array_value+="$next_line"
      done
      # Remove closing ")" and export
      array_value="${array_value%)}"
      eval "$array_name=($array_value)"
      export "$array_name"
      echo "Loaded array: $array_name=($array_value)"
    else
      # Export simple variables
      export "$line"
      echo "Loaded variable: $line"
    fi
  fi
done < "$input_file"

echo "Variables from '$input_file' are now available!"

