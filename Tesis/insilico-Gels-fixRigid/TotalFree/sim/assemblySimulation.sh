#!/bin/bash

 # Run the assembly simulation

env OMP_RUN_THREADS=2 mpirun -np 8 lmp -sf omp -in in.assemblyShear.lmp -var L 10.69 -var NCL 100 -var NMO 1900 -var seed1 1234 -var seed2 4321 -var seed3 3124 -var steps 1500000 -var tstep 0.005 -var sstep 10000