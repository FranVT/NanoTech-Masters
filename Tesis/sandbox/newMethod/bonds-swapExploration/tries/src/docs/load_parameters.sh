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

# Create a temporary cleaned file
cleaned_file=$(mktemp)

# Flags to handle comment block
inside_comment=0

# Process the input file
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

  # Write valid lines to the cleaned file
  echo "$line" >> "$cleaned_file"
done < "$input_file"

# Source the cleaned file to load variables and arrays
source "$cleaned_file"

# Clean up
rm "$cleaned_file"

echo "Variables from '$input_file' are now available!"

