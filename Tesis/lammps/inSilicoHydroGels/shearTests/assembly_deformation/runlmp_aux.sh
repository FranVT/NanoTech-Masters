#!/bin/bash

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.changeBoxShear.lmp
echo -e '\n'
