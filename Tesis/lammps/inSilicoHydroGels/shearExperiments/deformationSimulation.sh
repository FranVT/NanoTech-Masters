#!/bin/bash

 # Run the deformation simulation

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep 0.001 -var sstep 10000 -var shear_rate 0.02 -var max_strain 50 -var Nstep_per_strain 51000 -var shear_it 2550000 -var Nsave 500 -var seed3 3124