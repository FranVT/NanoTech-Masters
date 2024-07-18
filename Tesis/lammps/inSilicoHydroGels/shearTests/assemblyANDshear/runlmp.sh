#!/bin/bash

# Script to run the input file

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp
echo -e '\n'
echo -e 'End of the assembly process\n'
echo -e 'Start the deformation process\n'
echo -e '\n'
env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.shearDeformation.lmp
