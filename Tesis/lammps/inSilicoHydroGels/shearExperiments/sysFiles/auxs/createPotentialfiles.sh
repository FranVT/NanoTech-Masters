#!/bin/bash

# Bash script to create the potential files for lammps simulation

echo -e 'Create potential tables'
echo -e '\n'

julia createSwapfile.jl
julia createTable.jl
julia createTablePatch.jl

echo -e 'End'
echo -e '\n'

