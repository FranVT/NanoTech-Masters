#!/bin/bash

 # Run the deformation simulation

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.deformationShear.lmp -var tstep 0.001 -var sstep 10000 -var shear_rate 0.02 -var max_strain 12 -var Nstep_per_strain 50000 -var shear_it 600000 -var Nsave 500 -var seed3 3124 -var Nave 1000